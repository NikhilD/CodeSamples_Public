function NoiseAnalys()
nodes = [50 100 150 200 250 300 350 400 450 500];
rssNoise = [0 0.02 0.04 0.06 0.08 0.10]; % percent-RSS
angleNoise = [0 (pi/90) (pi/45) (pi/30) (pi/22.5) (pi/18)]; % radians ~ (0-10 degrees)
numExpts = 30;  numTypes = 4;


for ks = 1:length(nodes)
    filenm = strcat('dataInterpNoise',num2str(nodes(ks)),'.mat');
    dataNoise = load(filenm);
    a=1;b=1;c=1;d=1;
    for rN = 1:length(rssNoise)
        e=1;f=1;g=1;h=1;
        for aN = 1:length(angleNoise)
            i=1;j=1;k=1;m=1;
            f1=0;f2=0;f3=0;f4=0;
            for eX = 1:numExpts                
                if((dataNoise.fails(rN,aN,eX).fail(1)==0)&&(dataNoise.pathLens(rN,aN,eX).len(1)~=0))
                    PGinterp(1).pathRatios(a,e).expt(i) = dataNoise.pathLens(rN,aN,eX).len(1)/dataNoise.shortest(rN,aN,eX).short(1);
                    PGinterp(1).routeLen(a,e).expt(i) = dataNoise.routeLens(rN,aN,eX).len(1);
                    PGinterp(1).area(a,e).expt(i) = dataNoise.areas(rN,aN,eX).area(1);
                    i=i+1;
                else                    
                    f1 = f1 + 1;
                end
                if((dataNoise.fails(rN,aN,eX).fail(2)==0)&&(dataNoise.pathLens(rN,aN,eX).len(2)~=0))
                    PGinterp(2).pathRatios(b,f).expt(j) = dataNoise.pathLens(rN,aN,eX).len(2)/dataNoise.shortest(rN,aN,eX).short(2);
                    PGinterp(2).routeLen(b,f).expt(j) = dataNoise.routeLens(rN,aN,eX).len(2);
                    PGinterp(2).area(b,f).expt(j) = dataNoise.areas(rN,aN,eX).area(2);
                    j=j+1;
                else
                    f2 = f2+1;
                end
                if((dataNoise.fails(rN,aN,eX).fail(3)==0)&&(dataNoise.pathLens(rN,aN,eX).len(3)~=0))
                    PGinterp(3).pathRatios(c,g).expt(k) = dataNoise.pathLens(rN,aN,eX).len(3)/dataNoise.shortest(rN,aN,eX).short(3);
                    PGinterp(3).routeLen(c,g).expt(k) = dataNoise.routeLens(rN,aN,eX).len(3);
                    PGinterp(3).area(c,g).expt(k) = dataNoise.areas(rN,aN,eX).area(3);
                    k=k+1;
                else
                    f3 = f3+1;
                end
                if((dataNoise.fails(rN,aN,eX).fail(4)==0)&&(dataNoise.pathLens(rN,aN,eX).len(4)~=0))
                    PGinterp(4).pathRatios(d,h).expt(m) = dataNoise.pathLens(rN,aN,eX).len(4)/dataNoise.shortest(rN,aN,eX).short(4);
                    PGinterp(4).routeLen(d,h).expt(m) = dataNoise.routeLens(rN,aN,eX).len(4);
                    PGinterp(4).area(d,h).expt(m) = dataNoise.areas(rN,aN,eX).area(4);
                    m=m+1;
                else
                    f4 = f4+1;
                end
            end
            e=e+1;f=f+1;g=g+1;h=h+1;
            PGinterp(1).fail(rN,aN) = f1;  PGinterp(2).fail(rN,aN) = f2;
            PGinterp(3).fail(rN,aN) = f3;  PGinterp(4).fail(rN,aN) = f4;
        end        
        a=a+1;b=b+1;c=c+1;d=d+1;
    end
    for ty = 1:numTypes      
        for rN = 1:length(PGinterp(ty).pathRatios(:,1))
            basicRSS1(rN).expt = PGinterp(ty).pathRatios(rN,1).expt;
            basicRSS2(rN).expt = PGinterp(ty).routeLen(rN,1).expt;
            basicRSS3(rN).expt = PGinterp(ty).area(rN,1).expt;
            PGinterp(ty).rss.plotRatios(ks,rN) = mean(basicRSS1(rN).expt);
            PGinterp(ty).rss.stdRatios(ks,rN) = 1.96.*((std(basicRSS1(rN).expt,0))./sqrt(length(basicRSS1(rN).expt)));
            PGinterp(ty).rss.plotLens(ks,rN) = mean(basicRSS2(rN).expt);% - (0.1 + (0.15)*rand);
            PGinterp(ty).rss.stdLens(ks,rN) = 1.96.*((std(basicRSS2(rN).expt,0))./sqrt(length(basicRSS2(rN).expt)));
            PGinterp(ty).rss.plotAreas(ks,rN) = mean(basicRSS3(rN).expt);    
            PGinterp(ty).rss.stdAreas(ks,rN) = 1.96.*((std(basicRSS3(rN).expt,0))./sqrt(length(basicRSS3(rN).expt)));    
        end        
        
        for aN = 1:length(PGinterp(ty).pathRatios(1,:))
            basicRSS1(aN).expt = PGinterp(ty).pathRatios(1,aN).expt;
            basicRSS2(aN).expt = PGinterp(ty).routeLen(1,aN).expt;
            basicRSS3(aN).expt = PGinterp(ty).area(1,aN).expt;
            PGinterp(ty).angle.plotRatios(ks,aN) = mean(basicRSS1(aN).expt);
            PGinterp(ty).angle.stdRatios(ks,aN) = 1.96.*((std(basicRSS1(aN).expt,0))./sqrt(length(basicRSS1(aN).expt)));
            PGinterp(ty).angle.plotLens(ks,aN) = mean(basicRSS2(aN).expt);% - (0.1 + (0.15)*rand);
            PGinterp(ty).angle.stdLens(ks,aN) = 1.96.*((std(basicRSS2(aN).expt,0))./sqrt(length(basicRSS2(aN).expt)));
            PGinterp(ty).angle.plotAreas(ks,aN) = mean(basicRSS3(aN).expt);    
            PGinterp(ty).angle.stdAreas(ks,aN) = 1.96.*((std(basicRSS3(aN).expt,0))./sqrt(length(basicRSS3(aN).expt)));    
        end
        for rN = 1:length(rssNoise)
            for aN = 1:length(angleNoise)
                fails(ks,ty,rN,aN) = PGinterp(ty).fail(rN,aN);
            end
        end
    end    
end
PGinterp(2).rss.plotRatios(:,1)
PGinterp(2).rss.stdRatios(:,1)
PGinterp(2).rss.plotLens(:,1)
PGinterp(2).rss.stdLens(:,1)

% bar3(basicPG.rss.plotRatios);
colours = ['r' 'g' 'b' 'c' 'm' 'k'];    markers = ['d' 'o' 's' '^'];
styles = {'-' ':' '--' '-.'};
figure; grid on; hold on;
for ty = 1:numTypes
    plotErrorBar(nodes,PGinterp(ty).rss.plotRatios(:,1),PGinterp(ty).rss.stdRatios(:,1),colours(ty),styles(ty),markers(ty));
end
hold off;
figure; grid on; hold on;
for ty = 1:numTypes
    plotErrorBar(nodes,PGinterp(ty).rss.plotLens(:,1),PGinterp(ty).rss.stdLens(:,1),colours(ty),styles(ty),markers(ty));
end
hold off;

figure; grid on; hold on;
for ty = 1:2
    plotTheData(nodes,PGinterp(ty).rss.plotRatios,PGinterp(ty).rss.stdRatios,styles(ty),markers(ty));
end
hold off;
figure; grid on; hold on;
for ty = 1:2
    plotTheData(nodes,PGinterp(ty).rss.plotLens,PGinterp(ty).rss.stdLens,styles(ty),markers(ty));
end
hold off;

figure; grid on; hold on;
for ty = 1:2
    plotTheData(nodes,PGinterp(ty).angle.plotRatios,PGinterp(ty).angle.stdRatios,styles(ty),markers(ty));
end
hold off;
figure; grid on; hold on;
for ty = 1:2
    plotTheData(nodes,PGinterp(ty).angle.plotLens,PGinterp(ty).angle.stdLens,styles(ty),markers(ty));
end
hold off;


function plotTheData(xAxis, meanVal, stdVal, style, marker)

colours = ['r' 'g' 'b' 'c' 'm' 'k'];
for i = 1:length(meanVal(1,:))
    plotUsual(xAxis,meanVal(:,i),colours(i),style,marker);
%     plotErrorBar(xAxis,meanVal(:,i),stdVal(:,i),colours(i),style,marker);
end


function plotErrorBar(xAxis, meanVals, stdVals, colour, lineStyle, marker)
errorbar(xAxis,meanVals,stdVals,'LineWidth',2,'Color',colour,'LineStyle',char(lineStyle),'Marker',marker);


function plotUsual(xAxis, meanVals, colour, lineStyle, marker)
plot(xAxis,meanVals,'LineWidth',2,'Color',colour,'LineStyle',char(lineStyle),'Marker',marker);
