function matrix = randsymm(dim,rmin,rmax,diag,dim1)
% first generate a vector of random elements. The number of elements in the
% vector depend on 'dim'. For an 'n x n' symmetric matrix, the number of
% unique values in the matrix is given by the formula - n(n+1)/2. These
% values are entered in the upper triangular and mirrored in the lower
% triangular as follows.

n = (dim*(dim+1))/2;
randv = (rand(n,1).*(rmax-rmin)) + rmin;

switch(dim1)
    case 1
        matrix = zeros(1,dim);
        for i = 1:dim
            matrix(i) = randv(i);            
        end
    case 2
        matrix = zeros(dim,dim);    % pre-allocating for program speed purposes
        k = 1;
        if(diag==1)
            for i = 1:dim
                for j = i:dim
                    matrix(i,j) = randv(k);     % upper triangular
                    matrix(j,i) = randv(k);     % lower triangular
                    k = k + 1;
                end
            end
        else
            for i = 1:dim
                for j = i:dim
                    if(j~=i)
                        matrix(i,j) = randv(k);     % upper triangular
                        matrix(j,i) = randv(k);     % lower triangular
                        k = k + 1;
                    end
                end
            end
        end
end
