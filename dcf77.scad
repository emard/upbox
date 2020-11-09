include <upbox.scad>
include <esp32wemos.scad>
include <dcf77antenna.scad>

/* [STL element to export] */
//Coque haut - Top shell
  TShell        = 1;// [0:No, 1:Yes]
//Coque bas- Bottom shell
  BShell        = 1;// [0:No, 1:Yes]
//Panneau arrière - Rear panel  
  BPanel        = 1;// [0:No, 1:Yes]
//Panneau avant - Front panel
  FPanel        = 1;// [0:No, 1:Yes]
// Font color: at height 2.7: M600; change filament
// button pins
  Pins          = 0; // button pins
  Pin           = 0; // one pin

// Flat Cable holes
  FlatCable     = 0;

//Texte façade - Front text
  Text          = 1;// [0:No, 1:Yes]
  
// multicolor front panel
/*
;BEFORE_LAYER_CHANGE
;2.7
M600 ; Pause print to change filament
*/

/*//////////////////////////////////////////////////////////////////
              -  mjesečno po svojem parkir  FB Aka Heartman/Hearty 2016     -                   
              -   http://heartygfx.blogspot.com    -                  
              -       OpenScad Parametric Box      -                     
              -         CC BY-NC 3.0 License       -                      
////////////////////////////////////////////////////////////////////                                                                                                             
12/02/2016 - Fixed minor bug 
28/02/2016 - Added holes ventilation option                    
09/03/2016 - Added PCB feet support, fixed the shell artefact on export mode. 

*/////////////////////////// - Info - //////////////////////////////

// All coordinates are starting as integrated circuit pins.
// From the top view :

//   CoordD           <---       CoordC
//                                 ^
//                                 ^
//                                 ^
//   CoordA           --->       CoordB


////////////////////////////////////////////////////////////////////


////////// - Paramètres de la boite - Box parameters - /////////////

/* [PCB_Feet--TheBoard_Will_NotBeExported) ] */
//All dimensions are from the center foot axis
// - Coin bas gauche - Low left corner X position
PCBPosX         = 0;
// - Coin bas gauche - Low left corner Y position
PCBPosY         = 0;
// - Longueur PCB - PCB Length
PCBLength       = 59.5;
// - Largeur PCB - PCB Width
PCBWidth        = 23.5;
// Thickness of PCB
PCBThick        = 1.6;
PCBThickTol     = 0.0;
BFclr = 0.2; // bottom feet clearance
// - Heuteur pied - Feet height
FootHeight      = 7;
// - Diamètre pied - Foot diameter
FootDia         = 6;
// - Diamètre trou - Hole diameter
FootHole        = 1.8;
// - 3-foot mode, one foot width-asymmetric, 0 for normal 4-foot mode
Foot3Width = 0*2.54;

// those clearances should be larger than
// the PCB edge to hole centers distances
FootClrX = 15; // foot center to panel clearance 25 for DB-9, 11 for tight
FootClrY = 10-3; // foot center to shell wall clearance
FootmvX = -11; // move foot out of center x directoy
FootmvY = 0; // move foot out of center y direction

// - Epaisseur - Wall thickness  
Thick           = 1.5;//[2:5]  


/* [Box dimensions] */
// - Longueur - Length  
  Length        = PCBLength+2*(2*Thick+FootClrX);
// - Largeur - Width
  Width         = PCBWidth+2*(Thick+FootClrY);
// - Hauteur - Height  
  Height        = 29;

/* [Box options] */
// Pieds PCB - PCB feet (x4) 
  PCBFeet       = 1;// [0:No, 1:Yes]
// - Decorations to ventilation holes
  Vent          = 0;// [0:No, 1:Yes]
// - Decoration-Holes width (in mm)
  Vent_width    = 0;   
// - Text you want
  txt           = "DCF77";
// - Font size  
  TxtSize       = 6;                 
// - Font  
  Police        ="Arial Black"; 
// - Diamètre Coin arrondi - Filet diameter  
  Filet         = 2;//[0.1:12] 
// - lissage de l'arrondi - Filet smoothness  
  Resolution    = 20;//[1:100] 
// - Tolérance - Tolerance (Panel/rails gap)
  m             = 0.7;
  mz            = 0.7; // panels height tolerance
// mounting legs clearance
  MountClearance = 0.1;
  // clearance between Top and Bottom shell
  ShellClearance = 0.0;


// mounting hole diameters
MountOuterHole = 2.0;
MountInnerHole = 1.8;

// fixation leg size
MountLegSize = 0; // 10
// fixation hole z-position from center
MountHolePos = 2.5;
// distance of leg to the edge
MountLegEdge = 0*MountLegSize;

  
/* [Hidden] */
// - Couleur coque - Shell color  
Couleur1        = "Orange";       
// - Couleur panneaux - Panels color    
Couleur2        = "OrangeRed";    
// Thick X 2 - making decorations thicker if it is a vent to make sure they go through shell
Dec_Thick       = Vent ? Thick*2 : Thick; 
// - Depth decoration
Dec_size        = Vent ? Thick*2 : 0.8;

//////////////////// Oversize PCB limitation -Actually disabled - ////////////////////
//PCBL= PCBLength+PCBPosX>Length-(Thick*2+7) ? Length-(Thick*3+20+PCBPosX) : PCBLength;
//PCBW= PCBWidth+PCBPosY>Width-(Thick*2+10) ? Width-(Thick*2+12+PCBPosY) : PCBWidth;
PCBL=PCBLength;
PCBW=PCBWidth;
//echo (" PCBWidth = ",PCBW);

// flat cable connector spacing between centers
flatcable_spacing = 35*2.54;


///////////////////////////////////// - Main - ///////////////////////////////////////

  // mounting hole xy-position
  Footx = 2*Thick+FootClrX+FootmvX;
  Footy = Thick+FootClrY+FootmvY;
  Fh = 2.1+3.0; // top feet height
  // foot xy positions
  Fxy = [
  [Footx, Footy, 0],
  [Footx+PCBLength, Footy, 0],
  [Footx, Footy+PCBWidth, 0],
  [Footx+PCBLength, Footy+PCBWidth, 0]
  ];

module connector_cut()
{
  // mounting hole x-position
  //footx = 2*Thick+FootClrX;
  //footy = Thick+FootClrY;
  cy = 60-8;
  translate([Footx,Footy,-0.7])
  {
      // cut off for WiFi
      translate([24-10,-10,6])
        cube([21,3,3],center=true);
      // cut off for HDMI
      translate([42.3,cy,12])
        cube([22,10,13],center=true);
      // cut off for AUDIO
      translate([21.47,cy,11])
        rotate([90,0,0])
          cylinder(d=13.5,h=10,$fn=32,center=true);
      // cut off for 2.5/3.3V jumper
      translate([27.07+2.54,cy,11])
        cube([13,10,7],center=true);
      // cut off for USB1
      translate([8.89,cy,9.5])
        cube([13,10,9],center=true);
      // cut off for USB2
      translate([67.31,cy,9.5])
        cube([13,10,9],center=true);
  }    
}

module flatcable_cut()
{
  height=5;
  width=6.3;
  length=56;
  notch=2;
  notch_length=4;
  translate((Fxy[0]+Fxy[3])/2)
  {
    for(i=[-1:2:1])
      translate([flatcable_spacing*i/2,0,height/2-0.01])
      {
        cube([width,length,height],center=true);
        translate([-i*notch,0,0])
        cube([width,notch_length,height],center=true);
      }
  }
}

// xyz positions of all buttons
// relative to feet
button_pos =
[
  [68.58,34.29,0], // btn0
  [2.54,19.05,0], // btn1
  [13.97,19.05,0], // btn2
  [57.15,8.89,0], // btn3
  [57.15,0,0], // btn4
  [45.72,0,0], // btn5
  [68.58,0,0] // btn6  
];

AntennamvX=2; // a little bit inside
Antennafn=6; // number of sides 6, 10, 14, or 128

module antenna_add()
{
  difference()
  {
      union()
      {
  difference()
  {
    rotate([0,0,90])
    union()
    {
      cylinder(d=Height,h=fl,$fn=Antennafn,center=true);
      for(i=[-1:2:1])
        translate([0,0,i*fl/2])
          sphere(d=Height,$fn=Antennafn);
    }
    // inside, leaving holder on one side
    rotate([0,0,90])
      cylinder(d=Height-2*Thick,h=fl+1,$fn=Antennafn,center=true);
    // hemisphere at ends
    for(i=[-1:2:1])
      translate([0,0,i*fl/2])
        rotate([0,0,90])
        difference()
        {
          sphere(d=Height-2*Thick,$fn=Antennafn);
          cylinder(d=Height,h=Thick,$fn=Antennafn,center=true);
        }
    }
    if(1) // additional holder on one side
      translate([0,0,70])
       //cube([50,50,Thick/2],center=true);
       rotate([0,0,90])
       cylinder(d=Height,h=Thick/2,$fn=Antennafn,center=true);
    }
    // cut box
    cube([Height+1,Height+1,Width-2*Thick],center=true);
    // cut half
    translate([0,(fl+1)/2,0])
      cube([fl+1,fl+1,fl+Height],center=true);
  }

}

module antenna_cut()
{
  scale([1.06,1.06,1])
  rod();
  // cut for wire leads
  translate([0,0,Width/2])
   cylinder(d=22,h=10,center=true);
  cube([2,15,Width+1],center=true);
}

// addition to top shell - button tubes
module top_add()
{
  // mounting hole xy-position
  //footx = 2*Thick+FootClrX;
  //footy = Thick+FootClrY;
  tube_h=Height/2-3;
  tube_od=9; // tube outer diameter
  if(0)
  translate([Footx,Footy,Height-tube_h/2])
  {
      // btn hole
    for(i = [0:6])
      translate(button_pos[i])
        cylinder(d=tube_od,h=tube_h,$fn=12,center=true);
  }
  for(i = [0:3])
  {
    upbase=1;
    translate([0,0,Height-Fh/2])
    translate(Fxy[i])
    {
      translate([0,0,-upbase/2])
      cylinder(d1=4.5,d2=7,h=Fh-upbase,$fn=12,center=true);
      // small in-hole centering cylinders
      if(0)
      translate([0,0,-Fh/2-(PCBThick-PCBThickTol-0.001)])
        cylinder(d=3,h=PCBThick-PCBThickTol,$fn=32);
    }
  }
  // antenna shell
  if(1)
  translate([Length-Height/2-AntennamvX,Width/2,Height/2])
  rotate([90,180,0])
    antenna_add();

}

module button_pin()
{
  pin_d1=6; // top dia
  pin_h=Height/2+2; // total height
  pin_d2=8; // button touch dia
  pin_h2=2; // button touch h

      union()
      {
        cylinder(d=pin_d1,h=pin_h,$fn=32);
        cylinder(d=pin_d2,h=pin_h2,$fn=32);
      }
}

module button_pins()
{
  translate([Footx,Footy,Height/2+0.5])
  for(i = [0:6])
    translate(button_pos[i])
      button_pin();
}


module top_cut()
{
  // mounting hole xy-position
  //footx = 2*Thick+FootClrX;
  //footy = Thick+FootClrY;
  tube_h=Height/2-3;
  tube_id=7; // button tube inner diameter
  translate([Footx,Footy,Height])
  {
      // display (screen)
      if(1)
      translate([PCBLength/2-10,PCBWidth/2-1,0])
        rotate([0,0,0])
        cube([25,15,10],center=true);
  }
  // screw holes on top legs
  screwhole_h=4; // depth of the screw hole
  for(i=[0:3])
    translate([0,0,Height-Fh])
    translate(Fxy[i])
      cylinder(d=1.8,h=screwhole_h,$fn=6,center=true);
  if(1)
  translate([Length-Height/2-AntennamvX,Width/2,Height/2])
    rotate([90,0,0])
      antenna_cut();
}

// add bottom custom feet
module bottom_add()
{
  upbase=1;
  bfh=Height-Fh-PCBThick-BFclr; // bottom feet height
  for(i=[0:3])
    translate(Fxy[i])
    {
      translate([0,0,upbase])
      cylinder(d2=6.5,d1=6.5,h=bfh-upbase,$fn=12,center=false);
      translate([0,0,bfh])
        cylinder(d=2.7,h=0.8,$fn=12,center=false);
    }
  if(1)
  translate([Length-Height/2-AntennamvX,Width/2,Height/2])
  rotate([90,0,0])
    antenna_add();
}

// cut holes in bottom feet
module bottom_cut()
{
  transition=2;
  bfhole=Height-Fh-PCBThick-BFclr-(Thick+transition/2);
  for(i=[0:3])
    translate([0,0,-0.01])
    translate(Fxy[i])
    union()
    {
      cylinder(d=MountOuterHole,h=Height,$fn=12,center=false);
      // conical transition
      translate([0,0,bfhole-0.01])
        cylinder(d1=5,d2=MountOuterHole,h=transition+0.02,$fn=12,center=false);
      // screw head hole
      cylinder(d=5,h=bfhole,$fn=12,center=false);
    }
    // cut rails for PCB
    if(0)
    translate((Fxy[0]+Fxy[3])/2+[0,24.6,Height/2+(Height-Fh-PCBThick-BFclr)])
      cube([99,2.1,Height],center=true);
    // cut for PCB headers near feet
    pinxy=1;
    plasticxy=3;
    translate(Fxy[1]+[-3.3,-1.3,Height-8.3])
    {
      cube([plasticxy,plasticxy,3],center=true);
      cube([pinxy,pinxy,20],center=true);
    }
    translate(Fxy[3]+[-3.3, 1.3,Height-8.3])
    {
      cube([plasticxy,plasticxy,3],center=true);
      cube([pinxy,pinxy,20],center=true);
    }
  if(1)
  translate([Length-Height/2-AntennamvX,Width/2,Height/2])
    rotate([90,0,0])
      antenna_cut();
}


if(BPanel==1)
//Back Panel
translate ([-m/2,0,0]){
  difference()
  {
    union()
    {
      Panels();
      // screw extenders
       if(0)
       for(i=[-1:2:1])
         translate([Thick*1.5*0+m,25.4/2*i+Width/2,Height/2])
           rotate([0,90,0])
             cylinder(d=4,h=Thick*2,$fn=32,center=true);
    }
       if(0)
       {
       // cut off opening for DB-9 connector
       translate([Thick*1.5+m,Width/2,Height/2])
         cube([Thick*2,19,10],center=true);
       // cut off screw holes
       for(i=[-1:2:1])
         translate([Thick*1.5+m-1.9,25.4/2*i+Width/2,Height/2])
           rotate([0,90,0])
             cylinder(d=1.8,h=6,$fn=12,center=true);
       }

  }
}

if(FPanel==1)
{
  //Front Panel
  rotate([0,0,180])
    translate([-Length-m/2,-Width,0])
       Panels();

  if(Text==1)
   // Front text
   color(Couleur1)
   {
     translate([
       Length-(Thick)-m/2,
       Width/2,
       Height/2])
     {// x,y,z
          rotate([90,0,90]){
              linear_extrude(height = 1.0){
              text(txt, font = Police, size = TxtSize,  valign ="center", halign ="center");
                        }
                 }
     }
   }
}

if(BShell==1)
// Coque bas - Bottom shell
color(Couleur1){
difference()
{
   union()
   {
      Coque(top=0);
      bottom_add();
   }
   //connector_cut();
   bottom_cut();
   if(FlatCable)
     flatcable_cut();
}
  if(0)
  if (PCBFeet==1)  // Feet
  {
    footx = 2*Thick+FootClrX;
    footy = Thick+FootClrY;

    difference()
    {
    union()
    {
      translate([PCBPosX,PCBPosY,0])
        Feet();
      // add centering cylinder for 3.2 mm hole
      if(0)
      for(i=[0:1])
        for(j=[0:1])
          translate([footx+i*PCBLength,footy+j*PCBWidth,FootHeight-Thick+1.5])
            cylinder(d=3,h=1.5,$fn=32);
    }
      // drill holes 1.8 mm for screws
      for(i=[0:1])
        for(j=[0:1])
          translate([footx+i*PCBLength,footy+j*PCBWidth,FootHeight-Thick+1.5-4])
            cylinder(d=2.5,h=Height,$fn=32);
    }
  }
}


if(TShell==1)
// Coque haut - Top Shell
color( Couleur1,1){
  difference()
  {
    union()
    {
      translate([Length,0,Height+ShellClearance])
        rotate([0,180,0])
          Coque(top=1);
      top_add();
    }
    //connector_cut();
    top_cut();
  }
}

if(Pins==1)
    button_pins();

if(Pin==1)
    button_pin();

if(1)
translate([Length-Height/2-AntennamvX,Width/2,Height/2])
  rotate([0,0,90])
    %dcf77antenna();
    //rotate([0,90,0])
    //cylinder(d=1,h=144,center=true);

if(1)
translate([Length/2+FootmvX,Width/2,Height-6])
  rotate([0,0,180])
    %esp32wemos();
