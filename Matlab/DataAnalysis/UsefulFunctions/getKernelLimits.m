function val = getKernelLimits(rc, mSize, kerSize)
if(rc>mSize)
    val = [];
	return;    
end
neg = 0; pos = 0;
while(1)
    if(((rc+neg)<=(rc-kerSize))||((rc+neg)==1))
        break;
    end
    neg = neg - 1;
end
while(1)
    if(((rc+pos)>=(rc+kerSize))||((rc+pos)>=mSize))
        break;
    end
    pos = pos + 1;
end
val = neg:1:pos;
