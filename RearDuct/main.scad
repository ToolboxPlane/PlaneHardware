part = "both"; //[both, top, bottom]

ductWidth = 39; //[200]
ductLength = 59; //[200]
ductDepth = 20; //[200]

//Duct Wall Thickness
wallThickness = 2; //[10]

//Baseplate Width
plateWidth = 47; //[200]
//Baseplate Length
plateLength = 99; //[200]
basePlateThickness = 4; //[20]

outletAngleDegrees = 30; //[90]
outletWallThickness = 1; //[10]

//Screwhole Diameter
holeDiameter = 4; //[10]
//X-offset from outer edge to center of screwhole
xHoleOffset = 10; //[100]
//Y-offset from outer edge to center of screwhole
yHoleOffset = 14; //[100]

// Distance between polygons in the outlet
outletRes = 1; //[1]


module mountingHoles(depth){
    x = plateLength - (2 * xHoleOffset);
    y = plateWidth - (2 * yHoleOffset);
    module mountingHole(depth, diameter) {
        cylinder(h = depth, r = 0.5 * diameter, center = false, $fs=0.1);
    }
    union(){
        mountingHole(depth, holeDiameter);
        translate([x,0]) mountingHole(depth, holeDiameter);
        translate([x,y]) mountingHole(depth, holeDiameter);
        translate([0,y]) mountingHole(depth, holeDiameter);
    }
}

module nutHoles(depth) {
    x = plateLength - (2 * xHoleOffset);
    y = plateWidth - (2 * yHoleOffset);
    module nutHole(depth, diameter) {
        cylinder(h = depth, r = 3.8, center = false, $fn=6);
    }
    union(){
        nutHole(depth, holeDiameter);
        translate([x,0]) nutHole(depth, holeDiameter);
        translate([x,y]) nutHole(depth, holeDiameter);
        translate([0,y]) nutHole(depth, holeDiameter);
    }
}

module basePlate(){
    cutoutX = ductLength - 2 * wallThickness;
    cutoutY = ductWidth - 2 * wallThickness;
    translate([-0.5 * plateLength, -0.5 * plateWidth]) difference(){
        cube(size = [plateLength, plateWidth, basePlateThickness]);
        translate([xHoleOffset, yHoleOffset, 0]){
            mountingHoles(basePlateThickness);
        }
        translate([0.5 * (plateLength - cutoutX), 0.5 * (plateWidth - cutoutY), 0]){ 
            cube(size = [ cutoutX, cutoutY, basePlateThickness]);
        }
    }
}

module ductPipe(){
    translate([-0.5 * ductLength, -0.5 * ductWidth]) difference(){
        cube(size = [ductLength, ductWidth, ductDepth]);
        translate([wallThickness, wallThickness]){
            cube(size = [
                ductLength - 2 * wallThickness,
                ductWidth - 2 * wallThickness,
                ductDepth]);
        }
    }
}

module duct(){
    difference(){
         basePlate(plateLength, plateWidth);
         translate([-0.5 * plateLength + xHoleOffset, -0.5 * plateWidth + yHoleOffset]) {
            nutHoles(3);
         }
    }
    translate([0, 0, -1 * ductDepth]) ductPipe();
}


function ductHeight(x) = sqrt(x)*5/6*PI; 

module outlet(){
    innerWidth = ductWidth - 2 * wallThickness;
    innerLength = ductLength - 2 * wallThickness;
    
    outerWidth = innerWidth + 2 * outletWallThickness;
    
    translate([-0.5 * innerLength, -0.5 * outerWidth, 0]){
        for(y = [0:outletRes:innerLength]){
            difference(){
                //Outer
                translate ([y-outletRes, outerWidth, 0]) rotate([90, 0, 0]) linear_extrude(outerWidth){
                    
                    polygon(points=[
                        [0, 0],
                        [0, ductHeight(y)],
                        [outletRes, ductHeight(y+1)], 
                        [outletRes, 0]
                    ]);
                }
                //Inner
                translate ([y-outletRes, innerWidth+outletWallThickness, 0]) rotate([90, 0, 0]) linear_extrude(innerWidth){
                    polygon(points=[
                        [0, 0],
                        [0, ductHeight(y)-outletWallThickness],
                        [outletRes, ductHeight(y+1)-outletWallThickness], 
                        [outletRes, 0]
                    ]);
                }
             }
        }
    }
}

module ductCover() {
    basePlate(plateLength, plateWidth);
    translate([0, 0, basePlateThickness]) outlet();
}

if(part == "both"){
    translate([0, 0, 50]) ductCover();
    duct();
} else if(part == "top"){
    ductCover();
} else{
    duct();
}

