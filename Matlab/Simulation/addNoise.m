function val = addNoise(noise, val)
eta = noise*randn;
val = eta + val;
