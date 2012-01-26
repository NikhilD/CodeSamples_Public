function [numIters, delVals, wtVect, RBFcenters, trained] = trainRBFGrDe(xInp, z_val, iter, epsilon, rbfunction)

RBFcenters = xInp;         % basis function centres
N = size(xInp,2);          % number of points
radii = zeros(N);          % basis function radii
for m = 1:N
    for n = 1:N
        radii(m,n)=sqrt(sum((RBFcenters(:,m) - xInp(:,n)).^2));
    end
end

% Apply RBF
switch(rbfunction)
    case 'thinPlate'
        E = (radii.^2).*log(radii); E(find(radii==0))=0;
    case 'gaussian'
        sigma = 100; E = exp(-(radii.^2)./(2*(sigma^2)));
    case 'invMultiQuadric'
        beta = 200; E = 1./(sqrt((radii.^2) + (beta^2)));
end
% E = E'*E;   z_val = E'*z_val;   
[V, D] = eig(E);

wtRgeMin = -1e-5;   wtRgeMax = 1e-5;    trained = 0;
wtVect = rand(N,1)*(wtRgeMax-wtRgeMin) + wtRgeMin; 

resi = z_val - E*wtVect;   d_val = resi;
del = resi'*resi;   del0 = del;     delVals = del;
for i = 1:iter
    q = E*d_val;
    alpha = del/(d_val'*q);
    wtVect = wtVect + alpha*d_val;
    if(mod(i,6)==0)
        resi = z_val - E*wtVect;
    else
        resi = resi - alpha*q;
    end
    delOld = del;
    del = resi'*resi;
    beta = del/delOld;
    d_val = resi + beta*d_val;
    delVals = [delVals del];
    if(del<((epsilon^2)*del0))
        trained = 1;
        numIters = i;
        break;
    end
end
if(trained==0)
    numIters = iter;
end
wtVect = wtVect';
