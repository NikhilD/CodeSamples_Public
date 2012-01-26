function [tricorr sqcorr] = getcorrn(var)
req_signal = envelope_signal(var);
[tricorr sqcorr] = xcorrn(req_signal);