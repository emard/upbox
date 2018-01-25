include <upbox.scad>

/*//////////////////////////////////////////////////////////////////
              -    FB Aka Heartman/Hearty 2016     -                   
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
PCBLength       = 35*2.54;
// - Largeur PCB - PCB Width
PCBWidth        = 11*2.54;
// - Heuteur pied - Feet height
FootHeight      = 5;
// - Diamètre pied - Foot diameter
FootDia         = 7;
// - Diamètre trou - Hole diameter
FootHole        = 1.8;
// - 3-foot mode, one foot width-asymmetric, 0 for normal 4-foot mode
Foot3Width = 6*2.54;

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
  Height        = 28;
  
/* [Box options] */
// Pieds PCB - PCB feet (x4) 
  PCBFeet       = 1;// [0:No, 1:Yes]
// - Decorations to ventilation holes
  Vent          = 0;// [0:No, 1:Yes]
// - Decoration-Holes width (in mm)
  Vent_width    = 1.5;   
// - Text you want
  txt           = "12*";
// - Font size  
  TxtSize       = 5;                 
// - Font  
  Police        ="Arial Black"; 
// - Diamètre Coin arrondi - Filet diameter  
  Filet         = 2;//[0.1:12] 
// - lissage de l'arrondi - Filet smoothness  
  Resolution    = 20;//[1:100] 
// - Tolérance - Tolerance (Panel/rails gap)
  m             = 1.5;
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

/* [STL element to export] */
//Coque haut - Top shell
  TShell        = 1;// [0:No, 1:Yes]
//Coque bas- Bottom shell
  BShell        = 1;// [0:No, 1:Yes]
//Panneau arrière - Back panel  
  BPanel        = 1;// [0:No, 1:Yes]
//Panneau avant - Front panel
  FPanel        = 1;// [0:No, 1:Yes]
//Texte façade - Front text
  Text          = 1;// [0:No, 1:Yes]


  
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

if(BPanel==1)
//Back Panel
translate ([-m/2,0,0]){
  difference()
  {
    Panels();
    // cut off opening for micro USB connector
    translate([Thick*1.5+m,Width/2,21])
       cube([Thick*2,11,6],center=true);
  }
}

if(FPanel==1)
{
//Front Panel
rotate([0,0,180]){
    translate([-Length-m/2,-Width,0]){
     difference()
     {
       Panels();
       // cut off opening for USB connector
       translate([Thick*1.5+m,Width/2,10])
         cube([Thick*2,15,7],center=true);
     }
       }
   }

if(Text==1)
// Front text
color(Couleur1){     
     translate([Length-(Thick),Width/2+Thick*0,(Height-(Thick*3+(TxtSize/2)))]){// x,y,z
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
Coque(top=0);
if (PCBFeet==1)  // Feet
  translate([PCBPosX,PCBPosY,0])
    Feet();
}


if(TShell==1)
// Coque haut - Top Shell
color( Couleur1,1){
    translate([Length,0,Height+ShellClearance]){
        rotate([0,180,0]){
                Coque(top=1);
                }
        }
}

