# PseudonymiCaps

## Keycaps originally by Pseudoku, with additions by zzeneg and others before me.

The original version of these caps was created by Pseudoku, proprietor of [Asymplex](http://asymplex.xyz/). The original repository is still available [here](https://github.com/pseudoku/PseudoMakeMeKeyCapProfiles) and there is a wonderful writeup by the creator at [KBD News](https://kbd.news/On-the-DES-keycap-profile-2229.html).

## TL;DR 

Clone the repo and use OpenSCAD to open the keycap file (one of the .scad files not in the libraries dir), then edit the parameters near the top to generate a keycap. Export to .stl or whatever else.

## But why tho?

Shouldn't this just be a fork? Pseudoku's repo has been forked numerous times and has a long history. I [forked](https://github.com/jusdisgi/PseudoMakeMeKeyCapProfiles) zzeneg's [fork](https://github.com/zzeneg/PseudoMakeMeKeyCapProfiles) in order to adapt some of the profiles to the new Kailh PG1316S switch; I quickly discovered the repo is impractically large, and a good portion of that is because the .git directory has grown to over 1.5GB. Most of the rest was .stl exports.

So I created a new repo with only the files necessary to create the keycaps. Any STLs I make available will be elsewhere (and I will put a link here). So far so good: this repo comes in under 1MB vs >3GB for a "real" fork.

## What is actually here then?

At the moment this repo only contains low-profile DES keycaps for Choc v1 and PG1316S switches. Only the 17x17 file labeled PG1316S will support that switch (though it will support Choc as well at that spacing). I will be adding other models (DES for MX, CS, PM, etc.) as I have time to test them out and add comments. I also hope to port over some of the export scripts from some other forks.

If you're familiar with zzeneg's Low-profile Choc DES, these are the same, except the PG ones are 0.5mm taller...zzeneg's were so low the PG1316S mounting slot wouldn't fit. A bit ironic that this ultra-low-profile switch needs higher-profile keycaps, but such is life.

The rest of this is straight from the original Pseudoku repo's readme:

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
