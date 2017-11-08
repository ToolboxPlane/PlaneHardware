OPENSCADC=openscad
INPUT=main.scad
OUTPUT=main.stl
FLAGS="part=\"both\""
STLVIEWER=meshlab

all: compile view

compile:
	$(OPENSCADC) -o $(OUTPUT) -D $(FLAGS) $(INPUT)

clean:
	rm $(OUTPUT)

view:
	$(STLVIEWER) $(OUTPUT) & 

build:
	$(OPENSCADC) -o top.stl -D "part=\"top\"" $(INPUT)&
	$(OPENSCADC) -o bottom.stl -D "part=\"bottom\"" $(INPUT)
