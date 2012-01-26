function RLSTest1()
x  = 2 + (0.1*randn(1,500));     % Input to the filter
n  = 0.1*randn(1,500); % Observation noise signal
d  = 2*ones(1,500);% + n; % desired signal
P0 = 10*eye(50); % Initial sqrt correlation matrix inverse
lam = 0.9;            % RLS forgetting factor
ha = adaptfilt.rls(50,lam,P0);
[y,e] = filter(ha,x,d);
plot(1:500,[d;y;e]);
title('System Identification of an FIR Filter');
legend('Desired','Output','Error');
xlabel('Time Index'); ylabel('Signal Value');
