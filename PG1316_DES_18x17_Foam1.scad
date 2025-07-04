use <./libraries/scad-utils/morphology.scad> //for cheaper minwoski
use <./libraries/scad-utils/transformations.scad>
use <./libraries/scad-utils/shapes.scad>
use <./libraries/scad-utils/trajectory.scad>
use <./libraries/scad-utils/trajectory_path.scad>
use <./libraries/sweep.scad>
use <./libraries/skin.scad>
use <./libraries/PG1316_Negspace.scad>
//use <z-butt.scad>

// DES (Distorted Elliptical Saddle) v2 - 18x17 Spacing - Minimum Z-height
// For Kailh PG1316 / PG1316S ultra-low-profile keyswitches
// EZ-Print cutout - different deisgn vs. Kailh keycaps, works better with 3D printers
// Foam mod - 1mm extra cutout depth

//Cheat Sheet: key KeyIDs to know
//0 Regular bottom alpha row (R4)
//1 Regular home row (R3)
//2 Regular top alpha row (R2)
//5 Regular num row (R1)
//43 Edge R4
//44 Edge R3
//45 Edge R2
//46 Edge R1
//47 Thumb
//48 Thumb
//49 Thumb

// Configure keycap to render here. You probably only want to
// do one at a time unless your computer is real fast.
keycap(
    keyID  = 48, //change profile refer to KeyParameters Struct
    Stem   = false, //Turn on shell and Choc v1 stem.
    pg1316_nofoam = false, //Turn on (new) PG1316 mounting slot, without space for foam mod
    pg1316_foam1 = true, //Turn on PG1316 mounting slot with 1mm foam allowance (need to increase key height)
    pg1316_foam05 = false, //Turn on PG1316 mounting slot with 0.5mm foam allowance (need more height)
    pg1316_old = false, //Turn on old "official" PG1316 mounting slot. 
    Dish   = true, //turn on dish cut
    visualizeDish = false, // turn on debug visual of Dish
    crossSection  = false, // center cut to check internal
    homeDot = false, //turn on homedots
    homeRing = false, //turn on homing rings
    Legends = false
);



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

heightDelta = -5.25;

keyParameters = //keyParameters[KeyID][ParameterID]
[
//BotWid, BotLen, TWDif, TLDif, keyh, WSft, LSft, XSkew, YSkew, ZSkew, WEx, LEx, CapR0i, CapR0f, CapR1i, CapR1f, CapREx, StemEx
//Column high sculpt 3 row system
//0~5
[16.4,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//0 R4 8
[16.4,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//1 R3 Home
[16.4,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//2 R2
[16.4,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.00,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//3 R3 deepdish
[16.4,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//4 R5 mod
[16.4,	15.40,	6.50,	4.50,	16.00,	0.00,	-0.50, 20.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//5 R1 num

//1.25u 6~9
[20.6,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//6 R5
[20.6,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//7 R4  // neuron 3 deg
[20.6,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//8 R3 Home
[20.6,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//9 R2
//1.5u 10~13
[24.9,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//10 R5
[24.9,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//11 R4
[24.9,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//12 R3 Home
[24.9,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//13 R2
//1.75u 14~17
[29.2,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//14 R5
[29.2,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//15 R4
[29.2,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//16 R3 Home
[29.2,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//17 R2
//2.0u  18~22
[33.4,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//18 R5
[33.4,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//19 R4
[33.4,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//20 R3 Home
[33.4,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//21 R2
[33.4,	15.40,	6.50,	4.50,	16.00,	0.00,	-0.50, 20.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//22 R1
//2.25u 23~26
[37.7,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//23 R5
[37.7,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//24 R4
[37.7,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//25 R3 Home
[37.7,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//26 R2
//2.50u 27~30
[41.9,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//27 R5  // neuron 2deg height to 10.5
[41.9,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//28 R4
[41.9,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//29 R3 Home
[41.9,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//30 R2
//2.75u 31~34
[46.2,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//31 R5
[46.2,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//32 R4
[46.2,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	-4.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//33 R3 Home
[46.2,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//34 R2
//3.00u 34~37
[50.4,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//35 R5
[50.4,	15.40,	6.50,	4.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//36 R4
[50.4,	15.40,	6.50,	4.50,	9.75,	  0.00,	0.50,	4.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//37 R3 Home
[50.4,	15.40,	6.50,	4.50,	10.75,	0.00,	0.00,	-13.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//38 R2
//6.25u 39
[105.7,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//39 R5
//7.00u 40
[118.4,	15.40,	6.50,	4.50,	12.50,	0.00,	0.00,	-3.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//40 R5
//num pad vert  2u 41
[16.4,  33.4,	6.50,	6.50,	10.50,	0.00,	0.00,	-5.00,	0.00,	0.00,	2.00,	2.00,	1.00,	6.00,	1.00,	3.50,	2.00,	2],	//41 R4
[16.4,  33.4,	6.50,	6.50,	11.55,	0.00,	0.00,	9.00,	  0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//42 R4
//edge 43-46
[16.4,  15.4,	6.50,	4.50,	12.30,	0.00,	0.00,	9.00,	  15.0,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//43 R4
[16.4,  15.4,	6.50,	4.50,	10.50,	0.00,	0.50,	4.00,	  15.0,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//44 R3
[16.4,  15.4,	6.50,	4.50,	11.50,	0.00,	0.00,	-13.00,	15.0,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//45 R2
[16.4,  15.4,	6.50,	4.50,	15.80,	0.00,	-0.50, -20.0,	15.0,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.50,	2.00,	2],	//46 R1 num
//thumbs 47-49
[16.4,  15.4,	4.00,	4.00,	12.00,	0.00,	0.00,	-10.00,	-5.0,	-10,	2.00,	2.00,	1.00,	5.00,	1.00,	2.00,	2.00,	2],	//47
[16.4,  15.4,	4.00,	3.50,	11.00,	0.00,	0.00,	-10.00,	0.00,	0.00,	2.00,	2.00,	1.00,	5.00,	1.00,	3.00,	2.00,	2],	//48
[16.4,  15.4,	4.00,	4.00,	12.00,	0.00,	0.00,	-10.00,	8.00,	10.0,	2.00,	2.00,	1.00,	5.00,	1.00,	2.00,	2.00,	2], //49
];

dishParameters = //dishParameter[keyID][ParameteID]
[
//FFwd1 FFwd2 FPit1 FPit2  DshDep DshHDif FArcIn FArcFn FArcEx     BFwd1 BFwd2 BPit1 BPit2  BArcIn BArcFn BArcEx
  // low pro 3 row system
  [   6,    3,   18,  -50,      5,    1.8,   8.8,    15,     2,        5,  4.4,    5,  -55,    8.8,    15,     2], //R4
  [   5,  3.5,   10,  -55,      5,    1.8,   8.5,    15,     2,        5,    4,   10,  -55,    8.5,    15,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,   8.8,    15,     2,        6,    4,   13,   30,    8.8,    16,     2], //R2
  [ 4.8,  3.3,   18,  -55,      5,    2.0,   8.5,    15,     2,      4.8,  3.3,   18,  -55,    8.5,    15,     2], //R3 deep
  [   6,    3,   -5,  -50,      5,    1.8,   8.8,    15,     2,        6,  3.5,   13,  -50,    8.8,    15,     2], //R5 mod
  [   6,    3,   13,   30,      5,    1.9,   8.9,    15,     2,        5,  4.4,   10,  -50,    8.9,    16,     2], //R1
  //1.25
  [   6,    3,   -5,  -50,      5,    1.8,  12.4,    18,     2,        6,  3.5,   13,  -50,   12.4,    19,     2], //R5
  [   6,    3,   18,  -50,      5,    1.8,  12.4,    21,     2,        5,  4.4,    5,  -55,   12.4,    19,     2], //R4
  [   5,  3.5,   10,  -55,      5,    1.8,  12.4,    18,     2,        5,  3.7,   10,  -55,   12.4,    19,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  12.4,    18,     2,        6,    4,    13,  30,   12.4,    19,     2], //R2
  //1.5
  [   6,    3,   -5,  -50,      5,    1.8,  15.6,    22,     2,        6,  3.5,   13,  -50,   15.6,    22,     2], //R5
  [   6,    3,   18,  -50,      5,    1.8,  15.6,  27.2,     2,        5,  4.4,    5,  -55,   15.6,    22,     2], //R4
  [   5,  3.5,   10,  -55,      5,    1.8,  15.5,    22,     2,        5,  3.7,   10,  -55,   15.5,    22,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  15.7,    22,     2,        6,    4,   13,   30,   15.7,    23,     2], //R2
  //1.75
  [   6,    3,   -5,  -50,      5,    1.8,  18.7,    25,     2,        6,  3.5,   13,  -50,   18.7,    26,     2], //R5
  [   6,    3,   17,  -50,      5,    1.8,  18.7,    32,     2,        5,  4.4,    5,  -55,   18.7,    25,     2], //R4
  [   5,  3.5,   10,  -55,      5,    1.8,  18.7,    27,     2,        5,  3.8,   10,  -55,   18.7,    25,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  18.7,    25,     2,        6,    4,   13,   30,   18.7,    28,     2], //R2
  //2
  [   6,    3,   -5,  -50,      5,    1.8,  22.3,    30,     2,        6,  3.5,   13,  -50,   22.3,    31,     2], //R5
  [   6,    3,   15,  -50,      5,    1.8,  22.3,    35,     2,        5,  4.4,    5,  -55,   22.3,    31,     2], //R4
  [   6,    3,   17,  -55,      5,    1.8,  22.3,  32.5,     2,        5,  3.7,    8,  -55,   22.3,    31,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  22.3,    30,     2,        5,    4, 11.5,  -55,   22.3,    33,     2], //R2
  [ 6.4,  3.2,   13,   30,      5,    1.9,  23.1,    38,     2,        5,  4.4,   10,  -50,   23.1,    34,     2], //R1
  //2.25
  [   6,    3,   -5,  -50,      5,    1.8,  25.6,    30,     2,        6,  3.5,   13,  -50,   25.6,    40,     2], //R5
  [   6,    3,   15,  -50,      5,    1.8,  25.6,    41,     2,        5,  4.4,    5,  -55,   25.6,    34,     2], //R4
  [   6,    3,   17,  -55,      5,    1.8,  25.6,  32.5,     2,        5,  3.7,    8,  -55,   21.9,    31,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  21.9,    30,     2,        5,    4, 11.5,  -55,   21.9,    33,     2], //R2
  //2.50
  [   6,    3,   -5,  -50,      5,    1.8,  29.0,    40,     2,        6,  3.5,   13,  -50,   29.0,    43,     2], //R5
  [   6,    3,   15,  -50,      5,    1.8,  21.9,    34,     2,        5,  4.4,    5,  -55,   21.9,    31,     2], //R4
  [   6,    3,   17,  -55,      5,    1.8,  21.9,  32.5,     2,        5,  3.7,    8,  -55,   21.9,    31,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  21.9,    30,     2,        5,    4, 11.5,  -55,   21.9,    33,     2], //R2
  //2.75
  [   6,    3,   -5,  -50,      5,    1.8,  33.1,    38,     2,        6,  3.5,   13,  -50,   33.1,    50,     2], //R5
  [   6,    3,   15,  -50,      5,    1.8,  21.9,    34,     2,        5,  4.4,    5,  -55,   21.9,    31,     2], //R4
  [   6,    3,   17,  -55,      5,    1.8,  21.9,  32.5,     2,        5,  3.7,    8,  -55,   21.9,    31,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  21.9,    30,     2,        5,    4, 11.5,  -55,   21.9,    33,     2], //R2
  //3
  [   6,    3,   -5,  -50,      5,    1.8, 35.85,    46,     2,        6,  3.5,   13,  -50,  35.85,    55,     2], //R5
  [   6,    3,   15,  -50,      5,    1.8,  21.9,    34,     2,        5,  4.4,    5,  -55,   21.9,    31,     2], //R4
  [   6,    3,   17,  -55,      5,    1.8,  21.9,  32.5,     2,        5,  3.7,    8,  -55,   21.9,    31,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,  21.9,    30,     2,        5,    4, 11.5,  -55,   21.9,    33,     2], //R2
  //6.25u
  [   6,    3,   -5,  -50,      5,    1.8,  79.1,    95,     2,        6,  3.5,   13,  -50,   79.1,    127,     2], //R5
  //7.00u
  [   6,    3,   -5,  -50,      5,    1.8,  89.7,   105,     2,        6,  3.5,   13,  -50,   89.7,    143,     2], //R5
  //2.00u vert
  [  13,  5.5,    5,  -30,      4,    1.8,   8.5,    12,   1.5,       10,    8,    7,  -10,    8.5,     12,   1.5], //R5
  [  13,  5.5,   -5,  -50,      5,    1.8,  79.1,    95,     2,       10,    8,   13,  -50,   79.1,    127,     2], //R5
  //edge
  [   6,    3,   18,  -50,      5,    1.8,   8.8,    15,     2,        5,  4.4,    5,  -55,    8.8,    15,     2], //R4
  [   5,  3.5,   10,  -55,      5,    1.8,   8.5,    15,     2,        5,    4,   10,  -55,    8.5,    15,     2], //R3
  [   6,    3,   10,  -50,      5,    1.8,   8.8,    15,     2,        6,    4,   13,   30,    8.8,    16,     2], //R2
  [   6,    3,   13,   30,      5,    1.9,   8.9,    15,     2,        5,  4.4,   10,  -50,    8.9,    16,     2], //R1
  //thumbs
  [   5,  4.4,    5,  -45,      4,    1.8,    11,    15,     2,        6,    4,   13,  -35,     11,    28,     2],
  [   5,  4.4,    5,  -45,      4,    1.8,    11,    15,     2,        6,    4,   13,  -30,     11,    18,     2],
  [   5,  4.6,    5,  -42,      4,    1.8,    11,    15,     2,        6,    4,   13,  -35,     11,    28,     2],
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

function BottomWidth(keyID)  = keyParameters[keyID][0];  //
function BottomLength(keyID) = keyParameters[keyID][1];  //
function TopWidthDiff(keyID) = keyParameters[keyID][2];  //
function TopLenDiff(keyID)   = keyParameters[keyID][3];  //
function KeyHeight(keyID)    = keyParameters[keyID][4] + heightDelta;  //
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
    pg1316_foam1 = false,
    pg1316_old = false,
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
          choc_stem();
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
    if (pg1316_nofoam == true) {
      union() {
        pg1316_negspace_nofoam();
        translate([-10,-10,-20])cube(20);
      }
    }
    if (pg1316_foam1 == true) {
      union() {
        pg1316_negspace_foam1();
        translate([-10,-10,-20])cube(20);
      }
    }
    if (pg1316_foam05 == true) {
      union() {
        pg1316_negspace_foam05();
        translate([-10,-10,-20])cube(20);
      }
    }
    if (pg1316_old == true) {
      union() {
        pg1316_negspace_old();
        translate([-10,-10,-20])cube(20);
      }
    }
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
