clear
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\'));
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\'));
filepath = 'C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';

load([filepath 'IFCB-Data\BuddInlet\eqdiam_biovol_2021']);

% remove data from October-March
dt=datetime(matdate,'convertfrom','datenum');
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12);
dt(idx)=[]; ESD(idx)=[];

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
    histogram(cell2mat(ESD),5:2:55); hold on
    set(gca,'fontsize',10,'tickdir','out');
    ylabel('count','fontsize',11)
    xlabel('ESD (\mum)')

%% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_ESD_histogram.png'],'Resolution',100)    
hold off