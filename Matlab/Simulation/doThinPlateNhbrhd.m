function point = doThinPlateNhbrhd(field, X_inp, z_val, plotit, type)
[point, x_mesh, y_mesh, Y_mesh_r] = doAnalys(field, X_inp, z_val, type);
if(plotit)
    figure; grid on; hold on;
    surf(x_mesh,y_mesh,Y_mesh_r);
    colormap(jet);
    shading interp; lighting phong;
    plot3(X_inp(1,:),X_inp(2,:),z_val,'ok','MarkerSize',10,'MarkerFaceColor',[0 0 0]);
    hold off;
end
       



function [point, x_mesh, y_mesh, Y_mesh_r] = doAnalys(field, X_inp, z_val, type)
[a, Xc]=train_thin_plate_spline(X_inp,z_val);%train thin plate spline network
X_range=[field.x1 field.x2;field.y1 field.y2];%limits of X to plot at
plotPts = round(abs(field.x1 - field.x2));
N_grid=[plotPts plotPts];%number of points to plot at in form [x y]
[x_mesh y_mesh]=meshgrid(linspace(X_range(1,1),X_range(1,2),N_grid(1)),linspace(X_range(2,1),X_range(2,2),N_grid(2)));
X_mesh=[reshape(x_mesh,1,[]);reshape(y_mesh,1,[])];%reshape into X=[x;y] matrix

Y_mesh=sim_thin_plate_spline(X_mesh,Xc,a);%perform tps calculation on mesh points
Y_mesh_r=reshape(Y_mesh,N_grid(1),N_grid(2));%reshape into rectangular matrix

[maxRows, row] = max(Y_mesh_r);     [maxCols, col] = max(maxRows);
point.x = x_mesh(row(col),col);      point.y = y_mesh(row(col),col);      
switch(type)
    case 'gpn'
        point.gpn = maxCols;
    case 'tempr'
        point.Tempr = maxCols;
end





