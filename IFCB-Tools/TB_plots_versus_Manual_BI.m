%% plot manual vs classifier results for Budd Inlet
clear;
classifiername='NOAA-OSU_v1';
class2do_full='Dinophysis_acuminata,Dinophysis_acuta,Dinophysis_caudata,Dinophysis_fortii,Dinophysis_norvegica,Dinophysis_odiosa,Dinophysis_parva,Dinophysis_rotundata,Dinophysis_tripos';
%class2do_full='Mesodinium';

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'IFCB-Data/BuddInlet/class/' classifiername '/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed','filelist');
load([filepath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB_' classifiername],...
    'class2useTB','classcountTB_above_optthresh','filelistTB','mdateTB','ml_analyzedTB');

% match up data
%%%% find matched files and class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);
matdate=datetime(matdate,'convertfrom','datenum');

%%%% sum up grouped classes
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end

man=sum(classcount(im,imclass),2);
auto=classcountTB_above_optthresh(it,strcmp(class2do_full,class2useTB));

clearvars im it i imclass ind;

%%%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 4 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.1 0.1], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

[~,label]=get_class_ind(class2do_full, 'all',class_indices_path);

ymax=ceil(max(max([auto./ml_analyzedTB,man./ml_analyzed])));

subplot(2,1,1);
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    datetick('x', 'mmm', 'keeplimits');        
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2021-05-01') datetime('2021-11-01')],...
        'xticklabel',{},'ylim',[0 ymax],'fontsize',10); 
    ylabel('2021','fontsize',12);    
    title([char(label) ' (cells mL^{-1})'],'fontsize',12); 
 legend('classifier','manual','location','nw');legend boxoff;

subplot(2,1,2);
stem(mdateTB,auto./ml_analyzedTB,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    plot(matdate,man./ml_analyzed,'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','ylim',[0 ymax],...
        'xlim',[datetime('2022-05-01') datetime('2022-11-01')],'fontsize',10); 
    datetick('x', 'mmm', 'keeplimits');    
    ylabel('2022','fontsize',12);    
 
if contains(class2do_full,',')
    class2do_string = [extractBefore(class2do_full,',') '_grouped'];
else
    class2do_string=class2do_full;
end

% set figure parameters
exportgraphics(gcf,[outpath 'Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
hold off
