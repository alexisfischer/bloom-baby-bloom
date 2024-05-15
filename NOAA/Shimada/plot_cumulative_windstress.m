%% Calculate CUI (cumulative upwelling index) from Cape Elizabeth NDBC #46041 
% analysis to examine how leaky the Juan de Fuca Eddy was during 2019 and 2021 Hake surveys
% A.D. Fischer, May 2024
%
clear;

%%%%USER
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/wind_46041'],'w19','w21');

%%%% plot cumulative wind stress 
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 2.5]); 
    h1=plot(w19.dt+2*365,w19.cui,'r-','linewidth',1.5); hold on;
    h2=plot(w21.dt,w21.cui,'b-','linewidth',1.5); hold on;  
    set(gca,'xlim',[datetime('27-Apr-2021') datetime('22-Sep-2021')],...
        'ylim',[-20 170],'tickdir','out','fontsize',10)
ylabel('cumulative wind stress','fontsize',12)
%title('Cape Elizabeth NDBC #46041','fontsize',12)

x=datetime('09-Jul-2021'):1:datetime('19-Aug-2021');
line(x,-10*ones(size(x)),'Color','r','LineStyle',':','linewidth',2)

x=datetime('26-Jul-2021'):1:datetime('22-Sep-2021');
line(x,0*ones(size(x)),'Color','b','LineStyle',':','linewidth',2)
legend([h1 h2],'2019','2021','Location','Northwest')

exportgraphics(fig,[filepath 'Figs/CUI_WA.png'],'Resolution',300)    

%% plot wind stress
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
     
save([filepath 'NOAA/Shimada/Data/Wind_Shimada'],'w19','w21');