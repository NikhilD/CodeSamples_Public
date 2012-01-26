function Ant6_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant6.mat',micCol);
piezoa6_1 = window(piezo,1000,1300);
piezoa6_2 = window(piezo,7250,7650);
ira6 = window(ir,1,600);
mica6 = window(mic,7300,7600);
timepiezoa6_1 = timeaxis(piezoa6_1,freq);
timepiezoa6_2 = timeaxis(piezoa6_2,freq);
timeira6 = timeaxis(ira6,freq);
timemica6 = timeaxis(mica6,freq);

figure;
subplot(2,2,1), plot(timepiezoa6_1,piezoa6_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa6_1,0.6);
plot(timepiezoa6_1(maxdexTP1),maxValTP1,'o',timepiezoa6_1(mindexTP1),minValTP1,'o');
hold off;
title('Ant6 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezoa6_1,maxdexTP1,timepiezoa6_1,MAX);
[anglep1n regionp1n] = placepeaks(piezoa6_1,mindexTP1,timepiezoa6_1,MIN);

subplot(2,2,2), plot(timepiezoa6_2,piezoa6_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa6_2,0.6);
plot(timepiezoa6_2(maxdexTP2),maxValTP2,'o',timepiezoa6_2(mindexTP2),minValTP2,'o');
hold off;
title('Ant6 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezoa6_2,maxdexTP2,timepiezoa6_2,MAX);
[anglep2n regionp2n] = placepeaks(piezoa6_2,mindexTP2,timepiezoa6_2,MIN);

subplot(2,2,3), plot(timeira6,ira6,'g');
title('Ant6 IR signal');

subplot(2,2,4), plot(timemica6,mica6,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(mica6,0.6);
plot(timemica6(maxdexTM1),maxValTM1,'o',timemica6(mindexTM1),minValTM1,'o');
hold off;
title('Ant6 MIC signal');
[anglem1x regionm1x] = placepeaks(mica6,maxdexTM1,timemica6,MAX);
[anglem1n regionm1n] = placepeaks(mica6,mindexTM1,timemica6,MIN);

figure;
[PPIEZO_a6_1 FPIEZO_a6_1] = freq_domain(piezoa6_1,fftpt,freq);
[PPIEZO_a6_2 FPIEZO_a6_2] = freq_domain(piezoa6_2,fftpt,freq);
[PIR_a6 FIR_a6] = freq_domain(ira6,fftpt,freq);
[PMIC_a6 FMIC_a6] = freq_domain(mica6,fftpt,freq);
subplot(2,2,1), plot(FPIEZO_a6_1, PPIEZO_a6_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a6_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a6_1(indexFP1),maxValFP1,'o');
hold off;
title('Ant6 PIEZO Frequencies 1');
subplot(2,2,2), plot(FPIEZO_a6_2, PPIEZO_a6_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a6_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a6_2(indexFP2),maxValFP2,'o');
hold off;
title('Ant6 PIEZO Frequencies 2');
subplot(2,2,3), plot(FIR_a6, PIR_a6(12:((fftpt/2)+11)),'g');
title('Ant6 IR Frequencies');
subplot(2,2,4), plot(FMIC_a6, PMIC_a6(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_a6(12:((fftpt/2)+11)),0.4);
plot(FMIC_a6(indexFM1),maxValFM1,'o');
hold off;
title('Ant6 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa6_1)) length(piezoa6_1); sum(abs(piezoa6_2)) length(piezoa6_2)];
barplot_ir = [sum(abs(ira6)) length(ira6);];
barplot_mic = [sum(abs(mica6)) length(mica6)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 6 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 6 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 6 sum|width');

figure;
var = runEnvelope(piezoa6_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant6 Piezo Envelope 1');
var = runEnvelope(piezoa6_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant6 Piezo Envelope 2');
var = runEnvelope(mica6);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Ant6 MIC Envelope');

timepiezoa1x = timepiezoa6_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa1n = timepiezoa6_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezoa2x = timepiezoa6_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezoa2n = timepiezoa6_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timemica1x = timemica6(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemica1n = timemica6(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_a6_1 = FPIEZO_a6_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a6_2 = FPIEZO_a6_2(indexFP2)';
maxValFP2 = maxValFP2';
FMIC_a6 = FMIC_a6(indexFM1)';
maxValFM1 = maxValFM1';

% save('Ant6data.mat','timepiezoa1x','maxValTP1','anglep1x','regionp1x','timepiezoa1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezoa2x','maxValTP2','anglep2x','regionp2x','timepiezoa2n','minValTP2','anglep2n','regionp2n',...
%                      'timemica1x','maxValTM1','anglem1x','regionm1x','timemica1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_a6_1','maxValFP1','FPIEZO_a6_2','maxValFP2','FMIC_a6','maxValFM1',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x))/(length(anglep1x)+length(anglep2x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x))/(length(regionp1x)+length(regionp2x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n))/(length(anglep1n)+length(anglep2n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n))/(length(regionp1n)+length(regionp2n));
numfreqpeaksP = length(FPIEZO_a6_1)+length(FPIEZO_a6_2);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(maxValFP1),max(maxValFP2));
maxfreqvalP = max(max(FPIEZO_a6_1),max(FPIEZO_a6_2));
minfreqpeakvalP = min(min(maxValFP1),min(maxValFP2));
minfreqvalP = min(min(FPIEZO_a6_1),min(FPIEZO_a6_2));
avgtimeenvelopeareaP = (areaEP1+areaEP2)/2;
avgtricorrP = (p1tri+p2tri)/2;
avggausscorrP = (p1gauss+p2gauss)/2;

numtimemaxpeaksM = length(maxValTM1);
avgtimemaxpeakvalM = (sum(maxValTM1))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM = length(minValTM1);
avgtimeminpeakvalM = (sum(minValTM1))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM = length(FMIC_a6);
avgfreqpeakvalM = (sum(maxValFM1')/numfreqpeaksM);
maxfreqpeakvalM = max(maxValFM1);
maxfreqvalM = max(FMIC_a6);
minfreqpeakvalM = min(maxValFM1);
minfreqvalM = min(FMIC_a6);
avgtimeenvelopeareaM = (areaEM1);
avgtricorrM = (m1tri);
avggausscorrM = (m1gauss);

save('Ant6data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');