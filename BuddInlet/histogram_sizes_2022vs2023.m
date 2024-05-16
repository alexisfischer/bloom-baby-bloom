%% histogram of what was imaged between 2022 and 2023
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
ifcbpath = '~/Documents/MATLAB/ifcb-data-science/';
addpath(genpath(filepath));
addpath(genpath(ifcbpath));

load([ifcbpath 'IFCB-Data/BuddInlet/class/summary_biovol_allTB'],'class2useTB',...
    'ESD_above_optthreshTB','mdateTB','runtypeTB','filecommentTB');

dt=datetime(mdateTB,'convertfrom','datenum');

% remove discrete samples (data with file comment)
idx=find(contains(filecommentTB,'trigger'));
ESD_above_optthreshTB(idx,:)=[]; runtypeTB(idx)=[]; filecommentTB(idx)=[]; dt(idx)=[];

% remove PMTA triggers
idx=find(contains(runtypeTB,{'ALT','Alternative'}));
ESD_above_optthreshTB(idx,:)=[]; runtypeTB(idx)=[]; filecommentTB(idx)=[]; dt(idx)=[];

% remove 2021
idx=(dt.Year==2021);
ESD_above_optthreshTB(idx,:)=[]; runtypeTB(idx)=[]; filecommentTB(idx)=[]; dt(idx)=[];

% remove data from October-March
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12);
ESD_above_optthreshTB(idx,:)=[]; runtypeTB(idx)=[]; filecommentTB(idx)=[]; dt(idx)=[];

clearvars runtypeTB filecommentTB mdateTB idx
%% separate data into 2021-2022 and 2023
idx=(dt.Year==2023);
ESD22=ESD_above_optthreshTB(~idx); ESD22=ESD22(:); 
ESD23=ESD_above_optthreshTB(idx); ESD23=ESD23(:); 

figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.15 0.04], [0.18 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings

subplot(2,1,1)
    histogram(ESD22(~isnan(ESD22)),10:5:100); hold on
    set(gca,'xlim',[20 100],'xtick',20:10:100,'xticklabel',{},'ylim',[0 1000],'fontsize',10,'tickdir','out');
    ylabel('2022','fontsize',11)

subplot(2,1,2)
    histogram(ESD23(~isnan(ESD23)),10:5:100); hold on
    set(gca,'xlim',[20 100],'xtick',20:10:100,'ylim',[0 1000],'fontsize',10,'tickdir','out');
    ylabel('2023','fontsize',11)
    xlabel('ESD (\mum)')

%% set figure parameters
exportgraphics(gcf,[filepath 'BuddInlet/Figs/Mesodinium_ESD_histogram.png'],'Resolution',100)    
hold off
