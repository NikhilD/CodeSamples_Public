function [val, chk] = pointSegmentTest(segmBegin, segmEnd, testpt)

val = ((testpt.y - segmBegin.y)*(segmEnd.x - segmBegin.x)) - ((testpt.x - segmBegin.x)*(segmEnd.y - segmBegin.y));

if(val==0)
    chk = 'OnIT';
elseif (val<0)
    chk = 'RIGHT';
else
    chk = 'LEFT';
end
        