function Signals_Frequency()%filename)
fftpt = 512;
freq = 1000;
MAX = 1;
MIN = 2;
scale = 3/4095;
data = load('ant1.mat');
piezo = data.sendata(:,1)*scale;
ir = data.sendata(:,2)*scale;
mic = data.sendata(:,5)*scale;

piezobias = mean(piezo);
irbias = mean(ir);
micbias = mean(mic);

piezo = piezo - piezobias;
ir = ir - irbias;
mic = mic - micbias;

signalpiezo = fft(piezo,512);
signalir = fft(ir,512);
signalmic = fft(mic,512);

Pyypiezo = signalpiezo.*conj(signalpiezo)/512;
Pyyir = signalir.*conj(signalir)/512;
Pyymic = signalmic.*conj(signalmic)/512;

f = freq*(1:(fftpt/2))/fftpt;
y = Pyymic(12:((fftpt/2)+11));
% plot(f, Pyypiezo(11:257), 'r', f, Pyyir(11:257), 'g', f, Pyymic(11:257), 'b');
% plot(f,Pyyir(1:257));
plot(f,y);
hold on;
[index maxVal]=signalPeaks(y,0.5);
plot(f(index),maxVal,'o');
hold off;
[angle1 region1] = peakdata(f(index(1)-1:index(1)+1),y(index(1)-1:index(1)+1),MAX);
[angle2 region2] = peakdata(f(index(2)-1:index(2)+1),y(index(2)-1:index(2)+1),MAX);


