function [dist,angle] = ObjectDist(object1,object2)
dist = sqrt(((object1.x-object2.x)^2)+((object1.y-object2.y)^2));
angle = atan2(object2.y-object1.y,object2.x-object1.x);
% angle = angle*180/pi;