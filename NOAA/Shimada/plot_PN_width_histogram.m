%% plot PN cell width histogram
% complete dataset
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
outpath = [filepath 'NOAA/Shimada/Figs/'];
class_indices_path=[filepath 'IFCB-Tools/convert_index_class/class_indices.mat'];   
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'IFCB-Data/Shimada/class/summary_PN_allTB.mat'],...
    'mdateTB','PNwidth_opt','filelistTB','ml_analyzedTB','PNcount_above_optthresh');

dt=datetime(mdateTB,'ConvertFrom','datenum');

figure('Units','inches','Position',[1 1 6.5 4.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.08], [0.12 0.07], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%2019
idx=find(dt<datetime('01-Jan-2021'));
mean_width_19=nanmean([PNwidth_opt(idx).total])
std_width_19=std([PNwidth_opt(idx).total])
max_19=max([PNcount_above_optthresh(idx)./ml_analyzedTB(idx)])

subplot(2,2,1);
plot(dt(idx),PNcount_above_optthresh(idx)./ml_analyzedTB(idx),'-')
set(gca,'xlim',[datetime('28-Jun-2019') datetime('01-Oct-2019')],'fontsize',10,'tickdir','out');
datetick('x', 'mm/dd', 'keeplimits');    
ylabel('PN per mL','fontsize',12)
title('2019','fontsize',12)

subplot(2,2,3);
histogram([PNwidth_opt(idx).total],0:1:10);
set(gca,'xtick',0:2:10,'fontsize',10,'tickdir','out');
xlabel('Width (\mum)','fontsize',12)
ylabel('Count','fontsize',12)

%2021
idx=find(dt>datetime('01-Jan-2021'));
mean_width_21=nanmean([PNwidth_opt(idx).total])
std_width_21=std([PNwidth_opt(idx).total])
max_21=max([PNcount_above_optthresh(idx)./ml_analyzedTB(idx)])

subplot(2,2,2);
plot(dt(idx),PNcount_above_optthresh(idx)./ml_analyzedTB(idx),'-')
set(gca,'xlim',[datetime('28-Jun-2021') datetime('01-Oct-2021')],'fontsize',10,'tickdir','out');
datetick('x', 'mm/dd', 'keeplimits');    
title('2021','fontsize',12)

subplot(2,2,4);
histogram([PNwidth_opt(idx).total],0:1:10);
set(gca,'xtick',0:2:10,'fontsize',10,'tickdir','out');
xlabel('Width (\mum)','fontsize',12)

% set figure parameters
exportgraphics(gcf,[outpath 'PN_width_histogram_CCS.png'],'Resolution',100)    
hold off

