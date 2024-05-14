%% plot LOTT nutrients 
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/LOTT_nutrients'],'dt','NH3_mgL','NO3NO2_mgL','TKN_mgL');


figure('Units','inches','Position',[1 1 5 3],'PaperPositionMode','auto');

h=plot(dt(~isnan(NH3_mgL)),NH3_mgL(~isnan(NH3_mgL)),'-',...
    dt(~isnan(NO3NO2_mgL)),NO3NO2_mgL(~isnan(NO3NO2_mgL)),'-',...
    dt(~isnan(TKN_mgL)),TKN_mgL(~isnan(TKN_mgL)),'-'); hold on;
ylabel('LOTT Effluent (mg/L)','fontsize',11)
xline(datetime('01-Apr-2023'),'--','LOTT upgrade completed','fontsize',10)
set(gca,'fontsize',10,'xlim',[datetime('01-Apr-2021') datetime('01-Oct-2023')],...
    'xtick',[datetime('01-Apr-2021'),datetime('01-Oct-2021'),datetime('01-Apr-2022'),...
    datetime('01-Oct-2022'),datetime('01-Apr-2023'),datetime('01-Oct-2023')])
legend([h(1) h(2) h(3)],'NH_3','NO_3+NO_2','TKN','Location','NW','fontsize',10); legend boxoff

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/LOTT_Nutrients.png'],'Resolution',100)    
hold off


