function inside = insideSquare(square, mote)
inside = 0;
for e = 1:4
    v(e).x = square.x(e); v(e).y = square.y(e); 
end
v(5).x = square.x(1); v(5).y = square.y(1); 
for a = 1:4
    angle(a) = threePtAngle(v(a),mote,v(a+1));
end
s = sum(angle);
if((s>=((2*pi)-0.005))&&(s<=((2*pi)+0.005)))
    inside = 1;
end
