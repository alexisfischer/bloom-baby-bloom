%PN chain length frequency histogram
clear;
classifiername='CCS_NOAA-OSU_v7';
class2do_full='Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_small_3cell';

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');

label={'1cell','2cell','3cell','4cell','5cell'};
for i=1:length(label)
    ax(i)=subplot(1,5,i);   
    val(:,i)=sum(classcount(:,contains(class2use,label(i))),2);
end


%%
figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');

Y=sum(val,1);
X = categorical(label);
X = reordercats(X,label);
bar(X,Y)
set(gca,'fontsize',10)

ylabel('image frequency','fontsize',12)
title('\itPseudo-nitzschia \rmspp.','fontsize',12)

% set figure parameters
exportgraphics(gcf,[outpath 'PN_histogram_CCS.png'],'Resolution',100)    
hold off

%% multipanel plot
figure('Units','inches','Position',[1 1 8 2.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.2 0.1], [0.08 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

for i=1:length(label)
    ax(i)=subplot(1,5,i);   
    histogram(val(:,i),[.5:.5:12.5])
    set(gca,'xlim',[0 12],'xtick',0:5:10,'ylim',[0 50],'ytick',0:25:50,'yticklabel',[],'fontsize',11);
    title(label(i)); hold on
end

ax(1).YTickLabel=0:25:50;
ylabel(ax(1),'frequency','fontsize',14)
xlabel(ax(3),'cells per sample','fontsize',14)

% set figure parameters
exportgraphics(gcf,[outpath 'PN_histogram_CCS.png'],'Resolution',100)    
hold off
