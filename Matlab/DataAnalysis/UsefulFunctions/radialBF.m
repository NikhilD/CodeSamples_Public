x = [1 2 3; 2 4 1];
xc=x;%basis function centres
N=size(x,2);%number of points
r=zeros(N);%basis function radii
for i=1:N
    for j=1:N
        r(i,j)=sqrt(sum((xc(:,i)-x(:,j)).^2));
    end
end
disp(r);
brk = 1;