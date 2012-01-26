function CubicSpline()
[x, y] = meshgrid(-5:0.25:5, -5:0.25:5);
ptx = 0; pty = 0;
h = 1;
factor = 10/(7*pi*(h^2));
X = ((x - ptx).^2);  Y = ((y - pty).^2);
kappa = sqrt(X+Y)./h;
[row, col] = size(kappa);
w = zeros(row,col);
for r = 1:row
    for c = 1:col
        if((kappa(r,c)>=0)&&(kappa(r,c)<=1))
            w(r,c) = 1 - ((3/2)*(kappa(r,c)^2)) + ((3/4)*(kappa(r,c)^3));
        elseif((kappa(r,c)>1)&&(kappa(r,c)<=2))
            w(r,c) = (1/4)*((2 - kappa(r,c))^3);
        else
            w(r,c) = 0;    
        end        
    end
end
cuSpline = w.*factor;
figure;
surf(x, y, cuSpline);

