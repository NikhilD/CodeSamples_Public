function Ant7_17Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant7.mat',micCol);
ira7_1 = window(ir,500,1100);
ira7_2 = window(ir,5800,6800);
timeira7_1 = timeaxis(ira7_1,freq);
timeira7_2 = timeaxis(ira7_2,freq);

figure;
subplot(2,2,1), plot(timeira7_1,ira7_1,'g');
title('Ant7 IR signal 1');
subplot(2,2,2), plot(timeira7_2,ira7_2,'g');
title('Ant7 IR signal 2');

[piezo ir mic] = time_domain('ant17.mat',micCol);
piezoa17 = window(piezo,9300,9800);
ira17 = window(ir,1850,2460);
timepiezoa17 = timeaxis(piezoa17,freq);
timeira17 = timeaxis(ira17,freq);

subplot(2,2,3), plot(timepiezoa17,piezoa17,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa17,0.6);
plot(timepiezoa17(maxdexTP1),maxValTP1,'o',timepiezoa17(mindexTP1),minValTP1,'o');
hold off;
title('Ant17 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezoa17,maxdexTP1,timepiezoa17,MAX);
[anglep1n regionp1n] = placepeaks(piezoa17,mindexTP1,timepiezoa17,MIN);

subplot(2,2,4), plot(timeira17,ira17,'g');
title('Ant17 IR signal');

figure;
[PPIEZO_a17 FPIEZO_a17] = freq_domain(piezoa17,fftpt,freq);
[PIR_a7_1 FIR_a7_1] = freq_domain(ira7_1,fftpt,freq);
[PIR_a7_2 FIR_a7_2] = freq_domain(ira7_2,fftpt,freq);
[PIR_a17 FIR_a17] = freq_domain(ira17,fftpt,freq);

subplot(2,2,1), plot(FPIEZO_a17, PPIEZO_a17(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a17(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a17(indexFP1),maxValFP1,'o');
hold off;
title('Ant17 PIEZO Frequencies');
subplot(2,2,2), plot(FIR_a7_1, PIR_a7_1(12:((fftpt/2)+11)),'g');
title('Ant7 IR Frequencies 1');
subplot(2,2,3), plot(FIR_a7_2, PIR_a7_2(12:((fftpt/2)+11)),'g');
title('Ant7 IR Frequencies 2');
subplot(2,2,4), plot(FIR_a17, PIR_a17(12:((fftpt/2)+11)),'g');
title('Ant17 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa17)) length(piezoa17);];
barplot_ir = [sum(abs(ira7_1)) length(ira7_1); sum(abs(ira7_2)) length(ira7_2); sum(abs(ira17)) length(ira17);];
barplot_mic = [0 0];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 17 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 7&17 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 7 sum|width');

figure;
var = runEnvelope(piezoa17);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant17 Piezo Envelope');

timepiezoa1x = timepiezoa17(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa1n = timepiezoa17(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
FPIEZO_a17 = FPIEZO_a17(indexFP1)';
maxValFP1 = maxValFP1';

% save('Ant7_17data.mat','timepiezoa1x','maxValTP1','anglep1x','regionp1x','timepiezoa1n','minValTP1','anglep1n','regionp1n',...
%                      'FPIEZO_a17','maxValFP1','barplot_piezo','barplot_ir','barplot_mic','areaEP1');

numtimemaxpeaksP17 = length(maxValTP1);
avgtimemaxpeakvalP17 = (sum(maxValTP1))/numtimemaxpeaksP17;
avgtimemaxpeakangleP17 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP17 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP17 = length(minValTP1);
avgtimeminpeakvalP17 = (sum(minValTP1))/numtimeminpeaksP17;
avgtimeminpeakangleP17 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP17 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP17 = length(FPIEZO_a17);
avgfreqpeakvalP17 = (sum(maxValFP1'))/numfreqpeaksP17;
maxfreqpeakvalP17 = (max(maxValFP1));
maxfreqvalP17 = (max(FPIEZO_a17));
minfreqpeakvalP17 = (min(maxValFP1));
minfreqvalP17 = (min(FPIEZO_a17));
avgtimeenvelopeareaP17 = areaEP1;
avgtricorrP17 = (p1tri);
avggausscorrP17 = (p1gauss);

save('Ant7_17data.mat','numtimemaxpeaksP17','avgtimemaxpeakvalP17','avgtimemaxpeakangleP17','avgtimemaxpeakareaP17',...
      'numtimeminpeaksP17','avgtimeminpeakvalP17','avgtimeminpeakangleP17','avgtimeminpeakareaP17',...
      'numfreqpeaksP17','avgfreqpeakvalP17','maxfreqpeakvalP17','maxfreqvalP17','minfreqpeakvalP17','minfreqvalP17','avgtimeenvelopeareaP17',...
      'avgtricorrP17','avggausscorrP17');
  
