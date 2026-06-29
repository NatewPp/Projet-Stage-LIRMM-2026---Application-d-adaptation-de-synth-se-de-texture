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

#Toutes les librairies du projet
import os
import shutil
import threading
import traceback
import tkinter as tk
from PIL import Image, ImageTk
import sys
import customtkinter as ctk
import tkinter.font as tkfont
import pygame
from tkinter import filedialog, messagebox
import locale

#Le script principal
import regen_uvhints as engine
SDT_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "SDT")
sys.path.append(SDT_DIR)
import InjectSDTcode as ISDT

#Palette de couleur style minecraft utilisé dans l'ATH du l'app
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

TEXTS = { #variable pour modifier la lanque de l'application
    "fr": {
        "title": "Texture Synthesis Implementer",
        "regen": "Générer",
        "browse": "Parcourir",
        "atlas_label": "1. Atlas de ta version (PNG)",
        "atlas_label2": "2. Dossier du shaderpack",
        # checkboxes
        "debug": "DEBUG",
        "multi": "MULTI-SHADER",
        "zip": "ZIP",
        # bouton pendant le run
        "running": "En cours…",
        # statuts
        "ready": "Prêt.",
        "generating": "Génération en cours…",
        "done": "Terminé ✔",
        "error_status": "Erreur — voir le journal.",
        # dialogues
        "pick_atlas": "Choisir l'atlas",
        "pick_pack": "Choisir un shaderpack .zip (ou Annuler pour un dossier)",
        "pick_dir": "Choisir le dossier du shaderpack",
        # messages d'erreur (titre + corps)
        "err_atlas_missing_t": "Atlas manquant",
        "err_atlas_missing_m": "Choisis un fichier d'atlas.",
        "err_format_t": "Mauvais format",
        "err_format_m": "L'atlas doit être un fichier .png",
        "err_invalid_t": "Fichier invalide",
        "err_invalid_m": "Ce fichier n'est pas une image PNG valide.",
        "err_notatlas_t": "Pas un atlas",
    },
    "en": {
        "title": "Texture Synthesis Implementer",
        "regen": "Generate",
        "browse": "Browse",
        "atlas_label": "1. Your version's atlas (PNG)",
        "atlas_label2": "2. Shaderpack folder",
        "debug": "DEBUG",
        "multi": "MULTI-SHADER",
        "zip": "ZIP",
        "running": "Working…",
        "ready": "Ready.",
        "generating": "Generating…",
        "done": "Done ✔",
        "error_status": "Error — see the log.",
        "pick_atlas": "Choose the atlas",
        "pick_pack": "Choose a .zip shaderpack (or Cancel for a folder)",
        "pick_dir": "Choose the shaderpack folder",
        "err_atlas_missing_t": "Missing atlas",
        "err_atlas_missing_m": "Choose an atlas file.",
        "err_format_t": "Wrong format",
        "err_format_m": "The atlas must be a .png file",
        "err_invalid_t": "Invalid file",
        "err_invalid_m": "This file is not a valid PNG image.",
        "err_notatlas_t": "Not an atlas",
    },
}

#Variables de chemin
HERE = os.path.dirname(os.path.abspath(__file__))
DOWNLOADS = os.path.join(os.path.expanduser("~"), "Downloads")
DEFAULT_REF = os.path.join(HERE, "reference_blocks")   # textures de référence embarquées
GLSL_NAME = "textureSynthesisUVHints.glsl"

def find_glsl(path):
    """À partir d'un chemin (fichier .glsl OU dossier de shaderpack), retrouve le
    textureSynthesisUVHints.glsl. Renvoie le chemin trouvé, ou None."""
    if not path:
        return None
    if os.path.isfile(path) and os.path.basename(path) == GLSL_NAME:
        return path
    if os.path.isdir(path):
        for dp, _dn, fn in os.walk(path):
            if GLSL_NAME in fn:
                return os.path.join(dp, GLSL_NAME)
    return None

def mc_font(size, weight="normal"):
    """Applique à la police le thème monocraft si installer sur l'ordinateur"""
    fams = set(tkfont.families()) #Toutes les polices d'écriture de l'ordi
    fam = "Consolas"                       # valeur par défaut si rien n'est trouvé
    for f in ("Monocraft", "Minecraft", "Consolas"):
        if f in fams:                     
            fam = f                        
            break                         
    return ctk.CTkFont(family=fam, size=size, weight=weight) #on applique la nouvelle police à Ctk

def tiled_bg(w, h, scale=4, dark=0.4):
    """Fond menu Minecraft avec image dirt periodique"""
    tex = Image.open(os.path.join(DEFAULT_REF, "dirt.png")).convert("RGB")
    tex = tex.resize((tex.width * scale, tex.height * scale), Image.NEAREST)
    bg = Image.new("RGB", (w, h))
    for x in range(0, w, tex.width):
        for y in range(0, h, tex.height):
            bg.paste(tex, (x, y))
    return Image.eval(bg, lambda v: int(v * dark)) #retourne le bg avec les valeurs RGB * 0.35 pour l'effet sombre

def detect_lang():
    """Renvoie 'fr' si l'OS est en français, sinon 'en' (par défaut)."""
    try:
        code = locale.getlocale()[0] or ""
    except Exception:
        code = ""
    # couvre 'fr_FR', 'French_France', 'fr-FR'... insensible à la casse
    return "fr" if code.lower().startswith(("fr", "french")) else "en"

class App(ctk.CTk):
    def __init__(self):
        super().__init__() #hérite de Ctk
        ctk.set_appearance_mode("dark")
        ctk.set_default_color_theme("blue")

        self._i18n = []   # liste de fonctions "mets à jour mon texte"

        self.canvas = tk.Canvas(self, highlightthickness=0, bg=MC["bg"])
        self.canvas.pack(fill="both", expand=True)
        self.canvas.bind("<Configure>", self._redraw_bg)   #redessine au redimensionnement de la fenêtre
        self._bg_ref = None
        self._ui_off = (0, 0)

        self.geometry("1280x720")
        self.minsize(760, 620)
        
        self.lang = detect_lang()   

        #Fond + icone
        self.configure(fg_color=MC["bg"]) #Fond façon MC
        try:
            self.iconbitmap(os.path.join(HERE, "logo.ico")) #Chargement du logo
        except Exception:
            pass
        self.title("Texture Synthesis Implementer")

        #Pour l'affichagfe de l'icone en haut à droite de la fenètre
        try:
            self.iconbitmap(os.path.join(HERE, "logo_minecraft.ico"))
        except Exception:
            pass

        self.click_snd = None #variable pour les sons de click minecraft
        self.error_snd = None #variable pour les sons d'erreur (ici explosion)
        try:
            pygame.mixer.init()
            self.click_snd = pygame.mixer.Sound(os.path.join(HERE, "sound", "button.wav"))
            self.error_snd = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
        except Exception:
            pass

        
        #Titre
        self._txt(382, 32, "title", font=("Monocraft", 22, "bold"), fill="#3f3f3f", tags="ui")
        self._txt(380, 30, "title", font=("Monocraft", 22, "bold"), fill="white", tags="ui")

        self.lang_btn = tk.Button(self.canvas, text=self.lang.upper(),
                                font=mc_font(20, "bold"), fg="white",
                                bg=MC["stone"], activebackground=MC["stone_hi"],
                                bd=3, relief="raised", highlightthickness=0,
                                cursor="hand2", command=self._toggle_lang)
        self.canvas.create_window(700, 30, window=self.lang_btn, anchor="nw", width=50, height=30, tags="ui")
        self._i18n.append(lambda: self.lang_btn.configure(text=self.lang.upper()))
        self.canvas.create_window(10,10, window=self.lang_btn, anchor="nw",
                                  width=150, height=50)
        #Actionne le changement de couleur quand on survole le bouton
        self.lang_btn.bind("<Enter>", lambda e: self.lang_btn.config(bg=MC["stone_hi"])) 
        self.lang_btn.bind("<Leave>", lambda e: self.lang_btn.config(bg=MC["stone"]))

        #Selection atlas
        self.atlas_var = ctk.StringVar()
        self._row(80, "atlas_label", self.atlas_var, self._pick_atlas)
        #self._register_widget(self.atlas_var, "atlas_label")

        #Selection Shader pack
        self.pack_var = ctk.StringVar()
        self._row(150, "atlas_label2", self.pack_var, self._pick_pack)

        #Option debug
        self.debug_var = ctk.BooleanVar(value=True)
        cb2 = tk.Checkbutton( #bouton pour activer ou désactiver le debug
            self.canvas, text= self.t("debug"),
            variable=self.debug_var,
            font=mc_font(12),                     
            indicatoron=False,                   
            fg="white", bg=MC["stone"],
            selectcolor=MC["green_hi"],   #Couleur lorsque activé
            activebackground=MC["stone_hi"], activeforeground="white",
            bd=3, relief="raised",                
            highlightthickness=0, cursor="hand2",
            command=self._click)
        self._register_widget(cb2, "debug")

        #option si dossier de plusieurs shaderpacks ou si un seul shaderpack
        self.manyfolders_var = ctk.BooleanVar(value=False)
        cb3 = tk.Checkbutton( #bouton pour savoir si un ou plusieurs shaders
            self.canvas, text="multi",
            variable=self.manyfolders_var,
            font=mc_font(12),
            indicatoron=False,
            fg="white", bg=MC["stone"],
            selectcolor=MC["green_hi"],   #Couleur lorsque activé
            activebackground=MC["stone_hi"], activeforeground="white",
            bd=3, relief="raised",
            highlightthickness=0, cursor="hand2",
            command=self._click)
        self._register_widget(cb3, "multi")

        self.canvas.create_window(16, 262, window=cb2, anchor="nw",
                                width=100, height=34, tags="ui") 
        cb2.bind("<Enter>", lambda e: cb2.config(bg=MC["stone_hi"]))
        cb2.bind("<Leave>", lambda e: cb2.config(bg=MC["stone"]))
        self.canvas.create_window(132, 262, window=cb3, anchor="nw",
                                width=130, height=34, tags="ui")
        cb3.bind("<Enter>", lambda e: cb3.config(bg=MC["stone_hi"]))
        cb3.bind("<Leave>", lambda e: cb3.config(bg=MC["stone"]))

        #Bouton pour choisir zip ou non en sortie
        self.zip_var = ctk.BooleanVar(value=True)
        cb4 = tk.Checkbutton(
            self.canvas, text="zip",
            variable=self.zip_var,
            font=mc_font(12), indicatoron=False,
            fg="white", bg=MC["stone"], selectcolor=MC["green_hi"],
            activebackground=MC["stone_hi"], activeforeground="white",
            bd=3, relief="raised", highlightthickness=0, cursor="hand2",
            command=self._click)
        self.canvas.create_window(272, 262, window=cb4, anchor="nw",
                                width=80, height=34, tags="ui")
        cb4.bind("<Enter>", lambda e: cb4.config(bg=MC["stone_hi"]))
        cb4.bind("<Leave>", lambda e: cb4.config(bg=MC["stone"]))
        self._register_widget(cb4, "zip")

        #Bouton Générer
        self.run_btn = tk.Button(
            self.canvas, text=self.t("regen"),
            font=mc_font(16, "bold"),
            fg="white", bg=MC["green"], activebackground=MC["green_hi"],
            activeforeground="white", bd=3, relief="raised",
            highlightthickness=0, cursor="hand2",
            command=self._wichtorun)
        self.canvas.create_window(16, 305, window=self.run_btn, anchor="nw",
                                  width=728, height=46,tags="ui")
        self.run_btn.bind("<Enter>", lambda e: self.run_btn.config(bg=MC["green_hi"]))
        self.run_btn.bind("<Leave>", lambda e: self.run_btn.config(bg=MC["green"]))
        self._register_widget(self.run_btn, "regen")

        #Etat de la génération
        self.canvas.create_text(17, 371, text="", anchor="w",
                        font=("Monocraft", 12), fill="black", tags=("status_sh", "ui"))
        self.canvas.create_text(16, 370, text="", anchor="w",
                                font=("Monocraft", 12), fill=MC["subtext"], tags=("status", "ui"))
        self._status_key, self._status_color = "ready", MC["subtext"]
        self._set_status("ready")

        #Zone de log et debug
        self.log = ctk.CTkTextbox(self.canvas, corner_radius=0, fg_color=MC["entry"],
                                  border_color=MC["entry_bd"], border_width=2,
                                  font=mc_font(12))
        self.canvas.create_window(16, 390, window=self.log, anchor="nw",
                                  width=728, height=212,tags="ui")
        self.log.configure(state="disabled")

    #Sound
    def _click(self):
        if self.click_snd:
            self.click_snd.play() #joue le son click_snd

    def _error(self, title, msg):
        if self.error_snd:
            self.error_snd.play() #joue le son d'erreur
        messagebox.showerror(title, msg) #affiche une error box

    #UI
    def _row(self, y, key, var, browse_cmd):
        """Fonction de création des zones pour mettre atlas et shader"""
        self._txt(17, y + 1, key, anchor="w",
                                font=("Monocraft", 13), fill="black",tags="ui")#Ombre
        self._txt(16, y, key, anchor="w",
                                font=("Monocraft", 13), fill=MC["text"],tags="ui")
        entry = ctk.CTkEntry(self.canvas, textvariable=var, corner_radius=0, #zone pour rentrer manuellement un chemin
                             fg_color=MC["entry"], border_color=MC["entry_bd"],
                             border_width=2, font=mc_font(12))
        self.canvas.create_window(16, y + 16, window=entry, anchor="nw",
                                  width=610, height=30,tags="ui")
        btn = tk.Button( #bouton parcourir
            self.canvas, text=self.t("browse"),
            font=mc_font(12, "bold"),
            fg="white", bg=MC["stone"], activebackground=MC["stone_hi"],
            activeforeground="white", bd=3, relief="raised",
            highlightthickness=0, cursor="hand2",
            command=lambda: (self._click(), browse_cmd()))
        self.canvas.create_window(634, y + 16, window=btn, anchor="nw",
                                  width=110, height=30,tags="ui")
        #Actionne le changement de couleur quand on survole le bouton
        btn.bind("<Enter>", lambda e: btn.config(bg=MC["stone_hi"])) 
        btn.bind("<Leave>", lambda e: btn.config(bg=MC["stone"]))
        self._register_widget(btn, "browse")

    def _pick_atlas(self):
        """Fonction pour séléctionner dans ses fichier son atlas.png"""
        f = filedialog.askopenfilename(title=self.t("pick_atlas"),
                                       filetypes=[("Images PNG", "*.png"), ("Tous", "*.*")])
        if f:
            self.atlas_var.set(f)

    def _pick_pack(self):
        """Choisir un shaderpack : un .zip, ou (si on annule) un dossier."""
        f = filedialog.askopenfilename(
            title=self.t("pick_dir"),
            filetypes=[("Shaderpack zip", "*.zip"), ("Tous", "*.*")])
        if f:
            self.pack_var.set(f); return
        d = filedialog.askdirectory(title=self.t("pick_dir"))
        if d:
            self.pack_var.set(d)

    #fonction lier au texte et la langue
    def t(self, key):
        return TEXTS[self.lang][key]
    
    def _txt(self, x, y, key, **kw):
        """Crée un texte canvas traduisible : il se mettra à jour au changement de langue."""
        item = self.canvas.create_text(x, y, text=self.t(key), **kw)
        self._i18n.append(lambda: self.canvas.itemconfigure(item, text=self.t(key)))
        return item
    
    def _register_widget(self, widget, key):
        self._i18n.append(lambda: widget.configure(text=self.t(key)))
    
    def _apply_lang(self):
        for update in self._i18n:
            update()
        if hasattr(self, "_status_key"):
            self._set_status(self._status_key, self._status_color)

    def _toggle_lang(self):
        self._click()                              
        self.lang = "en" if self.lang == "fr" else "fr"
        self._apply_lang()  

    def _clear_log(self):
        """Vide les logs"""
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
        self.after(0, do) #execute le do dans le thread principal pour la sécurité
    
    def _set_status(self, text, color=MC["subtext"]):
        """Met à jour le message de statut (thread-safe via after)."""
        def do():
            self.canvas.itemconfigure("status", text=text, fill=color)
            self.canvas.itemconfigure("status_sh", text=text)   # l'ombre suit le même texte
        self.after(0, do)
    
    def _set_running(self, running):
        def do():
            self.run_btn.configure(text=self.t("running") if running else self.t("regen"))
            if self.debug_var.get():
                self.run_btn.configure(text="En cours…" if running else "Générer")
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


    def _wichtorun(self):
        atlas = self.atlas_var.get().strip()
        self._say(f"Atlas    : {atlas}")
        if self.manyfolders_var.get():
            threading.Thread(target=self._multirun, daemon=True).start()
        else:
            threading.Thread(target=self._run, args=(self.pack_var.get(),), daemon=True).start()

    def _multirun(self):
        contenu_brut = os.listdir(self.pack_var.get())
        ListeShaders = [
            f for f in contenu_brut 
            if os.path.isdir(os.path.join(self.pack_var.get(), f))
        ]
        self.NbShadersInjectes = 0
        self.NbShadersMax = len(ListeShaders)
        log_lock = threading.Lock()
        semaphore = threading.Semaphore(5)

        def worker_shader(shader_path, shader_name):
            with semaphore:
                self._say(f"[Début] Traitement de : {shader_name}")
                self._run(shader_path)
                with log_lock:
                    self.NbShadersInjectes += 1
                    nb_restants = self.NbShadersMax - self.NbShadersInjectes
                    self._say(f"[Fini] {shader_name} terminé !")
                    progress_percent = (self.NbShadersInjectes / self.NbShadersMax) * 100
                    self._say(f"Progression : {progress_percent}% (Restants : {nb_restants})")

        for shader in ListeShaders:
            shader_path = os.path.join(self.pack_var.get(), shader)
            if os.path.isdir(shader_path):
                t = threading.Thread(target=worker_shader, args=(shader_path, shader), daemon=True)
                t.start()

    #Action principal
    def _run(self, pack):
        atlas = self.atlas_var.get().strip()
        pack = pack.strip()
        textures = DEFAULT_REF

        self._click()

        #Validations
        if not atlas or not os.path.exists(atlas):
            Error_sound = pygame.mixer.Sound(os.path.join(HERE, "sound", "boom.wav"))
            Error_sound.play()
            self._error("Atlas manquant", "Choisis un fichier d'atlas.")
            return

        #Doit être un .png et un vrai PNG ouvrable
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
        self._set_running(True)
        self._set_status("generating", "orange") 
        self._work(atlas, pack, textures)

        #Le calcul tourne dans un thread pour ne pas geler la fenêtre
        #threading.Thread(target=self._work, args=(atlas, pack, textures), daemon=True).start()

    def _work(self, atlas, pack, textures):
        tmp = None
        try:
            #Copie + injection SDT, directement dans Téléchargements
            base = os.path.basename(os.path.normpath(pack))
            if base.lower().endswith(".zip"):
                base = base[:-4]
            name = base + "_SDT"
            out_pack = os.path.join(DOWNLOADS, name)

            self._say(f"Injection du code SDT… dans : {out_pack}")
            ISDT.inject_sdt(pack, dest=out_pack)

            #Régénération de la table UVHints à partir de l'atlas
            glsl = find_glsl(out_pack)
            if not glsl:
                raise RuntimeError("Injection SDT : aucun glsl de synthèse dans " + out_pack)
            blockdir, tmp = engine.resolve_textures(textures)
            out = glsl + ".generated"
            
            shutil.move(out, glsl)       

            # Rezippage du pack traité
            if self.zip_var.get() :
                zip_path = shutil.make_archive(out_pack, "zip", out_pack)
                shutil.rmtree(out_pack, ignore_errors=True)
                self._say(f"Pack zippé : {zip_path}")
            else :
                self._say(f"Dossier créé : {out_pack}")
            self._set_status("done", "lightgreen")

        except Exception as e:
            self._say("\nERREUR : " + str(e))
            self._say(traceback.format_exc())
            self._set_status("error_status", "red")
        finally:
            if tmp:
                shutil.rmtree(tmp, ignore_errors=True)
            self._set_running(False)


if __name__ == "__main__":
    App().mainloop()
