function plotLine(mote, point, colour)
x = [mote.x point.x];
y = [mote.y point.y];
line(x,y,'Color',colour,'LineWidth',2);