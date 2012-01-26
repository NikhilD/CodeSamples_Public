function chk = onLine(object, square, triangle)
numSqr = length(square);
numTri = length(triangle);

runchk = 0;
for s = 1:numSqr
    [thischk, runchk] = chkOnline(object, square(s), 'square', runchk);
    if(runchk==numSqr)
        runchk = 0;
        for t = 1:numTri
            [thischk, runchk] = chkOnline(object, triangle(t), 'triangle', runchk);
            if(runchk==numTri)
                chk = 1;
            elseif(thischk==0)
                chk=0;
                break;
            end
        end
    elseif(thischk==0)
        chk=0;
        break;
    end    
end


function [chk, runchk] = chkOnline(object, obst, type, runchk)
switch(type)
    case 'square'
        t = 4;
    case 'triangle'
        t = 3;
end
for e = 1:t
    v(e).x = obst.x(e); v(e).y = obst.y(e); 
end
v(t+1).x = obst.x(1); v(t+1).y = obst.y(1); 
offset = 150;
for e = 1:t
    angle = radtodeg(threePtAngle(v(e),object,v(e+1)));        
    if(angle>offset)
        chk=0;
        break;
    else
        chk = 1;        
    end
end
runchk = runchk + chk;

