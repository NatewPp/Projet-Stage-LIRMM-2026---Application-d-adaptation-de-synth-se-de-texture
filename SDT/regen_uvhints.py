"""
regen_uvhints.py
================
Régénère les coordonnées pixel de `textureSynthesisUVHints.glsl` pour une version
de Minecraft, À PARTIR DE SON ATLAS.

PHILOSOPHIE (important) :
    Les positions des blocs viennent UNIQUEMENT de l'atlas stitché. Il n'y a donc
    qu'une seule vraie entrée : l'ATLAS de la version visée. On NE passe PAS de
    numéro de version : le numéro ne dit rien des positions et peut induire en
    erreur (textures d'une version + atlas d'une autre = coordonnées fausses).
    -> Tu fournis l'atlas de TA version, et le résultat correspond forcément à TA
       version. C'est plus de travail (il faut dumper l'atlas) mais c'est sûr.

IMAGES DE RÉFÉRENCE (pourquoi le script marche avec juste --atlas) :
    L'atlas est une grande image sans noms. Pour écrire "stone est en (x,y)", il
    faut une image de référence de chaque bloc. Ces références sont EMBARQUÉES une
    fois pour toutes dans `tools/reference_blocks/` (textures 16x16 nommées). Comme
    les textures de blocs sont quasi-stables entre versions, ce jeu de référence
    fonctionne pour la plupart des versions -> tu n'as qu'à fournir --atlas.
    (Si une texture a changé dans ta version, ce bloc tombera en best-match ; tu
     peux alors fournir --textures de TA version pour être exact.)

CE QUE FAIT LE SCRIPT :
    1. découpe l'atlas en tuiles 16x16 ;
    2. pour chaque bloc du .glsl, retrouve sa position dans l'atlas par
       comparaison de pixels (3 niveaux : hash exact -> pixels opaques -> best-match) ;
    3. réécrit le .glsl en gardant structure, catégories, ordre et noms.

USAGE :
    # cas normal : juste l'atlas de ta version
    python regen_uvhints.py --atlas atlas.png

    # appliquer directement au fichier du shader (backup .bak)
    python regen_uvhints.py --atlas atlas.png --apply

    # (optionnel) forcer les textures de TA version (dossier block/ ou .jar)
    python regen_uvhints.py --atlas atlas.png --textures "C:/.../1.21.10.jar"

OPTIONS :
    --atlas     (requis) PNG de l'atlas stitché de la version
    --textures  (optionnel) dossier block/ OU .jar ; défaut = reference_blocks/ embarqué
    --glsl      (def: chemin du shader voisin) le textureSynthesisUVHints.glsl cible
    --out       (def: <glsl>.generated) fichier de sortie
    --apply     remplace le .glsl (backup .bak) au lieu d'écrire .generated

COMMENT OBTENIR L'ATLAS :
    Lance la version dans Minecraft, dumpe l'atlas de blocs (mod de debug / sprite
    dumper). C'est le PNG 'minecraft_textures_atlas_blocks.png_0'.

DÉPENDANCES : pip install pillow numpy
"""

import argparse # Pour parser les arguments du code
import hashlib # calcul des empreintes pour facilement comparer des tuiles
import os # Pour les fonctions qui permettent de se déplacer dans les différents répertoires
import re # pour les regex
import shutil # pour la manipulation de fichiers/dossiers
import sys # Pour sys.exit | sortir du programme
import tempfile # Création de fichier temporaire
import zipfile # lire les .zip, .jar etc
import numpy as np # Pour les calculs matriciel
from PIL import Image # Pour gérer les images png

# CONSTANTES
TILE = 16 
MIN_OPAQUE_PX = 12
HERE = os.path.dirname(os.path.abspath(__file__)) # dossier source du script
DEFAULT_GLSL = os.path.normpath(os.path.join( # chemin vers le glsl
    HERE, "..", "shaders", "lib", "materials", "materialHandling",
    "textureSynthesisUVHints.glsl"))

LINE_RE = re.compile( #regex pour identifier les blocs dans le fichier glsl
    r'^(\s*)vec2\(\s*([\d.]+)\s*,\s*([\d.]+)\s*\)(\s*,?)\s*//\s*([a-z0-9_]+)\b.*$'
)


def detect_tile_size(blockdir):
    """Donne la résolution d'une tuile de minecraft vanilla"""
    from collections import Counter
    widths = Counter()
    for f in os.listdir(blockdir):
        if f.endswith(".png"):
            try:
                widths[Image.open(os.path.join(blockdir, f)).size[0]] += 1
            except Exception:
                pass
    return widths.most_common(1)[0][0] if widths else TILE


def build_atlas_index(atlas_path, tile):
    """Renvoie un dictionnaire pour gérer l'atlas"""
    atlas = np.asarray(Image.open(atlas_path).convert("RGBA"))
    h, w, _ = atlas.shape
    nx, ny = w // tile, h // tile          # grille déduite de la TAILLE de l'atlas
    t2 = tile * tile
    tiles = (atlas[: ny * tile, : nx * tile]
             .reshape(ny, tile, nx, tile, 4).transpose(0, 2, 1, 3, 4)
             .reshape(-1, tile, tile, 4))
    positions = np.array([(tx * tile, ty * tile)
                          for ty in range(ny) for tx in range(nx)])
    hash_idx = {}
    for i, t in enumerate(tiles):
        hash_idx.setdefault(hashlib.md5(t.tobytes()).digest(), []).append(i)
    rgb = tiles[:, :, :, :3].reshape(len(tiles), t2, 3).astype(int)
    rgba_i = tiles.astype(int).reshape(len(tiles), t2, 4)
    return dict(w=w, h=h, tile=tile, positions=positions, hash_idx=hash_idx,
                rgb=rgb, rgba_i=rgba_i)


def match_block(name, blockdir, A):
    """Retourne les coordonnées du bloc ainsi que la méthode utilisé pour l'obtenir"""
    tile = A["tile"]; t2 = tile * tile
    p = os.path.join(blockdir, name + ".png")
    if not os.path.exists(p):
        return None, "synthetic"
    im = Image.open(p).convert("RGBA")
    if im.size[0] != tile:
        return None, "notile"
    top = np.asarray(im)[:tile, :tile, :]
    # (a) hash exact
    h = hashlib.md5(top.tobytes()).digest()
    if h in A["hash_idx"]:
        i = A["hash_idx"][h][0]
        return (int(A["positions"][i][0]), int(A["positions"][i][1])), "exact"
    # (b) pixels opaques, RGB exact
    mask = (top[:, :, 3] == 255).reshape(t2)
    if mask.sum() >= MIN_OPAQUE_PX:
        ref = top.reshape(t2, 4)[mask, :3].astype(int)
        hits = np.where(np.all(A["rgb"][:, mask, :] == ref, axis=(1, 2)))[0]
        if len(hits):
            i = hits[0]
            return (int(A["positions"][i][0]), int(A["positions"][i][1])), "opaque"
    # (c) best-match L1 (à vérifier visuellement)
    d = np.abs(A["rgba_i"] - top.astype(int).reshape(t2, 4)).sum(axis=(1, 2))
    i = int(np.argmin(d))
    return (int(A["positions"][i][0]), int(A["positions"][i][1])), f"bestmatch(d={int(d[i])})"


def resolve_textures(textures_arg):
    """Accepte un dossier block/ OU un .jar. Retourne le path du dossier des textures de minecraft ainsi que
    le path d'un potentiel dossier temporaire à supprimer ultérieurement"""
    if os.path.isdir(textures_arg):
        return textures_arg, None
    if zipfile.is_zipfile(textures_arg):
        tmp = tempfile.mkdtemp(prefix="mcblocks_")
        prefix = "assets/minecraft/textures/block/"
        n = 0
        with zipfile.ZipFile(textures_arg) as z:
            for m in z.namelist():
                if m.startswith(prefix) and not m.endswith("/"):
                    with z.open(m) as src, open(os.path.join(tmp, os.path.basename(m)), "wb") as out:
                        shutil.copyfileobj(src, out)
                    n += 1
        print(f"  ({n} textures extraites du .jar)")
        return tmp, tmp
    print(f"--textures doit être un dossier ou un .jar : {textures_arg}", file=sys.stderr)
    sys.exit(1)


def regenerate(atlas_path, blockdir, glsl_path, out_path):
    """Modifie le fichier glsl mis en argument lors de l'éxécution du script python"""
    tile = detect_tile_size(blockdir)
    A = build_atlas_index(atlas_path, tile)
    print(f"Tuile detectee: {tile}px | Atlas : {A['w']}x{A['h']}  ({A['w']//tile}x{A['h']//tile} tuiles)")
    src = open(glsl_path, encoding="utf-8", errors="ignore").read().split("\n")
    out = []
    n_ok = n_verif = n_fail = 0
    verif, fail = [], []
    for ln in src:
        m = LINE_RE.match(ln) # pour verifier si une ligne correspond à notre regex
        if not m:
            out.append(ln)
            continue
        indent, x0, y0, comma, name = m.groups()
        pos, how = match_block(name, blockdir, A)
        if pos:
            tag = "" if how in ("exact", "opaque") else f"  // <verif: {how}>"
            out.append(f"{indent}vec2({pos[0]}.0, {pos[1]}.0){comma} //{name}{tag}")
            if how in ("exact", "opaque"):
                n_ok += 1
            else:
                n_verif += 1
                verif.append((name, pos, how))
        else:
            out.append(f"{indent}vec2({x0}, {y0}){comma} //{name} // !! NON REPLACE - texture custom shaderpack ({how})")
            n_fail += 1
            fail.append(name)
    open(out_path, "w", encoding="utf-8").write("\n".join(out))
    print(f"\nPlacés fiables (exact/opaque) : {n_ok}")
    print(f"Placés best-match (à vérifier): {n_verif}")
    print(f"Non placés (custom shaderpack): {n_fail}")
    if verif:
        print("\nÀ vérifier en jeu :")
        for name, pos, how in verif:
            print(f"   {name:28} -> {pos}  {how}")
    if fail:
        print("\nCustom shaderpack (fournir les PNG source) :", ", ".join(fail))


def main():
    ap = argparse.ArgumentParser(description="Régénère textureSynthesisUVHints.glsl à partir d'un atlas.")
    ap.add_argument("--atlas", required=True, help="PNG de l'atlas stitché de la version")
    ap.add_argument("--textures", default=None, help="(optionnel) dossier block/ OU .jar. Défaut: references embarquées dans tools/reference_blocks/")
    ap.add_argument("--glsl", default=DEFAULT_GLSL, help="textureSynthesisUVHints.glsl cible")
    ap.add_argument("--out", default=None, help="sortie (def: <glsl>.generated)")
    ap.add_argument("--apply", action="store_true", help="remplace le .glsl (backup .bak)")
    args = ap.parse_args()

    if not os.path.exists(args.atlas):
        print(f"Atlas introuvable : {args.atlas}", file=sys.stderr); sys.exit(1) #cas ou on ne trouve pas l'atlas.png
    if not os.path.exists(args.glsl):
        print(f"GLSL introuvable : {args.glsl}", file=sys.stderr); sys.exit(1) #cas ou on ne trouve pas textureSynthesisUVHinyd.glsl

    textures = args.textures or os.path.join(HERE, "reference_blocks") 
    if not args.textures:
        print(f"(textures: references embarquees -> {textures})")
    blockdir, tmp = resolve_textures(textures)
    try:
        out = args.out or (args.glsl + ".generated")
        regenerate(args.atlas, blockdir, args.glsl, out)
        if args.apply:
            bak = args.glsl + ".bak"
            if not os.path.exists(bak):
                shutil.copyfile(args.glsl, bak)
                print(f"\nBackup -> {bak}")
            shutil.move(out, args.glsl)
            print(f"Appliqué -> {args.glsl}")
        else:
            print(f"\nFichier généré : {out}  (ajoute --apply pour remplacer l'original)")
    finally:
        if tmp:
            shutil.rmtree(tmp, ignore_errors=True)


if __name__ == "__main__":
    main()
