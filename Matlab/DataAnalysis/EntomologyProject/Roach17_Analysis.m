function Roach17_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;


[piezo ir mic] = time_domain('roach17.mat',micCol);
piezor17_1 = window(piezo,40,190);
piezor17_2 = window(piezo,4930,5190);
piezor17_3 = window(piezo,6190,6400);
piezor17_4 = window(piezo,12495,12670);
irr17_1 = window(ir,430,1200);
irr17_2 = window(ir,4300,4600);
irr17_3 = window(ir,6325,6800);
irr17_4 = window(ir,12135,12360);
micr17_1 = window(mic,340,760);
micr17_2 = window(mic,4370,4510);
micr17_3 = window(mic,4760,4910);
micr17_4 = window(mic,6390,6530);
timepiezor17_1 = timeaxis(piezor17_1,freq);
timepiezor17_2 = timeaxis(piezor17_2,freq);
timepiezor17_3 = timeaxis(piezor17_3,freq);
timepiezor17_4 = timeaxis(piezor17_4,freq);
timeirr17_1 = timeaxis(irr17_1,freq);
timeirr17_2 = timeaxis(irr17_2,freq);
timeirr17_3 = timeaxis(irr17_3,freq);
timeirr17_4 = timeaxis(irr17_4,freq);
timemicr17_1 = timeaxis(micr17_1,freq);
timemicr17_2 = timeaxis(micr17_2,freq);
timemicr17_3 = timeaxis(micr17_3,freq);
timemicr17_4 = timeaxis(micr17_4,freq);

figure;
subplot(3,4,1), plot(timepiezor17_1,piezor17_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor17_1,0.6);
plot(timepiezor17_1(maxdexTP1),maxValTP1,'o',timepiezor17_1(mindexTP1),minValTP1,'o');
hold off;
title('Roach17 PIEZO signal 1');
[anglep1x regionp1x] = placepeaks(piezor17_1,maxdexTP1,timepiezor17_1,MAX);
[anglep1n regionp1n] = placepeaks(piezor17_1,mindexTP1,timepiezor17_1,MIN);

subplot(3,4,2), plot(timepiezor17_2,piezor17_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor17_2,0.6);
plot(timepiezor17_2(maxdexTP2),maxValTP2,'o',timepiezor17_2(mindexTP2),minValTP2,'o');
hold off;
title('Roach17 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezor17_2,maxdexTP2,timepiezor17_2,MAX);
[anglep2n regionp2n] = placepeaks(piezor17_2,mindexTP2,timepiezor17_2,MIN);

subplot(3,4,3), plot(timepiezor17_3,piezor17_3,'r');
hold on;
[maxdexTP3 maxValTP3 mindexTP3 minValTP3]=signalPeaks(piezor17_3,0.6);
plot(timepiezor17_3(maxdexTP3),maxValTP3,'o',timepiezor17_3(mindexTP3),minValTP3,'o');
hold off;
title('Roach17 PIEZO signal 3');
[anglep3x regionp3x] = placepeaks(piezor17_3,maxdexTP3,timepiezor17_3,MAX);
[anglep3n regionp3n] = placepeaks(piezor17_3,mindexTP3,timepiezor17_3,MIN);

subplot(3,4,4), plot(timepiezor17_4,piezor17_4,'r');
hold on;
[maxdexTP4 maxValTP4 mindexTP4 minValTP4]=signalPeaks(piezor17_4,0.6);
plot(timepiezor17_4(maxdexTP4),maxValTP4,'o',timepiezor17_4(mindexTP4),minValTP4,'o');
hold off;
title('Roach17 PIEZO signal 4');
[anglep4x regionp4x] = placepeaks(piezor17_4,maxdexTP4,timepiezor17_4,MAX);
[anglep4n regionp4n] = placepeaks(piezor17_4,mindexTP4,timepiezor17_4,MIN);

subplot(3,4,5), plot(timeirr17_1,irr17_1,'g');
title('Roach17 IR signal 1');
subplot(3,4,6), plot(timeirr17_2,irr17_2,'g');
title('Roach17 IR signal 2');
subplot(3,4,7), plot(timeirr17_3,irr17_3,'g');
title('Roach17 IR signal 3');
subplot(3,4,8), plot(timeirr17_4,irr17_4,'g');
title('Roach17 IR signal 4');

subplot(3,4,9), plot(timemicr17_1,micr17_1,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr17_1,0.6);
plot(timemicr17_1(maxdexTM1),maxValTM1,'o',timemicr17_1(mindexTM1),minValTM1,'o');
hold off;
title('Roach17 MIC signal 1');
[anglem1x regionm1x] = placepeaks(micr17_1,maxdexTM1,timemicr17_1,MAX);
[anglem1n regionm1n] = placepeaks(micr17_1,mindexTM1,timemicr17_1,MIN);

subplot(3,4,10), plot(timemicr17_2,micr17_2,'b');
hold on;
[maxdexTM2 maxValTM2 mindexTM2 minValTM2]=signalPeaks(micr17_2,0.6);
plot(timemicr17_2(maxdexTM2),maxValTM2,'o',timemicr17_2(mindexTM2),minValTM2,'o');
hold off;
title('Roach17 MIC signal 2');
[anglem2x regionm2x] = placepeaks(micr17_2,maxdexTM2,timemicr17_2,MAX);
[anglem2n regionm2n] = placepeaks(micr17_2,mindexTM2,timemicr17_2,MIN);

subplot(3,4,11), plot(timemicr17_3,micr17_3,'b');
hold on;
[maxdexTM3 maxValTM3 mindexTM3 minValTM3]=signalPeaks(micr17_3,0.6);
plot(timemicr17_3(maxdexTM3),maxValTM3,'o',timemicr17_3(mindexTM3),minValTM3,'o');
hold off;
title('Roach17 MIC signal 3');
[anglem3x regionm3x] = placepeaks(micr17_3,maxdexTM3,timemicr17_3,MAX);
[anglem3n regionm3n] = placepeaks(micr17_3,mindexTM3,timemicr17_3,MIN);

subplot(3,4,12), plot(timemicr17_4,micr17_4,'b');
hold on;
[maxdexTM4 maxValTM4 mindexTM4 minValTM4]=signalPeaks(micr17_4,0.6);
plot(timemicr17_4(maxdexTM4),maxValTM4,'o',timemicr17_4(mindexTM4),minValTM4,'o');
hold off;
title('Roach17 MIC signal 4');
[anglem4x regionm4x] = placepeaks(micr17_4,maxdexTM4,timemicr17_4,MAX);
[anglem4n regionm4n] = placepeaks(micr17_4,mindexTM4,timemicr17_4,MIN);

figure;
[PPIEZO_r17_1 FPIEZO_r17_1] = freq_domain(piezor17_1,fftpt,freq);
[PPIEZO_r17_2 FPIEZO_r17_2] = freq_domain(piezor17_2,fftpt,freq);
[PPIEZO_r17_3 FPIEZO_r17_3] = freq_domain(piezor17_3,fftpt,freq);
[PPIEZO_r17_4 FPIEZO_r17_4] = freq_domain(piezor17_4,fftpt,freq);
[PIR_r17_1 FIR_r17_1] = freq_domain(irr17_1,fftpt,freq);
[PIR_r17_2 FIR_r17_2] = freq_domain(irr17_2,fftpt,freq);
[PIR_r17_3 FIR_r17_3] = freq_domain(irr17_3,fftpt,freq);
[PIR_r17_4 FIR_r17_4] = freq_domain(irr17_4,fftpt,freq);
[PMIC_r17_1 FMIC_r17_1] = freq_domain(micr17_1,fftpt,freq);
[PMIC_r17_2 FMIC_r17_2] = freq_domain(micr17_2,fftpt,freq);
[PMIC_r17_3 FMIC_r17_3] = freq_domain(micr17_3,fftpt,freq);
[PMIC_r17_4 FMIC_r17_4] = freq_domain(micr17_4,fftpt,freq);
subplot(3,4,1), plot(FPIEZO_r17_1, PPIEZO_r17_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r17_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r17_1(indexFP1),maxValFP1,'o');
hold off;
title('Roach17 PIEZO Frequencies 1');
subplot(3,4,2), plot(FPIEZO_r17_2, PPIEZO_r17_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r17_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r17_2(indexFP2),maxValFP2,'o');
hold off;
title('Roach17 PIEZO Frequencies 2');
subplot(3,4,3), plot(FPIEZO_r17_3, PPIEZO_r17_3(12:((fftpt/2)+11)),'r');
hold on;
[indexFP3 maxValFP3 del ete]=signalPeaks(PPIEZO_r17_3(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r17_3(indexFP3),maxValFP3,'o');
hold off;
title('Roach17 PIEZO Frequencies 3');
subplot(3,4,4), plot(FPIEZO_r17_4, PPIEZO_r17_4(12:((fftpt/2)+11)),'r');
hold on;
[indexFP4 maxValFP4 del ete]=signalPeaks(PPIEZO_r17_4(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r17_4(indexFP4),maxValFP4,'o');
hold off;
title('Roach17 PIEZO Frequencies 4');
subplot(3,4,5), plot(FIR_r17_1, PIR_r17_1(12:((fftpt/2)+11)),'g');
title('Roach17 IR Frequencies 1');
subplot(3,4,6), plot(FIR_r17_2, PIR_r17_2(12:((fftpt/2)+11)),'g');
title('Roach17 IR Frequencies 2');
subplot(3,4,7), plot(FIR_r17_3, PIR_r17_3(12:((fftpt/2)+11)),'g');
title('Roach17 IR Frequencies 3');
subplot(3,4,8), plot(FIR_r17_4, PIR_r17_4(12:((fftpt/2)+11)),'g');
title('Roach17 IR Frequencies 4');
subplot(3,4,9), plot(FMIC_r17_1, PMIC_r17_1(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r17_1(12:((fftpt/2)+11)),0.4);
plot(FMIC_r17_1(indexFM1),maxValFM1,'o');
hold off;
title('Roach17 MIC Frequencies 1');
subplot(3,4,10), plot(FMIC_r17_2, PMIC_r17_2(12:((fftpt/2)+11)),'b');
hold on;
[indexFM2 maxValFM2 del ete]=signalPeaks(PMIC_r17_2(12:((fftpt/2)+11)),0.4);
plot(FMIC_r17_2(indexFM2),maxValFM2,'o');
hold off;
title('Roach17 MIC Frequencies 2');
subplot(3,4,11), plot(FMIC_r17_3, PMIC_r17_3(12:((fftpt/2)+11)),'b');
hold on;
[indexFM3 maxValFM3 del ete]=signalPeaks(PMIC_r17_3(12:((fftpt/2)+11)),0.4);
plot(FMIC_r17_3(indexFM3),maxValFM3,'o');
hold off;
title('Roach17 MIC Frequencies 3');
subplot(3,4,12), plot(FMIC_r17_4, PMIC_r17_4(12:((fftpt/2)+11)),'b');
hold on;
[indexFM4 maxValFM4 del ete]=signalPeaks(PMIC_r17_4(12:((fftpt/2)+11)),0.4);
plot(FMIC_r17_4(indexFM4),maxValFM4,'o');
hold off;
title('Roach17 MIC Frequencies 4');

figure;
barplot_piezo = [sum(abs(piezor17_1)) length(piezor17_1); sum(abs(piezor17_2)) length(piezor17_2); sum(abs(piezor17_3)) length(piezor17_3); sum(abs(piezor17_4)) length(piezor17_4)];
barplot_ir = [sum(abs(irr17_1)) length(irr17_1); sum(abs(irr17_2)) length(irr17_2); sum(abs(irr17_3)) length(irr17_3); sum(abs(irr17_4)) length(irr17_4)];
barplot_mic = [sum(abs(micr17_1)) length(micr17_1); sum(abs(micr17_2)) length(micr17_2); sum(abs(micr17_3)) length(micr17_3); sum(abs(micr17_4)) length(micr17_4)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 17 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 17 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 17 sum|width');

figure;
var = runEnvelope(piezor17_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach17 Piezo 1 Envelope');
var = runEnvelope(piezor17_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach17 Piezo 2 Envelope');
var = runEnvelope(piezor17_3);
[p3tri p3gauss] = getcorrn(var.out(2,:));
areaEP3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach17 Piezo 3 Envelope');
var = runEnvelope(piezor17_4);
[p4tri p4gauss] = getcorrn(var.out(2,:));
areaEP4 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,4), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach17 Piezo 4 Envelope');
var = runEnvelope(micr17_1);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,5), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach17 MIC 1 Envelope');
var = runEnvelope(micr17_2);
[m2tri m2gauss] = getcorrn(var.out(2,:));
areaEM2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,6), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach17 MIC 2 Envelope');
var = runEnvelope(micr17_3);
[m3tri m3gauss] = getcorrn(var.out(2,:));
areaEM3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,7), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach17 MIC 3 Envelope');
var = runEnvelope(micr17_4);
[m4tri m4gauss] = getcorrn(var.out(2,:));
areaEM4 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,4,8), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach17 MIC 4 Envelope');

timepiezor1x = timepiezor17_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor17_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor17_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor17_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timepiezor3x = timepiezor17_3(maxdexTP3)';
maxValTP3 = maxValTP3'; 
anglep3x = anglep3x'; 
regionp3x = regionp3x'; 
timepiezor3n = timepiezor17_3(mindexTP3)';
minValTP3 = minValTP3'; 
anglep3n = anglep3n'; 
regionp3n = regionp3n';
timepiezor4x = timepiezor17_4(maxdexTP4)';
maxValTP4 = maxValTP4'; 
anglep4x = anglep4x'; 
regionp4x = regionp4x'; 
timepiezor4n = timepiezor17_4(mindexTP4)';
minValTP4 = minValTP4'; 
anglep4n = anglep4n'; 
regionp4n = regionp4n';
timemicr1x = timemicr17_1(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr17_1(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
timemicr2x = timemicr17_2(maxdexTM2)';
maxValTM2 = maxValTM2';
anglem2x = anglem2x';
regionm2x = regionm2x';
timemicr2n = timemicr17_2(mindexTM2)';
minValTM2 = minValTM2';
anglem2n = anglem2n';
regionm2n = regionm2n';
timemicr3x = timemicr17_3(maxdexTM3)';
maxValTM3 = maxValTM3';
anglem3x = anglem3x';
regionm3x = regionm3x';
timemicr3n = timemicr17_3(mindexTM3)';
minValTM1 = minValTM3';
anglem3n = anglem3n';
regionm3n = regionm3n';
timemicr4x = timemicr17_4(maxdexTM4)';
maxValTM4 = maxValTM4';
anglem4x = anglem4x';
regionm4x = regionm4x';
timemicr4n = timemicr17_4(mindexTM4)';
minValTM4 = minValTM4';
anglem4n = anglem4n';
regionm4n = regionm4n';
FPIEZO_r17_1 = FPIEZO_r17_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r17_2 = FPIEZO_r17_2(indexFP2)';
maxValFP2 = maxValFP2';
FPIEZO_r17_3 = FPIEZO_r17_3(indexFP3)';
maxValFP3 = maxValFP3';
FPIEZO_r17_4 = FPIEZO_r17_4(indexFP4)';
maxValFP4 = maxValFP4';
FMIC_r17_1 = FMIC_r17_1(indexFM1)';
maxValFM1 = maxValFM1';
FMIC_r17_2 = FMIC_r17_2(indexFM2)';
maxValFM2 = maxValFM2';
FMIC_r17_3 = FMIC_r17_3(indexFM3)';
maxValFM3 = maxValFM3';
FMIC_r17_4 = FMIC_r17_4(indexFM4)';
maxValFM4 = maxValFM4';

% save('Roach17data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timepiezor3x','maxValTP3','anglep3x','regionp3x','timepiezor3n','minValTP3','anglep3n','regionp3n',...
%                      'timepiezor4x','maxValTP4','anglep4x','regionp4x','timepiezor4n','minValTP4','anglep4n','regionp4n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'timemicr2x','maxValTM2','anglem2x','regionm2x','timemicr2n','minValTM2','anglem2n','regionm2n',...
%                      'timemicr3x','maxValTM3','anglem3x','regionm3x','timemicr3n','minValTM3','anglem3n','regionm3n',...
%                      'timemicr4x','maxValTM4','anglem4x','regionm4x','timemicr4n','minValTM4','anglem4n','regionm4n',...
%                      'FPIEZO_r17_1','maxValFP1','FPIEZO_r17_2','maxValFP2','FPIEZO_r17_3','maxValFP3','FPIEZO_r17_4','maxValFP4',...
%                      'FMIC_r17_1','maxValFM1','FMIC_r17_2','maxValFM2','FMIC_r17_3','maxValFM3','FMIC_r17_4','maxValFM4',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEP3','areaEP4','areaEM1','areaEM2','areaEM3','areaEM4');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2)+length(maxValTP3)+length(maxValTP4);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2)+sum(maxValTP3)+sum(maxValTP4))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x)+sum(anglep3x)+sum(anglep4x))/(length(anglep1x)+length(anglep2x)+length(anglep3x)+length(anglep4x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x)+sum(regionp3x)+sum(regionp4x))/(length(regionp1x)+length(regionp2x)+length(regionp3x)+length(regionp4x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2)+length(minValTP3)+length(minValTP4);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2)+sum(minValTP3)+sum(minValTP4))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n)+sum(anglep3n)+sum(anglep4n))/(length(anglep1n)+length(anglep2n)+length(anglep3n)+length(anglep4n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n)+sum(regionp3n)+sum(regionp4n))/(length(regionp1n)+length(regionp2n)+length(regionp3n)+length(regionp4n));
numfreqpeaksP = length(FPIEZO_r17_1)+length(FPIEZO_r17_2)+length(FPIEZO_r17_3)+length(FPIEZO_r17_4);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2')+sum(maxValFP3')+sum(maxValFP4'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(max(maxValFP1),max(maxValFP2)),max(max(maxValFP3),max(maxValFP4)));
maxfreqvalP = max(max(max(FPIEZO_r17_1),max(FPIEZO_r17_2)),max(max(FPIEZO_r17_3),max(FPIEZO_r17_4)));
minfreqpeakvalP = min(min(min(maxValFP1),min(maxValFP2)),min(min(maxValFP3),min(maxValFP4)));
minfreqvalP = min(min(min(FPIEZO_r17_1),min(FPIEZO_r17_2)),min(min(FPIEZO_r17_3),min(FPIEZO_r17_4)));
avgtimeenvelopeareaP = (areaEP1+areaEP2+areaEP3+areaEP4)/4;
avgtricorrP = (p1tri+p2tri+p3tri+p4tri)/4;
avggausscorrP = (p1gauss+p2gauss+p3gauss+p4gauss)/4;

numtimemaxpeaksM = length(maxValTM1)+length(maxValTM2)+length(maxValTM3)+length(maxValTM4);
avgtimemaxpeakvalM = (sum(maxValTM1)+sum(maxValTM2)+sum(maxValTM3)+sum(maxValTM4))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x)+sum(anglem2x)+sum(anglem3x)+sum(anglem4x))/(length(anglem1x)+length(anglem2x)+length(anglem3x)+length(anglem4x));
avgtimemaxpeakareaM = (sum(regionm1x)+sum(regionm2x)+sum(regionm3x)+sum(regionm4x))/(length(regionm1x)+length(regionm2x)+length(regionm3x)+length(regionm4x));
numtimeminpeaksM = length(minValTM1)+length(minValTM2)+length(minValTM3)+length(minValTM4);
avgtimeminpeakvalM = (sum(minValTM1)+sum(minValTM2)+sum(minValTM3)+sum(minValTM4))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n)+sum(anglem2n)+sum(anglem3n)+sum(anglem4n))/(length(anglem1n)+length(anglem2n)+length(anglem3n)+length(anglem4n));
avgtimeminpeakareaM = (sum(regionm1n)+sum(regionm2n)+sum(regionm3n)+sum(regionm4n))/(length(regionm1n)+length(regionm2n)+length(regionm3n)+length(regionm4n));
numfreqpeaksM = length(FMIC_r17_1)+length(FMIC_r17_2)+length(FMIC_r17_3)+length(FMIC_r17_4);
avgfreqpeakvalM = (sum(maxValFM1')+sum(maxValFM2')+sum(maxValFM3')+sum(maxValFM4')/numfreqpeaksM);
maxfreqpeakvalM = max(max(max(maxValFM1),max(maxValFM2)),max(max(maxValFM3),max(maxValFM4)));
maxfreqvalM = max(max(max(FMIC_r17_1),max(FMIC_r17_2)),max(max(FMIC_r17_3),max(FMIC_r17_4)));
minfreqpeakvalM = min(min(min(maxValFM1),min(maxValFM2)),min(min(maxValFM3),min(maxValFM4)));
minfreqvalM = min(min(min(FMIC_r17_1),min(FMIC_r17_2)),min(min(FMIC_r17_3),min(FMIC_r17_4)));
avgtimeenvelopeareaM = (areaEM1+areaEM2+areaEM3+areaEM4)/4;
avgtricorrM = (m1tri+m2tri+m3tri+m4tri)/4;
avggausscorrM = (m1gauss+m2gauss+m3gauss+m4gauss)/4;

save('Roach17data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');