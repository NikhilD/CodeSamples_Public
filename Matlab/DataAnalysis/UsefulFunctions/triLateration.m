function point = triLateration(p1, p2, p3, p4)

if(chkCollinear(p1, p2, p3))
    error('Vertices are Collinear! Cannot do Trilateration...');
end

point1 = [0 0 0]';    dummy2 = [(p2(1)-p1(1)) p2(2)-p1(2) 0]';
dummy3 = [(p3(1)-p1(1)) p3(2)-p1(2) 0]';
dummy4 = [(p4(1)-p1(1)) p4(2)-p1(2) 0]';

ctr1.x = point1(1);  ctr1.y = point1(2);   
ctr2.x = dummy2(1);  ctr2.y = dummy2(2);   
[unused, angle] = ObjectDist(ctr1, ctr2);   % in radians

pt2 = rotz(-angle)*dummy2;   pt3 = rotz(-angle)*dummy3;
tgt1 = rotz(-angle)*dummy4;

point1 = ctr1;  
point2.x = pt2(1);  point2.y = pt2(2);
point3.x = pt3(1);  point3.y = pt3(2);
tgt.x = tgt1(1);    tgt.y = tgt1(2);

% Now following the description in wikipedia for triLateration
d = point2.x;  
r1 = ObjectDist(tgt,point1);
r2 = ObjectDist(tgt,point2);
r3 = ObjectDist(tgt,point3);

x = ((r1^2)-(r2^2)+(d^2))/(2*d);
yp1 = ((r1^2)-(r3^2)+(point3.x^2)+(point3.y^2))/(2*point3.y);
yp2 = (point3.x/point3.y)*x;
y = yp1 - yp2;

dummy = [x y 0]';    pt = rotz(angle)*dummy; 
point = [pt(1)+p1(1) pt(2)+p1(2)];

figure; grid on; hold on;
plotLateration(p1, p2, p3, p4);
plot(point(1), point(2), '-kh', 'MarkerFaceColor', 'k');
hold off;


function [dist,angle] = ObjectDist(object1,object2)
dist = sqrt(((object1.x-object2.x)^2)+((object1.y-object2.y)^2));
angle = atan2(object2.y-object1.y,object2.x-object1.x);



function plotLateration(p1, p2, p3, p4)

[X1, Y1] = getPlotData(p1, p4);
[X2, Y2] = getPlotData(p2, p4);
[X3, Y3] = getPlotData(p3, p4);

plot(X1, Y1, 'r', X2, Y2, 'g', X3, Y3, 'b');
plot(p1(1), p1(2), 'ro', p2(1), p2(2), 'go', p3(1), p3(2), 'bo');
plot(p4(1), p4(2), '-mh', 'MarkerFaceColor', 'm');



function [X, Y] = getPlotData(point1, point2)
ctr.x = point1(1);  ctr.y = point1(2);   
tgt.x = point2(1);  tgt.y = point2(2); 
radius = ObjectDist(tgt,ctr);
pts = 100;  THETA = linspace(0,2*pi,pts);
RHO = ones(1,pts)*radius;
[x, y] = pol2cart(THETA,RHO);
X = x + ctr.x;  Y = y + ctr.y;



function boolVal = chkCollinear(p1, p2, p3)
boolVal = 0;
pt1.x = p1(1);  pt1.y = p1(2);
pt2.x = p2(1);  pt2.y = p2(2);
pt3.x = p3(1);  pt3.y = p3(2);
angle = threePtAngle(pt1, pt2, pt3);
if((angle==pi)||(angle==0))
    boolVal = 1;
end

