use <./libraries/scad-utils/morphology.scad> //for cheaper minwoski
use <./libraries/scad-utils/transformations.scad>
use <./libraries/scad-utils/shapes.scad>
use <./libraries/scad-utils/trajectory.scad>
use <./libraries/scad-utils/trajectory_path.scad>
use <./libraries/sweep.scad>
use <./libraries/skin.scad>
use <./libraries/PG1316_Negspace.scad>
//use <z-butt.scad>

/* ============================================================================
   SUBLIMINAL CONTRADICTION  -  low-profile sculpted keycap profile
   ----------------------------------------------------------------------------
   Original sculpt by Pseudoku (https://github.com/pseudoku/Subliminal-Contradiction),
   distributed by the author as MX-stem / MX-spaced STLs only.  This is a
   parametric reconstruction in the Pseudonymicaps engine so the profile can be
   generated for Choc / Kailh PG1316S mounts at arbitrary key spacing.

   How the shape was reconstructed: the original STLs were sliced and measured
   (center sagittal + transverse sections, per row); rim heights and row tilts
   were fit to this engine's keyParameters, and the saddle dish uses the DES
   baseline tuned to SC's measured dish minima (~3.2 mm) and wider top surface.
   See docs/SC_RECONSTRUCTION.md for the full measurement + fit report.

   Rows available (keyID):
     0  R3  home row        (near-flat)
     1  R2  top alpha row   (leans back)
     2  R4  bottom alpha    (leans forward)
     3  R3  uniform / flat  (symmetric, e.g. uniform sets or combos)
     4  R2  left-reach      (back lean + lateral lean for inner column)
     5  R3  left-reach
     6  R4  left-reach
   For a HOMING key, render keyID 0 with homeDot=true (or homeRing=true).
   For RIGHT-hand reach keys, negate the YSkew of rows 4-6 (or mirror the STL).
   Convex thumb / mod caps live in Subliminal_Contradiction_Convex.scad.
   ============================================================================ */

// >>> PRESET: 18x17 PG1316 + 0.5mm foam (+0.5mm height) <<<  (standalone; just render. Master = Subliminal_Contradiction.scad)

// ----------------------------- USER KNOBS -----------------------------------
keyID  = 0;            // which row to render (see table above)

// Key spacing (mm). Cap footprint = unit * units - gap.  Common presets:
//   16, 16  |  17, 17  |  18, 17  |  19.05, 19.05 (MX)
unit_x = 18;
unit_y = 17;
gap    = 1.6;   // 18x17 PG1316 + 0.5mm foam (+0.5mm height)

stemType = "PG1316S";  // "PG1316S" | "Choc" | "MX"  (PG1316S also fits Choc v1)

pgCutout = "foam05";   // PG1316 mount cutout (used only when stemType=="PG1316S"):
                       //   "nofoam" = minimum height (Mike Holscher's EZ-print cutout)
                       //   "foam05" / "foam1" = quieter foam pocket, auto +0.5 / +1.0 mm height
                       //   "old" = Kailh's original cutout geometry
foamLift = (stemType=="PG1316S") ? (pgCutout=="foam05" ? 0.5 : pgCutout=="foam1" ? 1.0 : 0) : 0;

// Render toggles -------------------------------------------------------------
keycap(
    keyID   = keyID,
    Stem    = true,                    // build hollow shell + mount post
    pg1316_nofoam = (stemType=="PG1316S" && pgCutout=="nofoam"),
    pg1316_foam05 = (stemType=="PG1316S" && pgCutout=="foam05"),
    pg1316_foam1  = (stemType=="PG1316S" && pgCutout=="foam1"),
    pg1316_old    = (stemType=="PG1316S" && pgCutout=="old"),
    Dish    = true,
    visualizeDish = false,
    crossSection  = false,             // true = center-cut to inspect walls
    homeDot  = false,                  // R3 homing dots
    homeRing = false,
    Legends  = false
);
// ----------------------------------------------------------------------------



//Parameters
wallthickness = 1.2; // 1.5 for norm, 1.2 for cast master
topthickness  = 1.2; // 2 for norm, 1.6 for cast master
stepsize      = 60;  //resolution of Trajectory
step          = 0.5;   //resolution of ellipes
fn            = 60;  //resolution of Rounded Rectangles: 60 for output
layers        = 50;  //resolution of vertical Sweep: 50 for output
dotRadius     = 0.55;   //home dot size; default 0.55
//---Stem param
stemLayers      = 50; //resolution of stem to cap top transition
stemHeightDelta = 0.3;

heightDelta = 0;   // SC keyh values are absolute; nudge whole set here

keyParameters = //keyParameters[KeyID][ParameterID]
[
// col0/col1 = WIDTH/LENGTH in UNITS (footprint = unit*units - gap)
//uW, uL, TWDif, TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
  [1, 1, 6.5, 4.5, 4.77, 0, 0,   2.1, 0.0, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //0 R3 home  (near flat)
  [1, 1, 6.5, 4.5, 5.29, 0, 0, -11.8, 0.0, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //1 R2 top   (leans back)
  [1, 1, 6.5, 4.5, 5.83, 0, 0,   6.7, 0.0, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //2 R4 bottom(leans fwd)
  [1, 1, 6.5, 4.5, 4.86, 0, 0,   0.0, 0.0, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //3 R3 uniform/flat
  [1, 1, 6.5, 4.5, 5.71, 0, 0, -11.7, 6.9, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //4 R2 left-reach
  [1, 1, 6.5, 4.5, 5.20, 0, 0,   2.5, 5.3, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //5 R3 left-reach
  [1, 1, 6.5, 4.5, 6.30, 0, 0,   6.7, 3.3, 0, 2, 2, 1, 5, 1, 3.5, 2, 2], //6 R4 left-reach
];

dishParameters = //dishParameter[keyID][ParameteID]
[
//FFwd1 FFwd2 FPit1 FPit2 DshDep DshHDif FArcIn FArcFn FArcEx  BFwd1 BFwd2 BPit1 BPit2 BArcIn BArcFn BArcEx
  [ 5, 3.5, 10, -55, 5, 1.8, 8.5, 15, 2,   5, 4.0, 10, -55, 8.5, 15, 2], //0 R3 home
  [ 6, 3.0, 10, -50, 5, 1.8, 8.8, 15, 2,   6, 4.0, 13,  30, 8.8, 16, 2], //1 R2 top
  [ 6, 3.0, 18, -50, 5, 1.8, 8.8, 15, 2,   5, 4.4,  5, -55, 8.8, 15, 2], //2 R4 bottom
  [ 5, 3.5, 10, -55, 5, 1.8, 8.5, 15, 2,   5, 4.0, 10, -55, 8.5, 15, 2], //3 R3 uniform
  [ 6, 3.0, 10, -50, 5, 1.8, 8.8, 15, 2,   6, 4.0, 13,  30, 8.8, 16, 2], //4 R2 reach
  [ 5, 3.5, 10, -55, 5, 1.8, 8.5, 15, 2,   5, 4.0, 10, -55, 8.5, 15, 2], //5 R3 reach
  [ 6, 3.0, 18, -50, 5, 1.8, 8.8, 15, 2,   5, 4.4,  5, -55, 8.8, 15, 2], //6 R4 reach
];

function FrontForward1(keyID) = dishParameters[keyID][0];  //
function FrontForward2(keyID) = dishParameters[keyID][1];  //
function FrontPitch1(keyID)   = dishParameters[keyID][2];  //
function FrontPitch2(keyID)   = dishParameters[keyID][3];  //
function DishDepth(keyID)     = dishParameters[keyID][4];  //
function DishHeightDif(keyID) = dishParameters[keyID][5];  //
function FrontInitArc(keyID)  = dishParameters[keyID][6];
function FrontFinArc(keyID)   = dishParameters[keyID][7];
function FrontArcExpo(keyID)  = dishParameters[keyID][8];
function BackForward1(keyID)  = dishParameters[keyID][9];  //
function BackForward2(keyID)  = dishParameters[keyID][10];  //
function BackPitch1(keyID)    = dishParameters[keyID][11];  //
function BackPitch2(keyID)    = dishParameters[keyID][12];  //
function BackInitArc(keyID)   = dishParameters[keyID][13];
function BackFinArc(keyID)    = dishParameters[keyID][14];
function BackArcExpo(keyID)   = dishParameters[keyID][15];

function BottomWidth(keyID)  = unit_x*keyParameters[keyID][0] - gap;  //col0 = width in units
function BottomLength(keyID) = unit_y*keyParameters[keyID][1] - gap;  //col1 = length in units
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4] + heightDelta + foamLift;  //
function TopWidShift(keyID)  = keyParameters[keyID][5];
function TopLenShift(keyID)  = keyParameters[keyID][6];
function XAngleSkew(keyID)   = keyParameters[keyID][7];
function YAngleSkew(keyID)   = keyParameters[keyID][8];
function ZAngleSkew(keyID)   = keyParameters[keyID][9];
function WidExponent(keyID)  = keyParameters[keyID][10];
function LenExponent(keyID)  = keyParameters[keyID][11];
function CapRound0i(keyID)   = keyParameters[keyID][12];
function CapRound0f(keyID)   = keyParameters[keyID][13];
function CapRound1i(keyID)   = keyParameters[keyID][14];
function CapRound1f(keyID)   = keyParameters[keyID][15];
function ChamExponent(keyID) = keyParameters[keyID][16];
function StemExponent(keyID) = keyParameters[keyID][17];

function FrontTrajectory(keyID, inner = false) =
  [
    trajectory(forward = FrontForward1(keyID), pitch = inner ? 0 : FrontPitch1(keyID)), //more param available: yaw, roll, scale
    trajectory(forward = FrontForward2(keyID), pitch = inner ? 0 : FrontPitch2(keyID))  //You can add more traj if you wish
  ];

function BackTrajectory (keyID, inner = false) =
  [
    trajectory(forward = BackForward1(keyID), pitch =  inner ? 0 : BackPitch1(keyID)),
    trajectory(forward = BackForward2(keyID), pitch =  inner ? 0 : BackPitch2(keyID)),
  ];

//------- function defining Dish Shapes

function ellipse(a, b, d = 0, rot1 = 0, rot2 = 360) = [for (t = [rot1:step:rot2]) [a*cos(t)+a, b*sin(t)*(1+d*cos(t))]]; //Centered at a apex to avoid inverted face

function DishShape (a,b,c,d) =
  concat(
//   [[c+a,b]],
    ellipse(a, b, d = 0,rot1 = 90, rot2 = 270)
//   [[c+a,-b]]
  );



//--------------Function definng Cap
function CapTranslation(t, keyID) =
  [
    ((1-t)/layers*TopWidShift(keyID)),   //X shift
    ((1-t)/layers*TopLenShift(keyID)),   //Y shift
    (t/layers*KeyHeight(keyID))    //Z shift
  ];

function CapRotation(t, keyID) =
  [
    ((1-t)/layers*XAngleSkew(keyID)),   //X shift
    ((1-t)/layers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/layers*ZAngleSkew(keyID))    //Z shift
  ];

function CapTransform(t, keyID) =
  [
    pow(t/layers, WidExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)) + (1-pow(t/layers, WidExponent(keyID)))*BottomWidth(keyID),
    pow(t/layers, LenExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)) + (1-pow(t/layers, LenExponent(keyID)))*BottomLength(keyID)
  ];

function CapRoundness(t, keyID) =
  [
    pow(t/layers, ChamExponent(keyID))*(CapRound0f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound0i(keyID),
    pow(t/layers, ChamExponent(keyID))*(CapRound1f(keyID)) + (1-pow(t/layers, ChamExponent(keyID)))*CapRound1i(keyID)
  ];

function StemTranslation(t, keyID) =
  [
    ((1-t)/stemLayers*TopWidShift(keyID)),   //X shift
    ((1-t)/stemLayers*TopLenShift(keyID)),   //Y shift
    (t/stemLayers*(KeyHeight(keyID)))        //Z shift
  ];

function StemRotation(t, keyID) =
  [
    ((1-t)/stemLayers*XAngleSkew(keyID)),   //X shift
    ((1-t)/stemLayers*YAngleSkew(keyID)),   //Y shift
    ((1-t)/stemLayers*ZAngleSkew(keyID))    //Z shift
  ];

function StemTransform(t, keyID) =
  [
    pow(t/stemLayers, StemExponent(keyID))*(BottomWidth(keyID) -TopWidthDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*8,
    pow(t/stemLayers, StemExponent(keyID))*(BottomLength(keyID)-TopLenDiff(keyID)-wallthickness) + (1-pow(t/stemLayers, StemExponent(keyID)))*5
  ];

function StemRadius(t, keyID) = pow(t/stemLayers,3)*3 + (1-pow(t/stemLayers, 3))*1;
  //Stem Exponent


///----- KEY Builder Module
module keycap(
    keyID = 0,
    visualizeDish = false,
    Dish = true,
    Stem = false,
    pg1316_nofoam = false,
    pg1316_foam05 = false,
    pg1316_foam1  = false,
    pg1316_old    = false,
    crossSection = true,
    Legends = false,
    homeDot = false,
    homeRing = false,
    inner = false,
) {

  //Set Parameters for dish shape
  FrontPath = quantize_trajectories(FrontTrajectory(keyID, inner = inner), steps = stepsize, loop=false, start_position= $t*4);
  BackPath  = quantize_trajectories(BackTrajectory(keyID, inner = inner),  steps = stepsize, loop=false, start_position= $t*4);

  //Scaling initial and final dim tranformation by exponents
  function FrontDishArc(t) =  pow((t)/(len(FrontPath)),FrontArcExpo(keyID))*FrontFinArc(keyID) + (1-pow(t/(len(FrontPath)),FrontArcExpo(keyID)))*FrontInitArc(keyID);
  function BackDishArc(t)  =  pow((t)/(len(FrontPath)),BackArcExpo(keyID))*BackFinArc(keyID) + (1-pow(t/(len(FrontPath)),BackArcExpo(keyID)))*BackInitArc(keyID);

  FrontCurve = [ for(i=[0:len(FrontPath)-1]) transform(FrontPath[i], DishShape(DishDepth(keyID), FrontDishArc(i), 1, d = 0)) ];
  BackCurve  = [ for(i=[0:len(BackPath)-1])  transform(BackPath[i],  DishShape(DishDepth(keyID),  BackDishArc(i), 1, d = 0)) ];

  //builds
  difference(){
    difference(){
      union(){
        difference(){
          skin([for (i=[0:layers-1]) transform(translation(CapTranslation(i, keyID)) * rotation(CapRotation(i, keyID)), elliptical_rectangle(CapTransform(i, keyID), b = CapRoundness(i,keyID),fn=fn))]); //outer shell

          //Cut inner shell
          if (Stem == true) {
            xScale = (BottomWidth(keyID) -wallthickness*2)/BottomWidth(keyID);
            yScale = (BottomLength(keyID)-wallthickness*2)/BottomLength(keyID);
            zScale = (KeyHeight(keyID)-DishHeightDif(keyID)-topthickness)/(KeyHeight(keyID)-DishHeightDif(keyID));
            translate([0,0,-0.1])scale([xScale,yScale,zScale])keycap(keyID, crossSection = false, inner = true);
          }
        }
        if (Stem == true) {
          if (stemType=="MX") mx_stem(); else choc_stem();
          difference() {
            translate([0,0,-.001])skin([for (i=[0:stemLayers-1]) transform(translation(StemTranslation(i,keyID))*rotation(StemRotation(i, keyID)), rounded_rectangle_profile(StemTransform(i, keyID),fn=fn,r=StemRadius(i, keyID)))]); //Transition Support for taller profile
            cube([BottomWidth(keyID),BottomLength(keyID), stemHeightDelta*2], center=true);
          }
        }

      //cut for fonts and extra pattern for light?
      }

      //Cuts

      //Fonts
      if(Legends ==  true){
  //          #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
        translate([0,0,KeyHeight(keyID)-5])linear_extrude(height =5)text( text = "A", font = "Calibri:style=Bold", size = 4, valign = "center", halign = "center" );
        //  #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])translate([0,-3.5,0])linear_extrude(height = 0.5)text( text = "Me", font = "Constantia:style=Bold", size = 3, valign = "center", halign = "center" );
        }
    //Dish Shape
      if(Dish == true){
      if(visualizeDish == false){
        translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      } else {
        #translate([-TopWidShift(keyID),.00001-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)]) rotate([0,-YAngleSkew(keyID),0])rotate([0,-90+XAngleSkew(keyID),90-ZAngleSkew(keyID)])skin(FrontCurve);
        #translate([-TopWidShift(keyID),-TopLenShift(keyID),KeyHeight(keyID)-DishHeightDif(keyID)])rotate([0,-YAngleSkew(keyID),0])rotate([0,-90-XAngleSkew(keyID),270-ZAngleSkew(keyID)])skin(BackCurve);
      }
    }
      if(crossSection == true) {
        translate([0,-15,-.1])cube([15,30,20]);
  //      translate([-15.1,-15,-.1])cube([15,30,20]);
      }

    }
    if (pg1316_nofoam == true) { union() { pg1316_negspace_nofoam(); translate([-10,-10,-20])cube(20); } }
    if (pg1316_foam05 == true) { union() { pg1316_negspace_foam05(); translate([-10,-10,-20])cube(20); } }
    if (pg1316_foam1 == true) { union() { pg1316_negspace_foam1(); translate([-10,-10,-20])cube(20); } }
    if (pg1316_old == true) { union() { pg1316_negspace_old(); translate([-10,-10,-20])cube(20); } }
  }


  //Homing dot
    if(homeDot == true){
      // center dot
      // #translate([0,0,KeyHeight(keyID)-DishHeightDif(keyID)-0.1])sphere(r = dotRadius); // center dot */

      // double bar dots
      #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
          translate([.75,-4.5,KeyHeight(keyID)-DishHeightDif(keyID)+0.5])
          sphere(r = dotRadius, $fn=16);
      #rotate([-XAngleSkew(keyID),YAngleSkew(keyID),ZAngleSkew(keyID)])
          translate([-.75,-4.5,KeyHeight(keyID)-DishHeightDif(keyID)+0.5])
          sphere(r = dotRadius, $fn=16);
    }
    if (homeRing == true) {
        z = KeyHeight(keyID)-DishHeightDif(keyID) - 0.3;

        #rotate([ - XAngleSkew(keyID) * 0.5, -YAngleSkew(keyID), ZAngleSkew(keyID)])
        translate([0, 0, z])

        for (i = [0:3]) {
            translate([0, 0, i * 0.15])
            rotate_extrude(convexity = 10, $fn = 100)
            translate([i * 1.3, 0, 0])
            circle(r = .3, $fn = 100);
        }
    }
  
}

//------------------stems
// Basic Cherry MX cross stem (for 19.05 MX-spaced caps / validation against the
// original SC release). Approximate; tune slop to your switches.
module mx_stem(stemH = 3.6, slop = 0.0) {
  translate([0,0,-stemH/2 + stemHeightDelta + 0.1])
  difference() {
    cylinder(h=stemH, d=5.5+slop, center=true, $fn=48);     // stem body
    // cross slot
    cube([4.1+slop, 1.27-slop, stemH+0.2], center=true);
    cube([1.27-slop, 4.1+slop, stemH+0.2], center=true);
  }
}

module choc_stem(draftAng = 0) {
  stemHeight = 3.1;
  dia = .15;
  wids = 1.2/2;
  lens = 2.9/2;
  module Stem() {
    difference(){
      translate([0,0,-stemHeight/2])linear_extrude(height = stemHeight)hull(){
        translate([wids-dia,-3/2])circle(d=dia);
        translate([-wids+dia,-3/2])circle(d=dia);
        translate([wids-dia, 3/2])circle(d=dia);
        translate([-wids+dia, 3/2])circle(d=dia);
      }

    //cuts
      translate([3.9,0])cylinder(d1=7+sin(draftAng)*stemHeight, d2=7,3.5, center = true, $fn = 64);
      translate([-3.9,0])cylinder(d1=7+sin(draftAng)*stemHeight,d2=7,3.5, center = true, $fn = 64);
    }
  }

  translate([5.7/2,0,-stemHeight/2 + stemHeightDelta + 0.1])Stem();
  translate([-5.7/2,0,-stemHeight/2 + stemHeightDelta + 0.1])Stem();
}

/// ----- helper functions
function rounded_rectangle_profile(size=[1,1],r=1,fn=32) = [
	for (index = [0:fn-1])
		let(a = index/fn*360)
			r * [cos(a), sin(a)]
			+ sign_x(index, fn) * [size[0]/2-r,0]
			+ sign_y(index, fn) * [0,size[1]/2-r]
];

function elliptical_rectangle(a = [1,1], b =[1,1], fn=32) = [
    for (index = [0:fn-1]) // section right
     let(theta1 = -atan(a[1]/b[1])+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta1), a[1]*sin(theta1)]
    + [a[0]*cos(atan(b[0]/a[0])) , 0]
    - [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    - [0, b[0]*sin(atan(b[0]/a[0]))]
    + [0, a[1]*sin(atan(a[1]/b[1]))],

    for(index = [0:fn-1]) // section left
     let(theta2 = -atan(a[1]/b[1])+180+ 2*atan(a[1]/b[1])*index/fn)
      [b[1]*cos(theta2), a[1]*sin(theta2)]
    - [a[0]*cos(atan(b[0]/a[0])) , 0]
    + [b[1]*cos(atan(a[1]/b[1])) , 0],

    for(index = [0:fn-1]) // section Top
     let(theta2 = atan(b[0]/a[0]) + 180 + (180 -2*atan(b[0]/a[0]))*index/fn)
      [a[0]*cos(theta2), b[0]*sin(theta2)]
    + [0, b[0]*sin(atan(b[0]/a[0]))]
    - [0, a[1]*sin(atan(a[1]/b[1]))]
]/2;

function sign_x(i,n) =
	i < n/4 || i > n-n/4  ?  1 :
	i > n/4 && i < n-n/4  ? -1 :
	0;

function sign_y(i,n) =
	i > 0 && i < n/2  ?  1 :
	i > n/2 ? -1 :
	0;
