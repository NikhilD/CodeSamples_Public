function val = multNoise(noise, val)
eta = noise*randn;
adiNoise = 1 + eta;
while(adiNoise<0)
    eta = noise*randn;
    adiNoise = 1 + eta;
end
val = val*adiNoise;
