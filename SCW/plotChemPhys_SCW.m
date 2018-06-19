resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
%load([resultpath 'Data/wind_SCW_M1_2016_2018']);
load([resultpath 'Data/SCW_SCOOS.mat'],'a');
load([resultpath 'Data/TempChlTurb_SCW'],'S');
load([resultpath 'Data/Weatherstation_SCW'],'SC');

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
xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - SCW');

subplot(2,1,2); %M1 data
[U,~]=plfilt(M1(3).U,M1(3).DN);
[V,DN]=plfilt(M1(3).V,M1(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - M1');

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01')],...
    'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul'});

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_M1_SCW_2018.tif']);
hold off

%% plots 2012-2018 Wind for SCW

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(7,1,1); %2012
[U,~]=plfilt(SC(1).U,SC(1).DN);
[V,DN]=plfilt(SC(1).V,SC(1).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2012-01-01'); xax2=datenum('2012-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2012');

subplot(7,1,2); %2013
[U,~]=plfilt(SC(2).U,SC(2).DN);
[V,DN]=plfilt(SC(2).V,SC(2).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2013-01-01'); xax2=datenum('2013-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2013');

subplot(7,1,3); %2014
[U,~]=plfilt(SC(3).U,SC(3).DN);
[V,DN]=plfilt(SC(3).V,SC(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2014-01-01'); xax2=datenum('2014-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2014');

subplot(7,1,4); %2015
[U,~]=plfilt(SC(4).U,SC(4).DN);
[V,DN]=plfilt(SC(4).V,SC(4).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2015-01-01'); xax2=datenum('2015-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2015');

subplot(7,1,5); %2016
[U,~]=plfilt(SC(5).U,SC(5).DN);
[V,DN]=plfilt(SC(5).V,SC(5).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2016-01-01'); xax2=datenum('2016-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2016');

subplot(7,1,6); %2017
[U,~]=plfilt(SC(6).U,SC(6).DN);
[V,DN]=plfilt(SC(6).V,SC(6).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2017-01-01'); xax2=datenum('2017-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2017');

subplot(7,1,7); %2018
[U,~]=plfilt(SC(7).U,SC(7).DN);
[V,DN]=plfilt(SC(7).V,SC(7).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018');
set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01'),datenum('2018-08-01'),...
    datenum('2018-09-01'),datenum('2018-10-01'),...
    datenum('2018-11-01'),datenum('2018-12-01')],...
    'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep',...
    'Oct','Nov','Dec'},...
    'tickdir','out','fontsize',10);  

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_SCW_2012_2018.tif']);
hold off

%% plots 2016-2018 Wind for SCW

figure('Units','inches','Position',[1 1 8 9],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.09]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(6,1,1); %2016
[U,~]=plfilt(SC(5).U,SC(5).DN);
[V,DN]=plfilt(SC(5).V,SC(5).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2016-01-01'); xax2=datenum('2016-07-01');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2016 - SCW');

subplot(6,1,2); %2016 temp
yyaxis left
plot(a.dn,(a.temp),'o','Color',[0 0.4470 0.7410]);
hold on
plot(S.dn,(S.temp),'-','Color',[0 0.4470 0.7410]);
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:3:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-01-01'),datenum('2016-02-01'),...
    datenum('2016-03-01'),datenum('2016-04-01'),datenum('2016-05-01'),...
    datenum('2016-06-01'),datenum('2016-07-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,(a.chl),'*','Color',[0.8500 0.3250 0.0980]);
hold on
plot(S.dn,(S.chl),'-','Color',[0.8500 0.3250 0.0980]);
set(gca,'xgrid', 'on','ylim',[0 60],'ytick',0:20:60,'xlim',[xax1 xax2],...
    'xtick',[datenum('2016-01-01'),datenum('2016-02-01'),...
    datenum('2016-03-01'),datenum('2016-04-01'),datenum('2016-05-01'),...
    datenum('2016-06-01'),datenum('2016-07-01')],...
    'tickdir','out','xticklabel',{});     
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,3); %2017
[U,~]=plfilt(SC(6).U,SC(6).DN);
[V,DN]=plfilt(SC(6).V,SC(6).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2017-01-01'); xax2=datenum('2017-07-01');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2017 - SCW');

subplot(6,1,4); %2017 temp
yyaxis left
plot(a.dn,(a.temp),'o','Color',[0 0.4470 0.7410]);
hold on
plot(S.dn,(S.temp),'-','Color',[0 0.4470 0.7410]);
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:3:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2017-01-01'),datenum('2017-02-01'),...
    datenum('2017-03-01'),datenum('2017-04-01'),datenum('2017-05-01'),...
    datenum('2017-06-01'),datenum('2017-07-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,(a.chl),'*','Color',[0.8500 0.3250 0.0980]);
hold on
plot(S.dn,(S.chl),'-','Color',[0.8500 0.3250 0.0980]);
set(gca,'xgrid', 'on','ylim',[0 20],'ytick',0:10:20,'xlim',[xax1 xax2],...
    'xtick',[datenum('2017-01-01'),datenum('2017-02-01'),...
    datenum('2017-03-01'),datenum('2017-04-01'),datenum('2017-05-01'),...
    datenum('2017-06-01'),datenum('2017-07-01')],...
    'tickdir','out','xticklabel',{});     
ylabel('Chl (mg m^{-3})','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,5); %2018
[U,~]=plfilt(SC(7).U,SC(7).DN);
[V,DN]=plfilt(SC(7).V,SC(7).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
yax1=-5; yax2=5;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - SCW');

subplot(6,1,6); %2018 temp
plot(a.dn,(a.temp),'o','Color',[0 0.4470 0.7410]);
hold on
yyaxis left
plot(S.dn,(S.temp),'-','Color',[0 0.4470 0.7410]);
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:3:16,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01')],...
    'Xticklabel',{},'tickdir','out');      
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

yyaxis right
plot(a.dn,(a.chl),'*','Color',[0.8500 0.3250 0.0980]);
hold on
plot(S.dn,(S.chl),'-','Color',[0.8500 0.3250 0.0980]);
set(gca,'xgrid', 'on','ylim',[0 20],'ytick',0:10:20,'xlim',[xax1 xax2],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01')],...
    'Xticklabel',{'Jan','Feb','Mar','Apr','May','Jun','Jul'},...
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
xax1=datenum('2016-01-01'); xax2=datenum('2016-07-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2016 - M1');

subplot(6,1,2); %2016 temp
plot(M1(1).dn,smooth(M1(1).T),'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis([xax1 xax2 10 16]);
set(gca,'xgrid','on','xticklabel',{},'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,3); %2017 wind
[U,~]=plfilt(M1(2).U,M1(2).DN);
[V,DN]=plfilt(M1(2).V,M1(2).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2017-01-01'); xax2=datenum('2017-07-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2017 - M1');

subplot(6,1,4); %2017 temp
plot(M1(2).dn,smooth(M1(2).T),'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis([xax1 xax2 10 16]);
set(gca,'xgrid','on','xticklabel',{},'ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,5); %2018 wind
[U,~]=plfilt(M1(3).U,M1(3).DN);
[V,DN]=plfilt(M1(3).V,M1(3).DN);
[~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
yax1=-10; yax2=10;
stick(time,u,v,xax1,xax2,yax1,yax2,'2018 - M1');

subplot(6,1,6); %2018 temp
plot(M1(3).dn,smooth(M1(3).T),'-','color',[0,0.4470,0.7410]);
datetick('x','m');
axis([xax1 xax2 10 16]);
set(gca,'xgrid','on','ytick',10:3:16,'tickdir','out');
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_M1_2016_2018.tif']);
hold off
