
esp32hx=59.5; // holes in esp32
esp32hy=23.5;
esp32hd=3; // hole dia in esp32 module

module esp32wemos()
{
  esp32hx=59.5; // holes in esp32
  esp32hy=23.5;
  esp32hd=3; // hole dia in esp32 module

  // display
  color([0,0,0])
  translate([10,1,2])
    rotate([0,0,2]) // display slightly tilted
      cube([25,15,1],center=true); // display
  // pcb
  translate([-10,0,-2]*0)
    rotate([0,0,0]) // board slightly tilted
    difference()
    {
      cube([63.7,27.3,1.6],center=true);
      // screw holes 60x23.5
      for(x=[-1:2:1])
        for(y=[-1:2:1])
          translate([x*esp32hx/2,y*esp32hy/2,0])
            cylinder(d=esp32hd,h=10,$fn=32,center=true);
    }
  // pins
  //translate([0,25.4/2,0])
  for(i=[0:15])
    translate([-27+i*2.54,25.4/2,-10])
      cube([0.6,0.6,11.5]);
  for(i=[0:9])
    translate([-27+i*2.54,-25.4/2,-10])
      cube([0.6,0.6,11.5]);
    
}
