% plot histogram on Mesodinium
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/manual/summary_dinophysis_species_width_manual'],'mdate',...
    'acuminata','fortii','norvegica','parva','unknownDinophysis');
% elimianted odiosa, acuta, rodundata bc <10 cells were observed
dt=datetime(mdate,'convertfrom','datenum')';

acuminata=cell2mat(acuminata);
fortii=cell2mat(fortii);
norvegica=cell2mat(norvegica);
parva=cell2mat(parva);

ESD=[fortii;norvegica;acuminata;parva];
species=([repmat({'fortii'},length(fortii),1);...
    repmat({'norvegica'},length(norvegica),1);...
    repmat({'acuminata'},length(acuminata),1);...    
    repmat({'parva'},length(parva),1)]);

figure('Units','inches','Position',[1 1 3.8 3.5],'PaperPositionMode','auto');
boxplot(ESD,species); hold on;
    set(gca,'ylim',[29 74],'ytick',30:10:80,'fontsize',11,'tickdir','out');
    ylabel('Equivalent spherical diameter (μm)','fontsize',12)
%xtickangle(0);
% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_ESD_BoxWhiskers.png'],'Resolution',300)    
hold off
