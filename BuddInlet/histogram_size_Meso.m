% plot histogram on Mesodinium
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
ifcbpath = '~/Documents/MATLAB/ifcb-data-science/';
addpath(genpath(filepath));
addpath(genpath(ifcbpath));

load([ifcbpath 'IFCB-Data/BuddInlet/manual/summary_meso_width_manual'],...
    'filecomment','runtype','mdate','ESD','large','small','ml_analyzed');
%remove: discrete samples and PMTA triggers
idx=find(contains(filecomment,'trigger')); ESD(idx)=[]; mdate(idx)=[]; filecomment(idx)=[]; runtype(idx)=[]; ml_analyzed(idx)=[]; large(idx)=[]; small(idx)=[];
idx=find(contains(runtype,{'ALT','Alternative'})); ESD(idx)=[]; mdate(idx)=[]; filecomment(idx)=[]; runtype(idx)=[]; ml_analyzed(idx)=[]; large(idx)=[]; small(idx)=[];
dt=datetime(mdate,'convertfrom','datenum');

% small=small./ml_analyzed;
% large=large./ml_analyzed;
% 
% figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
% subplot(2,1,1)
% idx=find(dt.Year==2021);
%     scatter(dt(idx)+365*2,small(idx),5); hold on
% idx=find(dt.Year==2022);
%     scatter(dt(idx)+365,small(idx),5); hold on
% idx=find(dt.Year==2023);
%     scatter(dt(idx),small(idx),5); hold on
% set(gca,'xlim',[datetime('01-Mar-2023') datetime('01-Nov-2023')])
% ylabel('small/mL')        
% legend('2021','2022','2023','location','NW'); legend boxoff;
% 
% subplot(2,1,2)
% idx=find(dt.Year==2021);
%     scatter(dt(idx)+365*2,large(idx),5); hold on
% idx=find(dt.Year==2022);
%     scatter(dt(idx)+365,large(idx),5); hold on
% idx=find(dt.Year==2023);
%     scatter(dt(idx),large(idx),5); hold on
% set(gca,'xlim',[datetime('01-Mar-2023') datetime('01-Nov-2023')])
% ylabel('large/mL')    


% remove data from October-March
idx=find(dt.Month==1 | dt.Month==2 | dt.Month==3 | dt.Month==10 | dt.Month==11 | dt.Month==12);
dt(idx)=[]; ESD(idx)=[];

figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.12 0.05], [0.19 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
yrlist=[2021;2022;2023];
c=brewermap(3,'Set2'); 
for i=1:length(yrlist)
    idx=(dt.Year==yrlist(i));
    histogram(cell2mat([ESD(idx)]),0:1:70,'DisplayStyle','stairs','edgecolor',c(i,:)); hold on
    set(gca,'xlim',[8 45],'xtick',10:10:45,'xticklabel',{},'ylim',[0 600],'ytick',0:300:600, ...
       'fontsize',10,'tickdir','out'); hold on;    
end
    ylabel('particle count','fontsize',11)
    xline(19,':',{'19 \mum'},'linewidth',1.5); hold on;
    legend('2021','2022','2023'); legend boxoff;

subplot(2,1,2)    
    histogram(cell2mat(ESD),0:1:70,'facecolor',[.5 .5 .5]); hold on
    xline(19,':','linewidth',1.5); hold on;
    set(gca,'xlim',[8 45],'xtick',10:10:45,'ylim',[0 600],'ytick',0:300:600, ...
       'fontsize',10,'tickdir','out'); hold on;    
    xlabel('Mesodinium ESD (\mum)')

% set figure parameters
exportgraphics(gcf,[filepath 'BuddInlet/Figs/Mesodinium_ESD_histogram_yr.png'],'Resolution',100)    
hold off
