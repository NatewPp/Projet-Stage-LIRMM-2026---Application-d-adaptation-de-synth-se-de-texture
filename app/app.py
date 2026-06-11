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
import tkinter as tk
from PIL import Image, ImageDraw, ImageTk
import sys
import customtkinter as ctk
import tkinter.font as tkfont
import pygame
from tkinter import filedialog, messagebox
import random

# le script principal
import regen_uvhints as engine
SDT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "SDT")
sys.path.append(SDT_DIR)
import InjectSDTcode as ISDT

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
DOWNLOADS = os.path.join(os.path.expanduser("~"), "Downloads")
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

def mc_button_img(w, h, base=(110, 110, 110)):
    """Dessine un bouton style Minecraft : pierre bruitée + relief 3D + contour noir."""
    img = Image.new("RGB", (w, h), base)
    px = img.load()
    for y in range(h):                       # léger bruit type pierre
        for x in range(w):
            n = random.randint(-10, 10)
            r, g, b = px[x, y]
            px[x, y] = (r + n, g + n, b + n)
    d = ImageDraw.Draw(img)
    d.rectangle([1, 1, w - 2, 2], fill=(160, 160, 160))      # liseré clair haut
    d.rectangle([1, 1, 2, h - 2], fill=(160, 160, 160))      # liseré clair gauche
    d.rectangle([1, h - 4, w - 2, h - 2], fill=(60, 60, 60)) # ombre bas
    d.rectangle([w - 4, 1, w - 2, h - 2], fill=(60, 60, 60)) # ombre droite
    d.rectangle([0, 0, w - 1, h - 1], outline=(0, 0, 0), width=1)  # contour noir
    return img

def tiled_bg(w, h, scale=4, dark=0.35):
    """Fond menu Minecraft : dirt.png répété, pixels nets, assombri."""
    tex = Image.open(os.path.join(DEFAULT_REF, "dirt.png")).convert("RGB")
    tex = tex.resize((tex.width * scale, tex.height * scale), Image.NEAREST)
    bg = Image.new("RGB", (w, h))
    for x in range(0, w, tex.width):
        for y in range(0, h, tex.height):
            bg.paste(tex, (x, y))
    return Image.eval(bg, lambda v: int(v * dark))

class App(ctk.CTk):
    def __init__(self):
        super().__init__()
        ctk.set_appearance_mode("dark")
        ctk.set_default_color_theme("blue")

        self.canvas = tk.Canvas(self, highlightthickness=0, bg=MC["bg"])
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<Configure>", self._redraw_bg)   # redessine au redimensionnement
        self._bg_ref = None
        self._ui_off = (0, 0)

        self.title("Implémentation synthèse de texture pour shaders minecraft")
        self.geometry("760x620")
        self.minsize(760, 620)
        #self.resizable(False, False)

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

        self.click_snd = None
        self.error_snd = None
        try:
            pygame.mixer.init()
            self.click_snd = pygame.mixer.Sound(os.path.join(HERE, "sound", "button.wav"))
            self.error_snd = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
        except Exception:
            pass

        pad = {"padx": 16, "pady": 6}

        # Titre
        self.canvas.create_text(382, 32, text="Texture Synthesis Implementer",
                                font=("Monocraft", 22, "bold"), fill="#3f3f3f",tags="ui")   # ombre
        self.canvas.create_text(380, 30, text="Texture Synthesis Implementer",
                                font=("Monocraft", 22, "bold"), fill="white",tags="ui")

        # --- Atlas ---
        self.atlas_var = ctk.StringVar()
        self._row(80, "1. Atlas de ta version (PNG)", self.atlas_var, self._pick_atlas)

        # --- Shaderpack ---
        self.pack_var = ctk.StringVar()
        self._row(150, "2. Dossier du shaderpack", self.pack_var, self._pick_pack)


        # --- Option appliquer ---
        self.debug_var = ctk.BooleanVar(value=False)
        cb2 = ctk.CTkCheckBox(self.canvas, text="Pour voir les lignes de debug ou non",
                        variable=self.debug_var, corner_radius=0,
                        fg_color=MC["green"], hover_color=MC["green_hi"],
                        font=mc_font(12), text_color=MC["text"],command=self._click)
        self.canvas.create_window(16, 262, window=cb2, anchor="nw",tags="ui")

        # --- Bouton lancer ---
        self.run_btn = tk.Button(
            self.canvas, text="Régénérer",
            font=mc_font(16, "bold"),
            fg="white", bg=MC["green"], activebackground=MC["green_hi"],
            activeforeground="white", bd=3, relief="raised",
            highlightthickness=0, cursor="hand2",
            command=self._run)
        self.canvas.create_window(16, 305, window=self.run_btn, anchor="nw",
                                  width=728, height=46,tags="ui")
        #self.run_btn.pack(fill="x", padx=16, pady=12, ipady=10)
        self.run_btn.bind("<Enter>", lambda e: self.run_btn.config(bg=MC["green_hi"]))
        self.run_btn.bind("<Leave>", lambda e: self.run_btn.config(bg=MC["green"]))

        # --- Statut ---
        self.canvas.create_text(17, 371, text="Prêt.", anchor="w",
                                font=("Monocraft", 12), fill="black", tags=("status_sh","ui"))
        self.canvas.create_text(16, 370, text="Prêt.", anchor="w",
                                font=("Monocraft", 12), fill=MC["subtext"], tags=("status","ui"))
        # --- Zone de log ---
        self.log = ctk.CTkTextbox(self.canvas, corner_radius=0, fg_color=MC["entry"],
                                  border_color=MC["entry_bd"], border_width=2,
                                  font=mc_font(12))
        self.canvas.create_window(16, 390, window=self.log, anchor="nw",
                                  width=728, height=212,tags="ui")
        self.log.configure(state="disabled")

    #Sound
    def _click(self):
        if self.click_snd:
            self.click_snd.play()

    def _error(self, title, msg):
        """Boom + boîte d'erreur."""
        if self.error_snd:
            self.error_snd.play()
        messagebox.showerror(title, msg)

    # ---------- helpers UI ----------
    def _row(self, y, label, var, browse_cmd):
        self.canvas.create_text(17, y + 1, text=label, anchor="w",
                                font=("Monocraft", 13), fill="black",tags="ui")       # ombre
        self.canvas.create_text(16, y, text=label, anchor="w",
                                font=("Monocraft", 13), fill=MC["text"],tags="ui")
        entry = ctk.CTkEntry(self.canvas, textvariable=var, corner_radius=0,
                             fg_color=MC["entry"], border_color=MC["entry_bd"],
                             border_width=2, font=mc_font(12))
        self.canvas.create_window(16, y + 16, window=entry, anchor="nw",
                                  width=610, height=30,tags="ui")
        btn = ctk.CTkButton(self.canvas, text="Parcourir", width=110, corner_radius=0,
                            fg_color=MC["stone"], hover_color=MC["stone_hi"],
                            border_color=MC["border"], border_width=2,
                            font=mc_font(12),
                            command=lambda: (self._click(), browse_cmd()))
        self.canvas.create_window(634, y + 16, window=btn, anchor="nw",
                                  width=110, height=30,tags="ui")

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

    def _redraw_bg(self, event):
        self._bg_ref = ImageTk.PhotoImage(tiled_bg(event.width, event.height))
        self.canvas.delete("bg")
        self.canvas.create_image(0, 0, image=self._bg_ref, anchor="nw", tags="bg")
        self.canvas.tag_lower("bg")
        off_x = max(0, (event.width - 760) // 2)
        off_y = max(0, (event.height - 620) // 2)
        dx = off_x - self._ui_off[0]
        dy = off_y - self._ui_off[1]
        if dx or dy:
            self.canvas.move("ui", dx, dy)
        self._ui_off = (off_x, off_y)

    # ---------- action principale ----------
    def _run(self):
        atlas = self.atlas_var.get().strip()
        pack = self.pack_var.get().strip()
        textures = DEFAULT_REF

        #nettoyage des logs
        self._clear_log()

        self._click()

        # validations
        if not atlas or not os.path.exists(atlas):
            Error_sound = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
            Error_sound.play()
            self._error("Atlas manquant", "Choisis un fichier d'atlas.")
            return
        if not os.path.isdir(os.path.join(pack, "shaders")):
            Error_sound = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
            Error_sound.play()
            self._error("Pas un shaderpack",
                        f"Pas de dossier shaders/ dans :\n{pack}")
            return
        # doit être un .png ET un vrai PNG ouvrable
        if not atlas.lower().endswith(".png"):
            Error_sound = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
            Error_sound.play()
            messagebox.showerror("Mauvais format", "L'atlas doit être un fichier .png")
            return
        try:
            with Image.open(atlas) as im:
                if im.format != "PNG":
                    raise ValueError
        except Exception:
            Error_sound = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
            Error_sound.play()
            messagebox.showerror("Fichier invalide", "Ce fichier n'est pas une image PNG valide.")
            return
        w, h = im.size
        if w % 16 or h % 16 or w < 256:
            Error_sound = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
            Error_sound.play()
            messagebox.showerror("Pas un atlas",
            f"Dimensions {w}x{h} : ne ressemble pas à un atlas de blocs.")
            return

        self._say(f"Atlas    : {atlas}", append=False)
        self._say(f"Pack     : {pack}")
        self._say(f"Textures : {textures}\n")
        self._set_running(True)
        self._set_status("Injection + régénération en cours…", "orange")
        self._set_status("Régénération en cours…", "orange")

        # le calcul tourne dans un THREAD pour ne pas geler la fenêtre
        threading.Thread(target=self._work, args=(atlas, pack, textures), daemon=True).start()

    def _work(self, atlas, pack, textures):
        tmp = None
        try:
            # 1) Copie + injection SDT, directement dans Téléchargements
            name = os.path.basename(os.path.normpath(pack)) + "_SDT"
            out_pack = os.path.join(DOWNLOADS, name)
            self._say("Injection du code SDT…")
            ISDT.inject_sdt(pack, dest=out_pack)

            # 2) Régénération de la table UVHints à partir de l'atlas
            glsl = find_glsl(out_pack)
            if not glsl:
                raise RuntimeError("Injection SDT : aucun glsl de synthèse dans " + out_pack)
            blockdir, tmp = engine.resolve_textures(textures)
            out = glsl + ".generated"
            res = engine.regenerate(atlas, blockdir, glsl, out)
            shutil.move(out, glsl)        # on applique direct : c'est notre copie

            self._say(f"✅ Placés fiables  : {res['n_ok']}")
            self._say(f"⚠️  À vérifier      : {res['n_verif']}")
            self._say(f"🔧 Non placés      : {res['n_fail']}")
            self._set_status(f"Terminé ✔  Pack créé : Téléchargements/{name}", "lightgreen")

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
