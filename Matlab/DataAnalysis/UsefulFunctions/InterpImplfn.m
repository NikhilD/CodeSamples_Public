function InterpImplfn()
[X Y] = meshgrid(5:0.5:15, 5:0.5:15);
f = sqrt(((X-10).^2)+((Y-10).^2));
Z1 = (f.^2).*log(f);
Z2 = exp(-2*f.^2);
Z3 = sqrt((f.^2)+(2^2));
figure; surf(X, Y, Z1);
figure; surf(X, Y, Z2);
figure; surf(X, Y, Z3);
brk = 1;