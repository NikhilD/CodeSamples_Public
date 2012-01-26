function chkObst = chkObstacle(motes, path)
numPath = length(path);     global PLOTIT;
notOnObst = zeros(numPath,1);
if(numPath==0)
    chkObst = 1;
else
    for p = 1:numPath
        indi = path(p);
        inObst = sum(motes(indi).inSqr) + sum(motes(indi).inTri);
        if(inObst==0)
            notOnObst(p) = 1;
            chkObst = 0;
        else
            chkObst = 1;
             if((isempty(PLOTIT))||(PLOTIT==1))
%                 text(motes(indi).x,motes(indi).y,num2str(motes(indi).id));
             end
            break;
        end
    end
end
if(chkObst~=1)
    nP = sum(notOnObst);
    if(nP==numPath)
        chkObst = 0;
    else
        chkObst = 1;
    end
end
    