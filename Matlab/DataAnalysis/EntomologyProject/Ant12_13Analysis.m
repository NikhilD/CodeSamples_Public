function Ant12_13Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant12.mat',micCol);
piezoa12 = window(piezo,1,400);
ira12 = window(ir,1200,1700);
timepiezoa12 = timeaxis(piezoa12,freq);
timeira12 = timeaxis(ira12,freq);

figure;
subplot(2,2,1), plot(timepiezoa12,piezoa12,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa12,0.6);
plot(timepiezoa12(maxdexTP1),maxValTP1,'o',timepiezoa12(mindexTP1),minValTP1,'o');
hold off;
title('Ant12 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezoa12,maxdexTP1,timepiezoa12,MAX);
[anglep1n regionp1n] = placepeaks(piezoa12,mindexTP1,timepiezoa12,MIN);

subplot(2,2,2), plot(timeira12,ira12,'g');
title('Ant12 PIEZO signal');

[piezo ir mic] = time_domain('ant13.mat',micCol);
piezoa13 = window(piezo,4600,5600);
ira13 = window(ir,3700,4350);
timepiezoa13 = timeaxis(piezoa13,freq);
timeira13 = timeaxis(ira13,freq);

subplot(2,2,3), plot(timepiezoa13,piezoa13,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa13,0.6);
plot(timepiezoa13(maxdexTP2),maxValTP2,'o',timepiezoa13(mindexTP2),minValTP2,'o');
hold off;
title('Ant13 PIEZO signal');
[anglep2x regionp2x] = placepeaks(piezoa13,maxdexTP2,timepiezoa13,MAX);
[anglep2n regionp2n] = placepeaks(piezoa13,mindexTP2,timepiezoa13,MIN);

subplot(2,2,4), plot(timeira13,ira13,'g');
title('Ant13 IR signal');

figure;
[PPIEZO_a12 FPIEZO_a12] = freq_domain(piezoa12,fftpt,freq);
[PIR_a12 FIR_a12] = freq_domain(ira12,fftpt,freq);
[PPIEZO_a13 FPIEZO_a13] = freq_domain(piezoa13,fftpt,freq);
[PIR_a13 FIR_a13] = freq_domain(ira13,fftpt,freq);

subplot(2,2,1), plot(FPIEZO_a12, PPIEZO_a12(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a12(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a12(indexFP1),maxValFP1,'o');
hold off;
title('Ant12 PIEZO Frequencies');
subplot(2,2,2), plot(FIR_a12, PIR_a12(12:((fftpt/2)+11)),'g');
title('Ant12 IR Frequencies');
subplot(2,2,3), plot(FPIEZO_a13, PPIEZO_a13(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a13(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a13(indexFP2),maxValFP2,'o');
hold off;
title('Ant13 PIEZO Frequencies');
subplot(2,2,4), plot(FIR_a13, PIR_a13(12:((fftpt/2)+11)),'g');
title('Ant13 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa12)) length(piezoa12); sum(abs(piezoa13)) length(piezoa13);];
barplot_ir = [sum(abs(ira12)) length(ira12); sum(abs(ira13)) length(ira13);];
barplot_mic = [0 0];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 12&13 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 12&13 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 12&13 sum|width');

figure;
var = runEnvelope(piezoa12);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant12 Piezo Envelope');
var = runEnvelope(piezoa13);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant13 Piezo Envelope');

timepiezoa1x = timepiezoa12(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa1n = timepiezoa12(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezoa2x = timepiezoa13(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezoa2n = timepiezoa13(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
FPIEZO_a12 = FPIEZO_a12(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a13 = FPIEZO_a13(indexFP2)';
maxValFP2 = maxValFP2';

% save('Ant12_13data.mat','timepiezoa1x','maxValTP1','anglep1x','regionp1x','timepiezoa1n','minValTP1','anglep1n','regionp1n',...
%                         'timepiezoa2x','maxValTP2','anglep2x','regionp2x','timepiezoa2n','minValTP2','anglep2n','regionp2n',...
%                         'FPIEZO_a12','maxValFP1','FPIEZO_a13','maxValFP2','barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2');

numtimemaxpeaksP12 = length(maxValTP1);
avgtimemaxpeakvalP12 = (sum(maxValTP1))/numtimemaxpeaksP12;
avgtimemaxpeakangleP12 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP12 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP12 = length(minValTP1);
avgtimeminpeakvalP12 = (sum(minValTP1))/numtimeminpeaksP12;
avgtimeminpeakangleP12 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP12 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP12 = length(FPIEZO_a12);
avgfreqpeakvalP12 = (sum(maxValFP1'))/numfreqpeaksP12;
maxfreqpeakvalP12 = (max(maxValFP1));
maxfreqvalP12 = (max(FPIEZO_a12));
minfreqpeakvalP12 = (min(maxValFP1));
minfreqvalP12 = (min(FPIEZO_a12));
avgtimeenvelopeareaP12 = areaEP1;
avgtricorrP12 = (p1tri);
avggausscorrP12 = (p1gauss);

numtimemaxpeaksP13 = length(maxValTP2);
avgtimemaxpeakvalP13 = (sum(maxValTP2))/numtimemaxpeaksP13;
avgtimemaxpeakangleP13 = (sum(anglep2x))/(length(anglep2x));
avgtimemaxpeakareaP13 = (sum(regionp2x))/(length(regionp2x));
numtimeminpeaksP13 = length(minValTP2);
avgtimeminpeakvalP13 = (sum(minValTP2))/numtimeminpeaksP13;
avgtimeminpeakangleP13 = (sum(anglep2n))/(length(anglep2n));
avgtimeminpeakareaP13 = (sum(regionp2n))/(length(regionp2n));
numfreqpeaksP13 = length(FPIEZO_a13);
avgfreqpeakvalP13 = (sum(maxValFP2'))/numfreqpeaksP13;
maxfreqpeakvalP13 = (max(maxValFP2));
maxfreqvalP13 = (max(FPIEZO_a13));
minfreqpeakvalP13 = (min(maxValFP2));
minfreqvalP13 = (min(FPIEZO_a13));
avgtimeenvelopeareaP13 = areaEP2;
avgtricorrP13 = (p2tri);
avggausscorrP13 = (p2gauss);

save('Ant12_13data.mat','numtimemaxpeaksP12','avgtimemaxpeakvalP12','avgtimemaxpeakangleP12','avgtimemaxpeakareaP12',...
      'numtimeminpeaksP12','avgtimeminpeakvalP12','avgtimeminpeakangleP12','avgtimeminpeakareaP12',...
      'numfreqpeaksP12','avgfreqpeakvalP12','maxfreqpeakvalP12','maxfreqvalP12','minfreqpeakvalP12','minfreqvalP12','avgtimeenvelopeareaP12',...
      'avgtricorrP12','avggausscorrP12',...
      'numtimemaxpeaksP13','avgtimemaxpeakvalP13','avgtimemaxpeakangleP13','avgtimemaxpeakareaP13',...
      'numtimeminpeaksP13','avgtimeminpeakvalP13','avgtimeminpeakangleP13','avgtimeminpeakareaP13',...
      'numfreqpeaksP13','avgfreqpeakvalP13','maxfreqpeakvalP13','maxfreqvalP13','minfreqpeakvalP13','minfreqvalP13','avgtimeenvelopeareaP13',...
      'avgtricorrP13','avggausscorrP13');
  
