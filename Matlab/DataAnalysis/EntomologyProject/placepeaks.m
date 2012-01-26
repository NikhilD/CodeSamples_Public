function [angle region] = placepeaks(signal,index,time,extremum)
angle = [];
region = [];
for i = 1:length(index)
    [A Ar] = peakdata(time((index(i)-1):(index(i)+1)),signal((index(i)-1):(index(i)+1)),extremum);
    angle = [angle A];
    region = [region Ar];
end