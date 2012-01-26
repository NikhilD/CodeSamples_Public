function Ant8_9Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant8.mat',micCol);
piezoa8_1 = window(piezo,150,400);
piezoa8_2 = window(piezo,2400,3400);
timepiezoa8_1 = timeaxis(piezoa8_1,freq);
timepiezoa8_2 = timeaxis(piezoa8_2,freq);

figure;
subplot(2,2,1), plot(timepiezoa8_1,piezoa8_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa8_1,0.6);
plot(timepiezoa8_1(maxdexTP1),maxValTP1,'o',timepiezoa8_1(mindexTP1),minValTP1,'o');
hold off;
title('Ant8 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezoa8_1,maxdexTP1,timepiezoa8_1,MAX);
[anglep1n regionp1n] = placepeaks(piezoa8_1,mindexTP1,timepiezoa8_1,MIN);

subplot(2,2,2), plot(timepiezoa8_2,piezoa8_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa8_2,0.6);
plot(timepiezoa8_2(maxdexTP2),maxValTP2,'o',timepiezoa8_2(mindexTP2),minValTP2,'o');
hold off;
title('Ant8 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezoa8_2,maxdexTP2,timepiezoa8_2,MAX);
[anglep2n regionp2n] = placepeaks(piezoa8_2,mindexTP2,timepiezoa8_2,MIN);

[piezo ir mic] = time_domain('ant9.mat',micCol);
piezoa9 = window(piezo,1700,2300);
ira9 = window(ir,400,1100);
timepiezoa9 = timeaxis(piezoa9,freq);
timeira9 = timeaxis(ira9,freq);

subplot(2,2,3), plot(timepiezoa9,piezoa9,'r');
hold on;
[maxdexTP3 maxValTP3 mindexTP3 minValTP3]=signalPeaks(piezoa9,0.6);
plot(timepiezoa9(maxdexTP3),maxValTP3,'o',timepiezoa9(mindexTP3),minValTP3,'o');
hold off;
title('Ant9 PIEZO signal');
[anglep3x regionp3x] = placepeaks(piezoa9,maxdexTP3,timepiezoa9,MAX);
[anglep3n regionp3n] = placepeaks(piezoa9,mindexTP3,timepiezoa9,MIN);

subplot(2,2,4), plot(timeira9,ira9,'g');
title('Ant9 IR signal');


figure;
[PPIEZO_a8_1 FPIEZO_a8_1] = freq_domain(piezoa8_1,fftpt,freq);
[PPIEZO_a8_2 FPIEZO_a8_2] = freq_domain(piezoa8_2,fftpt,freq);
[PPIEZO_a9 FPIEZO_a9] = freq_domain(piezoa9,fftpt,freq);
[PIR_a9 FIR_a9] = freq_domain(ira9,fftpt,freq);

subplot(2,2,1), plot(FPIEZO_a8_1, PPIEZO_a8_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a8_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a8_1(indexFP1),maxValFP1,'o');
hold off;
title('Ant8 PIEZO Frequencies 1');
subplot(2,2,2), plot(FPIEZO_a8_2, PPIEZO_a8_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a8_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a8_2(indexFP2),maxValFP2,'o');
hold off;
title('Ant8 PIEZO Frequencies 2');
subplot(2,2,3), plot(FPIEZO_a9, PPIEZO_a9(12:((fftpt/2)+11)),'r');
hold on;
[indexFP3 maxValFP3 del ete]=signalPeaks(PPIEZO_a9(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a9(indexFP3),maxValFP3,'o');
hold off;
title('Ant9 PIEZO Frequencies');
subplot(2,2,4), plot(FIR_a9, PIR_a9(12:((fftpt/2)+11)),'g');
title('Ant9 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa8_1)) length(piezoa8_1); sum(abs(piezoa8_2)) length(piezoa8_2); sum(abs(piezoa9)) length(piezoa9)];
barplot_ir = [sum(abs(ira9)) length(ira9);];
barplot_mic = [0 0];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 8&9 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 9 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 8&9 sum|width');

figure;
var = runEnvelope(piezoa8_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant8 Piezo Envelope 1');
var = runEnvelope(piezoa8_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant8 Piezo Envelope 2');
var = runEnvelope(piezoa9);
[p3tri p3gauss] = getcorrn(var.out(2,:));
areaEP3 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant9 Piezo Envelope');

timepiezoa1x = timepiezoa8_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa1n = timepiezoa8_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezoa2x = timepiezoa8_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezoa2n = timepiezoa8_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timepiezoa3x = timepiezoa9(maxdexTP3)';
maxValTP3 = maxValTP2'; 
anglep3x = anglep3x'; 
regionp3x = regionp3x'; 
timepiezoa3n = timepiezoa9(mindexTP3)';
minValTP3 = minValTP3'; 
anglep3n = anglep3n'; 
regionp3n = regionp3n';
FPIEZO_a8_1 = FPIEZO_a8_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a8_2 = FPIEZO_a8_2(indexFP2)';
maxValFP2 = maxValFP2';
FPIEZO_a9 = FPIEZO_a9(indexFP3)';
maxValFP3 = maxValFP3';

% save('Ant8_9data.mat','timepiezoa1x','maxValTP1','anglep1x','regionp1x','timepiezoa1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezoa2x','maxValTP2','anglep2x','regionp2x','timepiezoa2n','minValTP2','anglep2n','regionp2n',...
%                      'timepiezoa3x','maxValTP3','anglep3x','regionp3x','timepiezoa3n','minValTP3','anglep3n','regionp3n',...
%                      'FPIEZO_a8_1','maxValFP1','FPIEZO_a8_2','maxValFP2','FPIEZO_a9','maxValFP3',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEP3');

numtimemaxpeaksP8 = length(maxValTP1)+length(maxValTP2);
avgtimemaxpeakvalP8 = (sum(maxValTP1)+sum(maxValTP2))/numtimemaxpeaksP8;
avgtimemaxpeakangleP8 = (sum(anglep1x)+sum(anglep2x))/(length(anglep1x)+length(anglep2x));
avgtimemaxpeakareaP8 = (sum(regionp1x)+sum(regionp2x))/(length(regionp1x)+length(regionp2x));
numtimeminpeaksP8 = length(minValTP1)+length(minValTP2);
avgtimeminpeakvalP8 = (sum(minValTP1)+sum(minValTP2))/numtimeminpeaksP8;
avgtimeminpeakangleP8 = (sum(anglep1n)+sum(anglep2n))/(length(anglep1n)+length(anglep2n));
avgtimeminpeakareaP8 = (sum(regionp1n)+sum(regionp2n))/(length(regionp1n)+length(regionp2n));
numfreqpeaksP8 = length(FPIEZO_a8_1)+length(FPIEZO_a8_2);
avgfreqpeakvalP8 = (sum(maxValFP1')+sum(maxValFP2'))/numfreqpeaksP8;
maxfreqpeakvalP8 = max(max(maxValFP1),max(maxValFP2));
maxfreqvalP8 = max(max(FPIEZO_a8_1),max(FPIEZO_a8_2));
minfreqpeakvalP8 = min(min(maxValFP1),min(maxValFP2));
minfreqvalP8 = min(min(FPIEZO_a8_1),min(FPIEZO_a8_2));
avgtimeenvelopeareaP8 = (areaEP1+areaEP2)/2;
avgtricorrP8 = (p1tri+p2tri)/2;
avggausscorrP8 = (p1gauss+p2gauss)/2;

numtimemaxpeaksP9 = length(maxValTP3);
avgtimemaxpeakvalP9 = (sum(maxValTP3))/numtimemaxpeaksP9;
avgtimemaxpeakangleP9 = (sum(anglep3x))/(length(anglep3x));
avgtimemaxpeakareaP9 = (sum(regionp3x))/(length(regionp3x));
numtimeminpeaksP9 = length(minValTP3);
avgtimeminpeakvalP9 = (sum(minValTP3))/numtimeminpeaksP9;
avgtimeminpeakangleP9 = (sum(anglep3n))/(length(anglep3n));
avgtimeminpeakareaP9 = (sum(regionp3n))/(length(regionp3n));
numfreqpeaksP9 = length(FPIEZO_a9);
avgfreqpeakvalP9 = (sum(maxValFP3'))/numfreqpeaksP9;
maxfreqpeakvalP9 = (max(maxValFP3));
maxfreqvalP9 = (max(FPIEZO_a9));
minfreqpeakvalP9 = (min(maxValFP3));
minfreqvalP9 = (min(FPIEZO_a9));
avgtimeenvelopeareaP9 = areaEP3;
avgtricorrP9 = (p3tri);
avggausscorrP9 = (p3gauss);

save('Ant8_9data.mat','numtimemaxpeaksP8','avgtimemaxpeakvalP8','avgtimemaxpeakangleP8','avgtimemaxpeakareaP8',...
      'numtimeminpeaksP8','avgtimeminpeakvalP8','avgtimeminpeakangleP8','avgtimeminpeakareaP8',...
      'numfreqpeaksP8','avgfreqpeakvalP8','maxfreqpeakvalP8','maxfreqvalP8','minfreqpeakvalP8','minfreqvalP8','avgtimeenvelopeareaP8',...
      'avgtricorrP8','avggausscorrP8',...
      'numtimemaxpeaksP9','avgtimemaxpeakvalP9','avgtimemaxpeakangleP9','avgtimemaxpeakareaP9',...
      'numtimeminpeaksP9','avgtimeminpeakvalP9','avgtimeminpeakangleP9','avgtimeminpeakareaP9',...
      'numfreqpeaksP9','avgfreqpeakvalP9','maxfreqpeakvalP9','maxfreqvalP9','minfreqpeakvalP9','minfreqvalP9','avgtimeenvelopeareaP9',...
      'avgtricorrP9','avggausscorrP9');