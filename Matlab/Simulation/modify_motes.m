function motes = modify_motes(field, numMotes, nodes, rfConfig, obstacle, plotit)
offset = 0; 
for m = 1:numMotes
    if(~isempty(obstacle))
        motes(m) = locnMarks(field.x, offset, obstacle);
    else    
        motes(m).x = nodes(m).x;
        motes(m).y = nodes(m).y;
    end
end
for m = 1:numMotes    
    motes(m).id = m;
    motes(m).faceColor = [1 1 1];
    if(plotit)
        figure(field.figMain);
        motes(m).plot = plot(motes(m).x,motes(m).y,'ro','MarkerSize',8,'MarkerFaceColor',motes(m).faceColor);
    else
        motes(m).plot = 0;
    end
    motes(m).text = 0;%text(motes(m).x,motes(m).y,num2str(m));
    motes(m).visited = 0;
    motes(m).hopCnt = -1;
    motes(m).neigh_radius = 0;
    motes(m).rfConfig = rfConfig;
    motes(m).neighHC = ones(numMotes,1)*(-1);
    motes(m).rfRSS = ones(numMotes,1)*(-1000);
    motes(m).Obstwifi = zeros(numMotes,1);

    motes(m).alti = 0;

    motes(m).gpn = 0;
    motes(m).gpm = zeros(numMotes,1);
    motes(m).neighRank = zeros(numMotes,1);
    motes(m).gpdelta = zeros(numMotes,1);
    motes(m).gpdelScale = zeros(numMotes,1);

    motes(m).rssScale = zeros(numMotes,1);
    motes(m).pwrNeighs = 0;
    motes(m).neighProb = 0;
    motes(m).gpnMod = 0;
    motes(m).gpdelRank = zeros(numMotes,1);
    motes(m).SArank = zeros(numMotes,1);       
    
end


