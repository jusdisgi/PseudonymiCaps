# PseudonymiCaps - PG1316 (mostly) Keycaps

Parametric, 3D-printable **keycap profiles** for low-profile mechanical keyboards — sculpted
caps you generate yourself in [OpenSCAD](https://openscad.org/) and export to STL for FDM, resin,
or CNC. Profiles are tuned for **Kailh PG1316S** and **Kailh Choc v1** switches across a range of
key spacings.

> Profiles originate with **Pseudoku** (proprietor of [Asymplex](http://asymplex.xyz/), author of
> the [DES profile](https://kbd.news/On-the-DES-keycap-profile-2229.html)), with additions by
> zzeneg and others. This repo is a slimmed-down, PG1316S-focused descendant — see
> [Why this repo](#why-this-repo).

---

## Quick start (5 minutes)

1. **Install OpenSCAD** (free, all platforms): <https://openscad.org/downloads.html>.
2. **Clone this repo** (the `libraries/` folder must sit next to the profile files).
3. **Open a profile** — e.g. `Subliminal_Contradiction_17x17.scad` — in OpenSCAD.
4. **Pick a key** near the top of the file:
   ```
   keyID = 0;   // which row/size to generate (the comment lists them)
   ```
5. Press **F5** to preview, **F6** to render, then **File → Export → Export as STL**.

That's it. Each profile file has a short **USER KNOBS** block at the top — spacing, stem type, and
which key to render — and you don't need to touch anything below it.

---

## Which file do I open?

| You want… | Open |
|-----------|------|
| **Subliminal Contradiction** (newest, low + sculpted), alphas | `Subliminal_Contradiction_<spacing>.scad` |
| Subliminal Contradiction thumb / mod caps (convex) | `Subliminal_Contradiction_Convex.scad` |
| **DES** (high-sculpt smooth) | `PG1316_DES_<spacing>_<variant>.scad` |
| **Chicago Stenographer** (subtle low-profile sculpt) | `PG1316_Chicago_Steno_<spacing>_<variant>.scad` |
| Convex / thumb variants of CS | `PG1316_Chicago_Steno_Convex_<spacing>_<variant>.scad` |

`<spacing>` is the key pitch: `17x17`, `18x17`, `19x19`, etc. `<variant>` is the PG1316 mount cutout:
`minZ` (lowest, no foam), `Foam05` (0.5 mm deeper for thin damping foam), or `Foam1` (1 mm deeper).
Subliminal Contradiction also ships a fully parametric master (`Subliminal_Contradiction.scad`)
where you set `unit_x`/`unit_y` yourself, plus standalone presets for **16×16, 17×17, 18×17, and
19.05×19.05**.

### Picking a spacing and stem

- **Stem / switch:** PG1316S caps also fit **Choc v1**. In the Subliminal Contradiction files set
  `stemType` in the USER KNOBS block to `"PG1316S"`, `"Choc"`, or `"MX"`.
- **Spacing:** most low-profile splits use **17×17** or **18×17**. **16×16** is tight/minimal,
  **19.05×19.05** is standard MX spacing. Cap footprint = `pitch − gap` (gap ≈ 1.6 mm by default).

---

## Subliminal Contradiction

A reconstruction of Pseudoku's **Subliminal Contradiction** — a next-gen DES that's lower and
flatter (like Chicago Steno) but as sculpted as DES, with a deeper "huggier" dish and a wide top
surface. The original ships as MX-stem STLs only; here it's rebuilt parametrically so it can be
generated for Choc / PG1316S at low profile and any spacing.

- **Alphas:** 3-row sculpt — `keyID` `1`=R2 (top, leans back), `0`=R3 (home), `2`=R4 (bottom,
  leans forward), `3`=uniform/flat, plus left-hand reach variants (`4`/`5`/`6`). Homing key =
  render `keyID 0` with `homeDot=true`. Right-hand reach = negate the row's `YSkew` (or mirror).
- **Thumbs / mods:** `Subliminal_Contradiction_Convex.scad`, sizes 1.0–2.25u + a slanted thumb.
- See [`docs/SC_RECONSTRUCTION.md`](docs/SC_RECONSTRUCTION.md) for exactly how the shape was
  measured from the originals and fit — and how to verify your renders against them
  (`tools/verify_sc.py`, `tools/render_sc.sh`).

---

## PG1316 mount cutouts

The PG1316 / PG1316S switch needs an unusual internal cutout. The DES and Chicago Steno files come
in variants for four cutout shapes (the library shapes live in `libraries/`):

1. **old** — the official Kailh cutout. Works great with the switches, but hard to print accurately.
2. **nofoam** — an "EZ-Print" cutout (by Mike Holscher) designed to 3D-print more easily.
3. **Foam05** — the EZ-Print cutout, 0.5 mm deeper, leaving room for a thin sound-damping foam
   layer (caps are 0.5 mm taller to suit).
4. **Foam1** — EZ-Print, 1 mm deeper, for a thicker foam layer (more cap height again).

---

## Editing profiles / making your own

Every profile is a table of per-key rows. The big `keyParameters` and `dishParameters` arrays
define the cap body and the dish (scoop) respectively. A friendly column-by-column guide lives in
[`docs/PROFILE_PARAMETERS.md`](docs/PROFILE_PARAMETERS.md). Short version: change a number, press
F5, look at the cross-section (`crossSection=true` cuts the cap in half so you can see the walls).

The profile families, briefly:

- **DES (Distorted Ellipsoidal Saddle)** — high-sculpt, smooth row-to-row transition.
- **Chicago Stenographer (CS)** — subtly sculpted, choc-spaced, low profile; convex variant for thumbs.
- **Subliminal Contradiction** — lower/flatter than DES with a deeper dish and broad top (see above).
- **Philadelphia Minimalist** — minimal spacing (upstream, under construction).

---

## Why this repo

Pseudoku's [original repo](https://github.com/pseudoku/PseudoMakeMeKeyCapProfiles) has a long fork
history and a `.git` directory over 1.5 GB (mostly old STL exports). This is a clean, small
descendant — only the files needed to *generate* caps — focused on adapting the profiles to the
ultra-low-profile **Kailh PG1316S** switch (the 17×17 files also fit Choc; PG caps are ~0.5 mm
taller than zzeneg's ultra-low Choc DES because the PG mounting slot needs the room). STL exports
live elsewhere and are linked when available.

## License

See [LICENSE](LICENSE). Profiles derive from Pseudoku's work; please keep attribution.
