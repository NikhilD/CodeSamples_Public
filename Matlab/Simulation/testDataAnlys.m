function testDataAnlys()
numExpts = 30;  numTypes = 4;
Ar = zeros(numExpts,numTypes); 
Pl = zeros(numExpts,numTypes);  
Sh = zeros(numExpts,numTypes); 
Rl = zeros(numExpts,numTypes);  
Fl = zeros(numExpts,numTypes); 

t = load('testData.mat');
for e = 1:numExpts
    Ar(e,:) = t.areas(1,1,e).area;
    Pl(e,:) = t.pathLens(1,1,e).len;
    Sh(e,:) = t.shortest(1,1,e).short;
    Rl(e,:) = t.routeLens(1,1,e).len;
    Fl(e,:) = t.fails(1,1,e).fail;
end
brk = 1;
