function Roach5_7_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;

[piezo ir mic] = time_domain('roach5.mat',micCol);
piezor5 = window(piezo,3250,3600);
irr5 = window(ir,1930,3320);
micr5 = window(mic,1120,1210);
timepiezor5 = timeaxis(piezor5,freq);
timeirr5 = timeaxis(irr5,freq);
timemicr5 = timeaxis(micr5,freq);

figure;
subplot(2,3,1), plot(timepiezor5,piezor5,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor5,0.6);
plot(timepiezor5(maxdexTP1),maxValTP1,'o',timepiezor5(mindexTP1),minValTP1,'o');
hold off;
title('Roach5 PIEZO signal');
[anglep1x regionp1x] = placepeaks(piezor5,maxdexTP1,timepiezor5,MAX);
[anglep1n regionp1n] = placepeaks(piezor5,mindexTP1,timepiezor5,MIN);

subplot(2,3,2), plot(timeirr5,irr5,'g');
title('Roach5 IR signal');

subplot(2,3,3), plot(timemicr5,micr5,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr5,0.6);
plot(timemicr5(maxdexTM1),maxValTM1,'o',timemicr5(mindexTM1),minValTM1,'o');
hold off;
title('Roach5 MIC signal');
[anglem1x regionm1x] = placepeaks(micr5,maxdexTM1,timemicr5,MAX);
[anglem1n regionm1n] = placepeaks(micr5,mindexTM1,timemicr5,MIN);

[piezo ir mic] = time_domain('roach7.mat',micCol);
piezor7 = window(piezo,1400,2000);
irr7 = window(ir,800,1500);
timepiezor7 = timeaxis(piezor7,freq);
timeirr7 = timeaxis(irr7,freq);

subplot(2,3,4), plot(timepiezor7,piezor7,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor7,0.6);
plot(timepiezor7(maxdexTP2),maxValTP2,'o',timepiezor7(mindexTP2),minValTP2,'o');
hold off;
title('Roach7 PIEZO signal');
[anglep2x regionp2x] = placepeaks(piezor7,maxdexTP2,timepiezor7,MAX);
[anglep2n regionp2n] = placepeaks(piezor7,mindexTP2,timepiezor7,MIN);

subplot(2,3,5), plot(timeirr7,irr7,'g');
title('Roach7 IR signal');

figure;
[PPIEZO_r5 FPIEZO_r5] = freq_domain(piezor5,fftpt,freq);
[PIR_r5 FIR_r5] = freq_domain(irr5,fftpt,freq);
[PMIC_r5 FMIC_r5] = freq_domain(micr5,fftpt,freq);

subplot(2,3,1), plot(FPIEZO_r5, PPIEZO_r5(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r5(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r5(indexFP1),maxValFP1,'o');
hold off;
title('Roach5 PIEZO Frequencies');
subplot(2,3,2), plot(FIR_r5, PIR_r5(12:((fftpt/2)+11)),'g');
title('Roach5 IR Frequencies');
subplot(2,3,3), plot(FMIC_r5, PMIC_r5(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r5(12:((fftpt/2)+11)),0.4);
plot(FMIC_r5(indexFM1),maxValFM1,'o');
hold off;
title('Roach5 MIC Frequencies');

[PPIEZO_r7 FPIEZO_r7] = freq_domain(piezor7,fftpt,freq);
[PIR_r7 FIR_r7] = freq_domain(irr7,fftpt,freq);
subplot(2,3,4), plot(FPIEZO_r7, PPIEZO_r7(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r7(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r7(indexFP2),maxValFP2,'o');
hold off;
title('Roach7 PIEZO Frequencies');
subplot(2,3,5), plot(FIR_r7, PIR_r7(12:((fftpt/2)+11)),'g');
title('Roach7 IR Frequencies');

figure;
barplot_piezo = [sum(abs(piezor5)) length(piezor5); sum(abs(piezor7)) length(piezor7)];
barplot_ir = [sum(abs(irr5)) length(irr5); sum(abs(irr7)) length(irr7)];
barplot_mic = [sum(abs(micr5)) length(micr5)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Roach 5&7 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Roach 5&7 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Roach 5 sum|width');

figure;
var = runEnvelope(piezor5);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach5 Piezo Envelope');
var = runEnvelope(micr5);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach5 MIC Envelope');
var = runEnvelope(piezor7);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach7 Piezo Envelope');

timepiezor1x = timepiezor5(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor5(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor7(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor7(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timemicr1x = timemicr5(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr5(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_r5 = FPIEZO_r5(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r7 = FPIEZO_r7(indexFP2)';
maxValFP2 = maxValFP2';
FMIC_r5 = FMIC_r5(indexFM1)';
maxValFM1 = maxValFM1';

% save('Roach5_7data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_r5','maxValFP1','FPIEZO_r7','maxValFP2','FMIC_r5','maxValFM1',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1');

numtimemaxpeaksP5 = length(maxValTP1);
avgtimemaxpeakvalP5 = (sum(maxValTP1))/numtimemaxpeaksP5;
avgtimemaxpeakangleP5 = (sum(anglep1x))/(length(anglep1x));
avgtimemaxpeakareaP5 = (sum(regionp1x))/(length(regionp1x));
numtimeminpeaksP5 = length(minValTP1);
avgtimeminpeakvalP5 = (sum(minValTP1))/numtimeminpeaksP5;
avgtimeminpeakangleP5 = (sum(anglep1n))/(length(anglep1n));
avgtimeminpeakareaP5 = (sum(regionp1n))/(length(regionp1n));
numfreqpeaksP5 = length(FPIEZO_r5);
avgfreqpeakvalP5 = (sum(maxValFP1'))/numfreqpeaksP5;
maxfreqpeakvalP5 = max(maxValFP1);
maxfreqvalP5 = (max(FPIEZO_r5));
minfreqpeakvalP5 = (min(maxValFP1));
minfreqvalP5 = (min(FPIEZO_r5));
avgtimeenvelopeareaP5 = areaEP1;
avgtricorrP5 = (p1tri);
avggausscorrP5 = (p1gauss);

numtimemaxpeaksP7 = length(maxValTP2);
avgtimemaxpeakvalP7 = (sum(maxValTP2))/numtimemaxpeaksP7;
avgtimemaxpeakangleP7 = (sum(anglep2x))/(length(anglep2x));
avgtimemaxpeakareaP7 = (sum(regionp2x))/(length(regionp2x));
numtimeminpeaksP7 = length(minValTP2);
avgtimeminpeakvalP7 = (sum(minValTP2))/numtimeminpeaksP7;
avgtimeminpeakangleP7 = (sum(anglep2n))/(length(anglep2n));
avgtimeminpeakareaP7 = (sum(regionp2n))/(length(regionp2n));
numfreqpeaksP7 = length(FPIEZO_r7);
avgfreqpeakvalP7 = (sum(maxValFP2'))/numfreqpeaksP7;
maxfreqpeakvalP7 = (max(maxValFP2));
maxfreqvalP7 = (max(FPIEZO_r7));
minfreqpeakvalP7 = (min(maxValFP2));
minfreqvalP7 = (min(FPIEZO_r7));
avgtimeenvelopeareaP7 = areaEP2;
avgtricorrP7 = (p2tri);
avggausscorrP7 = (p2gauss);

numtimemaxpeaksM5 = length(maxValTM1);
avgtimemaxpeakvalM5 = (sum(maxValTM1))/numtimemaxpeaksM5;
avgtimemaxpeakangleM5 = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM5 = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM5 = length(minValTM1);
avgtimeminpeakvalM5 = (sum(minValTM1))/numtimeminpeaksM5;
avgtimeminpeakangleM5 = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM5 = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM5 = length(FMIC_r5);
avgfreqpeakvalM5 = (sum(maxValFM1')/numfreqpeaksM5);
maxfreqpeakvalM5 = max(maxValFM1);
maxfreqvalM5 = max(FMIC_r5);
minfreqpeakvalM5 = min(maxValFM1);
minfreqvalM5 = min(FMIC_r5);
avgtimeenvelopeareaM5 = (areaEM1);
avgtricorrM5 = (m1tri);
avggausscorrM5 = (m1gauss);

save('Roach5_7data.mat','numtimemaxpeaksP5','avgtimemaxpeakvalP5','avgtimemaxpeakangleP5','avgtimemaxpeakareaP5',...
      'numtimeminpeaksP5','avgtimeminpeakvalP5','avgtimeminpeakangleP5','avgtimeminpeakareaP5',...
      'numfreqpeaksP5','avgfreqpeakvalP5','maxfreqpeakvalP5','maxfreqvalP5','minfreqpeakvalP5','minfreqvalP5','avgtimeenvelopeareaP5',...
      'avgtricorrP5','avggausscorrP5',...
      'numtimemaxpeaksP7','avgtimemaxpeakvalP7','avgtimemaxpeakangleP7','avgtimemaxpeakareaP7',...
      'numtimeminpeaksP7','avgtimeminpeakvalP7','avgtimeminpeakangleP7','avgtimeminpeakareaP7',...
      'numfreqpeaksP7','avgfreqpeakvalP7','maxfreqpeakvalP7','maxfreqvalP7','minfreqpeakvalP7','minfreqvalP7','avgtimeenvelopeareaP7',...
      'avgtricorrP7','avggausscorrP7',...
      'numtimemaxpeaksM5','avgtimemaxpeakvalM5','avgtimemaxpeakangleM5','avgtimemaxpeakareaM5',...
      'numtimeminpeaksM5','avgtimeminpeakvalM5','avgtimeminpeakangleM5','avgtimeminpeakareaM5',...
      'numfreqpeaksM5','avgfreqpeakvalM5','maxfreqpeakvalM5','maxfreqvalM5','minfreqpeakvalM5','minfreqvalM5','avgtimeenvelopeareaM5',...
      'avgtricorrM5','avggausscorrM5');
  