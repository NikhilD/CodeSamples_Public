function Roach16_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;


[piezo ir mic] = time_domain('roach16.mat',micCol);
piezor16_1 = window(piezo,1070,1230);
piezor16_2 = window(piezo,6860,6945);
irr16_1 = window(ir,490,1000);
irr16_2 = window(ir,7290,7950);
micr16_1 = window(mic,620,1170);
micr16_2 = window(mic,7630,7770);
timepiezor16_1 = timeaxis(piezor16_1,freq);
timepiezor16_2 = timeaxis(piezor16_2,freq);
timeirr16_1 = timeaxis(irr16_1,freq);
timeirr16_2 = timeaxis(irr16_2,freq);
timemicr16_1 = timeaxis(micr16_1,freq);
timemicr16_2 = timeaxis(micr16_2,freq);

figure;
subplot(2,3,1), plot(timepiezor16_1,piezor16_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor16_1,0.6);
plot(timepiezor16_1(maxdexTP1),maxValTP1,'o',timepiezor16_1(mindexTP1),minValTP1,'o');
hold off;
title('Roach16 PIEZO signal 1');
[anglep1x regionp1x] = placepeaks(piezor16_1,maxdexTP1,timepiezor16_1,MAX);
[anglep1n regionp1n] = placepeaks(piezor16_1,mindexTP1,timepiezor16_1,MIN);

subplot(2,3,2), plot(timepiezor16_2,piezor16_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor16_2,0.6);
plot(timepiezor16_2(maxdexTP2),maxValTP2,'o',timepiezor16_2(mindexTP2),minValTP2,'o');
hold off;
title('Roach16 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezor16_2,maxdexTP2,timepiezor16_2,MAX);
[anglep2n regionp2n] = placepeaks(piezor16_2,mindexTP2,timepiezor16_2,MIN);

subplot(2,3,3), plot(timeirr16_1,irr16_1,'g');
title('Roach16 IR signal 1');
subplot(2,3,4), plot(timeirr16_2,irr16_2,'g');
title('Roach16 IR signal 2');

subplot(2,3,5), plot(timemicr16_1,micr16_1,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr16_1,0.6);
plot(timemicr16_1(maxdexTM1),maxValTM1,'o',timemicr16_1(mindexTM1),minValTM1,'o');
hold off;
title('Roach16 MIC signal 1');
[anglem1x regionm1x] = placepeaks(micr16_1,maxdexTM1,timemicr16_1,MAX);
[anglem1n regionm1n] = placepeaks(micr16_1,mindexTM1,timemicr16_1,MIN);

subplot(2,3,6), plot(timemicr16_2,micr16_2,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(micr16_2,0.6);
plot(timemicr16_2(maxdexTM2),maxValTM2,'o',timemicr16_2(mindexTM2),minValTM2,'o');
hold off;
title('Roach16 MIC signal 2');
[anglem2x regionm2x] = placepeaks(micr16_2,maxdexTM2,timemicr16_2,MAX);
[anglem2n regionm2n] = placepeaks(micr16_2,mindexTM2,timemicr16_2,MIN);

figure;
[PPIEZO_r16_1 FPIEZO_r16_1] = freq_domain(piezor16_1,fftpt,freq);
[PPIEZO_r16_2 FPIEZO_r16_2] = freq_domain(piezor16_2,fftpt,freq);
[PIR_r16_1 FIR_r16_1] = freq_domain(irr16_1,fftpt,freq);
[PIR_r16_2 FIR_r16_2] = freq_domain(irr16_2,fftpt,freq);
[PMIC_r16_1 FMIC_r16_1] = freq_domain(micr16_1,fftpt,freq);
[PMIC_r16_2 FMIC_r16_2] = freq_domain(micr16_2,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_r16_1, PPIEZO_r16_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r16_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r16_1(indexFP1),maxValFP1,'o');
hold off;
title('Roach16 PIEZO Frequencies 1');
subplot(2,3,2), plot(FPIEZO_r16_2, PPIEZO_r16_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r16_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r16_2(indexFP2),maxValFP2,'o');
hold off;
title('Roach16 PIEZO Frequencies 2');
subplot(2,3,3), plot(FIR_r16_1, PIR_r16_1(12:((fftpt/2)+11)),'g');
title('Roach16 IR Frequencies 1');
subplot(2,3,4), plot(FIR_r16_2, PIR_r16_2(12:((fftpt/2)+11)),'g');
title('Roach16 IR Frequencies 2');
subplot(2,3,5), plot(FMIC_r16_1, PMIC_r16_1(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r16_1(12:((fftpt/2)+11)),0.4);
plot(FMIC_r16_1(indexFM1),maxValFM1,'o');
hold off;
title('Roach16 MIC Frequencies 1');
subplot(2,3,6), plot(FMIC_r16_2, PMIC_r16_2(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_r16_2(12:((fftpt/2)+11)),0.4);
plot(FMIC_r16_2(indexFM2),maxValFM2,'o');
hold off;
title('Roach16 MIC Frequencies 2');

figure;
barplot_piezo = [sum(abs(piezor16_1)) length(piezor16_1); sum(abs(piezor16_2)) length(piezor16_2)];
barplot_ir = [sum(abs(irr16_1)) length(irr16_1); sum(abs(irr16_2)) length(irr16_2)];
barplot_mic = [sum(abs(micr16_1)) length(micr16_1); sum(abs(micr16_2)) length(micr16_2)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 16 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 16 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 16 sum|width');

figure;
var = runEnvelope(piezor16_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach16 Piezo 1 Envelope');
var = runEnvelope(piezor16_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach16 Piezo 2 Envelope');
var = runEnvelope(micr16_1);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach16 MIC 1 Envelope');
var = runEnvelope(micr16_2);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,4), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach16 MIC 2 Envelope');

timepiezor1x = timepiezor16_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor16_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor16_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor16_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timemicr1x = timemicr16_1(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr16_1(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
timemicr2x = timemicr16_2(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemicr2n = timemicr16_2(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
FPIEZO_r16_1 = FPIEZO_r16_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r16_2 = FPIEZO_r16_2(indexFP2)';
maxValFP2 = maxValFP2';
FMIC_r16_1 = FMIC_r16_1(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_r16_2 = FMIC_r16_2(indexFM2)';
maxValFM2 = maxValFM2';

% save('Roach16data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'timemicr2x','maxValTM2','anglem2x','regionm2x','timemicr2n','minValTM2','anglem2n','regionm2n',...
%                      'FPIEZO_r16_1','maxValFP1','FPIEZO_r16_2','maxValFP2','FMIC_r16_1','maxValFM1','FMIC_r16_2','maxValFM2',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1','areaEM2');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x))/(length(anglep1x)+length(anglep2x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x))/(length(regionp1x)+length(regionp2x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n))/(length(anglep1n)+length(anglep2n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n))/(length(regionp1n)+length(regionp2n));
numfreqpeaksP = length(FPIEZO_r16_1)+length(FPIEZO_r16_2);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(maxValFP1),max(maxValFP2));
maxfreqvalP = max(max(FPIEZO_r16_1),max(FPIEZO_r16_2));
minfreqpeakvalP = min(min(maxValFP1),min(maxValFP2));
minfreqvalP = min(min(FPIEZO_r16_1),min(FPIEZO_r16_2));
avgtimeenvelopeareaP = (areaEP1+areaEP2)/2;
avgtricorrP = (p1tri+p2tri)/2;
avggausscorrP = (p1gauss+p2gauss)/2;

numtimemaxpeaksM = length(maxValTM1)+length(maxValTM2);
avgtimemaxpeakvalM = (sum(maxValTM1)+sum(maxValTM2))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x)+sum(anglem2x))/(length(anglem1x)+length(anglem2x));
avgtimemaxpeakareaM = (sum(regionm1x)+sum(regionm2x))/(length(regionm1x)+length(regionm2x));
numtimeminpeaksM = length(minValTM1)+length(minValTM2);
avgtimeminpeakvalM = (sum(minValTM1)+sum(minValTM2))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n)+sum(anglem2n))/(length(anglem1n)+length(anglem2n));
avgtimeminpeakareaM = (sum(regionm1n)+sum(regionm2n))/(length(regionm1n)+length(regionm2n));
numfreqpeaksM = length(FMIC_r16_1)+length(FMIC_r16_2);
avgfreqpeakvalM = (sum(maxValFM1')+sum(maxValFM2')/numfreqpeaksM);
maxfreqpeakvalM = (max(max(maxValFM1),max(maxValFM2)));
maxfreqvalM = (max(max(FMIC_r16_1),max(FMIC_r16_2)));
minfreqpeakvalM = (min(min(maxValFM1),min(maxValFM2)));
minfreqvalM = (min(min(FMIC_r16_1),min(FMIC_r16_2)));
avgtimeenvelopeareaM = (areaEM1+areaEM2)/2;
avgtricorrM = (m1tri+m2tri)/2;
avggausscorrM = (m1gauss+m2gauss)/2;

save('Roach16data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');
  