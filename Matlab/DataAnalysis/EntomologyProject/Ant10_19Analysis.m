function Ant10_19Analysis()
fftpt = 512;
freq = 1000;
MAX=1;
MIN=2;
micCol = 3;

[piezo ir mic] = time_domain('ant10.mat',micCol);
piezoa10_1 = window(piezo,1,800);
piezoa10_2 = window(piezo,8500,9500);
ira10 = window(ir,1,600);
timepiezoa10_1 = timeaxis(piezoa10_1,freq);
timepiezoa10_2 = timeaxis(piezoa10_2,freq);
timeira10 = timeaxis(ira10,freq);

figure;
subplot(2,3,1), plot(timepiezoa10_1,piezoa10_1,'r');
hold on;
[maxdexTP1 maxValTP1 mindexTP1 minValTP1]=signalPeaks(piezoa10_1,0.6);
plot(timepiezoa10_1(maxdexTP1),maxValTP1,'o',timepiezoa10_1(mindexTP1),minValTP1,'o');
hold off;
title('Ant10 PIEZO signal 1');
%[anglep1x regionp1x] = placepeaks(piezoa10_1,maxdexTP1,timepiezoa10_1,MAX);
anglep1x=0;
regionp1x=0;
[anglep1n regionp1n] = placepeaks(piezoa10_1,mindexTP1,timepiezoa10_1,MIN);

subplot(2,3,2), plot(timepiezoa10_2,piezoa10_2,'r');
hold on;
[maxdexTP2 maxValTP2 mindexTP2 minValTP2]=signalPeaks(piezoa10_2,0.6);
plot(timepiezoa10_2(maxdexTP2),maxValTP2,'o',timepiezoa10_2(mindexTP2),minValTP2,'o');
hold off;
title('Ant10 PIEZO signal 2');
%[anglep2x regionp2x] = placepeaks(piezoa10_2,maxdexTP2,timepiezoa10_2,MAX);
anglep2x=0; 
regionp2x=0;
[anglep2n regionp2n] = placepeaks(piezoa10_2,mindexTP2,timepiezoa10_2,MIN);

subplot(2,3,3), plot(timeira10,ira10,'g');
title('Ant10 IR signal');

[piezo ir mic] = time_domain('ant19.mat',micCol);
ira19 = window(ir,7750,10430);
mica19 = window(mic,8500,8800);
timeira19 = timeaxis(ira19,freq);
timemica19 = timeaxis(mica19,freq);

subplot(2,3,4), plot(timeira19,ira19,'g');
title('Ant19 IR signal');

subplot(2,3,5), plot(timemica19,mica19,'b');
hold on;
[maxdexTM1 maxValTM1 mindexTM1 minValTM1]=signalPeaks(mica19,0.6);
plot(timemica19(maxdexTM1),maxValTM1,'o',timemica19(mindexTM1),minValTM1,'o');
hold off;
title('Ant19 MIC signal');
[anglem1x regionm1x] = placepeaks(mica19,maxdexTM1,timemica19,MAX);
[anglem1n regionm1n] = placepeaks(mica19,mindexTM1,timemica19,MIN);

figure;
[PPIEZO_a10_1 FPIEZO_a10_1] = freq_domain(piezoa10_1,fftpt,freq);
[PPIEZO_a10_2 FPIEZO_a10_2] = freq_domain(piezoa10_2,fftpt,freq);
[PIR_a10 FIR_a10] = freq_domain(ira10,fftpt,freq);
[PIR_a19 FIR_a19] = freq_domain(ira19,fftpt,freq);
[PMIC_a19 FMIC_a19] = freq_domain(mica19,fftpt,freq);

subplot(2,3,1), plot(FPIEZO_a10_1, PPIEZO_a10_1(12:((fftpt/2)+11)),'r');
hold on;
[indexFP1 maxValFP1 del ete]=signalPeaks(PPIEZO_a10_1(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a10_1(indexFP1),maxValFP1,'o');
hold off;
title('Ant10 PIEZO Frequencies 1');
subplot(2,3,2), plot(FPIEZO_a10_2, PPIEZO_a10_2(12:((fftpt/2)+11)),'r');
hold on;
[indexFP2 maxValFP2 del ete]=signalPeaks(PPIEZO_a10_2(12:((fftpt/2)+11)),0.4);
plot(FPIEZO_a10_2(indexFP2),maxValFP2,'o');
hold off;
title('Ant10 PIEZO Frequencies 2');
subplot(2,3,3), plot(FIR_a10, PIR_a10(12:((fftpt/2)+11)),'g');
title('Ant10 IR Frequencies');
subplot(2,3,4), plot(FIR_a19, PIR_a19(12:((fftpt/2)+11)),'g');
title('Ant19 IR Frequencies');
subplot(2,3,5), plot(FMIC_a19, PMIC_a19(12:((fftpt/2)+11)),'b');
hold on;
[indexFM1 maxValFM1 del ete]=signalPeaks(PMIC_a19(12:((fftpt/2)+11)),0.4);
plot(FMIC_a19(indexFM1),maxValFM1,'o');
hold off;
title('Ant19 MIC Frequencies');

figure;
barplot_piezo = [sum(abs(piezoa10_1)) length(piezoa10_1);sum(abs(piezoa10_2)) length(piezoa10_2);];
barplot_ir = [sum(abs(ira10)) length(ira10); sum(abs(ira19)) length(ira19);];
barplot_mic = [sum(abs(mica19)) length(mica19);];
subplot(2,2,1), bar(barplot_piezo,'group');
title('PIEZO Ant 10&19 sum|width');
subplot(2,2,2), bar(barplot_ir,'group');
title('IR Ant 10&19 sum|width');
subplot(2,2,3), bar(barplot_mic,'group');
title('MIC Ant 19 sum|width');

figure;
var = runEnvelope(piezoa10_1);
[p1tri p1gauss] = getcorrn(var.out(2,:));
areaEP1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,1), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant10 Piezo Envelope 1');
var = runEnvelope(piezoa10_2);
[p2tri p2gauss] = getcorrn(var.out(2,:));
areaEP2 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,2), area(var.out(1,:),var.out(2,:),'FaceColor','r');
title('Ant10 Piezo Envelope 2');
var = runEnvelope(mica19);
[m1tri m1gauss] = getcorrn(var.out(2,:));
areaEM1 = Areaundercurve(var.out(1,:),var.out(2,:));
subplot(2,2,3), area(var.out(1,:),var.out(2,:),'FaceColor','b');
title('Ant19 MIC Envelope');

timepiezoa1x = timepiezoa10_1(maxdexTP1)';
maxValTP1 = maxValTP1'; 
anglep1x = anglep1x'; 
regionp1x = regionp1x'; 
timepiezoa1n = timepiezoa10_1(mindexTP1)';
minValTP1 = minValTP1'; 
anglep1n = anglep1n'; 
regionp1n = regionp1n';
timepiezoa2x = timepiezoa10_2(maxdexTP2)';
maxValTP2 = maxValTP2'; 
anglep2x = anglep2x'; 
regionp2x = regionp2x'; 
timepiezoa2n = timepiezoa10_2(mindexTP2)';
minValTP2 = minValTP2'; 
anglep2n = anglep2n'; 
regionp2n = regionp2n';
timemica1x = timemica19(maxdexTM1)';
maxValTM1 = maxValTM1';
anglem1x = anglem1x';
regionm1x = regionm1x';
timemica1n = timemica19(mindexTM1)';
minValTM1 = minValTM1';
anglem1n = anglem1n';
regionm1n = regionm1n';
FPIEZO_a10_1 = FPIEZO_a10_1(indexFP1)';
maxValFP1 = maxValFP1';
FPIEZO_a10_2 = FPIEZO_a10_2(indexFP2)';
maxValFP2 = maxValFP2';
FMIC_a19 = FMIC_a19(indexFM1)';
maxValFM1 = maxValFM1';

% save('Ant6data.mat','timepiezoa1x','maxValTP1','anglep1x','regionp1x','timepiezoa1n','minValTP1','anglep1n','regionp1n',...
%                      'timepiezoa2x','maxValTP2','anglep2x','regionp2x','timepiezoa2n','minValTP2','anglep2n','regionp2n',...
%                      'timemica1x','maxValTM1','anglem1x','regionm1x','timemica1n','minValTM1','anglem1n','regionm1n',...
%                      'FPIEZO_a10_1','maxValFP1','FPIEZO_a10_2','maxValFP2','FMIC_a19','maxValFM1',...
%                      'barplot_piezo','barplot_ir','barplot_mic','areaEP1','areaEP2','areaEM1');

numtimemaxpeaksP10 = length(maxValTP1)+length(maxValTP2);
avgtimemaxpeakvalP10 = (sum(maxValTP1)+sum(maxValTP2))/numtimemaxpeaksP10;
avgtimemaxpeakangleP10 = (sum(anglep1x)+sum(anglep2x))/(length(anglep1x)+length(anglep2x));
avgtimemaxpeakareaP10 = (sum(regionp1x)+sum(regionp2x))/(length(regionp1x)+length(regionp2x));
numtimeminpeaksP10 = length(minValTP1)+length(minValTP2);
avgtimeminpeakvalP10 = (sum(minValTP1)+sum(minValTP2))/numtimeminpeaksP10;
avgtimeminpeakangleP10 = (sum(anglep1n)+sum(anglep2n))/(length(anglep1n)+length(anglep2n));
avgtimeminpeakareaP10 = (sum(regionp1n)+sum(regionp2n))/(length(regionp1n)+length(regionp2n));
numfreqpeaksP10 = length(FPIEZO_a10_1)+length(FPIEZO_a10_2);
avgfreqpeakvalP10 = (sum(maxValFP1')+sum(maxValFP2'))/numfreqpeaksP10;
maxfreqpeakvalP10 = max(max(maxValFP1),max(maxValFP2));
maxfreqvalP10 = max(max(FPIEZO_a10_1),max(FPIEZO_a10_2));
minfreqpeakvalP10 = min(min(maxValFP1),min(maxValFP2));
minfreqvalP10 = min(min(FPIEZO_a10_1),min(FPIEZO_a10_2));
avgtimeenvelopeareaP10 = (areaEP1+areaEP2)/2;
avgtricorrP10 = (p1tri+p2tri)/2;
avggausscorrP10 = (p1gauss+p2gauss)/2;

numtimemaxpeaksM19 = length(maxValTM1);
avgtimemaxpeakvalM19 = (sum(maxValTM1))/numtimemaxpeaksM19;
avgtimemaxpeakangleM19 = (sum(anglem1x))/(length(anglem1x));
avgtimemaxpeakareaM19 = (sum(regionm1x))/(length(regionm1x));
numtimeminpeaksM19 = length(minValTM1);
avgtimeminpeakvalM19 = (sum(minValTM1))/numtimeminpeaksM19;
avgtimeminpeakangleM19 = (sum(anglem1n))/(length(anglem1n));
avgtimeminpeakareaM19 = (sum(regionm1n))/(length(regionm1n));
numfreqpeaksM19 = length(FMIC_a19);
avgfreqpeakvalM19 = (sum(maxValFM1')/numfreqpeaksM19);
maxfreqpeakvalM19 = max(maxValFM1);
maxfreqvalM19 = max(FMIC_a19);
minfreqpeakvalM19 = min(maxValFM1);
minfreqvalM19 = min(FMIC_a19);
avgtimeenvelopeareaM19 = (areaEM1);
avgtricorrM19 = (m1tri);
avggausscorrM19 = (m1gauss);

save('Ant10_19data.mat','numtimemaxpeaksP10','avgtimemaxpeakvalP10','avgtimemaxpeakangleP10','avgtimemaxpeakareaP10',...
      'numtimeminpeaksP10','avgtimeminpeakvalP10','avgtimeminpeakangleP10','avgtimeminpeakareaP10',...
      'numfreqpeaksP10','avgfreqpeakvalP10','maxfreqpeakvalP10','maxfreqvalP10','minfreqpeakvalP10','minfreqvalP10','avgtimeenvelopeareaP10',...
      'avgtricorrP10','avggausscorrP10',...
      'numtimemaxpeaksM19','avgtimemaxpeakvalM19','avgtimemaxpeakangleM19','avgtimemaxpeakareaM19',...
      'numtimeminpeaksM19','avgtimeminpeakvalM19','avgtimeminpeakangleM19','avgtimeminpeakareaM19',...
      'numfreqpeaksM19','avgfreqpeakvalM19','maxfreqpeakvalM19','maxfreqvalM19','minfreqpeakvalM19','minfreqvalM19','avgtimeenvelopeareaM19',...
      'avgtricorrM19','avggausscorrM19');
  
