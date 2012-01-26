function Roach9_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;

[piezo ir mic] = time_domain('roach9.mat',micCol);
piezor9_1 = window(piezo,1970,2450);
piezor9_2 = window(piezo,4300,4600);
piezor9_3 = window(piezo,5900,6300);
piezor9_4 = window(piezo,11450,11950);
irr9_1 = window(ir,1270,2060);
irr9_2 = window(ir,11950,12670);
micr9 = window(mic,90,130);
timepiezor9_1 = timeaxis(piezor9_1,freq);
timepiezor9_2 = timeaxis(piezor9_2,freq);
timepiezor9_3 = timeaxis(piezor9_3,freq);
timepiezor9_4 = timeaxis(piezor9_4,freq);
timeirr9_1 = timeaxis(irr9_1,freq);
timeirr9_2 = timeaxis(irr9_2,freq);
timemicr9 = timeaxis(micr9,freq);

figure;
subplot(2,4,1), plot(timepiezor9_1,piezor9_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor9_1,0.6);
plot(timepiezor9_1(maxdexTP1),maxValTP1,'o',timepiezor9_1(mindexTP1),minValTP1,'o');
hold off;
title('Roach9 PIEZO signal 1');
[anglep1x regionp1x] = placepeaks(piezor9_1,maxdexTP1,timepiezor9_1,MAX);
[anglep1n regionp1n] = placepeaks(piezor9_1,mindexTP1,timepiezor9_1,MIN);

subplot(2,4,2), plot(timepiezor9_2,piezor9_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor9_2,0.6);
plot(timepiezor9_2(maxdexTP2),maxValTP2,'o',timepiezor9_2(mindexTP2),minValTP2,'o');
hold off;
title('Roach9 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezor9_2,maxdexTP2,timepiezor9_2,MAX);
[anglep2n regionp2n] = placepeaks(piezor9_2,mindexTP2,timepiezor9_2,MIN);

subplot(2,4,3), plot(timepiezor9_3,piezor9_3,'r');
hold on;
[maxdexTP3 maxValTP3 mindexTP3 minValTP3]=signalPeaks(piezor9_3,0.6);
plot(timepiezor9_3(maxdexTP3),maxValTP3,'o',timepiezor9_3(mindexTP3),minValTP3,'o');
hold off;
title('Roach9 PIEZO signal 3');
[anglep3x regionp3x] = placepeaks(piezor9_3,maxdexTP3,timepiezor9_3,MAX);
[anglep3n regionp3n] = placepeaks(piezor9_3,mindexTP3,timepiezor9_3,MIN);

subplot(2,4,4), plot(timepiezor9_4,piezor9_4,'r');
hold on;
[maxdexTP4 maxValTP4 mindexTP4 minValTP4]=signalPeaks(piezor9_4,0.6);
plot(timepiezor9_4(maxdexTP4),maxValTP4,'o',timepiezor9_4(mindexTP4),minValTP4,'o');
hold off;
title('Roach9 PIEZO signal 4');
[anglep4x regionp4x] = placepeaks(piezor9_4,maxdexTP4,timepiezor9_4,MAX);
[anglep4n regionp4n] = placepeaks(piezor9_4,mindexTP4,timepiezor9_4,MIN);

subplot(2,4,5), plot(timeirr9_1,irr9_1,'g');
title('Roach9 IR signal 1');
subplot(2,4,6), plot(timeirr9_2,irr9_2,'g');
title('Roach9 IR signal 2');

subplot(2,4,7), plot(timemicr9,micr9,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr9,0.6);
plot(timemicr9(maxdexTM1),maxValTM1,'o',timemicr9(mindexTM1),minValTM1,'o');
hold off;
title('Roach9 MIC signal');
[anglem1x regionm1x] = placepeaks(micr9,maxdexTM1,timemicr9,MAX);
[anglem1n regionm1n] = placepeaks(micr9,mindexTM1,timemicr9,MIN);

figure;
[PPIEZO_r9_1 FPIEZO_r9_1] = freq_domain(piezor9_1,fftpt,freq);
[PPIEZO_r9_2 FPIEZO_r9_2] = freq_domain(piezor9_2,fftpt,freq);
[PPIEZO_r9_3 FPIEZO_r9_3] = freq_domain(piezor9_3,fftpt,freq);
[PPIEZO_r9_4 FPIEZO_r9_4] = freq_domain(piezor9_4,fftpt,freq);
[PIR_r9_1 FIR_r9_1] = freq_domain(irr9_1,fftpt,freq);
[PIR_r9_2 FIR_r9_2] = freq_domain(irr9_2,fftpt,freq);
[PMIC_r9 FMIC_r9] = freq_domain(micr9,fftpt,freq);
subplot(2,4,1), plot(FPIEZO_r9_1, PPIEZO_r9_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r9_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r9_1(indexFP1),maxValFP1,'o');
hold off;
title('Roach9 PIEZO Frequencies 1');
subplot(2,4,2), plot(FPIEZO_r9_2, PPIEZO_r9_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r9_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r9_2(indexFP2),maxValFP2,'o');
hold off;
title('Roach9 PIEZO Frequencies 2');
subplot(2,4,3), plot(FPIEZO_r9_3, PPIEZO_r9_3(12:((fftpt/2)+11)),'r');
hold on;
[indexFP3 maxValFP3 del ete]=signalPeaks(PPIEZO_r9_3(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r9_3(indexFP3),maxValFP3,'o');
hold off;
title('Roach9 PIEZO Frequencies 3');
subplot(2,4,4), plot(FPIEZO_r9_4, PPIEZO_r9_4(12:((fftpt/2)+11)),'r');
hold on;
[indexFP4 maxValFP4 del ete]=signalPeaks(PPIEZO_r9_4(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r9_4(indexFP4),maxValFP4,'o');
hold off;
title('Roach9 PIEZO Frequencies 4');
subplot(2,4,5), plot(FIR_r9_1, PIR_r9_1(12:((fftpt/2)+11)),'g');
title('Roach9 IR Frequencies 1');
subplot(2,4,6), plot(FIR_r9_2, PIR_r9_2(12:((fftpt/2)+11)),'g');
title('Roach9 IR Frequencies 2');
subplot(2,4,7), plot(FMIC_r9, PMIC_r9(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r9(12:((fftpt/2)+11)),0.4);
plot(FMIC_r9(indexFM1),maxValFM1,'o');
hold off;
title('Roach9 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezor9_1)) length(piezor9_1); sum(abs(piezor9_2)) length(piezor9_2); sum(abs(piezor9_3)) length(piezor9_3); sum(abs(piezor9_4)) length(piezor9_4)];
barplot_ir = [sum(abs(irr9_1)) length(irr9_1); sum(abs(irr9_2)) length(irr9_2)];
barplot_mic = [sum(abs(micr9)) length(micr9)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 9 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 9 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 9 sum|width');

figure;
var = runEnvelope(piezor9_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,3,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach9 Piezo 1 Envelope');
var = runEnvelope(piezor9_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,3,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach9 Piezo 2 Envelope');
var = runEnvelope(piezor9_3);
[p3tri p3gauss] = getcorrn(var.out(2,:));
areaEP3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,3,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach9 Piezo 3 Envelope');
var = runEnvelope(piezor9_4);
[p4tri p4gauss] = getcorrn(var.out(2,:));
areaEP4 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,3,4), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach9 Piezo 4 Envelope');
var = runEnvelope(micr9);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,3,5), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach9 MIC Envelope');

timepiezor1x = timepiezor9_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor9_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor9_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor9_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timepiezor3x = timepiezor9_3(maxdexTP3)';
maxValTP3 = maxValTP3'; 
anglep3x = anglep3x'; 
regionp3x = regionp3x'; 
timepiezor3n = timepiezor9_3(mindexTP3)';
minValTP3 = minValTP3'; 
anglep3n = anglep3n'; 
regionp3n = regionp3n';
timepiezor4x = timepiezor9_4(maxdexTP4)';
maxValTP4 = maxValTP4'; 
anglep4x = anglep4x'; 
regionp4x = regionp4x'; 
timepiezor4n = timepiezor9_4(mindexTP4)';
minValTP4 = minValTP4'; 
anglep4n = anglep4n'; 
regionp4n = regionp4n';
timemicr1x = timemicr9(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr9(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_r9_1 = FPIEZO_r9_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r9_2 = FPIEZO_r9_2(indexFP2)';
maxValFP2 = maxValFP2';
FPIEZO_r9_3 = FPIEZO_r9_3(indexFP3)';
maxValFP3 = maxValFP3';
FPIEZO_r9_4 = FPIEZO_r9_4(indexFP4)';
maxValFP4 = maxValFP4';
FMIC_r9 = FMIC_r9(indexFM1)';
maxValFM1 = maxValFM1';

% save('Roach9data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timepiezor3x','maxValTP3','anglep3x','regionp3x','timepiezor3n','minValTP3','anglep3n','regionp3n',...
%                      'timepiezor4x','maxValTP4','anglep4x','regionp4x','timepiezor4n','minValTP4','anglep4n','regionp4n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_r9_1','maxValFP1','FPIEZO_r9_2','maxValFP2','FPIEZO_r9_3','maxValFP3','FPIEZO_r9_4','maxValFP4',...
%                      'FMIC_r9','maxValFM1','barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEP3','areaEP4','areaEM1');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2)+length(maxValTP3)+length(maxValTP4);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2)+sum(maxValTP3)+sum(maxValTP4))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x)+sum(anglep3x)+sum(anglep4x))/(length(anglep1x)+length(anglep2x)+length(anglep3x)+length(anglep4x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x)+sum(regionp3x)+sum(regionp4x))/(length(regionp1x)+length(regionp2x)+length(regionp3x)+length(regionp4x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2)+length(minValTP3)+length(minValTP4);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2)+sum(minValTP3)+sum(minValTP4))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n)+sum(anglep3n)+sum(anglep4n))/(length(anglep1n)+length(anglep2n)+length(anglep3n)+length(anglep4n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n)+sum(regionp3n)+sum(regionp4n))/(length(regionp1n)+length(regionp2n)+length(regionp3n)+length(regionp4n));
numfreqpeaksP = length(FPIEZO_r9_1)+length(FPIEZO_r9_2)+length(FPIEZO_r9_3)+length(FPIEZO_r9_4);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2')+sum(maxValFP3')+sum(maxValFP4'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(max(maxValFP1),max(maxValFP2)),max(max(maxValFP3),max(maxValFP4)));
maxfreqvalP = max(max(max(FPIEZO_r9_1),max(FPIEZO_r9_2)),max(max(FPIEZO_r9_3),max(FPIEZO_r9_4)));
minfreqpeakvalP = min(min(min(maxValFP1),min(maxValFP2)),min(min(maxValFP3),min(maxValFP4)));
minfreqvalP = min(min(min(FPIEZO_r9_1),min(FPIEZO_r9_2)),min(min(FPIEZO_r9_3),min(FPIEZO_r9_4)));
avgtimeenvelopeareaP = (areaEP1+areaEP2+areaEP3+areaEP4)/4;
avgtricorrP = (p1tri+p2tri+p3tri+p4tri)/4;
avggausscorrP = (p1gauss+p2gauss+p3gauss+p4gauss)/4;

numtimemaxpeaksM = length(maxValTM1);
avgtimemaxpeakvalM = (sum(maxValTM1))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM = length(minValTM1);
avgtimeminpeakvalM = (sum(minValTM1))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM = length(FMIC_r9);
avgfreqpeakvalM = (sum(maxValFM1')/numfreqpeaksM);
maxfreqpeakvalM = max(maxValFM1);
maxfreqvalM = max(FMIC_r9);
minfreqpeakvalM = min(maxValFM1);
minfreqvalM = min(FMIC_r9);
avgtimeenvelopeareaM = (areaEM1);
avgtricorrM = (m1tri);
avggausscorrM = (m1gauss);

save('Roach9data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');
 
 