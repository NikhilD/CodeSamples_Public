function tgt = makeTarget(field, numTgts, plotit)
rad = 40;       offset = 20;
for o = 1:numTgts
    tgt(o).x = (25/500)*field.x;%(rand*(field-offset))+offset;
    tgt(o).y = (450/500)*field.x;%(rand*(field-offset))+offset;
    tgt(o).radius = rad;
    if(plotit)
        figure(field.figMain);
        tgt(o).plot = plot(tgt(o).x, tgt(o).y, 'kh', 'MarkerSize', 18, 'MarkerFaceColor',[0.74 0.72 0.42]); % Dark Khaki
    end
end

