% matchup between PN cells/mL from IFCB and microscopy from SSS
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_cells.mat'],'P');

%%
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 3]); 
scatter(P.Pseudonitzschia,P.PN_mcrspy);
ylabel('microscopy')
xlabel('IFCB')
title('PN cells/mL')
set(gca,'xlim',[0 45],'ylim',[0 45])
axis square; box on;

exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PN_IFCB_microscopy.png'],'Resolution',300)    
