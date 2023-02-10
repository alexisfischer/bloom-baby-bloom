clear
class2do_string = 'Akashiwo'; ymax=30;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/threshold/Coeff_' class2do_string],'slope','bin','chosen_threshold');
load([filepath 'IFCB-Data/Shimada/threshold/summary_allTB_bythre_' class2do_string],'threlist','classcountTB_above_thre','ml_analyzedTB','mdateTB');
load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','matdate','ml_analyzed');

[~,label]=get_class_ind(class2do_string, 'all',[filepath 'IFCB-Tools/convert_index_class/class_indices.mat']);

mdateTB=datetime(mdateTB,'convertfrom','datenum');
y_mat=classcountTB_above_thre(:,bin)./ml_analyzedTB;
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

ind2 = strmatch(class2do_string, class2use);
mdate_mat_manual=datetime(matdate,'convertfrom','datenum');
y_mat_manual=classcount(:,ind2)./ml_analyzed;

clearvars ml_analyzedTB bin threlist ind2 i ind2 classcount ml_analyzed matdate classcountTB_above_thre class2use

%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.13 0.08], [0.09 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1);
stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ind_nan=find(~isnan(y_mat_manual));
    plot(mdate_mat_manual(ind_nan), y_mat_manual(ind_nan),'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2019-06-01') datetime('2019-09-15')],'fontsize',10); 
    ylabel(['cells mL^{-1}\bf'],'fontsize',12);    
    title(label,'fontsize',12); 
    
subplot(2,1,2);
stem(mdateTB, y_mat./slope,'k-','Linewidth',.5,'Marker','none'); hold on; %This adjusts the automated counts by the chosen slope. 
    ind_nan=find(~isnan(y_mat_manual));
    plot(mdate_mat_manual(ind_nan), y_mat_manual(ind_nan),'r*','Markersize',6,'linewidth',.8);
    set(gca,'xgrid','on','tickdir','out','xlim',[datetime('2021-06-01') datetime('2021-09-15')],'fontsize',10); 
 
%% set figure parameters
exportgraphics(gcf,[filepath 'IFCB-Data/Shimada/threshold/Figs/Manual_automated_' num2str(class2do_string) '.png'],'Resolution',100)    
hold off
