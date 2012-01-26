function Gaussian()
m1 = 5; m2 = 5;
sig1 = 0.5; sig2 = 0.5;
rho = 0.5;
[X1 X2] = meshgrid(0:0.25:200, 0:0.25:200);
% [X1 X2] = meshgrid((m1-2):0.25:(m1+2), (m2-2):0.25:(m2+2));
f1 = (((X1-m1).^2)./(sig1)^2);
f12 = -2*rho*(((X1-m1).*(X2-m2))./(sig1*sig2));
f2 = (((X2-m2).^2)./(sig2)^2);
ef = (-1)/(2*(1-(rho^2))).*(f1+f12+f2);
e = exp(ef);
f = (1/(2*pi*sig1*sig2*(sqrt(1-(rho^2)))))*e;
figure;
surf(X1, X2, f);
brk = 1;