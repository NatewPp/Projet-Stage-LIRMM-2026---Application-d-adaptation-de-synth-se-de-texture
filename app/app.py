#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
app.py — Interface graphique (customtkinter) pour régénérer textureSynthesisUVHints.glsl.

Principe : cette fenêtre ne fait QUE l'interface. Tout le calcul est délégué au
moteur `regen_uvhints.py` (séparation interface / logique). Demain on pourra
empaqueter le tout en .exe (PyInstaller) sans toucher au moteur.

Lancer :  python app.py
Dépendances : pip install customtkinter numpy pillow
"""

import os
import shutil
import threading
import traceback
from tkinter import filedialog, messagebox, PhotoImage
from PIL import Image
import sys
import customtkinter as ctk
import tkinter.font as tkfont
import pygame

# le script principal
import regen_uvhints as engine

# Palette "Minecraft" (gris pierre + vert Done)
MC = {
    "bg":        "#313233",   # fond fenêtre (gris foncé)
    "stone":     "#6e6e6e",   # bouton pierre
    "stone_hi":  "#7f7f7f",   # survol pierre
    "green":     "#3c8527",   # bouton principal (Done)
    "green_hi":  "#4ba32f",   # survol vert
    "border":    "#1d1d1d",   # contour foncé
    "entry":     "#1e1e1e",   # fond des champs
    "entry_bd":  "#5a5a5a",   # contour des champs
    "text":      "#ffffff",
    "subtext":   "#a0a0a0",
}

HERE = os.path.dirname(os.path.abspath(__file__))
DEFAULT_REF = os.path.join(HERE, "reference_blocks")   # textures de référence embarquées
GLSL_NAME = "textureSynthesisUVHints.glsl"

def find_glsl(path):
    """À partir d'un chemin (fichier .glsl OU dossier de shaderpack), retrouve le
    textureSynthesisUVHints.glsl. Renvoie le chemin trouvé, ou None."""
    if not path:
        return None
    if os.path.isfile(path) and path.endswith(".glsl"):
        return path
    if os.path.isdir(path):
        for dp, _dn, fn in os.walk(path):
            if GLSL_NAME in fn:
                return os.path.join(dp, GLSL_NAME)
    return None

def validate_glsl(glsl):
    """Vérifie que le glsl est bien une table de synthèse de texture modifiable.
    Renvoie (True, nb_blocs) si éligible, sinon (False, message d'erreur)"""
    try:
        txt = open(glsl, encoding="utf-8", errors="ignore").read()
    except Exception:
        return False, "Fichier illisible."
    #compte les lignes de données reconnues par le moteur de type (vec2(...,...) //bloc_name)
    n = sum(1 for ln in txt.splitlines() if engine.LINE_RE.match(ln)) #utilisation de la regex dans engine
    if "normalBlockOffsets" not in txt or n == 0:
        return False, ("Ce fichier ne contient pas de données de synthèse de texture. Shader non compatible.")
    return True, n

def mc_font(size, weight="normal"):
    """Applique à la police le thème monocraft si installer sur l'ordinateur"""
    fams = set(tkfont.families())                      # nécessite que la fenêtre existe déjà
    fam = next((f for f in ("Monocraft", "Minecraft", "Consolas") if f in fams), "Consolas")
    return ctk.CTkFont(family=fam, size=size, weight=weight)

class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        ctk.set_appearance_mode("dark")
        ctk.set_default_color_theme("blue")

        self.title("Implémentation synthèse de texture pour shaders minecraft")
        self.geometry("760x620")
        self.minsize(680, 560)

        #fond + icone
        ctk.set_appearance_mode("dark")
        self.configure(fg_color=MC["bg"])              # fond façon MC
        try:
            self.iconbitmap(os.path.join(HERE, "logo.ico"))   # ton .ico
        except Exception:
            pass
        self.title("Texture Synthesis Implementer")

        #Pour l'affichagfe de l'icone en haut à droite de la fenètre
        try:
            self.iconbitmap(os.path.join(HERE, "logo_minecraft.ico"))
        except Exception:
            pass

        pad = {"padx": 16, "pady": 6}

        # Titre
        ctk.CTkLabel(self, text="Texture Synthesis Implementer",
                     font=mc_font(22, "bold"), text_color=MC["text"]).pack(**pad)
        ctk.CTkLabel(self, text="Implemente une synthèse de texture dans ton shader",
                     font=mc_font(13), text_color=MC["subtext"]).pack(padx=16, pady=(0, 10))

        # --- Atlas ---
        self.atlas_var = ctk.StringVar()
        self._row("1. Atlas de ta version (PNG)", self.atlas_var, self._pick_atlas)

        # --- Shaderpack ---
        self.pack_var = ctk.StringVar()
        self._row("2. Dossier du shaderpack", self.pack_var, self._pick_pack)

        # --- Option appliquer ---
        self.apply_var = ctk.BooleanVar(value=True)
        ctk.CTkCheckBox(self, text="Appliquer directement (sauvegarde .bak)",
                        variable=self.apply_var, corner_radius=0,
                        fg_color=MC["green"], hover_color=MC["green_hi"],
                        font=mc_font(12), text_color=MC["text"]).pack(anchor="w", padx=16, pady=(8, 4))
        
        self.debug_var = ctk.BooleanVar(value=False)
        ctk.CTkCheckBox(self, text="Pour voir les lignes de debug ou non",
                        variable=self.debug_var, corner_radius=0,
                        fg_color=MC["green"], hover_color=MC["green_hi"],
                        font=mc_font(12), text_color=MC["text"]).pack(anchor="w", padx=16, pady=(8, 4))

        # --- Bouton lancer ---
        self.run_btn = ctk.CTkButton(
            self, text="Régénérer", height=46, corner_radius=0,
            fg_color=MC["green"], hover_color=MC["green_hi"],
            border_color=MC["border"], border_width=3,
            font=mc_font(16, "bold"), command=self._run)
        self.run_btn.pack(fill="x", padx=16, pady=12)

        # --- Statut ---
        self.status = ctk.CTkLabel(self, text="Prêt.", font=mc_font(12), text_color=MC["subtext"])
        self.status.pack(anchor="w", padx=16)

        # --- Zone de log ---
        self.log = ctk.CTkTextbox(self, corner_radius=0, fg_color=MC["entry"],
                                  border_color=MC["entry_bd"], border_width=2,
                                  font=mc_font(12))
        self.log.pack(fill="both", expand=True, padx=16, pady=(6, 16))
        self.log.configure(state="disabled")

    # ---------- helpers UI ----------
    def _row(self, label, var, browse_cmd):
        ctk.CTkLabel(self, text=label, anchor="w",
                     font=mc_font(13), text_color=MC["text"]).pack(fill="x", padx=16, pady=(8, 0))
        frame = ctk.CTkFrame(self, fg_color="transparent")
        frame.pack(fill="x", padx=16)
        ctk.CTkEntry(frame, textvariable=var, corner_radius=0,
                     fg_color=MC["entry"], border_color=MC["entry_bd"], border_width=2,
                     font=mc_font(12)).pack(side="left", fill="x", expand=True)
        ctk.CTkButton(frame, text="Parcourir", width=110, corner_radius=0,
                      fg_color=MC["stone"], hover_color=MC["stone_hi"],
                      border_color=MC["border"], border_width=2,
                      font=mc_font(12), command=browse_cmd).pack(side="left", padx=(8, 0))

    def _pick_atlas(self):
        f = filedialog.askopenfilename(title="Choisir l'atlas",
                                       filetypes=[("Images PNG", "*.png"), ("Tous", "*.*")])
        if f:
            self.atlas_var.set(f)

    def _pick_pack(self):
        d = filedialog.askdirectory(title="Choisir le dossier du shaderpack")
        if d:
            self.pack_var.set(d)

    def _pick_tex(self):
        # un dossier OU un .jar
        f = filedialog.askopenfilename(title="Choisir un .jar (ou Annuler pour un dossier)",
                                       filetypes=[("Archives Java", "*.jar"), ("Tous", "*.*")])
        if f:
            self.tex_var.set(f); return
        d = filedialog.askdirectory(title="Choisir un dossier de textures (block/)")
        if d:
            self.tex_var.set(d)

    def _clear_log(self):
        """Vide le journal, quel que soit le mode débogage."""
        self.log.configure(state="normal")
        self.log.delete("1.0", "end")
        self.log.configure(state="disabled")

    def _say(self, text, append=True):
        """Écrit dans la zone de log (thread-safe via after)."""
        if not self.debug_var.get() :
            return
        def do():
            self.log.configure(state="normal")
            if not append:
                self.log.delete("1.0", "end")
            self.log.insert("end", text + "\n")
            self.log.see("end")
            self.log.configure(state="disabled")
        self.after(0, do)

    def _set_status(self, text, color="gray70"):
        self.after(0, lambda: self.status.configure(text=text, text_color=color))

    def _set_running(self, running):
        def do():
            self.run_btn.configure(state="disabled" if running else "normal")
            if self.debug_var.get():
                self.run_btn.configure(text="En cours…" if running else "Régénérer")
        self.after(0, do)

    # ---------- action principale ----------
    def _run(self):
        atlas = self.atlas_var.get().strip()
        pack = self.pack_var.get().strip()
        textures = DEFAULT_REF
        apply = self.apply_var.get()

        #nettoyage des logs
        self._clear_log()

        # validations
        if not atlas or not os.path.exists(atlas):
            messagebox.showerror("Atlas manquant", "Choisis un fichier d'atlas.")
            return
        # doit être un .png ET un vrai PNG ouvrable
        if not atlas.lower().endswith(".png"):
            messagebox.showerror("Mauvais format", "L'atlas doit être un fichier .png")
            return
        try:
            with Image.open(atlas) as im:
                if im.format != "PNG":
                    raise ValueError
        except Exception:
            messagebox.showerror("Fichier invalide", "Ce fichier n'est pas une image PNG valide.")
            return
        w, h = im.size
        if w % 16 or h % 16 or w < 256:
            messagebox.showerror("Pas un atlas",
            f"Dimensions {w}x{h} : ne ressemble pas à un atlas de blocs.")
            return
        glsl = find_glsl(pack)
        if not glsl:
            messagebox.showerror("Pas un shader compatible",
                f"Aucun {GLSL_NAME} trouvé dans :\n{pack}\n\n"
                "Ce dossier n'est pas un shader avec texture synthesis.")
            return
        ok, info = validate_glsl(glsl)
        if not ok:
            messagebox.showerror("Shader non compatible", info)
            return

        self._say(f"Atlas    : {atlas}", append=False)
        self._say(f"Cible    : {glsl}")
        self._say(f"Textures : {textures}")
        self._say(f"Appliquer: {'oui' if apply else 'non (fichier .generated)'}\n")
        self._set_running(True)
        self._set_status("Régénération en cours…", "orange")

        # le calcul tourne dans un THREAD pour ne pas geler la fenêtre
        threading.Thread(target=self._work, args=(atlas, textures, glsl, apply), daemon=True).start()

    def _work(self, atlas, textures, glsl, apply):
        tmp = None
        try:
            blockdir, tmp = engine.resolve_textures(textures)
            out = glsl + ".generated"
            res = engine.regenerate(atlas, blockdir, glsl, out)

            self._say(f"Tuile détectée : {res['tile']} px")
            self._say(f"Atlas : {res['w']}x{res['h']}  ({res['w']//res['tile']}x{res['h']//res['tile']} tuiles)\n")
            self._say(f"✅ Placés fiables  : {res['n_ok']}")
            self._say(f"⚠️  À vérifier      : {res['n_verif']}")
            self._say(f"🔧 Non placés      : {res['n_fail']}")
            if res["verif"]:
                self._say("\nÀ vérifier en jeu :")
                for name, pos, how in res["verif"]:
                    self._say(f"   {name:28} -> {pos}  {how}")
            if res["fail"]:
                self._say("\nCustom shaderpack (non placés) : " + ", ".join(res["fail"]))

            if apply:
                bak = glsl + ".bak"
                if not os.path.exists(bak):
                    shutil.copyfile(glsl, bak)
                    self._say(f"\nSauvegarde -> {os.path.basename(bak)}")
                shutil.move(out, glsl)
                self._say(f"Appliqué -> {os.path.basename(glsl)}")
                self._set_status("Terminé et appliqué ✔  (recharge les shaders dans Minecraft)", "lightgreen")
            else:
                self._say(f"\nFichier généré : {out}")
                self._set_status("Terminé (fichier .generated) ✔", "lightgreen")

        except Exception as e:
            self._say("\nERREUR : " + str(e))
            self._say(traceback.format_exc())
            self._set_status("Erreur — voir le journal.", "red")
        finally:
            if tmp:
                shutil.rmtree(tmp, ignore_errors=True)
            self._set_running(False)


if __name__ == "__main__":
    App().mainloop()
