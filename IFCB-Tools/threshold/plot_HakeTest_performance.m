%% plot_HakeTest_performance 
% requires input from classifier_oob_analysis_hake
filepath = '~/Documents/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/';
val='CCS_NOAA-OSU_v4';

load([filepath 'HakeTestSet_performance_' val ''],'Nclass','maxthre','threlist','opt','class','Precision','Recall','F1score','tPos','fNeg','fPos');
class_indices_path='~/Documents/MATLAB/bloom-baby-bloom/IFCB-Tools/convert_index_class/class_indices.mat';   

%% plot OPT: Recall and Precision, sort by F1
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
ylabel('total images in Hake test set');
set(gca,'ycolor','k', 'xtick', 1:length(class_s),'ylim',[0 max(opt.total)], 'xticklabel', class_s); hold on
legend('Recall', 'Precision','Location','W')
title(['Opt score threshold: ' num2str(length(opt.class)) ' classes ranked by F1 score'])
xtickangle(45);

set(gcf,'color','w');
exportgraphics(gca,[outpath 'threshold/' val '/Figs/HakeTest_F1score_opt_' val '.png'],'Resolution',100)    
hold off

%% plot FP and FN as function of threshold
% this might be wrong
i=20
[~,label]=get_class_ind(classes(i), 'all',class_indices_path);   

%for i=1:length(classes)
figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
plot(threlist,fPos(i,:),'-',threlist,fNeg(i,:),'-');hold on
vline(maxthre(i),'k--','opt threshold'); hold on
xlabel('threshold')
ylabel('Proportion of images')
title({char(label);['(Dataset: Hake, ' num2str(Nclass(i)) ' images)']})
%end
legend('False Positives','False Negatives','location','NW'); legend boxoff

class2do=char(classes(i));
if contains(class2do,',')
    label = [extractBefore(class2do,',') '_grouped'];
else
    label=class2do;
end

set(gcf,'color','w');
exportgraphics(gca,[outpath 'threshold/' val '/Figs/Threshold_eval_' label '.png'],'Resolution',100)    
hold off

%% need to work on this!
%% test classifier against hake test set
clear;
classifiername='CCS_v9'; %USER
class2do_full='Pseudo_nitzschia_large_1cell,Pseudo_nitzschia_small_1cell';

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';    
addpath(genpath(filepath));

if contains(class2do_full,',')
    class2do_string = [extractBefore(class2do_full,',') '_grouped'];
else
    class2do_string=class2do_full;
end

load([filepath 'IFCB-Data/Shimada/class/performance_classifier_' classifiername],'maxthre','opt','optHake');
load([filepath 'IFCB-Data/Shimada/threshold/' classifiername '/summary_allTB_bythre_' class2do_string],'threlist','classcountTB_above_thre','ml_analyzedTB','filelistTB','mdateTB');
load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
[~,label]=get_class_ind(class2do_full, 'all',[filepath 'IFCB-Tools/convert_index_class/class_indices.mat']);

%%%% find opt threshold in summary_allTB_bythre file
optthr=maxthre(strcmp(opt.class,class2do_full));
bin=find(threlist==round(optthr,1));

%%%% sum up grouped classes
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for c = 1:length(ind)-2
        imclass(c)=find(strcmp(class2use,class2do_full(ind(c)+1:ind(c+1)-1)),1);
    end
    c=length(ind)-1;
    imclass(c)=find(strcmp(class2use,class2do_full(ind(c)+1:ind(c+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end

%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
classcountTB_above_thre=classcountTB_above_thre(it,:);
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);
matdate=datetime(matdate,'convertfrom','datenum');

icm=strcmp(class2use,class2do_full);
classcount=sum(classcount(im,imclass),2);

clearvars im it i icm imclass c ind;

%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1);
stem(mdateTB,classcountTB_above_thre(:,bin)./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,classcount./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-01') datetime('2019-09-15')],...
        'xticklabel',{},'fontsize',10); 
    ylabel('2019','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;

subplot(2,1,2);
stem(mdateTB,classcountTB_above_thre(:,bin)./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,classcount./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out',...
        'xlim',[datetime('2021-06-01') datetime('2021-09-15')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2021','fontsize',12);    
 
% % set figure parameters
% exportgraphics(gcf,[filepath 'IFCB-Data/Shimada/threshold/' classifiername '/Figs/Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
% hold off

%% test a specific range of data
manual=classcount;
predicted=classcountTB_above_thre(:,bin);

[C, class] = confusionmat(manual,predicted); 
%total = sum(c_all')'; 
[TP TN FP FN] = conf_mat_props(C); % true positive (TP), true negative (TN), false positive (FP), false negative (FN)

R = TP./(TP+FN); %recall (or probability of detection)
P = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c_all)./sum(c_all)'
F1= 2*((P.*R)./(P+R));