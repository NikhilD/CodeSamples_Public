function distance = rssTodist(rss, config)
dist0 = (1/2.5);
power = config.rfPower;    freq = config.freq;      model = config.model;
lambda = (3e8)/(freq);     rxPower = 10^(rss/10);   loss = config.loss;
GL = config.antnGain;
switch(model)    
    case 'friis'
        intrm = (sqrt((rxPower*loss)/(power*GL*GL)));
        piD = lambda/intrm;      distance = piD/(4*pi);
end
distance = distance/dist0;
