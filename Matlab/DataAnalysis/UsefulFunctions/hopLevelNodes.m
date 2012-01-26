function [Nlvl, Ntotal] = hopLevelNodes(hopLvl)
% Taken from...
% Viswanath, K. & Obraczka, K. - "Modeling the Performance of Flooding in
% wireless multi-hop ad hoc networks"

% Ps needs to be greater than 0.1 OR 
% (Ps*N) & (Pb*N) need to result in a value greater than '1'.

N = 20;     Ps = 0.1;   
Nb = ceil((N/2)-(N/6));   beta = 0.41;
Pb = 1 - ((1-Ps)^Nb);

PbHop = ((Pb*N)^(hopLvl-1));    betaHop = (beta^(hopLvl-1));
Nlvl = (Ps*N)*PbHop*betaHop;

PbNB = (Pb*N*beta); numer = (PbNB^hopLvl) - 1;   denom = PbNB - 1;
Ntotal = (Ps*N)*(numer/denom);
