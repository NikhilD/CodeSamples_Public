function RSSIplot()
RSSI1 = [-70 -80 -78 -79 -80 -84 -82 -91 -100];
RSSI2 = [-71 -83 -78 -80 -81 -84 -85 -92 -100];
RSSI3 = [-70 -77 -78 -77 -80 -85 -85 -91 -92];
Dist = [1 5 10 15 20 25 30 35 40];
axis([0 50 -100 -50]);
grid on
hold on
plot(Dist,RSSI1,'r', Dist,RSSI2,'b', Dist,RSSI3,'g');
% set(h,'XData',Dist,'YData',RSSI);
