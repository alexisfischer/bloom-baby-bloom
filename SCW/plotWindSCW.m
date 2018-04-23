resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/wind_SCW_M1_2016_2018']);
load([resultpath 'Data/WeeklySampling_SCW.mat']);


%% plots 2018 Wind for SCW and M1

figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.05], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1); %SCW data

quiver(SC(3).DN,0*SC(3).DN,SC(3).U,SC(3).V,'ShowArrowHead','off','Color','k');
set(gca,'xgrid', 'on','ylim',[-8 8],'ytick',-8:4:8,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title('SCW','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(2,1,2); %M1 data
quiver(M1(3).DN,0*M1(3).DN,M1(3).U,M1(3).V,'ShowArrowHead','off','Color','k');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-8 8],'ytick',-8:4:8,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],'tickdir','out'); 
ylabel('Wind (ms^{-1})','fontsize',12, 'fontname', 'Arial');    
title('M1 buoy','fontsize',12, 'fontname', 'Arial');   

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_M1_SCW_2018.tif']);
hold off

%% plots 2016-2018 Wind for SCW

figure('Units','inches','Position',[1 1 8 9],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.09]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(6,1,1); %2016
[U,~]=plfilt(SC(1).U,SC(1).DN);
[V,DN]=plfilt(SC(1).V,SC(1).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);

n = length(time);
ax = [datenum('2016-01-01') datenum('2016-05-01') -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
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
title([' ' num2str(M1(1).yr) ' - SCW'],'fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,2); %2016 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 16],'ytick',10:3:16,...
    'xlim',[datenum('2016-01-01') datenum('2016-05-01')],...
    'xtick',[datenum('2016-01-01'),datenum('2016-02-01'),...
    datenum('2016-03-01'),datenum('2016-04-01'),...
    datenum('2016-05-01')],'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,a.chl,'*-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,...
    'xlim',[datenum('2016-01-01') datenum('2016-05-01')],...
    'xtick',[datenum('2016-01-01'),datenum('2016-02-01'),...
    datenum('2016-03-01'),datenum('2016-04-01'),...
    datenum('2016-05-01')],'tickdir','out','xticklabel',{});     
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,3); %2017
[U,~]=plfilt(SC(2).U,SC(2).DN);
[V,DN]=plfilt(SC(2).V,SC(2).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);

n = length(time);
ax = [datenum('2017-01-01') datenum('2017-05-01') -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
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
title([' ' num2str(M1(2).yr) ' - SCW'],'fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,4); %2017 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 16],'ytick',10:3:16,...
    'xlim',[datenum('2017-01-01') datenum('2017-05-01')],...
    'xtick',[datenum('2017-01-01'),datenum('2017-02-01'),...
    datenum('2017-03-01'),datenum('2017-04-01'),...
    datenum('2017-05-01')],'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,a.chl,'*-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,...
    'xlim',[datenum('2017-01-01') datenum('2017-05-01')],...
    'xtick',[datenum('2017-01-01'),datenum('2017-02-01'),...
    datenum('2017-03-01'),datenum('2017-04-01'),...
    datenum('2017-05-01')],'tickdir','out','xticklabel',{});     
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,5); %2018
[U,~]=plfilt(SC(3).U,SC(3).DN);
[V,DN]=plfilt(SC(3).V,SC(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);

n = length(time);
ax = [datenum('2018-01-01') datenum('2018-05-01') -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
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
title([' ' num2str(M1(3).yr) ' - SCW'],'fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,6); %2018 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 16],'ytick',10:3:16,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],...
    'Xticklabel',{},'tickdir','out');      
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,a.chl,'*-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],...
    'Xticklabel',{'Jan','Feb','Mar','Apr','May'},'tickdir','out');      
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_SCW_2016_2018.tif']);
hold off

%% plots 2016-2018 Wind for M1

figure('Units','inches','Position',[1 1 8 9],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(6,1,1); %2016 wind
[U,~]=plfilt(M1(1).U,M1(1).DN);
[V,DN]=plfilt(M1(1).V,M1(1).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);

n = length(time);
ax = [datenum('2016-01-01') datenum('2016-05-01') -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
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
title([' ' num2str(M1(1).yr) ' - M1'],'fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,2); %2016 temp
plot(M1(1).dn,M1(1).T,'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis(ax);
set(gca,'xgrid','on','xticklabel',{},'ylim',[10 16],'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,3); %2017 wind
[U,~]=plfilt(M1(2).U,M1(2).DN);
[V,DN]=plfilt(M1(2).V,M1(2).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);

n = length(time);
ax = [datenum('2017-01-01') datenum('2017-05-01') -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
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
title([' ' num2str(M1(2).yr) ' - M1'],'fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,4); %2017 temp
plot(M1(2).dn,M1(2).T,'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis(ax);
set(gca,'xgrid','on','xticklabel',{},'ylim',[10 16],'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,5); %2018 wind
[U,~]=plfilt(M1(3).U,M1(3).DN);
[V,DN]=plfilt(M1(3).V,M1(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);

n = length(time);
ax = [datenum('2018-01-01') datenum('2018-05-01') -10 10]; %edit the +/-10 values if your speed max is > 10 m/s or min is < 10 m/s
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
set(gca,'xgrid', 'on','ytick',-10:10:10,'tickdir','out','xticklabel',{});
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title([' ' num2str(M1(3).yr) ' - M1'],'fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,6); %2018 temp
plot(M1(3).dn,M1(3).T,'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis(ax);
set(gca,'xgrid','on','ylim',[10 16],'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_M1_2016_2018.tif']);
hold off
