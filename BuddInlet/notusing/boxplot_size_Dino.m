% plot Dinophysis box and whiskers chart
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

mean(parva)
std(parva)
%%
% %%%% histogram
% figure('Units','inches','Position',[1 1 3.5 3],'PaperPositionMode','auto');
%     histogram(ESD,20:1:60,'facecolor',[.5 .5 .5]); hold on
%     %xline(19,':','linewidth',1.5); hold on;
%     set(gca,'xlim',[24 51],'xtick',25:5:50,'ylim',[0 200],'ytick',0:100:200, ...
%        'fontsize',10,'tickdir','out'); hold on;    
%     xlabel('Dinophysis ESD (\mum)')

col=(brewermap(7,'Paired'));
c=[col(2:3,:);col(6:7,:);col(1,:);col(4:5,:)];

%%%% histogram
figure('Units','inches','Position',[1 1 3.5 2.5],'PaperPositionMode','auto');
    h1=histogram(fortii,20:1:60,'FaceColor',c(1,:)); hold on
    h2=histogram(norvegica,20:1:60,'FaceColor',c(3,:)); hold on    
    h3=histogram(acuminata,20:1:60,'FaceColor',c(2,:)); hold on
    h4=histogram(parva,20:1:60,'FaceColor',c(4,:)); hold on
    
    xline(37,':','linewidth',1.5); hold on;
    set(gca,'xlim',[23 51],'xtick',25:5:50,'ylim',[0 180],'ytick',0:90:180, ...
       'fontsize',10,'tickdir','out'); hold on;    
    xlabel('Dinophysis ESD (\mum)')
    ylabel('frequency')
    legend([h1 h2 h3 h4],'location','NW'); legend boxoff;

    exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_sp_histogram.png'],'Resolution',300)    
hold off


%% box and whisker plot
figure('Units','inches','Position',[1 1 5.6 3],'PaperPositionMode','auto');
boxplot(ESD,species); hold on;
    set(gca,'ylim',[20 52],'ytick',20:10:50,'fontsize',11,'tickdir','out');
    ylabel('Equivalent spherical diameter (μm)','fontsize',12)
%xtickangle(0);
% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/BuddInlet/Figs/Dinophysis_ESD_BoxWhiskers_v2.png'],'Resolution',300)    
hold off
