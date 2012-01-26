function [robot, target] = getLine(robot,field)
point(1).x = 0; point(1).y = 0;
point(2).x = 0; point(2).y = field.y;
point(3).x = field.x; point(3).y = field.y;
point(4).x = field.x; point(4).y = 0;

for i = 1:4
    dist(i) = ObjectDist(robot,point(i));
end
[d,j] = max(dist);
target.x = abs(point(j).x - 2);
target.y = abs(point(j).y - 2);
x = [robot.x target.x];
y = [robot.y target.y];
robot.line = line(x,y,'Color','k');

