function Roach15_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;


[piezo ir mic] = time_domain('roach15.mat',micCol);
piezor15 = window(piezo,550,700);
irr15_1 = window(ir,720,1020);
irr15_2 = window(ir,3670,4660);
irr15_3 = window(ir,6340,7410);
micr15_1 = window(mic,700,850);
micr15_2 = window(mic,4450,4580);
micr15_3 = window(mic,6360,6670);
timepiezor15 = timeaxis(piezor15,freq);
timeirr15_1 = timeaxis(irr15_1,freq);
timeirr15_2 = timeaxis(irr15_2,freq);
timeirr15_3 = timeaxis(irr15_3,freq);
timemicr15_1 = timeaxis(micr15_1,freq);
timemicr15_2 = timeaxis(micr15_2,freq);
timemicr15_3 = timeaxis(micr15_3,freq);

figure;
subplot(2,4,1), plot(timepiezor15,piezor15,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor15,0.6);
plot(timepiezor15(maxdexTP1),maxValTP1,'o',timepiezor15(mindexTP1),minValTP1,'o');
hold off;
title('Roach15 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezor15,maxdexTP1,timepiezor15,MAX);
[anglep1n regionp1n] = placepeaks(piezor15,mindexTP1,timepiezor15,MIN);

subplot(2,4,2), plot(timeirr15_1,irr15_1,'g');
title('Roach15 IR signal 1');
subplot(2,4,3), plot(timeirr15_2,irr15_2,'g');
title('Roach15 IR signal 2');
subplot(2,4,4), plot(timeirr15_3,irr15_3,'g');
title('Roach15 IR signal 3');

subplot(2,4,5), plot(timemicr15_1,micr15_1,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr15_1,0.6);
plot(timemicr15_1(maxdexTM1),maxValTM1,'o',timemicr15_1(mindexTM1),minValTM1,'o');
hold off;
title('Roach15 MIC signal 1');
[anglem1x regionm1x] = placepeaks(micr15_1,maxdexTM1,timemicr15_1,MAX);
[anglem1n regionm1n] = placepeaks(micr15_1,mindexTM1,timemicr15_1,MIN);

subplot(2,4,6), plot(timemicr15_2,micr15_2,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(micr15_2,0.6);
plot(timemicr15_2(maxdexTM2),maxValTM2,'o',timemicr15_2(mindexTM2),minValTM2,'o');
hold off;
title('Roach15 MIC signal 2');
[anglem2x regionm2x] = placepeaks(micr15_2,maxdexTM2,timemicr15_2,MAX);
[anglem2n regionm2n] = placepeaks(micr15_2,mindexTM2,timemicr15_2,MIN);

subplot(2,4,7), plot(timemicr15_3,micr15_3,'b');
hold on;
[maxdexTM3 maxValTM3 mindexTM3 minValTM3]=signalPeaks(micr15_3,0.6);
plot(timemicr15_3(maxdexTM3),maxValTM3,'o',timemicr15_3(mindexTM3),minValTM3,'o');
hold off;
title('Roach15 MIC signal 3');
[anglem3x regionm3x] = placepeaks(micr15_3,maxdexTM3,timemicr15_3,MAX);
[anglem3n regionm3n] = placepeaks(micr15_3,mindexTM3,timemicr15_3,MIN);


figure;
[PPIEZO_r15 FPIEZO_r15] = freq_domain(piezor15,fftpt,freq);
[PIR_r15_1 FIR_r15_1] = freq_domain(irr15_1,fftpt,freq);
[PIR_r15_2 FIR_r15_2] = freq_domain(irr15_2,fftpt,freq);
[PIR_r15_3 FIR_r15_3] = freq_domain(irr15_3,fftpt,freq);
[PMIC_r15_1 FMIC_r15_1] = freq_domain(micr15_1,fftpt,freq);
[PMIC_r15_2 FMIC_r15_2] = freq_domain(micr15_2,fftpt,freq);
[PMIC_r15_3 FMIC_r15_3] = freq_domain(micr15_3,fftpt,freq);
subplot(2,4,1), plot(FPIEZO_r15, PPIEZO_r15(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r15(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r15(indexFP1),maxValFP1,'o');
hold off;
title('Roach15 PIEZO Frequencies');
subplot(2,4,2), plot(FIR_r15_1, PIR_r15_1(12:((fftpt/2)+11)),'g');
title('Roach15 IR Frequencies 1');
subplot(2,4,3), plot(FIR_r15_2, PIR_r15_2(12:((fftpt/2)+11)),'g');
title('Roach15 IR Frequencies 2');
subplot(2,4,4), plot(FIR_r15_3, PIR_r15_3(12:((fftpt/2)+11)),'g');
title('Roach15 IR Frequencies 3');
subplot(2,4,5), plot(FMIC_r15_1, PMIC_r15_1(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r15_1(12:((fftpt/2)+11)),0.4);
plot(FMIC_r15_1(indexFM1),maxValFM1,'o');
hold off;
title('Roach15 MIC Frequencies 1');
subplot(2,4,6), plot(FMIC_r15_2, PMIC_r15_2(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_r15_2(12:((fftpt/2)+11)),0.4);
plot(FMIC_r15_2(indexFM2),maxValFM2,'o');
hold off;
title('Roach15 MIC Frequencies 2');
subplot(2,4,7), plot(FMIC_r15_3, PMIC_r15_3(12:((fftpt/2)+11)),'b');
hold on;
[indexFM3 maxValFM3 del ete]=signalPeaks(PMIC_r15_3(12:((fftpt/2)+11)),0.4);
plot(FMIC_r15_3(indexFM3),maxValFM3,'o');
hold off;
title('Roach15 MIC Frequencies 3');

figure;
barplot_piezo = [sum(abs(piezor15)) length(piezor15)];
barplot_ir = [sum(abs(irr15_1)) length(irr15_1); sum(abs(irr15_2)) length(irr15_2); sum(abs(irr15_3)) length(irr15_3)];
barplot_mic = [sum(abs(micr15_1)) length(micr15_1); sum(abs(micr15_2)) length(micr15_2); sum(abs(micr15_3)) length(micr15_3)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 15 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 15 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 15 sum|width');

figure;
var = runEnvelope(piezor15);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach15 Piezo Envelope');
var = runEnvelope(micr15_1);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach15 MIC 1 Envelope');
var = runEnvelope(micr15_2);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach15 MIC 2 Envelope');
var = runEnvelope(micr15_3);
[m3tri m3gauss] = getcorrn(var.out(2,:));
areaEM3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,4), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach15 MIC 3 Envelope');

timepiezor1x = timepiezor15(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor15(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timemicr1x = timemicr15_1(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr15_1(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
timemicr2x = timemicr15_2(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemicr2n = timemicr15_2(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
timemicr3x = timemicr15_3(maxdexTM3)';
maxValTM3 = maxValTM3';
anglem3x = anglem3x';
regionm3x = regionm3x';
timemicr3n = timemicr15_3(mindexTM3)';
minValTM3 = minValTM3';
anglem3n = anglem3n';
regionm3n = regionm3n';
FPIEZO_r15 = FPIEZO_r15(indexFP1)';
maxValFP1 = maxValFP1';
FMIC_r15_1 = FMIC_r15_1(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_r15_2 = FMIC_r15_2(indexFM2)';
maxValFM2 = maxValFM2';
FMIC_r15_3 = FMIC_r15_3(indexFM3)';
maxValFM3 = maxValFM3';

% save('Roach15data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'timemicr2x','maxValTM2','anglem2x','regionm2x','timemicr2n','minValTM2','anglem2n','regionm2n',...
%                      'timemicr3x','maxValTM3','anglem3x','regionm3x','timemicr3n','minValTM3','anglem3n','regionm3n',...
%                      'FPIEZO_r15','maxValFP1','FMIC_r15_1','maxValFM1','FMIC_r15_2','maxValFM2','FMIC_r15_3','maxValFM3',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEM1','areaEM2','areaEM3');

numtimemaxpeaksP = length(maxValTP1);
avgtimemaxpeakvalP = (sum(maxValTP1))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP = length(minValTP1);
avgtimeminpeakvalP = (sum(minValTP1))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP = length(FPIEZO_r15);
avgfreqpeakvalP = (sum(maxValFP1'))/numfreqpeaksP;
maxfreqpeakvalP = max(maxValFP1);
maxfreqvalP = (max(FPIEZO_r15));
minfreqpeakvalP = (min(maxValFP1));
minfreqvalP = (min(FPIEZO_r15));
avgtimeenvelopeareaP = areaEP1;
avgtricorrP = (p1tri);
avggausscorrP = (p1gauss);

numtimemaxpeaksM = length(maxValTM1)+length(maxValTM2)+length(maxValTM3);
avgtimemaxpeakvalM = (sum(maxValTM1)+sum(maxValTM2)+sum(maxValTM3))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x)+sum(anglem2x)+sum(anglem3x))/(length(anglem1x)+length(anglem2x)+length(anglem3x));
avgtimemaxpeakareaM = (sum(regionm1x)+sum(regionm2x)+sum(regionm3x))/(length(regionm1x)+length(regionm2x)+length(regionm3x));
numtimeminpeaksM = length(minValTM1)+length(minValTM2)+length(minValTM3);
avgtimeminpeakvalM = (sum(minValTM1)+sum(minValTM2)+sum(minValTM3))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n)+sum(anglem2n)+sum(anglem3n))/(length(anglem1n)+length(anglem2n)+length(anglem3n));
avgtimeminpeakareaM = (sum(regionm1n)+sum(regionm2n)+sum(regionm3n))/(length(regionm1n)+length(regionm2n)+length(regionm3n));
numfreqpeaksM = length(FMIC_r15_1)+length(FMIC_r15_2)+length(FMIC_r15_3);
avgfreqpeakvalM = (sum(maxValFM1')+sum(maxValFM2')+sum(maxValFM3')/numfreqpeaksM);
maxfreqpeakvalM = max(max(max(maxValFM1),max(maxValFM2)),max(maxValFM3));
maxfreqvalM = max(max(max(FMIC_r15_1),max(FMIC_r15_2)),max(FMIC_r15_3));
minfreqpeakvalM = min(min(min(maxValFM1),min(maxValFM2)),min(maxValFM3));
minfreqvalM = min(min(min(FMIC_r15_1),min(FMIC_r15_2)),min(FMIC_r15_3));
avgtimeenvelopeareaM = (areaEM1+areaEM2+areaEM3)/3;
avgtricorrM = (m1tri+m2tri+m3tri)/3;
avggausscorrM = (m1gauss+m2gauss+m3gauss)/3;

save('Roach15data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');
  