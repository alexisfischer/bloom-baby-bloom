%% plot manual vs classifier results for Budd Inlet
clear;
class2do_string='Dinophysis'; ymax=20; 
%class2do_string='Mesodinium'; ymax=30;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'IFCB-Data/BuddInlet/class/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
load([filepath 'IFCB-Data/BuddInlet/class/summary_cells_allTB'],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

%% match up data
%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
%mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);
matdate=datetime(matdate,'convertfrom','datenum');
imclass=find(contains(class2use,class2do_string));

man=sum(classcount(im,imclass),2);
auto=classcountTB_above_optthresh(it,contains(class2useTB,class2do_string));
clearvars im it i imclass ind mdateTB;

figure('Units','inches','Position',[1 1 4 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[~,label]=get_class_ind(class2do_string, 'all',class_indices_path);

%ymax=ceil(max(max([auto./ml_analyzedTB,man./ml_analyzed])));

subplot(3,1,1);
stem(matdate,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2021-04-01') datetime('2021-10-01')],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');            
    set(gca,'xticklabel',{});
    ylabel('2021','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;
 
subplot(3,1,2); 
stem(matdate,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2022-04-01') datetime('2022-10-01')],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');            
    set(gca,'xticklabel',{});
    ylabel('2022','fontsize',12);    

subplot(3,1,3);
stem(matdate,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime('2023-04-01') datetime('2023-10-01')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2023','fontsize',12);    
 
% set figure parameters
exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
hold off
