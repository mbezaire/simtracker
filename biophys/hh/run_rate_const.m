% script to generate Dickson, et. al, JNP 2000, Fig. 11C
[V, c] = rate_const;
% 
plot(V, c(1,:), '-', V, c(3,:), ':', V, c(2,:), '-', V, c(4,:), ':')
xlabel('voltage (mv)'); ylabel('rate constant (1/s)');
legend('a1','b1','a2','b2');

