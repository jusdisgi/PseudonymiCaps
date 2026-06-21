#!/usr/bin/env python3
"""
Overlay a rendered Subliminal Contradiction cap against the original SC STL and
report top-surface deviation. Pure numpy + matplotlib (no extra deps).

Usage:
    python3 tools/verify_sc.py rendered.stl "/path/to/Subliminal-Contradiction/STL/1u Row 3.stl"

Compares the center sagittal (X=0) and transverse (Y=0) top-surface curves of the
two meshes and prints max / RMS deviation in mm. Saves an overlay PNG next to the
rendered file. Best run on the 19.05 MX-stem validation cap vs the matching original
row (both ~18.06 mm footprint, so the tops line up without rescaling).
"""
import sys, os, struct
import numpy as np
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt

def load_stl(path):
    with open(path, "rb") as f:
        f.read(80); n = struct.unpack("<I", f.read(4))[0]
        data = np.frombuffer(f.read(n*50), dtype=np.uint8).reshape(n, 50)
    return data[:, :48].copy().view("<f4").reshape(n, 12)[:, 3:].reshape(n, 3, 3)

def plane_segments(tris, axis, val):
    other = [a for a in range(3) if a != axis]
    segs = []
    for tri in tris:
        dd = tri[:, axis] - val; s = np.sign(dd)
        if np.all(s > 0) or np.all(s < 0): continue
        pts = []
        for i in range(3):
            j = (i+1) % 3
            if dd[i]*dd[j] < 0:
                t = dd[i]/(dd[i]-dd[j]); p = tri[i]+t*(tri[j]-tri[i]); pts.append(p[other])
            elif dd[i] == 0:
                pts.append(tri[i][other])
        if len(pts) >= 2: segs.append((np.array(pts[0]), np.array(pts[1])))
    return segs

def top_curve(segs, n=200):
    P = np.array([p for s in segs for p in s])
    ug = np.linspace(P[:, 0].min(), P[:, 0].max(), n); zt = np.full(n, np.nan)
    for a, b in segs:
        u0, z0 = a; u1, z1 = b
        if abs(u1-u0) < 1e-9: continue
        lo, hi = sorted((u0, u1)); m = (ug >= lo) & (ug <= hi)
        if not m.any(): continue
        zi = z0 + (z1-z0)*(ug[m]-u0)/(u1-u0)
        cur = zt[m]; zt[m] = np.where(np.isnan(cur), zi, np.maximum(cur, zi))
    ok = ~np.isnan(zt); o = np.argsort(ug[ok])
    return ug[ok][o], zt[ok][o]

def deviation(ua, za, ub, zb):
    lo, hi = max(ua.min(), ub.min())+0.6, min(ua.max(), ub.max())-0.6
    xs = np.linspace(lo, hi, 150)
    da = np.interp(xs, ua, za); db = np.interp(xs, ub, zb)
    d = da - db
    return xs, da, db, np.sqrt(np.mean(d**2)), np.max(np.abs(d))

def main():
    if len(sys.argv) != 3:
        print(__doc__); sys.exit(1)
    rend, orig = sys.argv[1], sys.argv[2]
    A, B = load_stl(rend), load_stl(orig)
    fig, axs = plt.subplots(1, 2, figsize=(15, 6))
    for ax, axis, title in ((axs[0], 0, "Sagittal X=0 (front-back)"),
                            (axs[1], 1, "Transverse Y=0 (left-right)")):
        ua, za = top_curve(plane_segments(A, axis, 0.0))
        ub, zb = top_curve(plane_segments(B, axis, 0.0))
        xs, da, db, rms, mx = deviation(ua, za, ub, zb)
        ax.plot(ua, za, "C0", label="reconstructed")
        ax.plot(ub, zb, "C3--", label="original SC")
        ax.set_title(f"{title}\nRMS={rms:.3f} mm  max={mx:.3f} mm")
        ax.set_aspect("equal"); ax.grid(alpha=.3); ax.legend()
        print(f"{title:28s} RMS={rms:.3f} mm   max={mx:.3f} mm")
    out = os.path.splitext(rend)[0] + "_vs_original.png"
    plt.tight_layout(); plt.savefig(out, dpi=110)
    print("overlay saved:", out)

if __name__ == "__main__":
    main()
