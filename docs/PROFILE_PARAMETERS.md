# Profile parameters — a friendly guide

Every profile file is driven by two tables: **`keyParameters`** (the cap body) and
**`dishParameters`** (the scooped top). One row per key; `keyID` selects the row. You tune a cap by
editing numbers in these rows and pressing **F5**. Turn on `crossSection=true` to slice the cap in
half and watch the walls and dish as you tweak.

Units are millimetres and degrees. Angles accumulate over the vertical sweep, so a few degrees goes
a long way.

## `keyParameters` columns

| # | Name | What it does |
|--:|------|--------------|
| 0 | `BotWid` / units | Cap bottom width. In Subliminal Contradiction this column is **width in units** and the footprint is computed as `unit_x * units - gap`. In the older files it's an absolute mm width. |
| 1 | `BotLen` / units | Cap bottom length (same convention as col 0, using `unit_y`). |
| 2 | `TWDif` | How much **narrower the top is than the bottom**, in width. Bigger = more taper / smaller top. Smaller = wider top surface. |
| 3 | `TLDif` | Same, for length (front-to-back). |
| 4 | `keyh` | **Cap height** (top above the seating plane). The single biggest knob for profile height. |
| 5 | `WSft` | Shifts the top sideways (X) relative to the bottom. |
| 6 | `LSft` | Shifts the top forward/back (Y). |
| 7 | `XSkew` | **Front-back tilt.** Negative leans the cap **back** (top rows), positive leans it **forward** (bottom rows). |
| 8 | `YSkew` | **Left-right tilt.** Used for inner-column "reach" keys; positive raises the right edge. |
| 9 | `ZSkew` | Yaw (rotation about vertical). Usually 0. |
| 10 | `WEx` | Width taper *exponent* — how the taper is distributed up the height (2 ≈ gentle barrel). |
| 11 | `LEx` | Length taper exponent. |
| 12 | `CapR0i` | Corner rounding at the **bottom**, axis 0. |
| 13 | `CapR0f` | Corner rounding at the **top**, axis 0. Larger = rounder top corners. |
| 14 | `CapR1i` | Corner rounding at the bottom, axis 1. |
| 15 | `CapR1f` | Corner rounding at the top, axis 1. |
| 16 | `CapREx` | Exponent controlling how rounding blends bottom→top. |
| 17 | `StemEx` | Exponent for the stem-to-top transition support. |

## `dishParameters` columns

The dish is a saddle swept from a **front** trajectory and a **back** trajectory that meet in the
middle. Most rows only need small tweaks from a working baseline.

| # | Name | What it does |
|--:|------|--------------|
| 0 | `FFwd1` | Front trajectory: first segment length. |
| 1 | `FFwd2` | Front trajectory: second segment length. |
| 2 | `FPit1` | Front pitch (curvature) of segment 1 — controls how the front lip rises. |
| 3 | `FPit2` | Front pitch of segment 2. |
| 4 | `DshDep` | **Dish depth** — how deep the scoop is. Bigger = "huggier". |
| 5 | `DshHDif` | How far **below the cap top** the dish sits (vertical placement of the scoop). |
| 6 | `FArcIn` | Front dish arc radius at the start (side-to-side curvature of the scoop). |
| 7 | `FArcFn` | Front dish arc radius at the end. |
| 8 | `FArcEx` | Exponent blending `FArcIn`→`FArcFn`. |
| 9–15 | `BFwd1 BFwd2 BPit1 BPit2 BArcIn BArcFn BArcEx` | Same set for the **back** half of the saddle. |

## Common edits

- **Lower the whole cap:** decrease `keyh` (col 4), or set the file's global `heightDelta` negative.
- **Wider, flatter top (more keycap surface):** decrease `TWDif`/`TLDif`.
- **Deeper scoop:** increase `DshDep`; if it pokes through the wall, also nudge `DshHDif`.
- **Change row tilt:** adjust `XSkew` (front-back). Negative = leans back, positive = leans forward.
- **Inner-column reach key:** add a few degrees of `YSkew` (negate for the opposite hand).
- **Inspect walls/dish:** set `crossSection=true` in the render call and press F5.

See [`SC_RECONSTRUCTION.md`](SC_RECONSTRUCTION.md) for a worked example: measuring a target shape
and fitting these parameters to it.
