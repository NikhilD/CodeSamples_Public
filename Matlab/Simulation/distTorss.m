function rss = distTorss(robot1,robot2)
distance = ObjectDist(robot1, robot2);
param.power = robot1.rfConfig.rfPower;    param.freq = robot1.rfConfig.freq;      
param.model = robot1.rfConfig.model;      param.ple = robot1.rfConfig.ple;
param.sigma = robot1.rfConfig.sigma;      param.obstlen = robot1.Obstwifi(robot2.id);
param.noise = robot1.rfConfig.noise;      param.sensitivity = robot1.rfConfig.sensitivity;  
param.rxRate = robot1.rfConfig.rxRate;    param.minRange = robot1.rfConfig.minRange;
param.loss = robot1.rfConfig.loss;        param.antnGain = robot1.rfConfig.antnGain;  
mindist = rssTodist(param.minRange, robot1.rfConfig);
if(distance<=mindist)
    distance = mindist;
end
rss = pathLossModel(param, distance);
