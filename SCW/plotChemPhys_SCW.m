resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/SCW_SCOOS.mat'],'a');
load([resultpath 'Data/TempChlTurb_SCW'],'S');
load([resultpath 'Data/Weatherstation_SCW'],'SC');
load([resultpath 'Data/M1_buoy'],'M1');
load([resultpath 'Data/coastal_46042'],'coast');

%% plot 2018 SCW, M1, and 46042
figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.06], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1); %46042
    [U,~]=plfilt(coast(7).U,coast(7).DN);
    [V,DN]=plfilt(coast(7).V,coast(7).DN);
    [~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'2018');
        legend('46042','Location','NW')
        legend boxoff
    hold on

subplot(3,1,2); %M1
    [U,~]=plfilt(M1(3).U,M1(3).DN);
    [V,DN]=plfilt(M1(3).V,M1(3).DN);
    [~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
        legend('M1','Location','NW')
        legend boxoff
    hold on

subplot(3,1,3); %SCW
    [U,~]=plfilt(SC(7).U,SC(7).DN);
    [V,DN]=plfilt(SC(7).V,SC(7).DN);
    [~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    yax1=-3; yax2=3;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
        legend('SCW','Location','NW')
        legend boxoff
    hold on
datetick('x','mmm');
set(gca,'xgrid', 'on','xlim',[xax1 xax2]);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\wind_2018_M1_46042_SCW.tif']);
hold off

%% plots 2012-2018 Wind for 46042
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

for i=1:length(coast)
    subplot(length(coast),1,i)
    
    [U,~]=plfilt(coast(i).U,coast(i).DN);
    [V,DN]=plfilt(coast(i).V,coast(i).DN);
    [~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
        
    xax1=datenum(['' num2str(coast(i).yr) '-01-01']);
    xax2=datenum(['' num2str(coast(i).yr) '-12-31']);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(coast(i).yr) ''],'Location','NW'); legend boxoff
    hold on
end

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01'),datenum('2018-08-01'),...
    datenum('2018-09-01'),datenum('2018-10-01'),datenum('2018-11-01'),...
    datenum('2018-12-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May',...
    'Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'tickdir','out','fontsize',10);  
   
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_46042_2012_2018.tif']);
hold off    
    
%% plots 2012-2018 Wind for SCW
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

for i=1:length(SC)
    subplot(length(SC),1,i)
    
    [U,~]=plfilt(SC(i).U,SC(i).DN);
    [V,DN]=plfilt(SC(i).V,SC(i).DN);
    [~,u,~] = ts_aggregation(DN,U,1,'day',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'day',@mean);
        
    xax1=datenum(['' num2str(SC(i).yr) '-01-01']);
    xax2=datenum(['' num2str(SC(i).yr) '-12-31']);
    yax1=-4; yax2=4;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(SC(i).yr) ''],'Location','NW'); legend boxoff
    hold on  
end

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01'),datenum('2018-08-01'),...
    datenum('2018-09-01'),datenum('2018-10-01'),datenum('2018-11-01'),...
    datenum('2018-12-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May',...
    'Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'tickdir','out','fontsize',10);  
   
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Wind_SCW_2012_2018.tif']);
hold off        

%% plots 2012-2018 temperature for SCW
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

for i=1:length(SC)
    subplot(length(SC),1,i)
    
    plot(a.dn,(a.temp),'o','Markersize',4,'Color',[0 0.4470 0.7410]);
    hold on
    plot(S.dn,(S.temp),'-','Color',[0 0.4470 0.7410]);
    datetick('x','mm');
    
    xax1=datenum(['' num2str(SC(i).yr) '-01-01']);
    xax2=datenum(['' num2str(SC(i).yr) '-12-31']);
    set(gca,'xgrid', 'on','ylim',[10 19],...
        'xlim',[xax1 xax2],'xticklabel',{});
    ylabel('SST (^oC)','fontsize',12, 'fontname', 'Arial');   
    legend(['' num2str(SC(i).yr) ''],'Location','NW'); legend boxoff
    hold on     
end

set(gca,'xtick',[datenum('2018-01-01'),datenum('2018-02-01'),...
    datenum('2018-03-01'),datenum('2018-04-01'),datenum('2018-05-01'),...
    datenum('2018-06-01'),datenum('2018-07-01'),datenum('2018-08-01'),...
    datenum('2018-09-01'),datenum('2018-10-01'),datenum('2018-11-01'),...
    datenum('2018-12-01')],'Xticklabel',{'Jan','Feb','Mar','Apr','May',...
    'Jun','Jul','Aug','Sep','Oct','Nov','Dec'},'tickdir','out','fontsize',10);  
   
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Temp_SCW_2012_2018.tif']);
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