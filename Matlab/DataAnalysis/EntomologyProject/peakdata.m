function [angle region] = peakdata(x,y,extremum)
MAX = 1;
MIN = 2;
switch extremum
    case MAX
        [angle region] = datapeak(x,y);
    case MIN
        [angle region] = datapeak(x,-y);
end

function [angle region] = datapeak(x,y)
for i =1:length(y)
    if(y(i)<0)
        y(i)=0;
    end
end
slope1 = (y(2)-y(1))/(x(2)-x(1));
slope2 = (y(3)-y(2))/(x(3)-x(2));

if(y(3)<y(1))
    const2 = y(2) - (slope2*x(2));
    interX = (y(1) - const2)/slope2;

    base = interX - x(1);
    height = y(2) - y(1);
    region = (1/2)*(base*height);

    langle = atand(height/(x(2)-x(1)));
    rangle = atand(height/(interX-x(2)));
    angle = 180 - (langle + rangle);

elseif(y(3)>y(1))
    const1 = y(2) - (slope1*x(2));
    interX = (y(3) - const1)/slope2;

    base = x(3) - interX;
    height = y(2) - y(3);
    region = (1/2)*(base*height);

    langle = atand(height/(x(2)-interX));
    rangle = atand(height/(x(3)-x(2)));
    angle = 180 - (langle + rangle);

else
    base = x(3) - x(1);
    height = y(2) - y(1);
    region = (1/2)*(base*height);
    
    langle = atand(height/(x(2)-x(1)));
    rangle = atand(height/(x(3)-x(2)));
    angle = 180 - (langle + rangle);
    
end