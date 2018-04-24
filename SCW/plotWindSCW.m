resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/wind_SCW_M1_2016_2018']);
load([resultpath 'Data/WeeklySampling_SCW.mat']);

%% plots 2018 Wind for SCW and M1

figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.08 0.06], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1); %SCW data
[U,~]=plfilt(SC(3).U,SC(3).DN);
[V,DN]=plfilt(SC(3).V,SC(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-05-01');
yax1=-2; yax2=2;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - SCW');

subplot(2,1,2); %M1 data
[U,~]=plfilt(M1(3).U,M1(3).DN);
[V,DN]=plfilt(M1(3).V,M1(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-05-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - M1');

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May'});

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
xax1=datenum('2016-01-01'); xax2=datenum('2016-05-01');
yax1=-3; yax2=3;
stick(time,u,v,xax1,xax2,yax1,yax2,'2016 - SCW');

subplot(6,1,2); %2016 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[10 16],'ytick',10:3:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-01-01'),datenum('2016-02-01'),...
    datenum('2016-03-01'),datenum('2016-04-01'),datenum('2016-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,a.chl,'*-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-01-01'),datenum('2016-02-01'),...
    datenum('2016-03-01'),datenum('2016-04-01'),datenum('2016-05-01')],...
    'tickdir','out','xticklabel',{});     
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,3); %2017
[U,~]=plfilt(SC(2).U,SC(2).DN);
[V,DN]=plfilt(SC(2).V,SC(2).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2017-01-01'); xax2=datenum('2017-05-01');
yax1=-3; yax2=3;
stick(time,u,v,xax1,xax2,yax1,yax2,'2017 - SCW');

subplot(6,1,4); %2017 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 16],'ytick',10:3:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2017-01-01'),datenum('2017-02-01'),...
    datenum('2017-03-01'),datenum('2017-04-01'),datenum('2017-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,a.chl,'*-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,'xlim',[xax1 xax2],...
    'xtick',[datenum('2017-01-01'),datenum('2017-02-01'),...
    datenum('2017-03-01'),datenum('2017-04-01'),datenum('2017-05-01')],...
    'tickdir','out','xticklabel',{});     
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,5); %2018
[U,~]=plfilt(SC(3).U,SC(3).DN);
[V,DN]=plfilt(SC(3).V,SC(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-05-01');
yax1=-3; yax2=3;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - SCW');

subplot(6,1,6); %2018 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 16],'ytick',10:3:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01')],...
    'Xticklabel',{},'tickdir','out');      
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,a.chl,'*-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[0 15],'ytick',0:5:15,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May'},...
    'tickdir','out');      
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
xax1=datenum('2016-01-01'); xax2=datenum('2016-05-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2016 - M1');

subplot(6,1,2); %2016 temp
plot(M1(1).dn,M1(1).T,'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis([ax1 ax2 10 16]);
set(gca,'xgrid','on','xticklabel',{},'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,3); %2017 wind
[U,~]=plfilt(M1(2).U,M1(2).DN);
[V,DN]=plfilt(M1(2).V,M1(2).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2017-01-01'); xax2=datenum('2017-05-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2017 - SCW');

subplot(6,1,4); %2017 temp
plot(M1(2).dn,M1(2).T,'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis([ax1 ax2 10 16]);
set(gca,'xgrid','on','xticklabel',{},'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,5); %2018 wind
[U,~]=plfilt(M1(3).U,M1(3).DN);
[V,DN]=plfilt(M1(3).V,M1(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-05-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - M1');

subplot(6,1,6); %2018 temp
plot(M1(3).dn,M1(3).T,'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis([ax1 ax2 10 16]);
set(gca,'xgrid','on','ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_M1_2016_2018.tif']);
hold off
