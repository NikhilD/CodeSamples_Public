function tempVariance()

stepp = 2;      field = 100;
% figure;
% axis([0 field 0 field]);
% axis square;
% grid off;
% hold on;

sigma = 5.67*(10^(-8));
degC = 200;
chi = 273 + degC;

a=roundn((rand*field),-2);    b=roundn((rand*field),-2);
c = a - fix(a);     d = b - fix(b);

% if(c<=0.25)
    source.x = 50;%fix(a);
% elseif((c>0.25)&&(c<=0.75))
%     source.x = fix(a) + 0.5;
% else
%     source.x = fix(a) + 1;
% end
% if(d<=0.25)
    source.y = 50;%fix(b);
% elseif((d>0.25)&&(d<=0.75))
%     source.y = fix(b) + 0.5;
% else
%     source.y = fix(b) + 1;
% end
source.Tm = 273 + degC;   % Kelvin
source.Rn = sigma*((source.Tm)^4);

[x, y] = meshgrid(0:stepp:field, 0:stepp:field);
lenx = size(x,1);   leny = size(x,2);

for i = 1:lenx
    for j = 1:leny        
        pt(i,j).x = x(i,j);  pt(i,j).y = y(i,j);
        pt(i,j).Tm1 = getTempr1(source, pt(i,j), sigma);
        pt(i,j).Tm2 = getTempr2(source, pt(i,j), chi);
        tempr1(i,j) = pt(i,j).Tm1;
        tempr2(i,j) = pt(i,j).Tm2;
%         pause(0.0025);  pt(i,j).plot = plot(pt(i,j).x,pt(i,j).y,'ro','MarkerSize',6,'MarkerFaceColor',[1 1 1]);
    end
end
figure, surf(x,y,tempr1);
figure, surf(x,y,tempr2);
minTempr = min(min(tempr1));
maxTempr = max(max(tempr1));
% for i = 1:lenx
%     for j = 1:leny
%         pause(0.0025);
%         tempr = pt(i,j).Tm;
%         colorG = valueScaling(tempr, source.Tm, minTempr, 0, 1);
%         if((colorG<=0)||(colorG>=1))
%             brk = 1;
%         end
%         faceColor = [1 colorG 0];
%         set(pt(i,j).plot, 'MarkerFaceColor', faceColor);
%     end
% end

brk = 1;



function tempr = getTempr1(source, pt, sigma)
dist = ObjectDist(source, pt);
if(dist<=0)
    radN = source.Rn;
else
    radN = source.Rn/(dist^2);
end
tempr = nthroot((radN/sigma), 4);




function tempr = getTempr2(source, pt, chi)
dist = ObjectDist(source, pt);
if(dist<=0)
    radN = source.Tm;
else
    radN = chi/(dist+1);
end
tempr = radN;


function [dist, angle] = ObjectDist(object1,object2)
dist = sqrt(((object1.x-object2.x)^2)+((object1.y-object2.y)^2));
angle = atan2(object2.y-object1.y,object2.x-object1.x);



