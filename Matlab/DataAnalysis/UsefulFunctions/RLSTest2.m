function RLSTest2()
p = 32; % filter order
del = 0.1; % regularization parameter
iter = 500;   % number of iterations
xVal  = 2 + randn(1,iter); % Input to the filter
lam = 0.9;            % RLS forgetting factor
d  = 2*ones(1,iter);% desired signal
d_hat1 = zeros(1,iter); % actual signal
err1 = d_hat1;
P = (1/del)*eye(p); % Initial sqrt correlation matrix inverse
P0 = P; % Initial sqrt correlation matrix inverse
wts = zeros(1,p)';
X = zeros(1,p)';
for i=1:iter
    for j=p:-1:2
        X(j) = X(j-1);
    end 
    X(1) = xVal(i); 
    dum1 = 0;
    for k=1:p
        dum1 = dum1 + X(k)*wts(k);
    end
%     alpha = d(i) - X'*wts;
    alpha = d(i) - dum1;
    dum1 = 0;  dum2 = zeros(p,1);
    for k=1:p
        for m=1:p
            dum1 = dum1 + P(k,m)*X(m);
        end
        dum2(k) = dum1;
        dum1 = 0;
    end
%     z = P*X;
    z = dum2; 
    dum1 = 0;
    for k=1:p
        for m=1:p
            dum1 = dum1 + X(k)*P(k,m)*X(m);
        end
    end        
%     denom = lam + X'*z;
    denom = lam + dum1;
    g = zeros(p,1);
    for k=1:p
        g(k) = z(k)/denom;
        wts(k) = wts(k) + alpha*g(k);
        for m=1:p
            dum1=0;
            for n=1:p
                dum1 = dum1 + X(n)*P(n,m);
            end
            trm2(k,m) = g(k)*dum1;
        end
    end
%     g = z/denom;
%     wts = wts + alpha*g;
%     trm2 = g*X'*P;
%     P = (1/lam)*(P - trm2);    
    dum1 = 0;
    for k=1:p
        for m=1:p
            P(k,m) = (1/lam)*(P(k,m) - trm2(k,m));
        end
        dum1 = dum1 + wts(k)*X(k);
    end
%     d_hat1(i) = wts'*X;
    d_hat1(i) = dum1;
    err1(i) = d(i) - d_hat1(i);
end
ha = adaptfilt.rls(p,lam,P0);
[d_hat2,err2] = filter(ha,xVal,d);

subplot(2,1,1); plot(1:iter,[d;d_hat1;err1]);
title('System Identification of an FIR Filter');
legend('Desired','Output1','Error1');
xlabel('Time Index'); ylabel('Signal Value');   grid on;
subplot(2,1,2); plot(1:iter,[d;d_hat2;err2]);
legend('Desired','Output2','Error2');
xlabel('Time Index'); ylabel('Signal Value');  grid on;
brk=1;