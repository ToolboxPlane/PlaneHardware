wallThickness = 2;
ductHeight = 20;

module basePlate(){
    difference(){
            translate([-20, -4]){
                cube([59+2*20, 39+2*4, wallThickness]);
            }
            {
                translate([wallThickness, wallThickness, 0]){
                    cube([59-2*wallThickness, 39-2*wallThickness, wallThickness]);
                }
                
                translate([-10, 10, 0]){
                    cylinder(h=wallThickness, r=1.5);
                }
                translate([-10, 39-10, 0]){
                    cylinder(h=wallThickness, r=1.5);
                }
                translate([59+10, 10, 0]){
                    cylinder(h=wallThickness, r=1.5);
                }
                translate([59+10, 39-10, 0]){
                    cylinder(h=wallThickness, r=1.5);
                }
            }
        }
}

color("blue"){
    difference(){
        cube([59, 39, 28]);
        translate([wallThickness, wallThickness, 0]){
            cube([59-2*wallThickness, 39-2*wallThickness, 28]);
        }
    }
    translate([0, 0, 28]){
        basePlate();
    }
}

color("green"){
    translate([0,0,28+10]){
        basePlate();
        difference(){
            translate([0,39,wallThickness]){
                rotate([90, 0, 0]){
                    linear_extrude(39){
                        polygon([
                            [0,0],
                            [59, 0],
                            [59, ductHeight]
                        ]);
                    }
                }
            }
            translate([0,39-wallThickness,wallThickness]){
                rotate([90, 0, 0]){
                    linear_extrude(39-2*wallThickness){
                        polygon([
                            [wallThickness,0],
                            [59, 0],
                            [59, ductHeight-wallThickness]
                        ]);
                    }
                }
            }
        }
    }
    
}