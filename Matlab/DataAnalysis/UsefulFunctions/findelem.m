function [outIndx, outArr] = findelem(inArr, elem, cmpr)
len = length(inArr);
outArr = [];    outIndx = outArr;

switch(cmpr)
    case '=='
        for i = 1:len
            if(elem==inArr(i))
                outArr = [outArr inArr(i)];
                outIndx = [outIndx i];
            end
        end
    case '<='
        for i = 1:len
            if(elem>=inArr(i))
                outArr = [outArr inArr(i)];
                outIndx = [outIndx i];
            end
        end
    case '>='
        for i = 1:len
            if(elem<=inArr(i))
                outArr = [outArr inArr(i)];
                outIndx = [outIndx i];
            end
        end
    case '<'
        for i = 1:len
            if(elem>inArr(i))
                outArr = [outArr inArr(i)];
                outIndx = [outIndx i];
            end
        end
    case '>'
        for i = 1:len
            if(elem<inArr(i))
                outArr = [outArr inArr(i)];
                outIndx = [outIndx i];
            end
        end
    case '~='
        for i = 1:len
            if(elem~=inArr(i))
                outArr = [outArr inArr(i)];
                outIndx = [outIndx i];
            end
        end
end
