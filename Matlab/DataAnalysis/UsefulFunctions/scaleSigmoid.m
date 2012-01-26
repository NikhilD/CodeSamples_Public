function outVal = scaleSigmoid(inVal, imax, imin, alpha, beta)
half = (imax + imin)/2;
value = inVal - half;
outVal = (exp(-value)^beta)/((1+(exp(-value)^beta))^alpha);
% outVal = log(value/(1-value));
