function Roach2_3_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;


[piezo ir mic] = time_domain('roach2.mat',micCol);
piezor2 = window(piezo,1450,1870);
irr2_1 = window(ir,1,650);
irr2_2 = window(ir,1300,1550);
timepiezor2 = timeaxis(piezor2,freq);
timeirr2_1 = timeaxis(irr2_1,freq);
timeirr2_2 = timeaxis(irr2_2,freq);

figure;
subplot(2,3,1), plot(timepiezor2,piezor2,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor2,0.6);
plot(timepiezor2(maxdexTP1),maxValTP1,'o',timepiezor2(mindexTP1),minValTP1,'o');
hold off;
title('Roach2 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezor2,maxdexTP1,timepiezor2,MAX);
[anglep1n regionp1n] = placepeaks(piezor2,mindexTP1,timepiezor2,MIN);

subplot(2,3,2), plot(timeirr2_1,irr2_1,'g');
title('Roach2 IR signal 1');
subplot(2,3,3), plot(timeirr2_2,irr2_2,'g');
title('Roach2 IR signal 2');

[piezo ir mic] = time_domain('roach3.mat',micCol);
piezor3 = window(piezo,4130,4900);
irr3 = window(ir,4760,5900);
timepiezor3 = timeaxis(piezor3,freq);
timeirr3 = timeaxis(irr3,freq);

subplot(2,3,4), plot(timepiezor3,piezor3,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor3,0.6);
plot(timepiezor3(maxdexTP2),maxValTP2,'o',timepiezor3(mindexTP2),minValTP2,'o');
hold off;
title('Roach3 PIEZO signal');
[anglep2x regionp2x] = placepeaks(piezor3,maxdexTP2,timepiezor3,MAX);
[anglep2n regionp2n] = placepeaks(piezor3,mindexTP2,timepiezor3,MIN);

subplot(2,3,5), plot(timeirr3,irr3,'g');
title('Roach3 IR signal');

figure;
[PPIEZO_r2 FPIEZO_r2] = freq_domain(piezor2,fftpt,freq);
[PIR_r2_1 FIR_r2_1] = freq_domain(irr2_1,fftpt,freq);
[PIR_r2_2 FIR_r2_2] = freq_domain(irr2_2,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_r2, PPIEZO_r2(30:((fftpt/2)+29)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r2(30:((fftpt/2)+29)),0.4);
plot(FPIEZO_r2(indexFP1),maxValFP1,'o');
hold off;
title('Roach2 PIEZO Frequencies');
subplot(2,3,2), plot(FIR_r2_1, PIR_r2_1(30:((fftpt/2)+29)),'g');
title('Roach2 IR Frequencies 1');
subplot(2,3,3), plot(FIR_r2_2, PIR_r2_2(20:((fftpt/2)+19)),'g');
title('Roach2 IR Frequencies 2');

[PPIEZO_r3 FPIEZO_r3] = freq_domain(piezor3,fftpt,freq);
[PIR_r3 FIR_r3] = freq_domain(irr3,fftpt,freq);
subplot(2,3,4), plot(FPIEZO_r3, PPIEZO_r3(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r3(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r3(indexFP2),maxValFP2,'o');
hold off;
title('Roach3 PIEZO Frequencies');
subplot(2,3,5), plot(FIR_r3, PIR_r3(20:((fftpt/2)+19)),'g');
title('Roach3 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezor2)) length(piezor2); sum(abs(piezor3)) length(piezor3)];
barplot_ir1 = [sum(abs(irr2_1)) length(irr2_1); sum(abs(irr2_2)) length(irr2_2)];
barplot_ir2 = [sum(abs(irr3)) length(irr3)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 2&3 sum|width');
subplot(2,2,2), bar(barplot_ir1,'group');
title('IR Roach 2 sum|width');
subplot(2,2,3), bar(barplot_ir2,'group');
title('IR Roach 3 sum|width');

figure;
var = runEnvelope(piezor2);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(1,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach2 Piezo Envelope');
var = runEnvelope(piezor3);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(1,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach3 Piezo Envelope');

timepiezor1x = timepiezor2(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor2(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor3(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor3(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
FPIEZO_r2 = FPIEZO_r2(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r3 = FPIEZO_r3(indexFP2)';
maxValFP2 = maxValFP2';

% save('Roach2_3data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'FPIEZO_r2','maxValFP1','FPIEZO_r3','maxValFP2',...
%                      'barplot_piezo','barplot_ir1','barplot_ir2','areaEP1','areaEP2');

numtimemaxpeaksP2 = length(maxValTP1);
avgtimemaxpeakvalP2 = (sum(maxValTP1))/numtimemaxpeaksP2;
avgtimemaxpeakangleP2 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP2 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP2 = length(minValTP1);
avgtimeminpeakvalP2 = (sum(minValTP1))/numtimeminpeaksP2;
avgtimeminpeakangleP2 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP2 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP2 = length(FPIEZO_r2);
avgfreqpeakvalP2 = (sum(maxValFP1'))/numfreqpeaksP2;
maxfreqpeakvalP2 = max(maxValFP1);
maxfreqvalP2 = (max(FPIEZO_r2));
minfreqpeakvalP2 = (min(maxValFP1));
minfreqvalP2 = (min(FPIEZO_r2));
avgtimeenvelopeareaP2 = areaEP1;
avgtricorrP2 = (p1tri);
avggausscorrP2 = (p1gauss);

numtimemaxpeaksP3 = length(maxValTP2);
avgtimemaxpeakvalP3 = (sum(maxValTP2))/numtimemaxpeaksP3;
avgtimemaxpeakangleP3 = (sum(anglep2x))/(length(anglep2x));
avgtimemaxpeakareaP3 = (sum(regionp2x))/(length(regionp2x));
numtimeminpeaksP3 = length(minValTP2);
avgtimeminpeakvalP3 = (sum(minValTP2))/numtimeminpeaksP3;
avgtimeminpeakangleP3 = (sum(anglep2n))/(length(anglep2n));
avgtimeminpeakareaP3 = (sum(regionp2n))/(length(regionp2n));
numfreqpeaksP3 = length(FPIEZO_r3);
avgfreqpeakvalP3 = (sum(maxValFP2'))/numfreqpeaksP3;
maxfreqpeakvalP3 = (max(maxValFP2));
maxfreqvalP3 = (max(FPIEZO_r3));
minfreqpeakvalP3 = (min(maxValFP2));
minfreqvalP3 = (min(FPIEZO_r3));
avgtimeenvelopeareaP3 = areaEP2;
avgtricorrP3 = (p2tri);
avggausscorrP3 = (p2gauss);

save('Roach2_3data.mat','numtimemaxpeaksP2','avgtimemaxpeakvalP2','avgtimemaxpeakangleP2','avgtimemaxpeakareaP2',...
      'numtimeminpeaksP2','avgtimeminpeakvalP2','avgtimeminpeakangleP2','avgtimeminpeakareaP2',...
      'numfreqpeaksP2','avgfreqpeakvalP2','maxfreqpeakvalP2','maxfreqvalP2','minfreqpeakvalP2','minfreqvalP2','avgtimeenvelopeareaP2',...
      'avgtricorrP2','avggausscorrP2',...
      'numtimemaxpeaksP3','avgtimemaxpeakvalP3','avgtimemaxpeakangleP3','avgtimemaxpeakareaP3',...
      'numtimeminpeaksP3','avgtimeminpeakvalP3','avgtimeminpeakangleP3','avgtimeminpeakareaP3',...
      'numfreqpeaksP3','avgfreqpeakvalP3','maxfreqpeakvalP3','maxfreqvalP3','minfreqpeakvalP3','minfreqvalP3','avgtimeenvelopeareaP3',...
      'avgtricorrP3','avggausscorrP3');