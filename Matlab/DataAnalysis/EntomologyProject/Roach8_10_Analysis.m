function Roach8_10_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;

[piezo ir mic] = time_domain('roach8.mat',micCol);
piezor8 = window(piezo,2900,3650);
irr8 = window(ir,2200,2830);
micr8 = window(mic,70,170);
timepiezor8 = timeaxis(piezor8,freq);
timeirr8 = timeaxis(irr8,freq);
timemicr8 = timeaxis(micr8,freq);

figure;
subplot(2,3,1), plot(timepiezor8,piezor8,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor8,0.6);
plot(timepiezor8(maxdexTP1),maxValTP1,'o',timepiezor8(mindexTP1),minValTP1,'o');
hold off;
title('Roach8 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezor8,maxdexTP1,timepiezor8,MAX);
[anglep1n regionp1n] = placepeaks(piezor8,mindexTP1,timepiezor8,MIN);

subplot(2,3,2), plot(timeirr8,irr8,'g');
title('Roach8 IR signal');

subplot(2,3,3), plot(timemicr8,micr8,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr8,0.6);
plot(timemicr8(maxdexTM1),maxValTM1,'o',timemicr8(mindexTM1),minValTM1,'o');
hold off;
title('Roach8 MIC signal');
[anglem1x regionm1x] = placepeaks(micr8,maxdexTM1,timemicr8,MAX);
[anglem1n regionm1n] = placepeaks(micr8,mindexTM1,timemicr8,MIN);

[piezo ir mic] = time_domain('roach10.mat',micCol);
irr10 = window(ir,6240,11650);
micr10 = window(mic,2500,2700);
timeirr10 = timeaxis(irr10,freq);
timemicr10 = timeaxis(micr10,freq);

subplot(2,3,4), plot(timeirr10,irr10,'g');
title('Roach10 IR signal');

subplot(2,3,5), plot(timemicr10,micr10,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(micr10,0.6);
plot(timemicr10(maxdexTM2),maxValTM2,'o',timemicr10(mindexTM2),minValTM2,'o');
hold off;
title('Roach10 MIC signal');
[anglem2x regionm2x] = placepeaks(micr10,maxdexTM2,timemicr10,MAX);
[anglem2n regionm2n] = placepeaks(micr10,mindexTM2,timemicr10,MIN);

figure;
[PPIEZO_r8 FPIEZO_r8] = freq_domain(piezor8,fftpt,freq);
[PIR_r8 FIR_r8] = freq_domain(irr8,fftpt,freq);
[PMIC_r8 FMIC_r8] = freq_domain(micr8,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_r8, PPIEZO_r8(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r8(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r8(indexFP1),maxValFP1,'o');
hold off;
title('Roach8 PIEZO Frequencies');
subplot(2,3,2), plot(FIR_r8, PIR_r8(12:((fftpt/2)+11)),'g');
title('Roach8 IR Frequencies');
subplot(2,3,3), plot(FMIC_r8, PMIC_r8(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r8(12:((fftpt/2)+11)),0.4);
plot(FMIC_r8(indexFM1),maxValFM1,'o');
hold off;
title('Roach8 MIC Frequencies');

[PIR_r10 FIR_r10] = freq_domain(irr10,fftpt,freq);
[PMIC_r10 FMIC_r10] = freq_domain(micr10,fftpt,freq);
subplot(2,3,4), plot(FIR_r10, PIR_r10(12:((fftpt/2)+11)),'g');
title('Roach10 IR Frequencies');
subplot(2,3,5), plot(FMIC_r10, PMIC_r10(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_r10(12:((fftpt/2)+11)),0.4);
plot(FMIC_r10(indexFM2),maxValFM2,'o');
hold off;
title('Roach10 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezor8)) length(piezor8)];
barplot_ir = [sum(abs(irr8)) length(irr8); sum(abs(irr10)) length(irr10)];
barplot_mic = [sum(abs(micr8)) length(micr8); sum(abs(micr10)) length(micr10)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 8 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 8&10 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 8&10 sum|width');

figure;
var = runEnvelope(piezor8);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach8 Piezo Envelope');
var = runEnvelope(micr8);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach8 MIC Envelope');
var = runEnvelope(micr10);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach10 MIC Envelope');

timepiezor1x = timepiezor8(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor8(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timemicr1x = timemicr8(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr8(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
timemicr2x = timemicr10(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemicr2n = timemicr10(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
FPIEZO_r8 = FPIEZO_r8(indexFP1)';
maxValFP1 = maxValFP1';
FMIC_r8 = FMIC_r8(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_r10 = FMIC_r10(indexFM2)';
maxValFM2 = maxValFM2';

% save('Roach8_10data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'timemicr2x','maxValTM2','anglem2x','regionm2x','timemicr2n','minValTM2','anglem2n','regionm2n',...
%                      'FPIEZO_r8','maxValFP1','FMIC_r8','maxValFM1','FMIC_r10','maxValFM2',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEM1','areaEM2');

numtimemaxpeaksP8 = length(maxValTP1);
avgtimemaxpeakvalP8 = (sum(maxValTP1))/numtimemaxpeaksP8;
avgtimemaxpeakangleP8 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP8 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP8 = length(minValTP1);
avgtimeminpeakvalP8 = (sum(minValTP1))/numtimeminpeaksP8;
avgtimeminpeakangleP8 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP8 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP8 = length(FPIEZO_r8);
avgfreqpeakvalP8 = (sum(maxValFP1'))/numfreqpeaksP8;
maxfreqpeakvalP8 = max(maxValFP1);
maxfreqvalP8 = (max(FPIEZO_r8));
minfreqpeakvalP8 = (min(maxValFP1));
minfreqvalP8 = (min(FPIEZO_r8));
avgtimeenvelopeareaP8 = areaEP1;
avgtricorrP8 = (p1tri);
avggausscorrP8 = (p1gauss);

numtimemaxpeaksM8 = length(maxValTM1);
avgtimemaxpeakvalM8 = (sum(maxValTM1))/numtimemaxpeaksM8;
avgtimemaxpeakangleM8 = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM8 = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM8 = length(minValTM1);
avgtimeminpeakvalM8 = (sum(minValTM1))/numtimeminpeaksM8;
avgtimeminpeakangleM8 = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM8 = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM8 = length(FMIC_r8);
avgfreqpeakvalM8 = (sum(maxValFM1')/numfreqpeaksM8);
maxfreqpeakvalM8 = max(maxValFM1);
maxfreqvalM8 = max(FMIC_r8);
minfreqpeakvalM8 = min(maxValFM1);
minfreqvalM8 = min(FMIC_r8);
avgtimeenvelopeareaM8 = (areaEM1);
avgtricorrM8 = (m1tri);
avggausscorrM8 = (m1gauss);

numtimemaxpeaksM10 = length(maxValTM2);
avgtimemaxpeakvalM10 = (sum(maxValTM2))/numtimemaxpeaksM10;
avgtimemaxpeakangleM10 = (sum(anglem2x))/(length(anglem2x));
avgtimemaxpeakareaM10 = (sum(regionm2x))/(length(regionm2x));
numtimeminpeaksM10 = length(minValTM2);
avgtimeminpeakvalM10 = (sum(minValTM2))/numtimeminpeaksM10;
avgtimeminpeakangleM10 = (sum(anglem2n))/(length(anglem2n));
avgtimeminpeakareaM10 = (sum(regionm2n))/(length(regionm2n));
numfreqpeaksM10 = length(FMIC_r10);
avgfreqpeakvalM10 = (sum(maxValFM2')/numfreqpeaksM10);
maxfreqpeakvalM10 = max(maxValFM2);
maxfreqvalM10 = max(FMIC_r10);
minfreqpeakvalM10 = min(maxValFM2);
minfreqvalM10 = min(FMIC_r10);
avgtimeenvelopeareaM10 = (areaEM2);
avgtricorrM10 = (m2tri);
avggausscorrM10 = (m2gauss);

save('Roach8_10data.mat','numtimemaxpeaksP8','avgtimemaxpeakvalP8','avgtimemaxpeakangleP8','avgtimemaxpeakareaP8',...
      'numtimeminpeaksP8','avgtimeminpeakvalP8','avgtimeminpeakangleP8','avgtimeminpeakareaP8',...
      'numfreqpeaksP8','avgfreqpeakvalP8','maxfreqpeakvalP8','maxfreqvalP8','minfreqpeakvalP8','minfreqvalP8','avgtimeenvelopeareaP8',...
      'avgtricorrP8','avggausscorrP8',...
      'numtimemaxpeaksM8','avgtimemaxpeakvalM8','avgtimemaxpeakangleM8','avgtimemaxpeakareaM8',...
      'numtimeminpeaksM8','avgtimeminpeakvalM8','avgtimeminpeakangleM8','avgtimeminpeakareaM8',...
      'numfreqpeaksM8','avgfreqpeakvalM8','maxfreqpeakvalM8','maxfreqvalM8','minfreqpeakvalM8','minfreqvalM8','avgtimeenvelopeareaM8',...
      'avgtricorrM8','avggausscorrM8',...
      'numtimemaxpeaksM10','avgtimemaxpeakvalM10','avgtimemaxpeakangleM10','avgtimemaxpeakareaM10',...
      'numtimeminpeaksM10','avgtimeminpeakvalM10','avgtimeminpeakangleM10','avgtimeminpeakareaM10',...
      'numfreqpeaksM10','avgfreqpeakvalM10','maxfreqpeakvalM10','maxfreqvalM10','minfreqpeakvalM10','minfreqvalM10','avgtimeenvelopeareaM10',...
      'avgtricorrM10','avggausscorrM10');
  
  