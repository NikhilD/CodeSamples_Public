function var = runEnvelope(vari)
% clear y;
assignin('base','y',vari);
sim('Envelope');
var = load('envelope.mat');
