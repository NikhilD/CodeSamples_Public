function [x, y] = rssCircChk(center, radius, pts, colour, plotit)
% pts = 200;   radius = 25;
THETA=linspace(0,2*pi,pts);
RHO=ones(1,pts)*radius;
[X,Y] = pol2cart(THETA,RHO);
% x = fix(round(X + center(1)));
% y = fix(round(Y + center(2)));
x = X + center(1);
y = Y + center(2);
if(plotit)
    plot(x, y, colour), grid on;
end
