function rss = pathLossModel(param, distance)
dist0 = (1/2.5);    distance = distance*dist0;    obstlen = param.obstlen*dist0;
lambda = (3e8)/(param.freq);    GL = param.antnGain;    loss = param.loss;
ple = param.ple;    sigma = param.sigma;    rxRate = param.rxRate;
power = param.power;    model = param.model;
if(obstlen~=0)
    model = 'shadowing';
end
switch(model)            
    case 'friis'
        M = lambda/(4*pi*distance);      rxPower = (power*GL*GL*(M*M))/loss;        
    case 'shadowing'
        M = lambda/(4*pi*dist0);      rx0 = (power*GL*GL*(M*M))/loss;
        avg_db = -10 * ple * (log10(distance/dist0));
%         invq = inv_Q(rxRate);   thresh_db = (invq * sigma) + avg_db;
%         rxPower = rx0 * (10^(thresh_db/10));
        powerLoss_db = avg_db + (sigma*randn);     % adding a log-normal random variable (shadowing)
        rxPower = rx0 * (10^(powerLoss_db/10));
end
fsl	= 10*(log10(rxPower));
fsl = multNoise(param.noise, fsl);
if((fsl>=param.sensitivity)&&(fsl<=param.minRange))
    rss = fsl;
else
    rss = -1000;
end

% Inverse of Q-function
% y = Q(x) --> x = inv_Q(y)
function x = inv_Q(y)
x = sqrt(2)*erfcinv(2*y); 
