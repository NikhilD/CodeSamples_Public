function y_hat = simulateRBFGrDe(x, x_c, a, rbfunction)

N_c = size(x_c,2);          %number of RBF centres
N_p = size(x,2);            %number of points

radii = zeros(N_c,N_p);     %basis function radii
for i = 1:N_c
    for j = 1:N_p
        radii(i,j) = sqrt(sum((x_c(:,i)-x(:,j)).^2));
    end
end

% radial basis function
switch(rbfunction)
    case 'thinPlate'
        E = (radii.^2).*log(radii);     E(find(radii==0)) = 0;      %avoid -inf
    case 'gaussian'
        sigma = 100; E = exp(-(radii.^2)./(2*(sigma^2)));
    case 'invMultiQuadric'
        beta = 200; E = 1./(sqrt((radii.^2) + (beta^2)));
end

y_hat = a*E;                %apply weights
