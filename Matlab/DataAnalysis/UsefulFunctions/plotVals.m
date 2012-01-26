function motes = plotVals(field, numMotes)
for m = 1:numMotes
    motes(m) =  getCoord(field);
end


function mote = getCoord(field)
offset = 0;
mote.x = roundn(((rand*(field-offset))+offset),-3);
mote.y = roundn(((rand*(field-offset))+offset),-3);
