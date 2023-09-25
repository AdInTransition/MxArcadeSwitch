include<threads.scad> //https://github.com/rcolyer/threads-scad
include <BOSL/constants.scad> //https://github.com/revarbat/BOSL  <--this could potentally handle the threads aswell
use <BOSL/masks.scad>

//Global Varialbles
$fn = 180;
UniversalTolaerance=0.25;

toothAngle=50;
threadPitch=2;

mxStemZHeight=3.6;
mxStemXWidth=4.25;
mxStemYdepth=1.38;
mxSocketDiameter=5.4; 
mxSwitchWidth=14;
mxSwitchTopHousing=5;

buttonSleeveWall=2.4; //actual wall thickness below the mxShelf will be x2 due to the mxShelfSupport
buttonSleeveOD=28; 
buttonSleveHeight=26;

profileHeight=3;
profileWidth=buttonSleeveOD+5;
buttonActivatorRadius=buttonSleeveOD/2-buttonSleeveWall/2-UniversalTolaerance;

counterClampOD=buttonSleeveOD+5;
counterClampHeight=12;

mxShelfThickness=1.4;
mxShelfSupportHeight=buttonSleveHeight-mxShelfThickness*2-mxSwitchTopHousing;


module buttonActivator(){
    translate([0, 0, buttonSleveHeight+profileHeight]) {
//add mx socket
        translate([0, 0, -mxStemZHeight/2]) {
            difference(){
            union(){
                cylinder(h=mxStemZHeight,d=mxSocketDiameter,center=true);
            
            }
            union(){
                cube(size = [mxStemXWidth,mxStemYdepth,mxStemZHeight],center = true);
                rotate([0,0,45]){cube(size = [mxStemYdepth*1.5,mxStemYdepth,mxStemZHeight],center = true);}
                rotate([0,0,135]){cube(size = [mxStemYdepth*1.5,mxStemYdepth,mxStemZHeight],center = true);}
                rotate([0,0,90]){cube(size = [mxStemXWidth,mxStemYdepth,mxStemZHeight],center = true);}   
            }
        }
    }

//add stabalising sides that fit in the button sleeve 

    translate([0, 0, -mxSwitchTopHousing/2]) {  
        difference() {
            cylinder(d=buttonSleeveOD-buttonSleeveWall-UniversalTolaerance*2, h=mxSwitchTopHousing, center=true);
            cylinder(d=buttonSleeveOD-buttonSleeveWall*2-UniversalTolaerance*2, h=mxSwitchTopHousing, center=true);
        }
    }
  
//Button top         
        difference() {
            cylinder(d=buttonSleeveOD-buttonSleeveWall-UniversalTolaerance*2, h=profileHeight, center=false);
            translate([0,0,profileHeight-UniversalTolaerance]){fillet_cylinder_mask(r=buttonActivatorRadius, fillet=3);}
        }
    }
}
module buttonSleeve()
{
    difference(){
        union(){    
            ScrewThread(outer_diam=buttonSleeveOD, height=buttonSleveHeight, pitch=threadPitch, tooth_angle=toothAngle, tolerance=0, tip_height=0, tooth_height=0, tip_min_fract=0);
    difference(){        
            translate([0, 0, buttonSleveHeight]){cylinder(h=profileHeight, d=profileWidth);}
            translate([0,0,buttonSleveHeight+profileHeight-UniversalTolaerance]){fillet_cylinder_mask(r=profileWidth/2, fillet=3);}
    
          }  
        }
        union(){ 
            cylinder(h=buttonSleveHeight+profileHeight,d=buttonSleeveOD-buttonSleeveWall-UniversalTolaerance);
        }
    }
    
}
module mxSwitchShelf(){
       translate([0,0,buttonSleveHeight+mxShelfThickness/2-mxSwitchTopHousing-profileHeight]){ 
            difference(){
                cylinder(h=mxShelfThickness, d=buttonSleeveOD-buttonSleeveWall, center=true);
                cube([mxSwitchWidth, mxSwitchWidth, mxShelfThickness*2], center=true);
            }
        }
    //mxShelfSupport
         translate([0,0,mxShelfSupportHeight/2]){
                difference(){
                    cylinder(h=mxShelfSupportHeight, d=buttonSleeveOD-buttonSleeveWall+UniversalTolaerance, center=true);
                    cylinder(h=mxShelfSupportHeight, d=buttonSleeveOD-buttonSleeveWall*2, center=true);
             }
        }
    
}

module counterClamp(){
    difference() {
        union(){
            difference() {
        
                cylinder(h=counterClampHeight,d=counterClampOD);
                ScrewHole(outer_diam=buttonSleeveOD+UniversalTolaerance, height=counterClampHeight, position=[0,0,0], rotation=[0,0,0], pitch=threadPitch, tooth_angle=toothAngle, tolerance=0, tooth_height=0);
        }
    }
    //Grip texture
        union(){
            for ( i = [0:6:360])
                rotate(i,[0,0,1]){
                translate([counterClampOD/2,0,counterClampHeight/2]) cube([0.8,1,counterClampHeight], center=true) ;
            }
        }
    }
}

//call modules
*buttonSleeve();
*counterClamp();
buttonActivator();
*mxSwitchShelf();