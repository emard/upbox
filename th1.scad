include <upbox.scad>

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
PCBLength       = 15*2.54;
// - Largeur PCB - PCB Width
PCBWidth        = 18*2.54;
// - Heuteur pied - Feet height
FootHeight      = 6;
// - Diamètre pied - Foot diameter
FootDia         = 7;
// - Diamètre trou - Hole diameter
FootHole        = 1.8;
// - 3-foot mode, one foot width-asymmetric, 0 for normal 4-foot mode
Foot3Width = 0;

// those clearances should be larger than
// the PCB edge to hole centers distances
FootClrX = 7; // foot center to panel clearance
FootClrY = 6; // foot center to shell wall clearance

// - Epaisseur - Wall thickness  
Thick           = 2;//[2:5]  


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
  Vent_width    = 1.5;   
// - Text you want
  txt           = "CSS TH1";
// - Font size  
  TxtSize       = 7;                 
// - Font  
  Police        ="Arial Black"; 
// - Diamètre Coin arrondi - Filet diameter  
  Filet         = 2;//[0.1:12] 
// - lissage de l'arrondi - Filet smoothness  
  Resolution    = 20;//[1:100] 
// - Tolérance - Tolerance (Panel/rails gap)
  m             = 0.5;
// mounting legs clearance
  MountClearance = 0.1;
  // clearance between Top and Bottom shell
  ShellClearance = 0.1;


// mounting hole diameters
MountOuterHole = 2.5;
MountInnerHole = 1.8;

// fixation leg size
MountLegSize = 16;
// fixation hole position from center
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


///////////////////////////////////// - Main - ///////////////////////////////////////

// cut for usb connector
module usbcut()
{
  // cut off opening for micro USB connector
  translate([32.5,0,21])
     cube([12,10,7],center=true);
  
}

module custom_rear_panel()
{
  translate ([-m/2,0,0]){
  difference()
  {
    Panels();
    // cut off opening for 2 RJ-45
    translate([Thick*1.5+m,Width/2+1.5,16])
    {
       cube([Thick*2,36,16],center=true);
       for(j=[-1:2:1])
       translate([0,18/2*j,-8])
        rotate([0,90,0])
         cylinder(d=2.5,h=Thick*2,$fn=6,center=true);
    }
  }
}
}

//Front Panel
module custom_front_panel()
{
rotate([0,0,180]){
    translate([-Length-m/2,-Width,0]){
       Panels();
       }
   }

color(Couleur1){     
     translate([Length-(Thick),Width/2+Thick*0,(Height/2-(-Thick-m/2+(TxtSize/2)))]){// x,y,z
          rotate([90,0,90]){
              linear_extrude(height = 1.0){
              text(txt, font = Police, size = TxtSize,  valign ="center", halign ="center");
                        }
                 }
         }
}
}

// Coque bas - Bottom shell
module custom_bottom_shell()
{
color(Couleur1){ 
difference()
{
Coque(top=0);
    usbcut();
}
if (PCBFeet==1)  // Feet
  translate([PCBPosX,PCBPosY,0])
    Feet();
}
}

// Coque haut - Top Shell
module custom_top_shell()
{
color( Couleur1,1)
{
    difference()
    {
    translate([Length,0,Height+ShellClearance]){
        rotate([0,180,0]){
                Coque(top=1);
                }
        }
      // OLED opening on top
      translate([22,24,20])
        cube([15,25,10]);
      usbcut();
    }
}
}


custom_front_panel();
custom_rear_panel();
custom_bottom_shell();
custom_top_shell();
