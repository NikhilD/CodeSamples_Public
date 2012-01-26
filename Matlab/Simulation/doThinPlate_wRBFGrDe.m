function [point, dataPoints, trained] = doThinPlate_wRBFGrDe(field, X_inp, z_val, plotit, ptDiv, rbfunction, locnVal, wlRange)
[point, dataPoints, trained] = doAnalys(field, X_inp, z_val, ptDiv, rbfunction, wlRange);
if(plotit)
    figure; grid on; hold on;
    surf(dataPoints.xVals,dataPoints.yVals,dataPoints.zVals);
    colormap(jet); shading interp; lighting phong;
    plot3(X_inp(1,:),X_inp(2,:),z_val,'ok','MarkerSize',10,'MarkerFaceColor',[0 0 0]);
    plot3(0,0,locnVal,'sk','MarkerSize',12,'MarkerFaceColor',[0 0 0]);
    hold off;
end


function [point, dataPoints, trained] = doAnalys(field, X_inp, z_val, ptDiv, rbfunction, wlRange)

[unused, unused, wtVect, RBFcenters, trained] = trainRBFGrDe(X_inp, z_val', 5000, 1e-10, rbfunction);       %train ANN using BP Algorithm

X_range = [field.x1 field.x2;field.y1 field.y2];                    %limits of X to plot at
plotPts = getPlotNums(field, ptDiv);
N_grid = [plotPts plotPts];                                         %number of points to plot at in form [x y]

[x_mesh y_mesh] = meshgrid(linspace(X_range(1,1),X_range(1,2),N_grid(1)),linspace(X_range(2,1),X_range(2,2),N_grid(2)));
X_mesh = [reshape(x_mesh,1,[]);reshape(y_mesh,1,[])];%reshape into X=[x;y] matrix

Y_mesh = simulateRBFGrDe(X_mesh, RBFcenters, wtVect, rbfunction);                    %perform tps calculation on mesh points
Y_mesh_r = reshape(Y_mesh,N_grid(1),N_grid(2));                       %reshape into rectangular matrix

circMesh = modifyToCircle(x_mesh, y_mesh, Y_mesh_r, plotPts, wlRange);

[maxRows, row] = max(circMesh);     [maxCols, col] = max(maxRows);
point.x = x_mesh(row(col),col);      point.y = y_mesh(row(col),col);      
point.gradVal = maxCols;    

dataPoints.xVals = x_mesh;  dataPoints.yVals = y_mesh;  dataPoints.zVals = circMesh;
dataPoints.xys = X_mesh;    dataPoints.Hrow = row(col);  dataPoints.Hcol = col;



function plotPts = getPlotNums(field, ptDiv)
useRge = abs(field.x1 - field.x2);
if(useRge<ptDiv)
    useRge = abs(field.y1 - field.y2);
end
plotPts = round(useRge/ptDiv);
if(plotPts<ptDiv)
    plotPts = ptDiv;
end
if(mod(plotPts,2)==0)
    plotPts = plotPts + 1;
end


function circMesh = modifyToCircle(xVals, yVals, zVals, plotPts, wlRange)
% The Robot Location is always [0;0];
center = [0; 0];
for r=1:plotPts    
    for c = 1:plotPts
        pt = [xVals(r,c); yVals(r,c)];
        dist = sqrt(sum((pt - center).^2));
        if(dist>wlRange)
            zVals(r,c)=min(min(zVals))/1e3;
        end
    end
end
circMesh = zVals;

