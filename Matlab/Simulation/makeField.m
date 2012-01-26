function field = makeField(x,y,plotit)
field.x = x;
field.y = y;
if(plotit)
    field.figMain = figure;
    % axis([-inf inf -inf inf]);
    axis([0 x 0 y]);
    axis square;
    grid off;
    hold on;
end