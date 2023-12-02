%% Calculate CUI (cumulative upwelling index) from Cape Elizabeth NDBC #46041 
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/wind_46041'],'w19','w21');

w19(~(w19.dt>datetime('2019-05-01') & w19.dt<datetime('2019-08-19')),:)=[];
w21(~(w21.dt>datetime('2021-05-01') & w21.dt<datetime('2021-09-25')),:)=[];

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 3]); 
    plot(w19.dt+2*365,w19.cui,'r-','linewidth',2); hold on;
    plot(w21.dt,w21.cui,'b-','linewidth',2); hold on;  
    set(gca,'ylim',[0 170])
legend('2019','2021','Location','Northoutside')
ylabel('cumulative wind stress')
title('Cape Elizabeth NDBC #46041')

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/CUI_WA.png'],'Resolution',100)    

    %%
figure
subplot(2,1,1)
yyaxis left
    plot(w19.dt,w19.v,'-','Color','k','linewidth',2); hold on;
    yline(0);
    set(gca,'xlim',[datetime('01-May-2019') datetime('26-Sep-2019')],...
        'ylim',[-11 10],'ytick',-7:7:7,'fontsize',10,'tickdir','out','ycolor','k');    
    ylabel('2019 (m s^{-1})','fontsize',11);
yyaxis right
    plot(w19.dt,w19.cui,'--','Color','r','linewidth',2); hold on;
    set(gca,'ylim',[-200 200],'ycolor','r')
    title('North-south wind stress')

subplot(2,1,2)
    plot(w21.dt,w21.v,'-','Color','k','linewidth',2); hold on;
    yline(0);
    set(gca,'xlim',[datetime('01-May-2021') datetime('26-Sep-2021')],...
        'ylim',[-11 10],'ytick',-7:7:7,'fontsize',10,'tickdir','out','ycolor','k');    
    ylabel('2021 (m s^{-1})','fontsize',11);
yyaxis right
    plot(w21.dt,w21.cui,'--','Color','r','linewidth',2); hold on;  
    set(gca,'ylim',[-200 200],'ycolor','r')
     
%%
save([filepath 'NOAA/Shimada/Data/Wind_Shimada'],'w19','w21');