function Ant11_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant11.mat',micCol);
piezoa11_1 = window(piezo,1050,1200);
piezoa11_2 = window(piezo,4200,4600);
ira11 = window(ir,1,400);
timepiezoa11_1 = timeaxis(piezoa11_1,freq);
timepiezoa11_2 = timeaxis(piezoa11_2,freq);
timeira11 = timeaxis(ira11,freq);

figure;
subplot(2,2,1), plot(timepiezoa11_1,piezoa11_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa11_1,0.6);
plot(timepiezoa11_1(maxdexTP1),maxValTP1,'o',timepiezoa11_1(mindexTP1),minValTP1,'o');
hold off;
title('Ant11 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezoa11_1,maxdexTP1,timepiezoa11_1,MAX);
[anglep1n regionp1n] = placepeaks(piezoa11_1,mindexTP1,timepiezoa11_1,MIN);

subplot(2,2,2), plot(timepiezoa11_2,piezoa11_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa11_2,0.6);
plot(timepiezoa11_2(maxdexTP2),maxValTP2,'o',timepiezoa11_2(mindexTP2),minValTP2,'o');
hold off;
title('Ant11 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezoa11_2,maxdexTP2,timepiezoa11_2,MAX);
[anglep2n regionp2n] = placepeaks(piezoa11_2,mindexTP2,timepiezoa11_2,MIN);

subplot(2,2,3), plot(timeira11,ira11,'g');
title('Ant11 IR signal');

figure;
[PPIEZO_a11_1 FPIEZO_a11_1] = freq_domain(piezoa11_1,fftpt,freq);
[PPIEZO_a11_2 FPIEZO_a11_2] = freq_domain(piezoa11_2,fftpt,freq);
[PIR_a11 FIR_a11] = freq_domain(ira11,fftpt,freq);
subplot(2,2,1), plot(FPIEZO_a11_1, PPIEZO_a11_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a11_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a11_1(indexFP1),maxValFP1,'o');
hold off;
title('Ant11 PIEZO Frequencies 1');
subplot(2,2,2), plot(FPIEZO_a11_2, PPIEZO_a11_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a11_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a11_2(indexFP2),maxValFP2,'o');
hold off;
title('Ant11 PIEZO Frequencies 2');
subplot(2,2,3), plot(FIR_a11, PIR_a11(12:((fftpt/2)+11)),'g');
title('Ant11 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa11_1)) length(piezoa11_1); sum(abs(piezoa11_2)) length(piezoa11_2)];
barplot_ir = [sum(abs(ira11)) length(ira11);];
barplot_mic = [0 0];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 11 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 11 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 11 sum|width');

figure;
var = runEnvelope(piezoa11_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant11 Piezo Envelope 1');
var = runEnvelope(piezoa11_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant11 Piezo Envelope 2');

timepiezoa1x = timepiezoa11_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa1n = timepiezoa11_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezoa2x = timepiezoa11_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezoa2n = timepiezoa11_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
FPIEZO_a11_1 = FPIEZO_a11_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a11_2 = FPIEZO_a11_2(indexFP2)';
maxValFP2 = maxValFP2';

% save('Ant11data.mat','timepiezoa1x','maxValTP1','anglep1x','regionp1x','timepiezoa1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezoa2x','maxValTP2','anglep2x','regionp2x','timepiezoa2n','minValTP2','anglep2n','regionp2n',...
%                      'timemica1x','maxValTM1','anglem1x','regionm1x','timemica1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_a11_1','maxValFP1','FPIEZO_a11_2','maxValFP2','FMIC_a11','maxValFM1',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x))/(length(anglep1x)+length(anglep2x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x))/(length(regionp1x)+length(regionp2x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n))/(length(anglep1n)+length(anglep2n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n))/(length(regionp1n)+length(regionp2n));
numfreqpeaksP = length(FPIEZO_a11_1)+length(FPIEZO_a11_2);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(maxValFP1),max(maxValFP2));
maxfreqvalP = max(max(FPIEZO_a11_1),max(FPIEZO_a11_2));
minfreqpeakvalP = min(min(maxValFP1),min(maxValFP2));
minfreqvalP = min(min(FPIEZO_a11_1),min(FPIEZO_a11_2));
avgtimeenvelopeareaP = (areaEP1+areaEP2)/2;
avgtricorrP = (p1tri+p2tri)/2;
avggausscorrP = (p1gauss+p2gauss)/2;

save('Ant11data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP');