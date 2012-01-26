function [wInit, wOut, wBias] = gaussianBPNN(inputPts, outDesired, iter, eta, numHidNeurons)
numNeurons = numHidNeurons;     wtRgeMin = -1;   wtRgeMax = 1;
numSamples = size(inputPts,2);               % number of input samples
numInputs = size(inputPts,1);               % number of input dimensions

wInit = rand(numNeurons,numInputs)*(wtRgeMax-wtRgeMin) + wtRgeMin; 
wOut = rand(1,numNeurons)*(wtRgeMax-wtRgeMin) + wtRgeMin;
wBias = rand(1, (numNeurons+1))*(wtRgeMax-wtRgeMin) + wtRgeMin;   

diffVal = zeros(1,(numNeurons+1));      hidNeu = zeros(numNeurons,1);
SSE = zeros(1,iter);
for i = 1:iter
    SE = zeros(1,numSamples);
    for trN = 1:numSamples
        for h = 1:numNeurons
            [hidNeu(h), diffVal(h)] = getNeuron(wInit(h,:),inputPts(:,trN),wBias(h));
        end
        [outNeu, diffVal(h+1)] = getNeuron(wOut, hidNeu, wBias(h+1));
        diffSE = outNeu - outDesired(trN);
        
        deltas = getDeltas(diffSE, wOut, diffVal);
        [delWInits, delWOuts, delWBias] = getDelWts(deltas, hidNeu, inputPts(:,trN), eta);
        
        [wInit, wOut, wBias] = updateWeights(delWInits, delWOuts, delWBias, wInit, wOut, wBias);
        
        SE(trN) = diffSE^2;
    end
    SSE(i) = (1/2)*sum(SE);    
    if(SSE(i)<0.00002),break,end
end


function [initNew, outNew, biasNew] = updateWeights(delWInits, delWOuts, delWBias, wInit, wOut, wBias)
initNew = wInit + delWInits;    outNew = wOut + delWOuts;   
biasNew = wBias + delWBias;


function [neuOut, diffVal] = getNeuron(weights, inputs, wBias)
xin = weights*inputs + wBias;   sigma = 0.5;
neuOut = exp((-xin^2)/(2*(sigma^2)));
diffVal = neuOut*(-xin/(sigma^2));


function deltas = getDeltas(diffSE, wOut, diffVal)
numNeurons = length(wOut);  deltas = zeros(1,(numNeurons+1));
deltas(numNeurons+1) = diffSE*diffVal(numNeurons+1);
for h = 1:numNeurons
    deltas(h) = deltas(numNeurons+1)*wOut(h)*diffVal(h);
end


function [delWInits, delWOuts, delWBias] = getDelWts(deltas, neuOuts, inputs, eta)
numInputs = length(inputs); numNeurons = length(deltas) - 1;    
delWInits = zeros(numNeurons,numInputs);    delWOuts = zeros(1,numNeurons);
delWBias = zeros(1,(numNeurons+1));
for h = 1:numNeurons
    delWOuts(h) = -eta*neuOuts(h)*deltas(numNeurons+1);
    for n = 1:numInputs
        delWInits(h,n) = -eta*inputs(n)*deltas(h);
    end
    delWBias(h) = -eta*deltas(h);
end
delWBias(h+1) = -eta*deltas(h+1);

