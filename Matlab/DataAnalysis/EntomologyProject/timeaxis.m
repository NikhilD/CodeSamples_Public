function time = timeaxis(signal,freq)
time = [];
for i = 0:(1/freq):freq
    time = [time i];
    if(length(time)==length(signal))
        break;
    end
end
