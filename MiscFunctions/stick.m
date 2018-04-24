function stick(time,u,v,ax1,ax2,subtitle)

n = length(time);
ax = [ax1 ax2 -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
pos = get(gca,'Position');
pap = get(gcf,'PaperPosition');
hwratio = (pos(4)*pap(4))/(pos(3)*pap(3));
dt = ax(2)-ax(1); dv = ax(4)-ax(3);
sf = hwratio*dt/dv;
s = [0; 1; 0];
us = u*sf;
vec = zeros( n*3, 2 );
id = (1:3);
for i=1:n
vec(id,:) = s*[us(i), v(i)];
vec(id,1) = vec(id,1)+ones(3,1)*time(i);
id = id+3;
end
plot(vec(:,1),vec(:,2),'Color','k');
datetick('x','m');
axis(ax);
set(gca,'xgrid', 'on','xticklabel',{},'ytick',-10:10:10,'tickdir','out');
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title(subtitle,'fontsize',12, 'fontname', 'Arial');    
hold on