function lineplottest()
x = [2 4];  
y = [3 5];

figure;
axis([0 10 0 10]);
axis square;
grid on;
hold on;

lin = line(x,y);
w = 2;
for i = 1:5
    pause(0.25);
    x = x+0.5;
    y = y+0.5;
    w = w+1;
    set(lin,'XData',x,'YData',y, 'LineWidth', w);   
    t = 1;
end
set(lin,'XData',0,'YData',0);