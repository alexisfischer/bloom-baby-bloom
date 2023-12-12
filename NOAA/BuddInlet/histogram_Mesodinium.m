% plot histogram on Mesodinium
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual.mat'])

%%
M=eqdiam(:,strcmp(class2use,'Mesodinium'));
Mb=eqdiam(:,strcmp(class2use,'Mesodinium_bad'));

figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');

    histogram(M,10:2:60); hold on
    histogram(Mb,10:2:60); hold on
    set(gca,'xlim',[10 60],'xtick',10:10:60,'fontsize',10,'xaxislocation','bottom','tickdir','out');
    ylabel('Count','fontsize',11)
    xlabel('ESD (um)')
    legend('"Mesodinium"','"Mesodinium bad"','Location','NorthOutside'); legend boxoff

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Mesodinium_ESD_histogram.png'],'Resolution',100)    
hold off
