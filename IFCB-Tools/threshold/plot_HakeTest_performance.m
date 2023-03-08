%% plot_HakeTest_performance 
% requires input from classifier_oob_analysis_hake
clear;
name='CCS_v10';
class2do_full='Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell';

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'IFCB-Data/Shimada/threshold/' name '/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/threshold/' name '/HakeTestSet_performance_' name ''],'Nclass','maxthre','threlist','opt','class','Precision','Recall','F1score','tPos','fNeg','fPos');
testtotal=max(opt.total);

% plot OPT: Recall and Precision, sort by F1
[opt,~]=sortrows(opt,'F1','descend');
[opt,~]=sortrows(opt,'total','descend');
[~,class_s]=get_class_ind( opt.class, 'all', class_indices_path);

figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
yyaxis left;
b=bar([opt.R opt.P],'Barwidth',1,'linestyle','none'); hold on
hline(.9,'k--');
vline((find(opt.total<testtotal,1)-.5),'k-')
set(gca,'ycolor','k', 'xtick', 1:length(class_s), 'xticklabel', class_s); hold on
ylabel('Performance');
col=flipud(brewermap(2,'RdBu')); 
for i=1:length(b)
    set(b(i),'FaceColor',col(i,:));
end  
yyaxis right;
plot(1:length(class_s),opt.total,'k*'); hold on
ylabel('total images in test set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 max(opt.total)], 'xticklabel', class_s); hold on
legend('Recall', 'Precision','Location','W')
title([num2str(max(opt.total)) ' image Hake test set: ' num2str(length(opt.class)) ' classes ranked by F1 score'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[outpath 'HakeTest_F1score_opt_' name '.png'],'Resolution',100)    
hold off

%% plot FP and FN as function of threshold
[~,label]=get_class_ind(class2do_full, 'all',class_indices_path);

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
plot(threlist,fPos(i,:),'-',threlist,fNeg(i,:),'-');hold on
vline(maxthre(i),'k--','opt threshold'); hold on
xlabel('threshold')
ylabel('Proportion of images')
title({char(label);['(Dataset: Hake, ' num2str(Nclass(i)) ' images)']})

legend('False Positives','False Negatives','location','NW'); legend boxoff

if contains(class2do_full,',')
    label=[extractBefore(class2do_full,',') '_grouped'];
else
    label=class2do_full;
end

set(gcf,'color','w');
exportgraphics(gca,[outpath 'Threshold_eval_' label '.png'],'Resolution',100)    
hold off
