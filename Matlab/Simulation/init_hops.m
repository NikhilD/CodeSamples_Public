function [motes, level] = init_hops(field, motes, level, maxIter, plotit)
R = 1; G = 0; B = 0;
for j = 2:maxIter
    R = R - 0.2; G = G + 0.08; B = B + 0.06;
    [R,G,B] = rgbChk(R,G,B);
    numLvl = length(level(j).nodes);
    for nL = 1:numLvl
        k = level(j).nodes(nL);
        if(motes(k).visited==0)            
            motes(k).faceColor = [R G B];
            motes(k).visited = 1;
            motes(k).hopCnt = j-1; 
            if(plotit)
                pause(0.0025);
                figure(field.figMain);
                set(motes(k).plot, 'MarkerFaceColor', motes(k).faceColor, 'MarkerEdgeColor', motes(k).faceColor);
            end
            level(j+1).nodes = [level(j+1).nodes motes(k).neighbors];
        end
    end
    ljp = level(j+1).nodes;
    if(isempty(ljp)),break,end
end



function [R,G,B] = rgbChk(R,G,B)
if(R<0.0),R=0.0;end
if(R>1.0),R=1.0;end
if(G<0.0),G=0.0;end
if(G>1.0),G=1.0;end
if(B<0.0),B=0.0;end
if(B>1.0),B=1.0;end
