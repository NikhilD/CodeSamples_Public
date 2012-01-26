function Roach11_12_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;


[piezo ir mic] = time_domain('roach11.mat',micCol);
piezor11 = window(piezo,680,910);
irr11 = window(ir,1,660);
micr11 = window(mic,510,620);
timepiezor11 = timeaxis(piezor11,freq);
timeirr11 = timeaxis(irr11,freq);
timemicr11 = timeaxis(micr11,freq);

figure;
subplot(2,3,1), plot(timepiezor11,piezor11,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor11,0.6);
plot(timepiezor11(maxdexTP1),maxValTP1,'o',timepiezor11(mindexTP1),minValTP1,'o');
hold off;
title('Roach11 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezor11,maxdexTP1,timepiezor11,MAX);
[anglep1n regionp1n] = placepeaks(piezor11,mindexTP1,timepiezor11,MIN);

subplot(2,3,2), plot(timeirr11,irr11,'g');
title('Roach11 IR signal');

subplot(2,3,3), plot(timemicr11,micr11,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr11,0.6);
plot(timemicr11(maxdexTM1),maxValTM1,'o',timemicr11(mindexTM1),minValTM1,'o');
hold off;
title('Roach11 MIC signal');
[anglem1x regionm1x] = placepeaks(micr11,maxdexTM1,timemicr11,MAX);
[anglem1n regionm1n] = placepeaks(micr11,mindexTM1,timemicr11,MIN);

[piezo ir mic] = time_domain('roach12.mat',micCol);
piezor12 = window(piezo,800,1250);
irr12 = window(ir,380,1020);
micr12 = window(mic,840,990);
timepiezor12 = timeaxis(piezor12,freq);
timeirr12 = timeaxis(irr12,freq);
timemicr12 = timeaxis(micr12,freq);

subplot(2,3,4), plot(timepiezor12,piezor12,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor12,0.6);
plot(timepiezor12(maxdexTP2),maxValTP2,'o',timepiezor12(mindexTP2),minValTP2,'o');
hold off;
title('Roach12 PIEZO signal');
[anglep2x regionp2x] = placepeaks(piezor12,maxdexTP2,timepiezor12,MAX);
[anglep2n regionp2n] = placepeaks(piezor12,mindexTP2,timepiezor12,MIN);

subplot(2,3,5), plot(timeirr12,irr12,'g');
title('Roach12 IR signal');

subplot(2,3,6), plot(timemicr12,micr12,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(micr12,0.6);
plot(timemicr12(maxdexTM2),maxValTM2,'o',timemicr12(mindexTM2),minValTM2,'o');
hold off;
title('Roach12 MIC signal');
[anglem2x regionm2x] = placepeaks(micr12,maxdexTM2,timemicr12,MAX);
[anglem2n regionm2n] = placepeaks(micr12,mindexTM2,timemicr12,MIN);

figure;
[PPIEZO_r11 FPIEZO_r11] = freq_domain(piezor11,fftpt,freq);
[PIR_r11 FIR_r11] = freq_domain(irr11,fftpt,freq);
[PMIC_r11 FMIC_r11] = freq_domain(micr11,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_r11, PPIEZO_r11(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r11(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r11(indexFP1),maxValFP1,'o');
hold off;
title('Roach11 PIEZO Frequencies');
subplot(2,3,2), plot(FIR_r11, PIR_r11(12:((fftpt/2)+11)),'g');
title('Roach11 IR Frequencies');
subplot(2,3,3), plot(FMIC_r11, PMIC_r11(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r11(12:((fftpt/2)+11)),0.4);
plot(FMIC_r11(indexFM1),maxValFM1,'o');
hold off;
title('Roach11 MIC Frequencies');

[PPIEZO_r12 FPIEZO_r12] = freq_domain(piezor12,fftpt,freq);
[PIR_r12 FIR_r12] = freq_domain(irr12,fftpt,freq);
[PMIC_r12 FMIC_r12] = freq_domain(micr12,fftpt,freq);
subplot(2,3,4), plot(FPIEZO_r12, PPIEZO_r12(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r12(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r12(indexFP2),maxValFP2,'o');
hold off;
title('Roach12 PIEZO Frequencies');
subplot(2,3,5), plot(FIR_r12, PIR_r12(12:((fftpt/2)+11)),'g');
title('Roach12 IR Frequencies');
subplot(2,3,6), plot(FMIC_r12, PMIC_r12(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_r12(12:((fftpt/2)+11)),0.4);
plot(FMIC_r12(indexFM2),maxValFM2,'o');
hold off;
title('Roach12 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezor11)) length(piezor11); sum(abs(piezor12)) length(piezor12)];
barplot_ir = [sum(abs(irr11)) length(irr11); sum(abs(irr12)) length(irr12)];
barplot_mic = [sum(abs(micr11)) length(micr11); sum(abs(micr12)) length(micr12)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 11&12 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 11&12 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 11&12 sum|width');

figure;
var = runEnvelope(piezor11);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach11 Piezo Envelope');
var = runEnvelope(micr11);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach11 MIC Envelope');
var = runEnvelope(piezor12);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach12 Piezo Envelope');
var = runEnvelope(micr12);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,4), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach12 MIC Envelope');

timepiezor1x = timepiezor11(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor11(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor12(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor12(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timemicr1x = timemicr11(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr11(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
timemicr2x = timemicr12(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemicr2n = timemicr12(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
FPIEZO_r11 = FPIEZO_r11(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r12 = FPIEZO_r12(indexFP2)';
maxValFP2 = maxValFP2';
FMIC_r11 = FMIC_r11(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_r12 = FMIC_r12(indexFM2)';
maxValFM2 = maxValFM2';

% save('Roach11_12data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'timemicr2x','maxValTM2','anglem2x','regionm2x','timemicr2n','minValTM2','anglem2n','regionm2n',...
%                      'FPIEZO_r11','maxValFP1','FMIC_r11','maxValFM1','FPIEZO_r12','maxValFP2','FMIC_r12','maxValFM2',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1','areaEM2');

numtimemaxpeaksP11 = length(maxValTP1);
avgtimemaxpeakvalP11 = (sum(maxValTP1))/numtimemaxpeaksP11;
avgtimemaxpeakangleP11 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP11 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP11 = length(minValTP1);
avgtimeminpeakvalP11 = (sum(minValTP1))/numtimeminpeaksP11;
avgtimeminpeakangleP11 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP11 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP11 = length(FPIEZO_r11);
avgfreqpeakvalP11 = (sum(maxValFP1'))/numfreqpeaksP11;
maxfreqpeakvalP11 = max(maxValFP1);
maxfreqvalP11 = (max(FPIEZO_r11));
minfreqpeakvalP11 = (min(maxValFP1));
minfreqvalP11 = (min(FPIEZO_r11));
avgtimeenvelopeareaP11 = areaEP1;
avgtricorrP11 = (p1tri);
avggausscorrP11 = (p1gauss);

numtimemaxpeaksP12 = length(maxValTP2);
avgtimemaxpeakvalP12 = (sum(maxValTP2))/numtimemaxpeaksP12;
avgtimemaxpeakangleP12 = (sum(anglep2x))/(length(anglep2x));
avgtimemaxpeakareaP12 = (sum(regionp2x))/(length(regionp2x));
numtimeminpeaksP12 = length(minValTP2);
avgtimeminpeakvalP12 = (sum(minValTP2))/numtimeminpeaksP12;
avgtimeminpeakangleP12 = (sum(anglep2n))/(length(anglep2n));
avgtimeminpeakareaP12 = (sum(regionp2n))/(length(regionp2n));
numfreqpeaksP12 = length(FPIEZO_r12);
avgfreqpeakvalP12 = (sum(maxValFP2'))/numfreqpeaksP12;
maxfreqpeakvalP12 = (max(maxValFP2));
maxfreqvalP12 = (max(FPIEZO_r12));
minfreqpeakvalP12 = (min(maxValFP2));
minfreqvalP12 = (min(FPIEZO_r12));
avgtimeenvelopeareaP12 = areaEP2;
avgtricorrP12 = (p2tri);
avggausscorrP12 = (p2gauss);

numtimemaxpeaksM11 = length(maxValTM1);
avgtimemaxpeakvalM11 = (sum(maxValTM1))/numtimemaxpeaksM11;
avgtimemaxpeakangleM11 = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM11 = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM11 = length(minValTM1);
avgtimeminpeakvalM11 = (sum(minValTM1))/numtimeminpeaksM11;
avgtimeminpeakangleM11 = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM11 = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM11 = length(FMIC_r11);
avgfreqpeakvalM11 = (sum(maxValFM1')/numfreqpeaksM11);
maxfreqpeakvalM11 = max(maxValFM1);
maxfreqvalM11 = max(FMIC_r11);
minfreqpeakvalM11 = min(maxValFM1);
minfreqvalM11 = min(FMIC_r11);
avgtimeenvelopeareaM11 = (areaEM1);
avgtricorrM11 = (m1tri);
avggausscorrM11 = (m1gauss);

numtimemaxpeaksM12 = length(maxValTM2);
avgtimemaxpeakvalM12 = (sum(maxValTM2))/numtimemaxpeaksM12;
avgtimemaxpeakangleM12 = (sum(anglem2x))/(length(anglem2x));
avgtimemaxpeakareaM12 = (sum(regionm2x))/(length(regionm2x));
numtimeminpeaksM12 = length(minValTM2);
avgtimeminpeakvalM12 = (sum(minValTM2))/numtimeminpeaksM12;
avgtimeminpeakangleM12 = (sum(anglem2n))/(length(anglem2n));
avgtimeminpeakareaM12 = (sum(regionm2n))/(length(regionm2n));
numfreqpeaksM12 = length(FMIC_r12);
avgfreqpeakvalM12 = (sum(maxValFM2')/numfreqpeaksM12);
maxfreqpeakvalM12 = max(maxValFM2);
maxfreqvalM12 = max(FMIC_r12);
minfreqpeakvalM12 = min(maxValFM2);
minfreqvalM12 = min(FMIC_r12);
avgtimeenvelopeareaM12 = (areaEM2);
avgtricorrM12 = (m2tri);
avggausscorrM12 = (m2gauss);

save('Roach11_12data.mat','numtimemaxpeaksP11','avgtimemaxpeakvalP11','avgtimemaxpeakangleP11','avgtimemaxpeakareaP11',...
      'numtimeminpeaksP11','avgtimeminpeakvalP11','avgtimeminpeakangleP11','avgtimeminpeakareaP11',...
      'numfreqpeaksP11','avgfreqpeakvalP11','maxfreqpeakvalP11','maxfreqvalP11','minfreqpeakvalP11','minfreqvalP11','avgtimeenvelopeareaP11',...
      'avgtricorrP11','avggausscorrP11',...
      'numtimemaxpeaksP12','avgtimemaxpeakvalP12','avgtimemaxpeakangleP12','avgtimemaxpeakareaP12',...
      'numtimeminpeaksP12','avgtimeminpeakvalP12','avgtimeminpeakangleP12','avgtimeminpeakareaP12',...
      'numfreqpeaksP12','avgfreqpeakvalP12','maxfreqpeakvalP12','maxfreqvalP12','minfreqpeakvalP12','minfreqvalP12','avgtimeenvelopeareaP12',...
      'avgtricorrP12','avggausscorrP12',...
      'numtimemaxpeaksM11','avgtimemaxpeakvalM11','avgtimemaxpeakangleM11','avgtimemaxpeakareaM11',...
      'numtimeminpeaksM11','avgtimeminpeakvalM11','avgtimeminpeakangleM11','avgtimeminpeakareaM11',...
      'numfreqpeaksM11','avgfreqpeakvalM11','maxfreqpeakvalM11','maxfreqvalM11','minfreqpeakvalM11','minfreqvalM11','avgtimeenvelopeareaM11',...
      'avgtricorrM11','avggausscorrM11',...
      'numtimemaxpeaksM12','avgtimemaxpeakvalM12','avgtimemaxpeakangleM12','avgtimemaxpeakareaM12',...
      'numtimeminpeaksM12','avgtimeminpeakvalM12','avgtimeminpeakangleM12','avgtimeminpeakareaM12',...
      'numfreqpeaksM12','avgfreqpeakvalM12','maxfreqpeakvalM12','maxfreqvalM12','minfreqpeakvalM12','minfreqvalM12','avgtimeenvelopeareaM12',...
      'avgtricorrM12','avggausscorrM12');
