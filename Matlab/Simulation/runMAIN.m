function runMAIN()

nodes = [50 100 150 200 250 300 350 400 450 500];
fields = [1350 1500 1600 1750 1750 1750 1750 1750 1750 1750];
rssNoise = [0 0.02 0.04 0.06 0.08 0.10]; % percent-RSS
angleNoise = [0 (pi/90) (pi/45) (pi/30) (pi/22.5) (pi/18)]; % radians ~ (0-10 degrees)

plotit = 1;     numExpts = 1;  numTypes = 4;   lrn = length(rssNoise); lan = length(angleNoise);

% matlabpool open local 2

for k = 2:2%length(nodes)
    filenm = strcat('motes',num2str(nodes(k)),'.mat');
    motes = load(filenm);
    field = fields(k);
    [areas, pathLens, shortest, routeLens, fails] = initVars(lrn,lan,numExpts);
    for n = 1:1%lrn
        rssN = rssNoise(n);
        for a = 1:1%lan
            angleN = angleNoise(a);
            for e = 1:numExpts            
                [areas(n,a,e).area, pathLens(n,a,e).len, shortest(n,a,e).short, routeLens(n,a,e).len, fails(n,a,e).fail] = ...
                      RBFwNoise_main(motes.motes(e).mote, field, rssN, angleN, e, plotit);                
            end
        end
    end
    filenm = strcat('dataInterpNoise',num2str(nodes(k)),'.mat');
    save(filenm,'areas','pathLens','shortest','routeLens','fails');
    clear 'areas' 'pathLens' 'shortest' 'routeLens' 'fails';
end
% matlabpool close



function [areas, pathLens, shortest, routeLens, fails] = initVars(lrn,lan,numExpts)
for n = 1:lrn
    for a = 1:lan
        for e = 1:numExpts
            areas(n,a,e).area = 0;
            pathLens(n,a,e).len = 0;
            shortest(n,a,e).short = 0;
            routeLens(n,a,e).len = 0;
            fails(n,a,e).fail = 0;
        end
    end
end

