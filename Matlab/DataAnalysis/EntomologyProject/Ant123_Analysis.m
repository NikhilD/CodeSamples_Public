function Ant123_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;

[piezo ir mic] = time_domain('ant1.mat',micCol);
ira1 = window(ir,1,400);
mica1_1 = window(mic,6900,7050);
mica1_2 = window(mic,9000,11000);
timeira1 = timeaxis(ira1,freq);
timemica1_1 = timeaxis(mica1_1,freq);
timemica1_2 = timeaxis(mica1_2,freq);

figure;
subplot(2,3,1), plot(timeira1,ira1,'g');
title('Ant1 IR signal');

subplot(2,3,2), plot(timemica1_1,mica1_1,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(mica1_1,0.6);
plot(timemica1_1(maxdexTM1),maxValTM1,'o',timemica1_1(mindexTM1),minValTM1,'o');
hold off;
title('Ant1 MIC signal 1 ');
[anglem1x regionm1x] = placepeaks(mica1_1,maxdexTM1,timemica1_1,MAX);
[anglem1n regionm1n] = placepeaks(mica1_1,mindexTM1,timemica1_1,MIN);

subplot(2,3,3), plot(timemica1_2,mica1_2,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(mica1_2,0.6);
plot(timemica1_2(maxdexTM2),maxValTM2,'o',timemica1_2(mindexTM2),minValTM2,'o');
hold off;
title('Ant1 MIC signal 2');
[anglem2x regionm2x] = placepeaks(mica1_2,maxdexTM2,timemica1_2,MAX);
[anglem2n regionm2n] = placepeaks(mica1_2,mindexTM2,timemica1_2,MIN);

[piezo ir mic] = time_domain('ant2.mat',micCol);
ira2 = window(ir,9350,9750);
timeira2 = timeaxis(ira2,freq);
subplot(2,3,4), plot(timeira2,ira2,'g');
title('Ant2 IR signal');

[piezo ir mic] = time_domain('ant3.mat',micCol);
ira3 = window(ir,110,630);
timeira3 = timeaxis(ira3,freq);
subplot(2,3,5), plot(timeira3,ira3,'g');
title('Ant3 IR signal');

[PIR_a1 FIR_a1] = freq_domain(ira1,fftpt,freq);
[PMIC_a1_1 FMIC_a1_1] = freq_domain(mica1_1,fftpt,freq);
[PMIC_a1_2 FMIC_a1_2] = freq_domain(mica1_2,fftpt,freq);

figure;
subplot(2,3,1), plot(FIR_a1, PIR_a1(12:((fftpt/2)+11)),'g');
title('Ant1 IR Frequencies');

subplot(2,3,2), plot(FMIC_a1_1, PMIC_a1_1(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_a1_1(12:((fftpt/2)+11)),0.4);
plot(FMIC_a1_1(indexFM1),maxValFM1,'o');
hold off;
title('Ant1 MIC Frequencies 1');

subplot(2,3,3), plot(FMIC_a1_2, PMIC_a1_2(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_a1_2(12:((fftpt/2)+11)),0.4);
plot(FMIC_a1_2(indexFM2),maxValFM2,'o');
hold off;
title('Ant1 MIC Frequencies 2');

[PIR_a2 FIR_a2] = freq_domain(ira2,fftpt,freq);
subplot(2,3,4), plot(FIR_a2, PIR_a2(12:((fftpt/2)+11)),'g');
title('Ant2 IR Frequencies');

[PIR_a3 FIR_a3] = freq_domain(ira3,fftpt,freq);
subplot(2,3,5), plot(FIR_a3, PIR_a3(12:((fftpt/2)+11)),'g');
title('Ant3 IR Frequencies');

figure;
barplot_piezo = [0 0];
barplot_ir = [sum(abs(ira1)) length(ira1); sum(abs(ira2)) length(ira2); sum(abs(ira3)) length(ira3)];
barplot_mic = [sum(abs(mica1_1)) length(mica1_1); sum(abs(mica1_2)) length(mica1_2)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 1&2&3 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 1&2&3 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 1 sum|width');

figure;
areaEP1=0;
var = runEnvelope(mica1_1);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(1,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Ant1 MIC 1 Envelope');
var = runEnvelope(mica1_2);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(1,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Ant1 MIC 2 Envelope');

timemica1_1x = timemica1_1(maxdexTM1)';
maxValTM1 = maxValTM1'; 
anglem1x = anglem1x'; 
regionm1x = regionm1x'; 
timemica1_1n = timemica1_1(mindexTM1)';
minValTM1 = minValTM1'; 
anglem1n = anglem1n'; 
regionm1n = regionm1n';
timemica1_2x = timemica1_2(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemica1_2n = timemica1_2(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
FMIC_a1_1 = FMIC_a1_1(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_a1_2 = FMIC_a1_2(indexFM2)';
maxValFM2 = maxValFM2';

% save('Ant123data.mat','timemica1_1x','maxValTM1','anglem1x','regionm1x','timemica1_1n','minValTM1','anglem1n','regionm1n',...
%                      'timemica1_2x','maxValTM2','anglem2x','regionm2x','timemica1_2n','minValTM2','anglem2n','regionm2n',...
%                      'FMIC_a1_1','maxValFM1','FMIC_a1_2','maxValFM2',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEM1','areaEM2');

numtimemaxpeaksM1 = length(maxValTM1)+length(maxValTM2);
avgtimemaxpeakvalM1 = (sum(maxValTM1)+sum(maxValTM2))/numtimemaxpeaksM1;
avgtimemaxpeakangleM1 = (sum(anglem1x)+sum(anglem2x))/(length(anglem1x)+length(anglem2x));
avgtimemaxpeakareaM1 = (sum(regionm1x)+sum(regionm2x))/(length(regionm1x)+length(regionm2x));
numtimeminpeaksM1 = length(minValTM1)+length(minValTM2);
avgtimeminpeakvalM1 = (sum(minValTM1)+sum(minValTM2))/numtimeminpeaksM1;
avgtimeminpeakangleM1 = (sum(anglem1n)+sum(anglem2n))/(length(anglem1n)+length(anglem2n));
avgtimeminpeakareaM1 = (sum(regionm1n)+sum(regionm2n))/(length(regionm1n)+length(regionm2n));
numfreqpeaksM1 = length(FMIC_a1_1)+length(FMIC_a1_2);
avgfreqpeakvalM1 = (sum(maxValFM1')+sum(maxValFM2')/numfreqpeaksM1);
maxfreqpeakvalM1 = (max(max(maxValFM1),max(maxValFM2)));
maxfreqvalM1 = (max(max(FMIC_a1_1),max(FMIC_a1_2)));
minfreqpeakvalM1 = (min(min(maxValFM1),min(maxValFM2)));
minfreqvalM1 = (min(min(FMIC_a1_1),min(FMIC_a1_2)));
avgtimeenvelopeareaM1 = (areaEM1+areaEM2)/2;
avgtricorrM1 = (m1tri+m2tri)/2;
avggausscorrM1 = (m1gauss+m2gauss)/2;

save('Ant123data.mat','numtimemaxpeaksM1','avgtimemaxpeakvalM1','avgtimemaxpeakangleM1','avgtimemaxpeakareaM1',...
      'numtimeminpeaksM1','avgtimeminpeakvalM1','avgtimeminpeakangleM1','avgtimeminpeakareaM1',...
      'numfreqpeaksM1','avgfreqpeakvalM1','maxfreqpeakvalM1','maxfreqvalM1','minfreqpeakvalM1','minfreqvalM1','avgtimeenvelopeareaM1',...
      'avgtricorrM1','avggausscorrM1');