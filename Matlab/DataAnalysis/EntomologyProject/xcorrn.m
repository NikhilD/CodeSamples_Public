function [tricorr gauscorr] = xcorrn(signal)

%define width for xcorr triangle and square
W=50; % going with a width of 50 corresponding to 0.5 sec width on the signal

if(length(signal)<W)
    a = W-length(signal);
    for g = 1:1:(a/2)
        signal = [0 signal 0];
    end
end

%Find cross-correlation coefficients of envelope with
%triangle and gauss pulse with defined width
Tp=(-length(signal)/2):1:(length(signal)/2)-1;
tri = tripuls(Tp,W);
gaus = gausscurve(length(Tp));
trixcorr = corrcoef(signal,tri);
tricorr = trixcorr(1,2);
gausxcorr = corrcoef(signal,gaus);
gauscorr = gausxcorr(1,2);