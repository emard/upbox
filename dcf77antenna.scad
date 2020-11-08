fl=144; // ferrite rod length
fd=10;  // ferrite rod diameter
fh=9;   // ferrite rod profile cut

c2d=12.5; // secondary coil
c2l=39; // secondary coul length

cd=16;  // coil diameter
cl=20;  // coil length

module rod()
{
  intersection()
  {
    cylinder(d=fd, h=fl, center=true);
    cube([fh,fd+1,fl+1],center=true);
  }
}

module coil()
{
  cylinder(d=cd, h=cl, center=true);
}

module coil2()
{
  translate([0,0,44])
  cylinder(d=c2d, h=c2l, center=true);
}

module dcf77antenna()
{
  rotate([0,90,0])
  {
    rod();
    coil();
    coil2();
  }
}
