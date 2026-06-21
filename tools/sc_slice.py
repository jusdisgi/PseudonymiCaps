import numpy as np, struct, os
import matplotlib; matplotlib.use('Agg'); import matplotlib.pyplot as plt

def load_stl(path):
    with open(path,'rb') as f:
        f.read(80); n=struct.unpack('<I',f.read(4))[0]
        data=np.frombuffer(f.read(n*50), dtype=np.uint8).reshape(n,50)
    return data[:,:48].copy().view('<f4').reshape(n,12)[:,3:].reshape(n,3,3)

def plane_segments(tris, axis, val):
    other=[a for a in range(3) if a!=axis]
    segs=[]
    for tri in tris:
        dd=tri[:,axis]-val; s=np.sign(dd)
        if np.all(s>0) or np.all(s<0): continue
        pts=[]
        for i in range(3):
            j=(i+1)%3
            if dd[i]*dd[j]<0:
                tt=dd[i]/(dd[i]-dd[j]); p=tri[i]+tt*(tri[j]-tri[i]); pts.append(p[other])
            elif dd[i]==0:
                pts.append(tri[i][other])
        if len(pts)>=2: segs.append((np.array(pts[0]),np.array(pts[1])))
    return segs

def top_curve(segs, n=200):
    P=np.array([p for s in segs for p in s])
    ug=np.linspace(P[:,0].min(),P[:,0].max(),n); zt=np.full(n,np.nan)
    for (a,b) in segs:
        u0,z0=a; u1,z1=b
        if abs(u1-u0)<1e-9: continue
        lo,hi=sorted((u0,u1)); m=(ug>=lo)&(ug<=hi)
        if not m.any(): continue
        zi=z0+(z1-z0)*(ug[m]-u0)/(u1-u0)
        cur=zt[m]; zt[m]=np.where(np.isnan(cur),zi,np.maximum(cur,zi))
    ok=~np.isnan(zt); return ug[ok],zt[ok]

STLDIR="/sessions/peaceful-ecstatic-keller/mnt/gittyup/Subliminal-Contradiction/STL"
rows={'R2':'1u Row 2.stl','R3':'1u Row 3.stl','R4':'1u Row 4.stl','Uniform':'1u Uniform.stl','Convex':'Convex 1.00u.stl'}
cols={'R2':'C0','R3':'C1','R4':'C2','Uniform':'C3','Convex':'C4'}

fig,axs=plt.subplots(2,2,figsize=(16,11))
# Row1: full outlines.  Row2: top curves.
print("=== Sagittal X=0 : front(-Y) .. back(+Y), top-surface ===")
for name,fn in rows.items():
    t=load_stl(os.path.join(STLDIR,fn)); segs=plane_segments(t,0,0.0)
    for (a,b) in segs: axs[0,0].plot([a[0],b[0]],[a[1],b[1]],cols[name],lw=.3,alpha=.5)
    u,z=top_curve(segs); o=np.argsort(u); u,z=u[o],z[o]
    axs[1,0].plot(u,z,cols[name],label=name)
    fz=z[np.argmin(u)]; bz=z[np.argmax(u)]; ci=np.argmin(abs(u)); 
    dmin=z.min(); ymin=u[np.argmin(z)]
    print(f"{name:8s} front(y={u.min():5.2f})Z={fz:5.2f} centerZ={z[ci]:5.2f} back(y={u.max():5.2f})Z={bz:5.2f} dishMin={dmin:5.2f}@y={ymin:+5.2f} tilt={bz-fz:+5.2f}")
axs[0,0].set_title('Sagittal outline X=0'); axs[1,0].set_title('Sagittal top curve'); axs[1,0].legend()

print("\n=== Transverse Y=0 : left(-X) .. right(+X), top-surface ===")
for name,fn in rows.items():
    t=load_stl(os.path.join(STLDIR,fn)); segs=plane_segments(t,1,0.0)
    for (a,b) in segs: axs[0,1].plot([a[0],b[0]],[a[1],b[1]],cols[name],lw=.3,alpha=.5)
    u,z=top_curve(segs); o=np.argsort(u); u,z=u[o],z[o]
    axs[1,1].plot(u,z,cols[name],label=name)
    lz=z[np.argmin(u)]; rz=z[np.argmax(u)]; dmin=z.min()
    print(f"{name:8s} leftZ={lz:5.2f} rightZ={rz:5.2f} dishMin={dmin:5.2f} sideArc={min(lz,rz)-dmin:5.2f}")
axs[0,1].set_title('Transverse outline Y=0'); axs[1,1].set_title('Transverse top curve'); axs[1,1].legend()
for ax in axs.flat: ax.set_aspect('equal'); ax.grid(alpha=.3)
plt.tight_layout(); plt.savefig('/sessions/peaceful-ecstatic-keller/mnt/outputs/sc_analysis/sections.png',dpi=110)
print("\nsaved")
