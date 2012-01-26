function inside = insideTriangle(triangle, mote)
inside = 0;
for e = 1:3
    v(e).x = triangle.x(e); v(e).y = triangle.y(e); 
end
v(4).x = triangle.x(1); v(4).y = triangle.y(1); 
for a = 1:3
    angle(a) = threePtAngle(v(a),mote,v(a+1));
end
s = sum(angle);
if((s>=((2*pi)-0.005))&&(s<=((2*pi)+0.005)))
    inside = 1;
end
