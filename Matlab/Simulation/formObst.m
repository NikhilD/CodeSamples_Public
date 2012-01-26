function obstacle = formObst(field, percent, obstFactor, plotit)
% It is decided that the areas of all obstacles will be same. Likewise,
% there is a relation between the radii, square side and triangle sides.
% The plot region has to be a 'Square'. The only variables are then the
% dimension of the region and the percentage of obstacle coverage in the
% region.

offset = (0.1)*field.x;
switch(percent)    
    case 0
        obstacle = [];
        return;
    otherwise
        numSqr = ceil((0.5)*percent);
        numTri = floor((0.5)*percent);
%       error('Incorrect obstacle percent value!');
end

A_region = (field.x)*(field.x);             % Area of plot region
A_obst = (1/obstFactor)*A_region;        % Area of each obstacle - constant for every obstacle
obstacle.area = A_obst;
obstacle.numObst = numSqr + numTri;

sideSqr = sqrt(A_obst);
baseTri = sqrt(A_obst);       % This is because, I have considered "base = (1/2)*height"
htTri = 2*baseTri;


if(numSqr~=0)
    for s = 1:numSqr
        pt.x = (rand*((field.x-offset)-offset)) + offset;
        pt.y = (rand*((field.x-offset)-offset)) + offset;
        square(s).side = sideSqr;
        [square(s).x, square(s).y] = makeSquare(field, pt, sideSqr, plotit);
        obstacle.square(s) = square(s);
    end
else
    obstacle.square = [];
end
if(numTri~=0)
    for t = 1:numTri
        pt.x = (rand*((field.x-offset)-offset)) + offset;
        pt.y = (rand*((field.x-offset)-offset)) + offset;
        triangle(t).base = baseTri;
        triangle(t).ht = htTri;
        [triangle(t).x, triangle(t).y] = makeTriangle(field, pt, baseTri, htTri, plotit);
        obstacle.triangle(t) = triangle(t);
    end
else
    obstacle.triangle = [];
end



function [x, y] = makeSquare(field, pt, side, plotit)

x(1) = pt.x;
x(2) = pt.x;
x(3) = pt.x + side;
x(4) = pt.x + side;
y(1) = pt.y;
y(2) = pt.y + side;
y(3) = pt.y + side;
y(4) = pt.y;
if(plotit)
    figure(field.figMain);
    line(x, y, 'Color', 'k', 'LineWidth', 2);
end



function [x, y] = makeTriangle(field, point, base, height, plotit)

x(1) = point.x;
x(2) = point.x + base;
x(3) = point.x + base;
y(1) = point.y;
y(2) = point.y;
y(3) = point.y + height;
if(plotit)
    figure(field.figMain);
    line(x, y, 'Color', 'k', 'LineWidth', 2);
end
