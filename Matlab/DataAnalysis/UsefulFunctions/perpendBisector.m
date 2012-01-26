function perpendBisector()
points = [1    1    2;    1    3    4];
numPts = size(points,2);

figure; axis([-2 4 -2 4]); grid on; hold on;
for n = 1:numPts-1
    for m = (n+1):numPts
        a = points(:,n);    b = points(:,m);
        [c,d] = doPerpendBisector(a,b);
        plotIt(a,b,c,d);
    end
end
hold off;


function [c, d] = doPerpendBisector(a, b)
slope = (b(2)-a(2))/(b(1)-a(1));
inter = a(2) - (slope*a(1));

c(1) = (a(1)+b(1))/2; % choosing a point on x-axis away from the original to get a point for the perpendicular
c(2) = (a(2)+b(2))/2; 
d(1) = b(1);
d(2) = ((-(1/slope))*(d(1)-c(1))) + c(2);


function plotIt(a,b,c,d)
x1 = [a(1) b(1)];   y1 = [a(2) b(2)];
x2 = [c(1) d(1)];   y2 = [c(2) d(2)];
line(x1,y1,'Color','r','LineWidth',2);
line(x2,y2,'Color','b','LineWidth',2);
