function signal = envelope_signal(var)
signal = [];
for i = 1:length(var)
    if(var(i)~=0)
        signal = [signal var(i)];
    end
end
signal = [0 signal 0];
if(mod(length(signal),2)~=0) % ensure that the signal has 'even' length
    signal = [signal 0];
end