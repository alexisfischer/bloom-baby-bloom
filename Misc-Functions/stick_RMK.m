function stick(time,u,v)
% stick(time,u,v)
% Stick vector plotter
% ax = [timemin timemax ymin ymax];
% create u and v using UVfromDM function

n = length(time);
ax = [time(1) time(n) -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
figure(1);
subplot(3,1,3); % delete this if you want the plot to fill up entire figure
axis(ax);

pos = get(gca,'Position');
pap = get(gcf,'PaperPosition');
hwratio = (pos(4)*pap(4))/(pos(3)*pap(3));

dt = ax(2)-ax(1);
dv = ax(4)-ax(3);
sf = hwratio*dt/dv;
s = [0; 1; 0];
us = u*sf;
vec = zeros( n*3, 2 );
id = (1:3');
for i=1:n;
vec(id,:) = s*[us(i), v(i)];
vec(id,1) = vec(id,1)+ones(3,1)*time(i);
id = id+3;
end


plot(vec(:,1),vec(:,2));
axis(ax); grid on;
xnum=get(gca,'XTick');
xname=datestr(xnum,6); % change the "6" to "15", if you would rather have hh:mm time labels (rather than mm/dd)
set(gca,'XTickLabel',xname);

 

 
