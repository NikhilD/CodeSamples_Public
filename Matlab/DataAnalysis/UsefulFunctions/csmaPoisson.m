function csmaPoisson(numNodes)
N = numNodes; p = 0:0.001:1;
fact1 = (N.*p); fact2 = (1-p);  fact3 = fact2.^(N-1);
alpha = fact1.*fact3;
figure, plot(p, alpha), grid on;
