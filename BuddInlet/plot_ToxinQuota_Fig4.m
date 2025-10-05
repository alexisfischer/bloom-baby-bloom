%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2023'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');

% create cells/mL vectors for Other
T.DOtherML=sum([T.DOdioML T.DParvML T.DAcutML],2);

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
fli(~(fli.dt.Year==str2double(yr)),:)=[];
idx=~(dmatrix.Year==str2double(yr)); dmatrix(idx)=[]; ymatrix(:,idx)=[];

%remove nans from microscopy dataset
M=T; M(isnan(M.DinoML_micro),:)=[];

%colorscheme
col=(brewermap(3,'Dark2')); 
c=[col(1,:);col(2,:);col(3,:)];
c(4,:)=[.1 .1 .1];
pink=brewermap(2,'RdPu');

%%%% Total Dinophysis
figure('Units','inches','Position',[1 1 2.5 3.8],'PaperPositionMode','auto');
%subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.13], [0.19 0.05]);
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.12], [0.23 0.18]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(4,1,1);
    idx=(M.DinoML_micro==0);        
    h=plot(M.dt(~idx),[M.DFortML(~idx) M.DAcumML(~idx) M.DNorvML(~idx) M.DOtherML(~idx)],'o-',...
        'Linewidth',.5,'markersize',2); hold on;    
    for i=1:length(h), set(h(i),'Color',c(i,:)); end  
    
    ylabel({'cells/mL'},'fontsize',10); hold on;   
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 12],'ytick',0:6:12,...
        'fontsize', 8,'fontname', 'arial','tickdir','out','ycolor','k')
    datetick('x', 'm', 'keeplimits');    
    ylabel({'cells/mL'},'fontsize',9); 
    title(yr,'fontsize', 10)   
%    lh=legend('\itfortii','\itacuminata','\itnorvegica','other','location','NW');
%    legend boxoff; lh.FontSize = 8; hp=get(lh,'pos');
%   lh.Position=[hp(1)-.03 hp(2)+.02 hp(3) hp(4)]; hold on   
  
subplot(4,1,2)
idx=~isnan(T.PTX2_pgcell);
yyaxis left
plot(T.dt(idx),T.DST_pgcell(idx),'k*-','Markersize',2,'linewidth',.5); hold on
    set(gca,'ylim',[0 12],'xlim',[xax(1) xax(2)],'ytick',0:6:12,'ycolor','k','xticklabel',{},'fontsize', 8,'tickdir','out');
    ylabel({'pg/cell';'DST'},'fontsize',9); hold on;
yyaxis right
plot(T.dt(idx),T.PTX2_pgcell(idx),'o-','color',pink(2,:),'Markersize',2,'linewidth',1); hold on
    set(gca,'ylim',[0 160],'ytick',0:75:150,'xlim',[xax(1) xax(2)],'ycolor',pink(2,:),'xticklabel',{},'fontsize',8,'tickdir','out');
    ylabel({'PTX2'},'fontsize',9); hold on;    
 
subplot(4,1,3)
yyaxis left
idx=~isnan(T.PTX2_pgML);
plot(T.dt(idx),T.DST_pgML(idx),'k*-','Markersize',2,'linewidth',.5); hold on
    set(gca,'ylim',[0 100],'ytick',0:50:100,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'pg/mL';'DST'},'fontsize',9); hold on;
yyaxis right
plot(T.dt(idx),T.PTX2_pgML(idx),'o-','color',pink(2,:),'Markersize',2,'linewidth',1); hold on
    set(gca,'ylim',[0 400],'ytick',0:200:400,'xlim',[xax(1) xax(2)],'ycolor',pink(2,:),'xticklabel',{},...
        'fontsize', 8,'tickdir','out');
    ylabel({'PTX2'},'fontsize',9); hold on;    

subplot(4,1,4)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'k*-','Markersize',2,'linewidth',.5); hold on;
hline(16,'k-'); hold on;
hline(6,'k--'); hold on;

    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'(µg/100g)';'DST'},'fontsize',9); hold on;
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_Species_ToxinQuota_' yr '.png'],'Resolution',300)    
hold off



