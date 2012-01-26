function inside = insideCircle(circle, mote)
inside = 0;
dist = ObjectDist(circle.center, mote);
if(dist<circle.radius)
    inside = 1;
end
