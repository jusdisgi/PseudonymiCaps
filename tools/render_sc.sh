#!/usr/bin/env bash
# Render Subliminal Contradiction caps to STL with the OpenSCAD CLI.
# Run on a machine that has OpenSCAD installed (the sandbox that generated these
# files does not). Usage:  bash tools/render_sc.sh [openscad_binary]
set -euo pipefail
OPENSCAD="${1:-openscad}"
OUT="stl/Subliminal_Contradiction"
mkdir -p "$OUT"

# Concave alpha rows (keyID 0..6) from the parametric master, at each preset spacing.
declare -A PRESETS=(
  [16x16]="Subliminal_Contradiction_16x16.scad"
  [17x17]="Subliminal_Contradiction_17x17.scad"
  [18x17]="Subliminal_Contradiction_18x17.scad"
  [19.05x19.05]="Subliminal_Contradiction_19.05x19.05.scad"
)
ROWS=(0 1 2 3 4 5 6)            # R3 R2 R4 uniform R2reach R3reach R4reach
for tag in "${!PRESETS[@]}"; do
  f="${PRESETS[$tag]}"
  for k in "${ROWS[@]}"; do
    "$OPENSCAD" -o "$OUT/SC_${tag}_row${k}.stl" -D "keyID=${k}" "$f"
  done
done

# Convex thumb/mod caps (keyID 0..6 = slanted/flat/1.25/1.5/1.75/2.0/2.25u)
for k in 0 1 2 3 4 5 6; do
  "$OPENSCAD" -o "$OUT/SC_convex_17x17_row${k}.stl" -D "keyID=${k}" Subliminal_Contradiction_Convex.scad
done

# Validation variant vs the original SC release (MX stem, 18.06 mm footprint)
for k in 0 1 2; do
  "$OPENSCAD" -o "$OUT/SC_validate_MX_row${k}.stl" -D "keyID=${k}" \
    Subliminal_Contradiction_19.05_MXstem_validation.scad
done
echo "Done. STLs in $OUT/"
