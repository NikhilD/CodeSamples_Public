function [piezod ird micd] = Ent_Signal_Time(filename,piezothresh,irthresh,micthresh)
piezod=[];
ird=[];
micd=[];
scale = 3/4095;
data = load(filename);
piezo = data.sendata(:,1)*scale;
ir = data.sendata(:,2)*scale;
mic = data.sendata(:,3)*scale; % 5

piezomean = mean(piezo);
irmean = mean(ir);
micmean = mean(mic);

for g=1:1:length(piezo)
    if((piezo(g)>(piezomean+piezothresh))||(piezo(g)<(piezomean-piezothresh)))
        piezod = [piezod piezo(g)];
    else
        piezod = [piezod piezomean];
    end
    if((ir(g)>(irmean+irthresh))||(ir(g)<(irmean-irthresh)))
        ird = [ird ir(g)];
    else
        ird = [ird irmean];
    end
    if((mic(g)>(micmean+micthresh))||(mic(g)<(micmean-micthresh)))
        micd = [micd mic(g)];
    else
        micd = [micd micmean];
    end
end
x1 = 1:length(piezod);
x2 = 1:length(ird);
x3 = 1:length(micd);
figure;
subplot(2,3,1), plot(x1,piezo,'r');
subplot(2,3,2), plot(x2,ir,'g');
subplot(2,3,3), plot(x3,mic,'b');
subplot(2,3,4), plot(x1,piezod,'r');
subplot(2,3,5), plot(x2,ird,'g');
subplot(2,3,6), plot(x3,micd,'b');
