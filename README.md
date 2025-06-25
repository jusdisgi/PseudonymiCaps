# PseudonymiCaps - PG1316 (mostly) KeyCaps

## Keycaps originally by Pseudoku, with additions by zzeneg and others before me.

The original version of these caps was created by Pseudoku, proprietor of [Asymplex](http://asymplex.xyz/). The original repository is still available [here](https://github.com/pseudoku/PseudoMakeMeKeyCapProfiles) and there is a wonderful writeup by the creator at [KBD News](https://kbd.news/On-the-DES-keycap-profile-2229.html).

The versions in this repo are modified to include the rather odd internal cutouts for mounting on PG1316 (and PG1316S) switches. There are 4 such cutouts available, each of which has a parameter in the files:

1. pg1316_old: the official cutout shape, as seen in the keycaps Kailh sells. Works great with the switches, but hard to print accurately.
2. pg1316_nofoam: an improved, "EZ-Print" cutout designed by Mike Holscher to be easier to 3D print.
3. pg1316_foam05: the EZ-Print cutout, but 0.5mm deeper. This allows space for a very thin layer of foam for sound reduction. As a result keycaps need to be 0.5mm taller.
4. pg1316_foam1: EZ-Print cutout, 1mm deeper, providing for a thicker foam layer but requiring yet more keycap height.

There are a couple other odds and ends (my personal choc DES for example) which you can use at your own risk, but understand I am not keeping them in any particular useable order.

## TL;DR 

Clone the repo and use OpenSCAD to open the keycap file (one of the .scad files not in the libraries dir), then edit the parameters near the top to generate a keycap. Export to .stl or whatever else.

## But why tho?

Shouldn't this just be a fork? Pseudoku's repo has been forked numerous times and has a long history. I [forked](https://github.com/jusdisgi/PseudoMakeMeKeyCapProfiles) zzeneg's [fork](https://github.com/zzeneg/PseudoMakeMeKeyCapProfiles) in order to adapt some of the profiles to the new Kailh PG1316S switch; I quickly discovered the repo is impractically large, and a good portion of that is because the .git directory has grown to over 1.5GB. Most of the rest was .stl exports.

So I created a new repo with only the files necessary to create the keycaps. Any STLs I make available will be elsewhere (and I will put a link here). So far so good: this repo comes in under 1MB vs >3GB for a "real" fork.

#Some notes on

## Distorted Ellipsoidal Saddle (DES)

High sculpt smooth transition profile
![DES](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/R1-R5.png)

### Standard

![Neuron v1](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/DES_cast.jpg)

### Concave

![Corne thumb and Convex Caps](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/Convex.jpg)

### Thumbs

![IMK Corne v1](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/DES_corne.jpg)
![Kyria](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/DES_kyria.png)

### Chicago Stenographer

Subtly sculpted choc spaced low profile
![CS](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/CS.png)

#### Standard

![Look](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/CS_gergo.jpg)

#### Convex

![Georgi](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/CS_convex.jpg)

#### Thumbs

![1.5 + 1](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/CS_Thumb.png)
Additional sculpt angle and smoother transitions

### Philadelphia Minimalist

![under](https://raw.githubusercontent.com/pseudoku/PseudoMakeMeKeyCapProfiles/master/Photo/Philadelphia_Minimalist.png)
Minimal spacing
Under construction
