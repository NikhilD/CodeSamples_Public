function [maxdex maxVal mindex minVal] = signalPeaks(signal,scale)
maxdex = [];
mindex = [];
maxVal = [];
minVal = [];
[xmax imax xmin imin]= extrema(signal);
sigMax = max(xmax);
sigMin = min(xmin);
for i=1:length(imax)
    if(xmax(i)>=(sigMax*scale))
        maxdex = [maxdex imax(i)];
        maxVal = [maxVal xmax(i)];
    end
end
for i=1:length(imin)
    if(xmin(i)<=(sigMin*scale))
        mindex = [mindex imin(i)];
        minVal = [minVal xmin(i)];
    end
end