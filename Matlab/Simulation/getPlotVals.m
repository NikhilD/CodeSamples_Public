function getPlotVals()
nodes = [50 100 150 200 250 300 350 400 450 500];
fields = [1350 1500 1600 1750 1750 1750 1750 1750 1750 1750];
numExpts = 30;

for n = 1:length(nodes)
    for e = 1:numExpts
        motes(e).mote = plotVals(fields(n), nodes(n));
    end
    filenm = strcat('motes',num2str(nodes(n)),'.mat');
    save(filenm,'motes');
end

