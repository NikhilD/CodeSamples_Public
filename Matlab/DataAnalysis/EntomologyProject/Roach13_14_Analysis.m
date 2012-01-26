function Roach13_14_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;


[piezo ir mic] = time_domain('roach13.mat',micCol);
piezor13 = window(piezo,3000,3500);
irr13 = window(ir,150,500);
micr13 = window(mic,2900,3040);
timepiezor13 = timeaxis(piezor13,freq);
timeirr13 = timeaxis(irr13,freq);
timemicr13 = timeaxis(micr13,freq);

figure;
subplot(2,3,1), plot(timepiezor13,piezor13,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor13,0.6);
plot(timepiezor13(maxdexTP1),maxValTP1,'o',timepiezor13(mindexTP1),minValTP1,'o');
hold off;
[anglep1x regionp1x] = placepeaks(piezor13,maxdexTP1,timepiezor13,MAX);
[anglep1n regionp1n] = placepeaks(piezor13,mindexTP1,timepiezor13,MIN);

subplot(2,3,2), plot(timeirr13,irr13,'g');
title('Roach13 IR signal');

subplot(2,3,3), plot(timemicr13,micr13,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr13,0.6);
plot(timemicr13(maxdexTM1),maxValTM1,'o',timemicr13(mindexTM1),minValTM1,'o');
hold off;
title('Roach13 MIC signal');
[anglem1x regionm1x] = placepeaks(micr13,maxdexTM1,timemicr13,MAX);
[anglem1n regionm1n] = placepeaks(micr13,mindexTM1,timemicr13,MIN);

[piezo ir mic] = time_domain('roach14.mat',micCol);
irr14 = window(ir,1,550);
micr14 = window(mic,1,350);
timeirr14 = timeaxis(irr14,freq);
timemicr14 = timeaxis(micr14,freq);

subplot(2,3,4), plot(timeirr14,irr14,'g');
title('Roach14 IR signal');

subplot(2,3,5), plot(timemicr14,micr14,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(micr14,0.6);
plot(timemicr14(maxdexTM2),maxValTM2,'o',timemicr14(mindexTM2),minValTM2,'o');
hold off;
title('Roach10 MIC signal');
[anglem2x regionm2x] = placepeaks(micr14,maxdexTM2,timemicr14,MAX);
[anglem2n regionm2n] = placepeaks(micr14,mindexTM2,timemicr14,MIN);


figure;
[PPIEZO_r13 FPIEZO_r13] = freq_domain(piezor13,fftpt,freq);
[PIR_r13 FIR_r13] = freq_domain(irr13,fftpt,freq);
[PMIC_r13 FMIC_r13] = freq_domain(micr13,fftpt,freq);

subplot(2,3,1), plot(FPIEZO_r13, PPIEZO_r13(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r13(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r13(indexFP1),maxValFP1,'o');
hold off;
title('Roach13 PIEZO Frequencies');
subplot(2,3,2), plot(FIR_r13, PIR_r13(12:((fftpt/2)+11)),'g');
title('Roach13 IR Frequencies');
subplot(2,3,3), plot(FMIC_r13, PMIC_r13(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r13(12:((fftpt/2)+11)),0.4);
plot(FMIC_r13(indexFM1),maxValFM1,'o');
hold off;
title('Roach13 MIC Frequencies');

[PIR_r14 FIR_r14] = freq_domain(irr14,fftpt,freq);
[PMIC_r14 FMIC_r14] = freq_domain(micr14,fftpt,freq);
subplot(2,3,4), plot(FIR_r14, PIR_r14(12:((fftpt/2)+11)),'g');
title('Roach14 IR Frequencies');
subplot(2,3,5), plot(FMIC_r14, PMIC_r14(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_r14(12:((fftpt/2)+11)),0.4);
plot(FMIC_r14(indexFM2),maxValFM2,'o');
hold off;
title('Roach14 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezor13)) length(piezor13)];
barplot_ir = [sum(abs(irr13)) length(abs(irr13)); sum(abs(irr14)) length(irr14)];
barplot_mic = [sum(abs(micr13)) length(micr13); sum(abs(micr14)) length(micr14)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 13 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 13&14 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 13&14 sum|width');

figure;
var = runEnvelope(piezor13);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach13 Piezo Envelope');
var = runEnvelope(micr13);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach13 MIC Envelope');
var = runEnvelope(micr14);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach14 MIC Envelope');

timepiezor1x = timepiezor13(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor13(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timemicr1x = timemicr13(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr13(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
timemicr2x = timemicr14(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemicr2n = timemicr14(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
FPIEZO_r13 = FPIEZO_r13(indexFP1)';
maxValFP1 = maxValFP1';
FMIC_r13 = FMIC_r13(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_r14 = FMIC_r14(indexFM2)';
maxValFM2 = maxValFM2';

% save('Roach13_14data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'timemicr2x','maxValTM2','anglem2x','regionm2x','timemicr2n','minValTM2','anglem2n','regionm2n',...
%                      'FPIEZO_r13','maxValFP1','FMIC_r13','maxValFM1','FMIC_r14','maxValFM2',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEM1','areaEM2');

numtimemaxpeaksP13 = length(maxValTP1);
avgtimemaxpeakvalP13 = (sum(maxValTP1))/numtimemaxpeaksP13;
avgtimemaxpeakangleP13 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP13 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP13 = length(minValTP1);
avgtimeminpeakvalP13 = (sum(minValTP1))/numtimeminpeaksP13;
avgtimeminpeakangleP13 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP13 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP13 = length(FPIEZO_r13);
avgfreqpeakvalP13 = (sum(maxValFP1'))/numfreqpeaksP13;
maxfreqpeakvalP13 = max(maxValFP1);
maxfreqvalP13 = (max(FPIEZO_r13));
minfreqpeakvalP13 = (min(maxValFP1));
minfreqvalP13 = (min(FPIEZO_r13));
avgtimeenvelopeareaP13 = areaEP1;
avgtricorrP13 = (p1tri);
avggausscorrP13 = (p1gauss);

numtimemaxpeaksM13 = length(maxValTM1);
avgtimemaxpeakvalM13 = (sum(maxValTM1))/numtimemaxpeaksM13;
avgtimemaxpeakangleM13 = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM13 = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM13 = length(minValTM1);
avgtimeminpeakvalM13 = (sum(minValTM1))/numtimeminpeaksM13;
avgtimeminpeakangleM13 = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM13 = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM13 = length(FMIC_r13);
avgfreqpeakvalM13 = (sum(maxValFM1')/numfreqpeaksM13);
maxfreqpeakvalM13 = max(maxValFM1);
maxfreqvalM13 = max(FMIC_r13);
minfreqpeakvalM13 = min(maxValFM1);
minfreqvalM13 = min(FMIC_r13);
avgtimeenvelopeareaM13 = (areaEM1);
avgtricorrM13 = (m1tri);
avggausscorrM13 = (m1gauss);

numtimemaxpeaksM14 = length(maxValTM2);
avgtimemaxpeakvalM14 = (sum(maxValTM2))/numtimemaxpeaksM14;
avgtimemaxpeakangleM14 = (sum(anglem2x))/(length(anglem2x));
avgtimemaxpeakareaM14 = (sum(regionm2x))/(length(regionm2x));
numtimeminpeaksM14 = length(minValTM2);
avgtimeminpeakvalM14 = (sum(minValTM2))/numtimeminpeaksM14;
avgtimeminpeakangleM14 = (sum(anglem2n))/(length(anglem2n));
avgtimeminpeakareaM14 = (sum(regionm2n))/(length(regionm2n));
numfreqpeaksM14 = length(FMIC_r14);
avgfreqpeakvalM14 = (sum(maxValFM2')/numfreqpeaksM14);
maxfreqpeakvalM14 = max(maxValFM2);
maxfreqvalM14 = max(FMIC_r14);
minfreqpeakvalM14 = min(maxValFM2);
minfreqvalM14 = min(FMIC_r14);
avgtimeenvelopeareaM14 = (areaEM2);
avgtricorrM14 = (m2tri);
avggausscorrM14 = (m2gauss);

save('Roach13_14data.mat','numtimemaxpeaksP13','avgtimemaxpeakvalP13','avgtimemaxpeakangleP13','avgtimemaxpeakareaP13',...
      'numtimeminpeaksP13','avgtimeminpeakvalP13','avgtimeminpeakangleP13','avgtimeminpeakareaP13',...
      'numfreqpeaksP13','avgfreqpeakvalP13','maxfreqpeakvalP13','maxfreqvalP13','minfreqpeakvalP13','minfreqvalP13','avgtimeenvelopeareaP13',...
      'avgtricorrP13','avggausscorrP13',...
      'numtimemaxpeaksM13','avgtimemaxpeakvalM13','avgtimemaxpeakangleM13','avgtimemaxpeakareaM13',...
      'numtimeminpeaksM13','avgtimeminpeakvalM13','avgtimeminpeakangleM13','avgtimeminpeakareaM13',...
      'numfreqpeaksM13','avgfreqpeakvalM13','maxfreqpeakvalM13','maxfreqvalM13','minfreqpeakvalM13','minfreqvalM13','avgtimeenvelopeareaM13',...
      'avgtricorrM13','avggausscorrM13',...
      'numtimemaxpeaksM14','avgtimemaxpeakvalM14','avgtimemaxpeakangleM14','avgtimemaxpeakareaM14',...
      'numtimeminpeaksM14','avgtimeminpeakvalM14','avgtimeminpeakangleM14','avgtimeminpeakareaM14',...
      'numfreqpeaksM14','avgfreqpeakvalM14','maxfreqpeakvalM14','maxfreqvalM14','minfreqpeakvalM14','minfreqvalM14','avgtimeenvelopeareaM14',...
      'avgtricorrM14','avggausscorrM14');
  
