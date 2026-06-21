import numpy as np

def elliptical_rectangle(a, b, fn=32):
    # exact port of Hunter's function (returns /2 at end)
    a0,a1=a; b0,b1=b
    pts=[]
    A=np.arctan2  # use degrees like OpenSCAD? OpenSCAD atan uses degrees; here ratios -> atan in rad ok since used symmetrically
    at=lambda y,x: np.degrees(np.arctan2(y,x))
    cos=lambda d: np.cos(np.radians(d)); sin=lambda d: np.sin(np.radians(d))
    for index in range(fn):  # right
        th=-at(a1,b1)+2*at(a1,b1)*index/fn
        pts.append([b1*cos(th)+a0*cos(at(b0,a0))-b1*cos(at(a1,b1)), a1*sin(th)])
    for index in range(fn):  # top
        th=at(b0,a0)+(180-2*at(b0,a0))*index/fn
        pts.append([a0*cos(th), b0*sin(th)-b0*sin(at(b0,a0))+a1*sin(at(a1,b1))])
    for index in range(fn):  # left
        th=-at(a1,b1)+180+2*at(a1,b1)*index/fn
        pts.append([b1*cos(th)-a0*cos(at(b0,a0))+b1*cos(at(a1,b1)), a1*sin(th)])
    for index in range(fn):  # bottom
        th=at(b0,a0)+180+(180-2*at(b0,a0))*index/fn
        pts.append([a0*cos(th), b0*sin(th)+b0*sin(at(b0,a0))-a1*sin(at(a1,b1))])
    return np.array(pts)/2.0

def rotmat(ax,ay,az):
    ax,ay,az=map(np.radians,(ax,ay,az))
    Rx=np.array([[1,0,0],[0,np.cos(ax),-np.sin(ax)],[0,np.sin(ax),np.cos(ax)]])
    Ry=np.array([[np.cos(ay),0,np.sin(ay)],[0,1,0],[-np.sin(ay),0,np.cos(ay)]])
    Rz=np.array([[np.cos(az),-np.sin(az),0],[np.sin(az),np.cos(az),0],[0,0,1]])
    return Rz@Ry@Rx  # OpenSCAD rotate applies Z*Y*X

def build_shell(p, layers=50, fn=60):
    # p: dict with keys matching keyParameters columns
    BW,BL=p['BotWid'],p['BotLen']; TWD,TLD=p['TWDif'],p['TLDif']; KH=p['keyh']
    WSh,LSh=p['WSft'],p['LSft']; XS,YS,ZS=p['XSkew'],p['YSkew'],p['ZSkew']
    WEx,LEx=p['WEx'],p['LEx']; R0i,R0f,R1i,R1f=p['CapR0i'],p['CapR0f'],p['CapR1i'],p['CapR1f']; CEx=p['CapREx']
    pcloud=[]
    for i in range(layers):
        t=i/layers              # exponent / z basis  (pow(i/layers,..))
        rf=(1-i)/layers         # rotation & shift factor (Hunter uses (1-i)/layers)
        w=(t**WEx)*(BW-TWD)+(1-t**WEx)*BW
        l=(t**LEx)*(BL-TLD)+(1-t**LEx)*BL
        r0=(t**CEx)*R0f+(1-t**CEx)*R0i
        r1=(t**CEx)*R1f+(1-t**CEx)*R1i
        prof=elliptical_rectangle([w,l],[r0,r1],fn)
        P=np.column_stack([prof,np.zeros(len(prof))])
        R=rotmat(rf*XS,rf*YS,rf*ZS)
        P=(R@P.T).T
        P[:,0]+= rf*WSh; P[:,1]+=rf*LSh; P[:,2]+= t*KH
        pcloud.append(P)
    return pcloud

def top_curve_from_cloud(pcloud, axis, val=0.0, n=200, tol=0.35):
    # gather points near plane axis=val, project to (other,z), take max-z per bin
    other=[a for a in range(2) if a!=axis][0] if axis<2 else 0
    pts=[]
    for P in pcloud:
        m=np.abs(P[:,axis]-val)<tol
        for q in P[m]:
            pts.append([q[other],q[2]])
    pts=np.array(pts); 
    if len(pts)==0: return None,None
    ug=np.linspace(pts[:,0].min(),pts[:,0].max(),n); zt=np.full(n,np.nan)
    # bin max
    idx=np.clip(((pts[:,0]-ug[0])/(ug[-1]-ug[0])*(n-1)).astype(int),0,n-1)
    for k,z in zip(idx,pts[:,1]):
        if np.isnan(zt[k]) or z>zt[k]: zt[k]=z
    ok=~np.isnan(zt); return ug[ok],zt[ok]

def shell_metrics(p):
    pc=build_shell(p)
    uy,zy=top_curve_from_cloud(pc,0,0.0)   # sagittal (vary Y)
    ux,zx=top_curve_from_cloud(pc,1,0.0)   # transverse (vary X)
    def trim(u,z,t=0.6):
        o=np.argsort(u);u,z=u[o],z[o];m=(u>u.min()+t)&(u<u.max()-t);return u[m],z[m]
    uy,zy=trim(uy,zy); ux,zx=trim(ux,zx)
    frim=zy[uy<0].max(); brim=zy[uy>0].max()
    lrim=zx[ux<0].max(); rrim=zx[ux>0].max()
    topw=ux.max()-ux.min(); topl=uy.max()-uy.min()
    return dict(frontRim=frim,backRim=brim,tilt=brim-frim,leftRim=lrim,rightRim=rrim,
                ltilt=rrim-lrim, maxRim=max(frim,brim,lrim,rrim), topW=topw, topL=topl)

if __name__=="__main__":
    # calibrate: Hunter's PG DES R2 row (keyID 2): XSkew=-13, keyh=10.25+heightDelta(-5.25)=5.0
    base=dict(BotWid=15.4,BotLen=15.4,TWDif=6.5,TLDif=4.5,WSft=0,LSft=0,YSkew=0,ZSkew=0,
              WEx=2,LEx=2,CapR0i=1,CapR0f=5,CapR1i=1,CapR1f=3.5,CapREx=2)
    for name,keyh,xs in [("DES_R2",5.00,-13),("DES_R3",4.00,4),("DES_R4",5.80,9)]:
        p=dict(base, keyh=keyh, XSkew=xs)
        m=shell_metrics(p)
        print(f"{name:7s} XSkew={xs:+3d} keyh={keyh:4.2f} -> frontRim={m['frontRim']:.2f} backRim={m['backRim']:.2f} tilt={m['tilt']:+.2f} topW={m['topW']:.1f} topL={m['topL']:.1f} maxRim={m['maxRim']:.2f}")
