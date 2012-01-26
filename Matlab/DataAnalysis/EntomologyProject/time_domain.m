function [piezo ir mic] = time_domain(filename,micCol)
scale = 3/4095;
data = load(filename);
p = data.sendata(:,1)*scale;
i = data.sendata(:,2)*scale;
m = data.sendata(:,micCol)*scale;

piezobias = mean(p);
irbias = mean(i);
micbias = mean(m);

piezo = p - piezobias;
ir = i - irbias;
mic = m - micbias;



