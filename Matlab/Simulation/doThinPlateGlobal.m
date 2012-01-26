function doThinPlateGlobal(field, motes, gpvals, pathGlobal, pathLocal, plotit)
numMotes = length(motes);   X_inp = zeros(2,numMotes);
x_glo = zeros(1,length(pathGlobal));    y_glo = zeros(1,length(pathGlobal));  
z_glo = zeros(1,length(pathGlobal));    x_loc = zeros(1,length(pathLocal));  
y_loc = zeros(1,length(pathLocal));     z_loc = zeros(1,length(pathLocal));
for m = 1:numMotes
    X_inp(1,m) = motes(m).x; 
    X_inp(2,m) = motes(m).y;    
end
for p = 1:length(pathGlobal)
    x_glo(p) = pathGlobal(p).node.x;
    y_glo(p) = pathGlobal(p).node.y;
    z_glo(p) = pathGlobal(p).node.gpn;
end
for p = 1:length(pathLocal)
    x_loc(p) = pathLocal(p).locn.x;
    y_loc(p) = pathLocal(p).locn.y;
    z_loc(p) = pathLocal(p).locn.gpn;
end
clear('motes');
dataPoints = doAnalys(field, X_inp, gpvals);
if(plotit)    
    figure; grid on; hold on;
    surf(dataPoints.xVals,dataPoints.yVals,dataPoints.zVals);
    colormap(jet); shading interp; lighting phong;
    plot3(X_inp(1,:),X_inp(2,:),gpvals,'ok','MarkerSize',10,'MarkerFaceColor',[0 0 0]);
    line(x_glo,y_glo,z_glo,'Color','c','LineWidth',2);
    line(x_loc,y_loc,z_loc,'Color','m','LineWidth',2);
    hold off;
end
       



function dataPoints = doAnalys(field, X_inp, z_val)
% [a, Xc]=train_thin_plate_spline(X_inp,z_val);%train thin plate spline network
[wtVect, RBFcenters, trained] = trainRBFGrDe(X_inp, z_val', 5000, 1e-10, 'thinPlate');       %train ANN using BP Algorithm

X_range=[0 field;0 field];%limits of X to plot at
N_grid=[(field/10) (field/10)];%number of points to plot at in form [x y]
[x_mesh y_mesh]=meshgrid(linspace(X_range(1,1),X_range(1,2),N_grid(1)),linspace(X_range(2,1),X_range(2,2),N_grid(2)));
X_mesh=[reshape(x_mesh,1,[]);reshape(y_mesh,1,[])];%reshape into X=[x;y] matrix

% Y_mesh=sim_thin_plate_spline(X_mesh,Xc,a);%perform tps calculation on mesh points
Y_mesh = simulateRBFGrDe(X_mesh, RBFcenters, wtVect, 'thinPlate');                    %perform tps calculation on mesh points
Y_mesh_r=reshape(Y_mesh,N_grid(1),N_grid(2));%reshape into rectangular matrix

dataPoints.xVals = x_mesh;  dataPoints.yVals = y_mesh;  dataPoints.zVals = Y_mesh_r;




