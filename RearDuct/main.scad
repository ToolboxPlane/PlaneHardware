wallThickness = 2;
basePlateThickness = 3;

ductWidth = 39;
ductLength = 59;
ductDepth = 20;

plateWidth = 47;
plateLength = 99;

holeDiameter = 4;

//Hole offset from outer edge to center of hole
xHoleOffset = 10;
yHoleOffset = 14;

module mountingHoles(depth){
    x = plateLength - (2 * xHoleOffset);
    y = plateWidth - (2 * yHoleOffset);
    module mountingHole(depth, diameter) {
        cylinder(h = depth, r = 0.5 * holeDiameter, center = false, $fs=0.1);
    }
    union(){
        mountingHole(depth, diameter);
        translate([x,0,0]) mountingHole(depth, holeDiameter);
        translate([x,y,0]) mountingHole(depth, holeDiameter);
        translate([0,y,0]) mountingHole(depth, holeDiameter);
    }
}

module basePlate(){
    cutoutX = ductLength - 2 * wallThickness;
    cutoutY = ductWidth - 2 * wallThickness;
    difference(){
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
    difference(){
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
    basePlate(plateLength, plateWidth);
    translate([
        0.5 * (plateLength - ductLength), 
        0.5 * (plateWidth - ductWidth ),
        -1 * ductDepth]){
            ductPipe();
        }
}

duct();