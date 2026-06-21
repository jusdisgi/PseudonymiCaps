# Repo architecture & cleanup notes

## How a profile file is organized

Each profile `.scad` has the same shape, top to bottom:

1. `use <./libraries/...>` — the sweep/skin/scad-utils helpers and `PG1316S_Negative_Space.scad`.
2. **USER KNOBS** — `keyID`, spacing (`unit_x`/`unit_y`/`gap`), `stemType`, and the `keycap(...)`
   render call with toggles. *This is the only block most users touch.*
3. **Engine parameters** — resolution + wall/stem constants.
4. **`keyParameters` / `dishParameters`** tables — one row per key (see `PROFILE_PARAMETERS.md`).
5. **Accessor functions** — name the columns (`BottomWidth`, `KeyHeight`, `XAngleSkew`, …).
   In the Subliminal Contradiction files `BottomWidth`/`BottomLength` are spacing-aware
   (`unit_x * units - gap`), so one file works at any pitch.
6. **`keycap` module** + helpers (`choc_stem`, `mx_stem`, `elliptical_rectangle`, …).

Per the repo convention, **one file per spacing** (`*_17x17`, `*_18x17`, `*_19x19`). This avoids
OpenSCAD's `use`-scope limitation: a `use`d module resolves globals like `keyParameters` at the call
site, so cap dimensions can't be cleanly overridden across files. Subliminal Contradiction keeps the
convention with standalone presets, but is *also* parametric (set `unit_x`/`unit_y` in the master).

## Current cleanup done

- Beginner `README.md` with a 5-minute quickstart and a "which file do I open" table.
- `docs/PROFILE_PARAMETERS.md` — plain-language column reference.
- `docs/SC_RECONSTRUCTION.md` — worked example (measure a target, fit parameters).
- Consistent **USER KNOBS** header + `stemType` selector across the new Subliminal Contradiction
  files, which serve as the clean exemplar for the house style.
- `tools/` — STL slicer, the numpy port of the shell math, and a render+overlay verifier.

## Proposed deeper refactor (render-gated)

The `keycap` module and pure helper functions are duplicated across ~16 files. The safe way to
de-duplicate, **verified one file at a time in OpenSCAD** (don't do it blind):

1. Move the **pure helpers** (`elliptical_rectangle`, `rounded_rectangle_profile`, `ellipse`,
   `sign_x/sign_y`) into `libraries/keycap_helpers.scad` and `use` them. These have no dependency on
   `keyParameters`, so `use` is safe. Removes the largest block of duplication with low risk.
2. Refactor the `keycap` module to take the parameter **row as an argument** instead of reading the
   global `keyParameters[keyID]`. That makes the whole engine `use`-safe and lets it live in one
   `libraries/keycap_engine.scad`, with each profile reduced to its tables + a thin call.
3. Standardize file/column naming and add the USER KNOBS header to the older DES/CS files.

Step 1 is mechanical and low-risk; steps 2–3 change the module signature and every call site, so
each converted profile should be rendered and (ideally) overlaid against a known-good STL with
`tools/verify_sc.py` before committing.
