function [newx,newy] = adjustPosition(distance, angle, buffer)
dist = distance-buffer;
if dist < 0
    if angle > 0
        angle = angle - pi;
    else
        angle = angle + pi;
    end
end
% newx = abs(dist)*cos(angle);
% newy = abs(dist)*sin(angle);
newx = (dist)*cos(angle);
newy = (dist)*sin(angle);
