function Roach1_Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 5;

[piezo ir mic] = time_domain('roach1.mat',micCol);
piezor1_1 = window(piezo,2050,2450);
piezor1_2 = window(piezo,8950,10050);
irr1_1 = window(ir,2770,3500);
irr1_2 = window(ir,8440,8760);
micr1 = window(mic,7300,7500);
timepiezor1_1 = timeaxis(piezor1_1,freq);
timepiezor1_2 = timeaxis(piezor1_2,freq);
timeirr1_1 = timeaxis(irr1_1,freq);
timeirr1_2 = timeaxis(irr1_2,freq);
timemicr1 = timeaxis(micr1,freq);

figure;
subplot(2,3,1), plot(timepiezor1_1,piezor1_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezor1_1,0.6);
plot(timepiezor1_1(maxdexTP1),maxValTP1,'o',timepiezor1_1(mindexTP1),minValTP1,'o');
hold off;
title('Roach1 PIEZO signal 1');
[anglep1x regionp1x] = placepeaks(piezor1_1,maxdexTP1,timepiezor1_1,MAX);
[anglep1n regionp1n] = placepeaks(piezor1_1,mindexTP1,timepiezor1_1,MIN);

subplot(2,3,2), plot(timepiezor1_2,piezor1_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezor1_2,0.6);
plot(timepiezor1_2(maxdexTP2),maxValTP2,'o',timepiezor1_2(mindexTP2),minValTP2,'o');
hold off;
title('Roach1 PIEZO signal 2');
[anglep2x regionp2x] = placepeaks(piezor1_2,maxdexTP2,timepiezor1_2,MAX);
[anglep2n regionp2n] = placepeaks(piezor1_2,mindexTP2,timepiezor1_2,MIN);

subplot(2,3,3), plot(timeirr1_1,irr1_1,'g');
title('Roach1 IR signal 1');
subplot(2,3,4), plot(timeirr1_2,irr1_2,'g');
title('Roach1 IR signal 2');

subplot(2,3,5), plot(timemicr1,micr1,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(micr1,0.6);
plot(timemicr1(maxdexTM1),maxValTM1,'o',timemicr1(mindexTM1),minValTM1,'o');
hold off;
title('Roach1 MIC signal');
[anglem1x regionm1x] = placepeaks(micr1,maxdexTM1,timemicr1,MAX);
[anglem1n regionm1n] = placepeaks(micr1,mindexTM1,timemicr1,MIN);

figure;
[PPIEZO_r1_1 FPIEZO_r1_1] = freq_domain(piezor1_1,fftpt,freq);
[PPIEZO_r1_2 FPIEZO_r1_2] = freq_domain(piezor1_2,fftpt,freq);
[PIR_r1_1 FIR_r1_1] = freq_domain(irr1_1,fftpt,freq);
[PIR_r1_2 FIR_r1_2] = freq_domain(irr1_2,fftpt,freq);
[PMIC_r1 FMIC_r1] = freq_domain(micr1,fftpt,freq);
subplot(2,3,1), plot(FPIEZO_r1_1, PPIEZO_r1_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_r1_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r1_1(indexFP1),maxValFP1,'o');
hold off;
title('Roach1 PIEZO Frequencies 1');
subplot(2,3,2), plot(FPIEZO_r1_2, PPIEZO_r1_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_r1_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_r1_2(indexFP2),maxValFP2,'o');
hold off;
title('Roach1 PIEZO Frequencies 2');
subplot(2,3,3), plot(FIR_r1_1, PIR_r1_1(12:((fftpt/2)+11)),'g');
title('Roach1 IR Frequencies 1');
subplot(2,3,4), plot(FIR_r1_2, PIR_r1_2(12:((fftpt/2)+11)),'g');
title('Roach1 IR Frequencies 2');
subplot(2,3,5), plot(FMIC_r1, PMIC_r1(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_r1(12:((fftpt/2)+11)),0.4);
plot(FMIC_r1(indexFM1),maxValFM1,'o');
hold off;
title('Roach1 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezor1_1)) length(piezor1_1); sum(abs(piezor1_2)) length(piezor1_2)];
barplot_ir = [sum(abs(irr1_1)) length(irr1_1); sum(abs(irr1_2)) length(irr1_2)];
barplot_mic = [sum(abs(micr1)) length(micr1)];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC sum|width');

figure;
var = runEnvelope(piezor1_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach1 Piezo 1 Envelope');
var = runEnvelope(piezor1_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Roach1 Piezo 2 Envelope');
var = runEnvelope(micr1);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Roach1 MIC Envelope');

timepiezor1x = timepiezor1_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezor1n = timepiezor1_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezor2x = timepiezor1_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezor2n = timepiezor1_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timemicr1x = timemicr1(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemicr1n = timemicr1(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_r1_1 = FPIEZO_r1_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_r1_2 = FPIEZO_r1_2(indexFP2)';
maxValFP2 = maxValFP2';
FMIC_r1 = FMIC_r1(indexFM1)';
maxValFM1 = maxValFM1';

% save('Roach1data.mat','timepiezor1x','maxValTP1','anglep1x','regionp1x','timepiezor1n','minValTP1','anglep1n','regionp1n',...
%                     'timepiezor2x','maxValTP2','anglep2x','regionp2x','timepiezor2n','minValTP2','anglep2n','regionp2n',...
%                      'timemicr1x','maxValTM1','anglem1x','regionm1x','timemicr1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_r1_1','maxValFP1','FPIEZO_r1_2','maxValFP2','FMIC_r1','maxValFM1',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1');

numtimemaxpeaksP = length(maxValTP1)+length(maxValTP2);
avgtimemaxpeakvalP = (sum(maxValTP1)+sum(maxValTP2))/numtimemaxpeaksP;
avgtimemaxpeakangleP = (sum(anglep1x)+sum(anglep2x))/(length(anglep1x)+length(anglep2x));
avgtimemaxpeakareaP = (sum(regionp1x)+sum(regionp2x))/(length(regionp1x)+length(regionp2x));
numtimeminpeaksP = length(minValTP1)+length(minValTP2);
avgtimeminpeakvalP = (sum(minValTP1)+sum(minValTP2))/numtimeminpeaksP;
avgtimeminpeakangleP = (sum(anglep1n)+sum(anglep2n))/(length(anglep1n)+length(anglep2n));
avgtimeminpeakareaP = (sum(regionp1n)+sum(regionp2n))/(length(regionp1n)+length(regionp2n));
numfreqpeaksP = length(FPIEZO_r1_1)+length(FPIEZO_r1_2);
avgfreqpeakvalP = (sum(maxValFP1')+sum(maxValFP2'))/numfreqpeaksP;
maxfreqpeakvalP = max(max(maxValFP1),max(maxValFP2));
maxfreqvalP = max(max(FPIEZO_r1_1),max(FPIEZO_r1_2));
minfreqpeakvalP = min(min(maxValFP1),min(maxValFP2));
minfreqvalP = min(min(FPIEZO_r1_1),min(FPIEZO_r1_2));
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
numfreqpeaksM = length(FMIC_r1);
avgfreqpeakvalM = (sum(maxValFM1')/numfreqpeaksM);
maxfreqpeakvalM = max(maxValFM1);
maxfreqvalM = max(FMIC_r1);
minfreqpeakvalM = min(maxValFM1);
minfreqvalM = min(FMIC_r1);
avgtimeenvelopeareaM = (areaEM1);
avgtricorrM = (m1tri);
avggausscorrM = (m1gauss);

save('Roach1data.mat','numtimemaxpeaksP','avgtimemaxpeakvalP','avgtimemaxpeakangleP','avgtimemaxpeakareaP',...
      'numtimeminpeaksP','avgtimeminpeakvalP','avgtimeminpeakangleP','avgtimeminpeakareaP',...
      'numfreqpeaksP','avgfreqpeakvalP','maxfreqpeakvalP','maxfreqvalP','minfreqpeakvalP','minfreqvalP','avgtimeenvelopeareaP',...
      'avgtricorrP','avggausscorrP',...
      'numtimemaxpeaksM','avgtimemaxpeakvalM','avgtimemaxpeakangleM','avgtimemaxpeakareaM',...
      'numtimeminpeaksM','avgtimeminpeakvalM','avgtimeminpeakangleM','avgtimeminpeakareaM',...
      'numfreqpeaksM','avgfreqpeakvalM','maxfreqpeakvalM','maxfreqvalM','minfreqpeakvalM','minfreqvalM','avgtimeenvelopeareaM',...
      'avgtricorrM','avggausscorrM');
                 
                 