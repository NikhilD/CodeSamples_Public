function formu = expectedNeighborhood(Ps, R, N)
ac = acos(-0.5);    as = asin(-0.5);
p1 = ((R^2)*ac) + (4*(R^3)*as) - (sqrt(3)*(R^3)) - ((R^2)*as) + ((sqrt(3)*(R^2))/8);
p2 = (2*Ps*N)/(pi*(R^2));
formu = p1*p2;
