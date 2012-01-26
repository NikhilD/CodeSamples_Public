function arrowDraw()
figure;
axis([0 10 0 10]);
axis square;
grid on;
hold on;
start = [3 3];
stop  = [0 0];
arrow(start,stop,10,'BaseAngle',60);
%set(a, 'FaceColor', 'b');
%set(a, 'EdgeColor', 'r'); 
brk = 1;
