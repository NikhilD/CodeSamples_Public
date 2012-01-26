function Ant15_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant15.mat',micCol);
piezoa15_1 = window(piezo,700,1000);
piezoa15_2 = window(piezo,2400,2700);
piezoa15_3 = window(piezo,7750,8150);
ira15 = window(ir,1,500);
mica15 = window(mic,200,600);
timepiezoa15_1 = timeaxis(piezoa15_1,freq);
timepiezoa15_2 = timeaxis(piezoa15_2,freq);
timepiezoa15_3 = timeaxis(piezoa15_3,freq);
timeira15 = timeaxis(ira15,freq);
timemica15 = timeaxis(mica15,freq);

figure;
subplot(2,3,1), plot(timepiezoa15_1,piezoa15_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa15_1,0.6);
plot(timepiezoa15_1(maxdexTP1),maxValTP1,'o',timepiezoa15_1(mindexTP1),minValTP1,'o');
hold off;
title('Ant15 PIEZO signal 1');
[anglep1x regionp1x] = placepeaks(piezoa15_1,maxdexTP1,timepiezoa15_1,MAX);
[anglep1n regionp1n] = placepeaks(piezoa15_1,mindexTP1,timepiezoa15_1,MIN);

subplot(2,3,2), plot(timepiezoa15_2,piezoa15_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa15_2,0.6);
plot(timepiezoa15_2(maxdexTP2),maxValTP2,'o',timepiezoa15_2(mindexTP2),minValTP2,'o');
hold off;
title('Ant15 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezoa15_2,maxdexTP2,timepiezoa15_2,MAX);
[anglep2n regionp2n] = placepeaks(piezoa15_2,mindexTP2,timepiezoa15_2,MIN);

subplot(2,3,3), plot(timepiezoa15_3,piezoa15_3,'r');
hold on;
[maxdexTP3 maxValTP3 mindexTP3 minValTP3]=signalPeaks(piezoa15_3,0.6);
plot(timepiezoa15_3(maxdexTP3),maxValTP3,'o',timepiezoa15_3(mindexTP3),minValTP3,'o');
hold off;
title('Ant15 PIEZO signal 3');
[anglep3x regionp3x] = placepeaks(piezoa15_3,maxdexTP3,timepiezoa15_3,MAX);
[anglep3n regionp3n] = placepeaks(piezoa15_3,mindexTP3,timepiezoa15_3,MIN);

subplot(2,3,4), plot(timeira15,ira15,'g');
title('Ant15 IR signal');

subplot(2,3,5), plot(timemica15,mica15,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(mica15,0.6);
plot(timemica15(maxdexTM1),maxValTM1,'o',timemica15(mindexTM1),minValTM1,'o');
hold off;
title('Ant15 MIC signal');
[anglem1x regionm1x] = placepeaks(mica15,maxdexTM1,timemica15,MAX);
[anglem1n regionm1n] = placepeaks(mica15,mindexTM1,timemica15,MIN);

figure;
[PPIEZO_a15_1 FPIEZO_a15_1] = freq_domain(piezoa15_1,fftpt,freq);
[PPIEZO_a15_2 FPIEZO_a15_2] = freq_domain(piezoa15_2,fftpt,freq);
[PPIEZO_a15_3 FPIEZO_a15_3] = freq_domain(piezoa15_3,fftpt,freq);
[PIR_a15 FIR_a15] = freq_domain(ira15,fftpt,freq);
[PMIC_a15 FMIC_a15] = freq_domain(mica15,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_a15_1, PPIEZO_a15_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a15_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a15_1(indexFP1),maxValFP1,'o');
hold off;
title('Ant15 PIEZO Frequencies 1');
subplot(2,3,2), plot(FPIEZO_a15_2, PPIEZO_a15_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a15_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a15_2(indexFP2),maxValFP2,'o');
hold off;
title('Ant15 PIEZO Frequencies 2');
subplot(2,3,3), plot(FPIEZO_a15_3, PPIEZO_a15_3(12:((fftpt/2)+11)),'r');
hold on;
[indexFP3 maxValFP3 del ete]=signalPeaks(PPIEZO_a15_3(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a15_3(indexFP3),maxValFP3,'o');
hold off;
title('Ant15 PIEZO Frequencies 3');
subplot(2,3,4), plot(FIR_a15, PIR_a15(12:((fftpt/2)+11)),'g');
title('Ant15 IR Frequencies');
subplot(2,3,5), plot(FMIC_a15, PMIC_a15(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_a15(12:((fftpt/2)+11)),0.4);
plot(FMIC_a15(indexFM1),maxValFM1,'o');
hold off;
title('Ant15 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa15_1)) length(piezoa15_1); sum(abs(piezoa15_2)) length(piezoa15_2); sum(abs(piezoa15_3)) length(piezoa15_3);];
barplot_ir = [sum(abs(ira15)) length(ira15);];
barplot_mic = [sum(abs(mica15)) length(mica15)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 15 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 15 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 15 sum|width');

figure;
var = runEnvelope(piezoa15_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant15 Piezo 1 Envelope');
var = runEnvelope(piezoa15_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant15 Piezo 2 Envelope');
var = runEnvelope(piezoa15_3);
[p3tri p3gauss] = getcorrn(var.out(2,:));
areaEP3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant15 Piezo 3 Envelope');
var = runEnvelope(mica15);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,4), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Ant15 MIC Envelope');

timepiezor1x = timepiezoa15_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezoa15_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezoa15_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezoa15_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timepiezor3x = timepiezoa15_3(maxdexTP3)';
maxValTP3 = maxValTP3'; 
anglep3x = anglep3x'; 
regionp3x = regionp3x'; 
timepiezor3n = timepiezoa15_3(mindexTP3)';
minValTP3 = minValTP3'; 
anglep3n = anglep3n'; 
regionp3n = regionp3n';
timemicr1x = timemica15(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemica15(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_a15_1 = FPIEZO_a15_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a15_2 = FPIEZO_a15_2(indexFP2)';
maxValFP2 = maxValFP2';
FPIEZO_a15_3 = FPIEZO_a15_3(indexFP3)';
maxValFP3 = maxValFP3';
FMIC_a15 = FMIC_a15(indexFM1)';
maxValFM1 = maxValFM1';

% save('Ant15data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timepiezor3x','maxValTP3','anglep3x','regionp3x','timepiezor3n','minValTP3','anglep3n','regionp3n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_a15_1','maxValFP1','FPIEZO_a15_2','maxValFP2','FPIEZO_a15_3','maxValFP3',...
%                      'FMIC_a15','maxValFM1','barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEP3','areaEM1');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2)+length(maxValTP3);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2)+sum(maxValTP3))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x)+sum(anglep3x))/(length(anglep1x)+length(anglep2x)+length(anglep3x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x)+sum(regionp3x))/(length(regionp1x)+length(regionp2x)+length(regionp3x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2)+length(minValTP3);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2)+sum(minValTP3))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n)+sum(anglep3n))/(length(anglep1n)+length(anglep2n)+length(anglep3n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n)+sum(regionp3n))/(length(regionp1n)+length(regionp2n)+length(regionp3n));
numfreqpeaksP = length(FPIEZO_a15_1)+length(FPIEZO_a15_2)+length(FPIEZO_a15_3);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2')+sum(maxValFP3'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(max(maxValFP1),max(maxValFP2)),max(maxValFP3));
maxfreqvalP = max(max(max(FPIEZO_a15_1),max(FPIEZO_a15_2)),max(FPIEZO_a15_3));
minfreqpeakvalP = min(min(min(maxValFP1),min(maxValFP2)),min(maxValFP3));
minfreqvalP = min(min(min(FPIEZO_a15_1),min(FPIEZO_a15_2)),min(FPIEZO_a15_3));
avgtimeenvelopeareaP = (areaEP1+areaEP2+areaEP3)/3;
avgtricorrP = (p1tri+p2tri+p3tri)/3;
avggausscorrP = (p1gauss+p2gauss+p3gauss)/3;

numtimemaxpeaksM = length(maxValTM1);
avgtimemaxpeakvalM = (sum(maxValTM1))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM = length(minValTM1);
avgtimeminpeakvalM = (sum(minValTM1))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM = length(FMIC_a15);
avgfreqpeakvalM = (sum(maxValFM1')/numfreqpeaksM);
maxfreqpeakvalM = max(maxValFM1);
maxfreqvalM = max(FMIC_a15);
minfreqpeakvalM = min(maxValFM1);
minfreqvalM = min(FMIC_a15);
avgtimeenvelopeareaM = (areaEM1);
avgtricorrM = (m1tri);
avggausscorrM = (m1gauss);

save('Ant15data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');
 
 
