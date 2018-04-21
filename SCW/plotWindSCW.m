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
datetick('x','m');
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
quiver(SC(1).DN,0*SC(1).DN,SC(1).U,SC(1).V,'ShowArrowHead','off','Color','k');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-14 14],'ytick',-10:10:10,...
    'xlim',[datenum('2016-01-01') datenum('2016-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title('2016 - SCW','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,2); %2016 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:2:16,...
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
quiver(SC(2).DN,0*SC(2).DN,SC(2).U,SC(2).V,'ShowArrowHead','off','Color','k');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-14 14],'ytick',-10:10:10,...
    'xlim',[datenum('2017-01-01') datenum('2017-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title('2017 - SCW','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,4); %2017 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:2:16,...
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
quiver(SC(3).DN,0*SC(3).DN,SC(3).U,SC(3).V,'ShowArrowHead','off','Color','k');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-14 14],'ytick',-10:10:10,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title('2018 - SCW','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(6,1,6); %2018 temp
yyaxis left
plot(a.dn,a.temp,'o-','Markersize',3);
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:2:16,...
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

figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.05], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

% subplot(6,1,1); %2016 wind
% quiver(M1(4).DN,0*M1(4).DN,M1(4).U,M1(4).V,'ShowArrowHead','off','Color','k');
% datetick('x','m');
% set(gca,'xgrid', 'on','ylim',[-14 14],'ytick',-10:10:10,...
%     'xlim',[datenum('2011-01-01') datenum('2011-05-01')],...
%     'tickdir','out','xticklabel',{}); 
% ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
% title('2016 - M1','fontsize',12, 'fontname', 'Arial');    
% hold on
% 
% subplot(6,1,2); %2016 temp
% plot(M1(1).DN,M1(1).T,'b-');
% datetick('x','m');
% set(gca,'xgrid', 'on','ylim',[10 15],'ytick',10:2:14,...
%     'xlim',[datenum('2011-01-01') datenum('2011-05-01')],...
%     'tickdir','out','xticklabel',{}); 
% ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
% hold on

subplot(4,1,1); %2017 wind
quiver(M1(2).DN,0*M1(2).DN,M1(2).U,M1(2).V,'ShowArrowHead','off','Color','k');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-14 14],'ytick',-10:10:10,...
    'xlim',[datenum('2017-01-01') datenum('2017-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title('2017 - M1','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,2); %2017 temp
plot(M1(2).DN,M1(2).T,'b-');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:2:16,...
    'xlim',[datenum('2017-01-01') datenum('2017-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,3); %2018 wind
quiver(M1(3).DN,0*M1(3).DN,M1(3).U,M1(3).V,'ShowArrowHead','off','Color','k');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-14 14],'ytick',-10:10:10,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (m s^{-1})','fontsize',12, 'fontname', 'Arial');    
title('2018 - M1','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(4,1,4); %2018 temp
plot(M1(3).DN,M1(3).T,'b-');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[10 17],'ytick',10:2:16,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),...
    datenum('2018-05-01')],...
    'Xticklabel',{'Jan','Feb','Mar','Apr','May'},'tickdir','out');   
ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');    
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_M1_2017_2018.tif']);
hold off
