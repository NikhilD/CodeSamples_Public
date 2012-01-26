function [Pyy f]= freq_domain(signal,fftpt,freq)
sign = fft(signal,fftpt);
Pyy = sign.*conj(sign)/fftpt;
f = freq*(1:(fftpt/2))/fftpt;
