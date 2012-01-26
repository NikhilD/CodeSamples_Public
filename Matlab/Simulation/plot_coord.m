function object = plot_coord(field,numMotes,id,rfConfig,obstacle,plotit)
offset = 0;        
object = getLocn(field.x, offset, obstacle);
% object.x = 0;   object.y = 0;
object.id = id;
object.faceColor = [1 1 1];
if(plotit)
    figure(field.figMain);
    object.plot = plot(object.x,object.y,'ro','MarkerSize',8,'MarkerFaceColor',object.faceColor);
else
    object.plot = 0;
end
object.text = 0;%text(object.x,object.y,num2str(id));
object.visited = 0;
object.hopCnt = -1;
object.neigh_radius = 0;
object.rfConfig = rfConfig;
object.neighHC = ones(numMotes,1)*(-1);
object.rfRSS = ones(numMotes,1)*(-1000);
object.Obstwifi = zeros(numMotes,1);

object.alti = 0;

object.gpn = 0;
object.gpm = zeros(numMotes,1);
object.neighRank = zeros(numMotes,1);
object.gpdelta = zeros(numMotes,1);
object.gpdelScale = zeros(numMotes,1);

object.rssScale = zeros(numMotes,1);
object.pwrNeighs = 0;
object.neighProb = 0;
object.gpnMod = 0;
object.gpdelRank = zeros(numMotes,1);
object.SArank = zeros(numMotes,1);

function object = getLocn(field, offset, obstacle)
if(~isempty(obstacle))
    object = locnMarks(field, offset, obstacle);
else
    object.x = roundn(((rand*(field-offset))+offset),-3);
    object.y = roundn(((rand*(field-offset))+offset),-3);
end
