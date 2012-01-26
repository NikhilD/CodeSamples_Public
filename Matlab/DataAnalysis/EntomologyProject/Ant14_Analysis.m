function Ant14_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant14.mat',micCol);
piezoa14_1 = window(piezo,400,600);
piezoa14_2 = window(piezo,1100,1500);
piezoa14_3 = window(piezo,4500,5600);
ira14 = window(ir,1,60);
timepiezoa14_1 = timeaxis(piezoa14_1,freq);
timepiezoa14_2 = timeaxis(piezoa14_2,freq);
timepiezoa14_3 = timeaxis(piezoa14_3,freq);
timeira14 = timeaxis(ira14,freq);

figure;
subplot(2,2,1), plot(timepiezoa14_1,piezoa14_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa14_1,0.6);
plot(timepiezoa14_1(maxdexTP1),maxValTP1,'o',timepiezoa14_1(mindexTP1),minValTP1,'o');
hold off;
title('Ant14 PIEZO signal 1');
[anglep1x regionp1x] = placepeaks(piezoa14_1,maxdexTP1,timepiezoa14_1,MAX);
[anglep1n regionp1n] = placepeaks(piezoa14_1,mindexTP1,timepiezoa14_1,MIN);

subplot(2,2,2), plot(timepiezoa14_2,piezoa14_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa14_2,0.6);
plot(timepiezoa14_2(maxdexTP2),maxValTP2,'o',timepiezoa14_2(mindexTP2),minValTP2,'o');
hold off;
title('Ant14 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezoa14_2,maxdexTP2,timepiezoa14_2,MAX);
[anglep2n regionp2n] = placepeaks(piezoa14_2,mindexTP2,timepiezoa14_2,MIN);

subplot(2,2,3), plot(timepiezoa14_3,piezoa14_3,'r');
hold on;
[maxdexTP3 maxValTP3 mindexTP3 minValTP3]=signalPeaks(piezoa14_3,0.6);
plot(timepiezoa14_3(maxdexTP3),maxValTP3,'o',timepiezoa14_3(mindexTP3),minValTP3,'o');
hold off;
title('Ant14 PIEZO signal 3');
[anglep3x regionp3x] = placepeaks(piezoa14_3,maxdexTP3,timepiezoa14_3,MAX);
[anglep3n regionp3n] = placepeaks(piezoa14_3,mindexTP3,timepiezoa14_3,MIN);

subplot(2,2,4), plot(timeira14,ira14,'g');
title('Ant14 IR signal');

figure;
[PPIEZO_a14_1 FPIEZO_a14_1] = freq_domain(piezoa14_1,fftpt,freq);
[PPIEZO_a14_2 FPIEZO_a14_2] = freq_domain(piezoa14_2,fftpt,freq);
[PPIEZO_a14_3 FPIEZO_a14_3] = freq_domain(piezoa14_3,fftpt,freq);
[PIR_a14 FIR_a14] = freq_domain(ira14,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_a14_1, PPIEZO_a14_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a14_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a14_1(indexFP1),maxValFP1,'o');
hold off;
title('Ant14 PIEZO Frequencies 1');
subplot(2,3,2), plot(FPIEZO_a14_2, PPIEZO_a14_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a14_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a14_2(indexFP2),maxValFP2,'o');
hold off;
title('Ant14 PIEZO Frequencies 2');
subplot(2,3,3), plot(FPIEZO_a14_3, PPIEZO_a14_3(12:((fftpt/2)+11)),'r');
hold on;
[indexFP3 maxValFP3 del ete]=signalPeaks(PPIEZO_a14_3(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a14_3(indexFP3),maxValFP3,'o');
hold off;
title('Ant14 PIEZO Frequencies 3');
subplot(2,3,4), plot(FIR_a14, PIR_a14(12:((fftpt/2)+11)),'g');
title('Ant14 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa14_1)) length(piezoa14_1); sum(abs(piezoa14_2)) length(piezoa14_2); sum(abs(piezoa14_3)) length(piezoa14_3);];
barplot_ir = [sum(abs(ira14)) length(ira14);];
barplot_mic = [0 0];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 14 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 14 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 14 sum|width');

figure;
var = runEnvelope(piezoa14_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant14 Piezo 1 Envelope');
var = runEnvelope(piezoa14_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant14 Piezo 2 Envelope');
var = runEnvelope(piezoa14_3);
[p3tri p3gauss] = getcorrn(var.out(2,:));
areaEP3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant14 Piezo 3 Envelope');

timepiezor1x = timepiezoa14_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezoa14_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezoa14_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezoa14_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timepiezor3x = timepiezoa14_3(maxdexTP3)';
maxValTP3 = maxValTP3'; 
anglep3x = anglep3x'; 
regionp3x = regionp3x'; 
timepiezor3n = timepiezoa14_3(mindexTP3)';
minValTP3 = minValTP3'; 
anglep3n = anglep3n'; 
regionp3n = regionp3n';
FPIEZO_a14_1 = FPIEZO_a14_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a14_2 = FPIEZO_a14_2(indexFP2)';
maxValFP2 = maxValFP2';
FPIEZO_a14_3 = FPIEZO_a14_3(indexFP3)';
maxValFP3 = maxValFP3';

% save('Ant14data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timepiezor3x','maxValTP3','anglep3x','regionp3x','timepiezor3n','minValTP3','anglep3n','regionp3n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_a14_1','maxValFP1','FPIEZO_a14_2','maxValFP2','FPIEZO_a14_3','maxValFP3',...
%                      'FMIC_a14','maxValFM1','barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEP3','areaEM1');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2)+length(maxValTP3);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2)+sum(maxValTP3))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x)+sum(anglep3x))/(length(anglep1x)+length(anglep2x)+length(anglep3x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x)+sum(regionp3x))/(length(regionp1x)+length(regionp2x)+length(regionp3x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2)+length(minValTP3);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2)+sum(minValTP3))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n)+sum(anglep3n))/(length(anglep1n)+length(anglep2n)+length(anglep3n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n)+sum(regionp3n))/(length(regionp1n)+length(regionp2n)+length(regionp3n));
numfreqpeaksP = length(FPIEZO_a14_1)+length(FPIEZO_a14_2)+length(FPIEZO_a14_3);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2')+sum(maxValFP3'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(max(maxValFP1),max(maxValFP2)),max(maxValFP3));
maxfreqvalP = max(max(max(FPIEZO_a14_1),max(FPIEZO_a14_2)),max(FPIEZO_a14_3));
minfreqpeakvalP = min(min(min(maxValFP1),min(maxValFP2)),min(maxValFP3));
minfreqvalP = min(min(min(FPIEZO_a14_1),min(FPIEZO_a14_2)),min(FPIEZO_a14_3));
avgtimeenvelopeareaP = (areaEP1+areaEP2+areaEP3)/3;
avgtricorrP = (p1tri+p2tri+p3tri)/3;
avggausscorrP = (p1gauss+p2gauss+p3gauss)/3;

save('Ant14data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP');
 
 
