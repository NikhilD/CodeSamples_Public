function SignalAnalysis(filename, piezobias, irbias, micbias)

scale = 3/4095;
data = load(filename);
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

f = 1000*(0:256)/512;

plot(f, Pyypiezo(1:257), 'r', f, Pyyir(1:257), 'g', f, Pyymic(1:257), 'b');
%plot(f,Pyyir(1:257));
%plot(f,Pyymic(1:257));
