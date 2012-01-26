function Ant4_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;

[piezo ir mic] = time_domain('ant4.mat',micCol);
piezoa4 = window(piezo,8450,8650);
ira4_1 = window(ir,1480,3400);
ira4_2 = window(ir,3950,5200);
mica4 = window(mic,3200,4100);
timepiezoa4 = timeaxis(piezoa4,freq);
timeira4_1 = timeaxis(ira4_1,freq);
timeira4_2 = timeaxis(ira4_2,freq);
timemica4 = timeaxis(mica4,freq);

figure;
subplot(2,2,1), plot(timepiezoa4,piezoa4,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa4,0.6);
plot(timepiezoa4(maxdexTP1),maxValTP1,'o',timepiezoa4(mindexTP1),minValTP1,'o');
hold off;
title('Ant4 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezoa4,maxdexTP1,timepiezoa4,MAX);
[anglep1n regionp1n] = placepeaks(piezoa4,mindexTP1,timepiezoa4,MIN);

subplot(2,2,2), plot(timeira4_1,ira4_1,'g');
title('Ant4 IR signal 1');
subplot(2,2,3), plot(timeira4_2,ira4_2,'g');
title('Ant4 IR signal 2 ');

subplot(2,2,4), plot(timemica4,mica4,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(mica4,0.6);
plot(timemica4(maxdexTM1),maxValTM1,'o',timemica4(mindexTM1),minValTM1,'o');
hold off;
title('Ant4 MIC signal');
[anglem1x regionm1x] = placepeaks(mica4,maxdexTM1,timemica4,MAX);
[anglem1n regionm1n] = placepeaks(mica4,mindexTM1,timemica4,MIN);

figure;
[PPIEZO_a4 FPIEZO_a4] = freq_domain(piezoa4,fftpt,freq);
[PIR_a4_1 FIR_a4_1] = freq_domain(ira4_1,fftpt,freq);
[PIR_a4_2 FIR_a4_2] = freq_domain(ira4_2,fftpt,freq);
[PMIC_a4 FMIC_a4] = freq_domain(mica4,fftpt,freq);
subplot(2,2,1), plot(FPIEZO_a4, PPIEZO_a4(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a4(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a4(indexFP1),maxValFP1,'o');
hold off;
title('Ant4 PIEZO Frequencies');
subplot(2,2,2), plot(FIR_a4_1, PIR_a4_1(12:((fftpt/2)+11)),'g');
title('Ant4 IR Frequencies 1');
subplot(2,2,3), plot(FIR_a4_2, PIR_a4_2(40:((fftpt/2)+39)),'g');
title('Ant4 IR Frequencies 2');
subplot(2,2,4), plot(FMIC_a4, PMIC_a4(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_a4(12:((fftpt/2)+11)),0.4);
plot(FMIC_a4(indexFM1),maxValFM1,'o');
hold off;
title('Ant4 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa4)) length(piezoa4)];
barplot_ir = [sum(abs(ira4_1)) length(ira4_1); sum(abs(ira4_2)) length(ira4_2)];
barplot_mic = [sum(abs(mica4)) length(mica4)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 4 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 4 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 4 sum|width');

figure;
var = runEnvelope(piezoa4);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(1,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant4 Piezo Envelope');
var = runEnvelope(mica4);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(1,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Ant4 MIC Envelope');

timepiezoa4x = timepiezoa4(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa4n = timepiezoa4(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timemica4x = timemica4(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemica4n = timemica4(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_a4 = FPIEZO_a4(indexFP1)';
maxValFP1 = maxValFP1';
FMIC_a4 = FMIC_a4(indexFM1)';
maxValFM1 = maxValFM1';

% save('Ant4data.mat','timepiezoa4x','maxValTP1','anglep1x','regionp1x','timepiezoa4n','minValTP1','anglep1n','regionp1n',...
%                      'timemica4x','maxValTM1','anglem1x','regionm1x','timemica4n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_a4','maxValFP1','FMIC_a4','maxValFM1',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEM1');

numtimemaxpeaksP = length(maxValTP1);
avgtimemaxpeakvalP = (sum(maxValTP1))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP = length(minValTP1);
avgtimeminpeakvalP = (sum(minValTP1))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP = length(FPIEZO_a4);
avgfreqpeakvalP = (sum(maxValFP1'))/numfreqpeaksP;
maxfreqpeakvalP = (max(maxValFP1));
maxfreqvalP = (max(FPIEZO_a4));
minfreqpeakvalP = (min(maxValFP1));
minfreqvalP = (min(FPIEZO_a4));
avgtimeenvelopeareaP = areaEP1;
avgtricorrP = (p1tri);
avggausscorrP = (p1gauss);

numtimemaxpeaksM = length(maxValTM1);
avgtimemaxpeakvalM = (sum(maxValTM1))/numtimemaxpeaksM;
avgtimemaxpeakangleM = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM = length(minValTM1);
avgtimeminpeakvalM = (sum(minValTM1))/numtimeminpeaksM;
avgtimeminpeakangleM = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM = length(FMIC_a4);
avgfreqpeakvalM = (sum(maxValFM1')/numfreqpeaksM);
maxfreqpeakvalM = max(maxValFM1);
maxfreqvalM = max(FMIC_a4);
minfreqpeakvalM = min(maxValFM1);
minfreqvalM = min(FMIC_a4);
avgtimeenvelopeareaM = (areaEM1);
avgtricorrM = (m1tri);
avggausscorrM = (m1gauss);

save('Ant4data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');