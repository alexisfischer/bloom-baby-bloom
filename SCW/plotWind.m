filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';

load([filepath 'Data/Wind_MB'],'w');

%% plot 2018 SCW, M1, and 46042
figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.06], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1); %46042
    [U,~]=plfilt(w.s42.u, w.s42.dn);
    [V,DN]=plfilt(w.s42.v, w.s42.dn);
    [~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'2018');
        legend('46042','Location','NW')
        legend boxoff
    hold on

subplot(3,1,2); %M1
    [U,~]=plfilt(w.M1.u, w.M1.dn);
    [V,DN]=plfilt(w.M1.v, w.M1.dn);
    [~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
        legend('M1','Location','NW')
        legend boxoff
    hold on

subplot(3,1,3); %SCW
    [U,~]=plfilt(w.scw.u, w.scw.dn);
    [V,DN]=plfilt(w.scw.v, w.scw.dn);
    [~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    xax1=datenum('2018-01-01'); xax2=datenum('2018-07-01');
    yax1=-4; yax2=4;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
        legend('SCW','Location','NW')
        legend boxoff
    hold on
datetick('x','mmm');
set(gca,'xgrid', 'on','xlim',[xax1 xax2]);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\wind_2018_M1_46042_SCW.tif']);
hold off

%% plots 2012-2018 Wind for SCW
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[U,~]=plfilt(w.scw.u, w.scw.dn);
[V,DN]=plfilt(w.scw.v, w.scw.dn);
[~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
[time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    
yr=[2012:2018]';    
for i=1:length(yr)
    subplot(length(yr),1,i)      
    xax1=datenum(['' num2str(yr(i)) '-01-01']);
    xax2=datenum(['' num2str(yr(i)) '-12-31']);
    yax1=-5; yax2=5;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(yr(i)) ''],'Location','NW'); legend boxoff
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
print(gcf,'-dtiff','-r600',[filepath 'Figs\Wind_SCW_2012_2018.tif']);
hold off        


%% plots 2012-2018 Wind for 46042
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

    [U,~]=plfilt(w.s42.u, w.s42.dn);
    [V,DN]=plfilt(w.s42.v, w.s42.dn);
    [~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    
yr=[2012:2018]';    
for i=1:length(yr)
    subplot(length(yr),1,i)      
    xax1=datenum(['' num2str(yr(i)) '-01-01']);
    xax2=datenum(['' num2str(yr(i)) '-12-31']);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(yr(i)) ''],'Location','NW'); legend boxoff
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
print(gcf,'-dtiff','-r600',[filepath 'Figs\Wind_46042_2012_2018.tif']);
hold off        


%% plots 2012-2018 Wind for M1
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.04 0.03], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

    [U,~]=plfilt(w.M1.u, w.M1.dn);
    [V,DN]=plfilt(w.M1.v, w.M1.dn);
    [~,u,~] = ts_aggregation(DN,U,1,'8hour',@mean);
    [time,v,~] = ts_aggregation(DN,V,1,'8hour',@mean);
    
yr=[2012:2018]';    
for i=1:length(yr)
    subplot(length(yr),1,i)      
    xax1=datenum(['' num2str(yr(i)) '-01-01']);
    xax2=datenum(['' num2str(yr(i)) '-12-31']);
    yax1=-10; yax2=10;
    stick(time,u,v,xax1,xax2,yax1,yax2,'');
    legend(['' num2str(yr(i)) ''],'Location','NW'); legend boxoff
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
print(gcf,'-dtiff','-r600',[filepath 'Figs\Wind_M1_2012_2018.tif']);
hold off        
