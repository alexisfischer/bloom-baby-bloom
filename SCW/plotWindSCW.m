filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
%load([filepath 'Data/wind_SCW_M1_2016_2018']);
load([filepath 'Data/Wind_MB'],'w');

%load([filepath 'Data/WeeklySampling_SCW.mat']);

%% plots 2018 Wind for SCW and M1

figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.05], [0.12 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1); %SCW data

quiver(SC(3).DN,0*SC(3).DN,SC(3).U,SC(3).V,'ShowArrowHead','off');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-8 8],'ytick',-8:4:8,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],...
    'tickdir','out','xticklabel',{}); 
ylabel('Wind (ms^{-1})','fontsize',12, 'fontname', 'Arial');    
title('SCW','fontsize',12, 'fontname', 'Arial');    
hold on

subplot(2,1,2); %M1 data
quiver(M1(3).DN,0*M1(3).DN,M1(3).U,M1(3).V,'ShowArrowHead','off');
datetick('x','m');
set(gca,'xgrid', 'on','ylim',[-8 8],'ytick',-8:4:8,...
    'xlim',[datenum('2018-01-01') datenum('2018-05-01')],'tickdir','out'); 
ylabel('Wind (ms^{-1})','fontsize',12, 'fontname', 'Arial');    
title('M1 buoy','fontsize',12, 'fontname', 'Arial');   

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Wind_M1_SCW_2018.tif']);
hold off

%% plots 2012-2018 SCW Wind

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.04], [0.08 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[U,~]=plfilt(w.scw.u, w.scw.dn);
[V,DN]=plfilt(w.scw.v, w.scw.dn);
[~,u,~] = ts_aggregation(DN,U,8,'hour',@mean);
[time,v,~] = ts_aggregation(DN,V,8,'hour',@mean);

yr=2012:1:2018;

for i=1:length(yr)  
    subplot(7,1,i); 
    xax1=datenum(['' num2str(yr(i)) '-01-01']); xax2=datenum(['' num2str(yr(i)) '-12-31']);     
    yax1=-3; yax2=3;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    datetick('x','mmm','keeplimits');   
    set(gca,'ytick',-2:2:2,'xlim',[xax1 xax2],'xticklabel',{},'fontsize',10);        
    ylabel('Wind (m/s)','fontsize',12,'fontname','arial','fontweight','bold');  
    title(['' num2str(yr(i)) ''],'fontsize',12)  
    hold on  
end

datetick('x','mmm','keeplimits');   
   
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Wind_SCW_2012_2018.tif']);
hold off

%% plots 2012-2018 M1 Wind

figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.04], [0.08 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[U,~]=plfilt(w.M1.u, w.M1.dn);
[~,u,~] = ts_aggregation(DN,U,12,'hour',@mean);
[time,v,~] = ts_aggregation(DN,V,12,'hour',@mean);

yr=2012:1:2018;

for i=1:length(yr)  
    subplot(7,1,i); 
    xax1=datenum(['' num2str(yr(i)) '-01-01']); xax2=datenum(['' num2str(yr(i)) '-12-31']);     
    yax1=-8; yax2=8;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    datetick('x','mmm','keeplimits');   
    set(gca,'ytick',-5:5:5,'xlim',[xax1 xax2],'xticklabel',{},'fontsize',10);        
    ylabel('Wind (m/s)','fontsize',12,'fontname','arial','fontweight','bold');  
    title(['' num2str(yr(i)) ''],'fontsize',12)  
    hold on  
end

datetick('x','mmm','keeplimits');   
   
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Wind_M1_2012_2018.tif']);
hold off
