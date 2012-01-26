function savematfile(filename,var)
fs = 1000;
t = [];
data = [];
for i=0:(1/fs):fs
    t = [t i];
    if(length(t)==length(var))
        break;
    end
end
data = [t; var];
save(filename,'data');
