#!/usr/bin/env python3
"""
Regenerate every Subliminal Contradiction preset from the parametric master.

The master `Subliminal_Contradiction.scad` is the single source of truth for the
SC geometry (keyParameters / dishParameters / engine). The per-spacing and foam
files are just the master with a few knobs flipped, so after you tune the master,
run this to push the changes out to all of them:

    python3 tools/make_presets.py        # run from the repo root

It rewrites: the 16/17/18/19.05 spacing presets, the 19.05 MX-stem validation cap,
and the 17x17 / 18x17 foam (Foam05 / Foam1) presets. It does NOT touch the master
or the convex file.
"""
import re, os

MASTER = "Subliminal_Contradiction.scad"

def stamp(fn, unit_x, unit_y, gap, stem, cut, label):
    s = open(MASTER).read()
    s = re.sub(r'unit_x = 17;',          f'unit_x = {unit_x};', s, 1)
    s = re.sub(r'unit_y = 17;',          f'unit_y = {unit_y};', s, 1)
    s = re.sub(r'gap    = 1\.6;[^\n]*',  f'gap    = {gap};   // {label}', s, 1)
    s = re.sub(r'stemType = "PG1316S";', f'stemType = "{stem}";', s, 1)
    s = re.sub(r'pgCutout = "nofoam";',  f'pgCutout = "{cut}";', s, 1)
    s = s.replace(
        '   ============================================================================ */',
        '   ============================================================================ */\n\n'
        f'// >>> PRESET: {label} <<<  (standalone; just render. Master = {MASTER})')
    open(fn, "w").write(s)
    print("wrote", fn)

# spacing presets (nofoam / min height)
stamp("Subliminal_Contradiction_16x16.scad",       16,    16,    1.4,  "PG1316S", "nofoam", "16x16 (Choc/PG, tight)")
stamp("Subliminal_Contradiction_17x17.scad",       17,    17,    1.6,  "PG1316S", "nofoam", "17x17 (Choc/PG)")
stamp("Subliminal_Contradiction_18x17.scad",       18,    17,    1.6,  "PG1316S", "nofoam", "18x17 (Choc/PG)")
stamp("Subliminal_Contradiction_19.05x19.05.scad", 19.05, 19.05, 0.99, "PG1316S", "nofoam", "19.05x19.05 (MX spacing, PG/Choc stem)")
# validation cap vs the original SC release (MX stem, 18.06 mm footprint)
stamp("Subliminal_Contradiction_19.05_MXstem_validation.scad", 19.05, 19.05, 0.99, "MX", "nofoam",
      "19.05 MX-stem VALIDATION vs original SC")
# foam presets for the two board spacings
for sp, (ux, uy, gap) in {"17x17": (17, 17, 1.6), "18x17": (18, 17, 1.6)}.items():
    stamp(f"Subliminal_Contradiction_{sp}_Foam05.scad", ux, uy, gap, "PG1316S", "foam05",
          f"{sp} PG1316 + 0.5mm foam (+0.5mm height)")
    stamp(f"Subliminal_Contradiction_{sp}_Foam1.scad",  ux, uy, gap, "PG1316S", "foam1",
          f"{sp} PG1316 + 1.0mm foam (+1.0mm height)")
print("done — all presets regenerated from", MASTER)
