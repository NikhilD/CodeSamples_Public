function outVal = valueScaling(inVal, imax, imin, omax, omin)
if(inVal>imax)
    error('Incorrect value - inputValue is greater than inputMax');    
elseif(inVal<imin)
    error('Incorrect value - inputValue is less than inputMin');
end
orange = omax-omin;
irange = imax-imin;
multFac = orange/irange;
num = (omin*imax) - (imin*omax);
outVal = inVal*(multFac) + num/irange;
