# Subliminal Contradiction — reconstruction notes

Pseudoku released **Subliminal Contradiction (SC)** as MX-stem / MX-spaced **STL meshes only**
(no parametric source; "Choc stem variants" is an open to-do in the original repo). To make SC
usable on Choc / Kailh PG1316S boards at low profile, the shape was **reconstructed
parametrically** in this repo's engine rather than mesh-grafted, so the result is a clean,
manifold, fully parametric cap suitable for FDM, resin, and CNC.

This document records how the parameters were derived so the fit is reproducible and tunable.

## Source geometry (measured from the original STLs)

The original STLs were parsed and sliced with `tools/sc_slice.py` (pure-numpy binary-STL reader +
plane sectioner). All caps share an **18.06 × 18.06 mm** 1u footprint (MX), convex sizes grow
4.76 mm/u. The seating plane sits at **z ≈ 0**; the skirt extends to z ≈ −1.0.

Per-row top-surface measurements (z in mm above seating plane; −Y = front):

| Cap      | front rim | back rim | front-back tilt | dish min | side rim | side dish depth |
|----------|----------:|---------:|----------------:|---------:|---------:|----------------:|
| R2 (top) |      3.44 |     5.95 |  **+2.51** (back high) |   2.67 |   5.40 | 1.95 |
| R3 (home)|      4.27 |     3.81 |  −0.46 (near flat) |   2.91 |   5.06 | 1.91 |
| R4 (bot) |      5.72 |     4.30 |  **−1.42** (front high) |   3.88 |   6.11 | 1.79 |
| Uniform  |      4.22 |     4.22 |   0.00 (flat) |   3.15 |   5.06 | 1.91 |
| Convex   |     ~5.3 center (domed) |   — |   — |   — |   — | — |
| R2 reach |      3.94 |     6.46 |  +2.52 |   3.19 |  5.11 / 6.33 (L/R) | lateral lean |
| R3 reach |      4.78 |     4.32 |  −0.45 |   3.53 |  4.92 / 5.88 | lateral lean |
| R4 reach |      6.24 |     4.80 |  −1.44 |   4.39 |  6.21 / 6.83 | lateral lean |

This matches the published spec (max height ~6.5 mm, dish minima ~3.2 mm). Key shape signatures:
a 3-row sculpt (R2 leans back, R3 ~flat, R4 leans forward), a **broad top surface** (little
taper), a **side-to-side saddle ~1.9 mm deep**, and "Left Reachy" inner-column variants that add a
**lateral lean** (right rim higher than left) on top of the row tilt.

## Fitting to the engine

Rim heights and tilts are **edge** features, so they're unaffected by the dish cut. The engine's
outer-shell math (`elliptical_rectangle` + `CapTransform/CapTranslation/CapRotation`) was ported to
numpy (`tools/sc_shell_model.py`) to predict front/back/left/right rim heights for a given
parameter row, and `keyh`, `XSkew`, `YSkew` were fit (zero yaw) to the measured rims:

| Row        | keyh | XSkew | YSkew | fit RMS (mm) |
|------------|-----:|------:|------:|-------------:|
| R3 home    | 4.77 |  +2.1 |   0.0 | 0.51 |
| R2 top     | 5.29 | −11.8 |   0.0 | 0.35 |
| R4 bottom  | 5.83 |  +6.7 |   0.0 | 0.55 |
| R3 uniform | 4.86 |   0.0 |   0.0 | 0.42 |
| R2 reach   | 5.71 | −11.7 |  +6.9 | 0.27 |
| R3 reach   | 5.20 |  +2.5 |  +5.3 | 0.44 |
| R4 reach   | 6.30 |  +6.7 |  +3.3 | 0.51 |

Sign convention (confirmed against this engine): **negative XSkew leans the cap back**, positive
leans it forward; positive YSkew raises the right rim (left-hand inner reach).

The residual (~0.3–0.5 mm) is almost entirely SC's **side rims sitting higher** than the DES default
roundness/taper predicts — i.e. SC's "wider top surface area." This is captured by reducing the top
taper (`TWDif 6.5 → 5.5`, `TLDif 4.5 → 4.0`); final side-rim fit is a render-loop tuning step.

## Dish

The saddle dish is **not** fully re-derived analytically (it's a skinned-ellipse sweep). Instead the
known-good **DES dish baseline** is mapped per row (R2/R3/R4), which already lands in SC's measured
dish-minima band (~2.9–3.9 mm). SC's "deeper, huggier dish" is a small `DishDepth`/`DishHeightDif`
increase to verify against the originals — see verification below.

## Minimum height

The PG1316S mount slot (`pg1316s_negspace`) is only **1.5 mm tall** (z 0→1.5), so minimum cap height
is limited by the **dish**, not the mount. SC's native heights (R3 home top 4.27 mm, dish min ~2.9)
already clear the mount with margin, so the reconstruction preserves SC's true low profile. The
global `heightDelta` (0 by default) raises/lowers the whole set if you want to trade dish depth for
even less height.

## Verification (run on a machine with OpenSCAD)

1. `bash tools/render_sc.sh` renders each preset/row to STL via OpenSCAD CLI.
2. `python3 tools/verify_sc.py <rendered.stl> "<original SC STL>"` slices both and overlays
   sagittal + transverse cross-sections, reporting max/RMS deviation of the top surface.
3. The **19.05 MX-stem validation** preset (`Subliminal_Contradiction_19.05_MXstem_validation.scad`,
   gap 0.99 → 18.06 mm footprint) is built specifically to overlay against Pseudoku's original
   STLs and confirm the reconstructed sculpt matches before trusting the Choc/PG variants.
