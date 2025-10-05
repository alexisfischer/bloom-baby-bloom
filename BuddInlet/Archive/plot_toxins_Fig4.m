%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2021'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');
%fli=retime(fli,'hourly','mean');

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
fli(~(fli.dt.Year==str2double(yr)),:)=[];
idx=~(dmatrix.Year==str2double(yr)); dmatrix(idx)=[]; ymatrix(:,idx)=[];

% %find when >=6 ug/100g mussel
% idx=find(T.DST>=6,1); T.dt(idx)
% %28-Jun-2021
% %13-Jun-2022
% %25-July-2023

% %find when >=16 ug/100g mussel
% idx=find(T.DST>=16,1); T.dt(idx)
% %12-Jul-2021
% %10-Aug-2022
% %never in 2023

% Total Dinophysis
figure('Units','inches','Position',[1 1 3 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.11], [0.16 0.24]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(4,1,1);
h = bar(T.dt,[T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',3.5,'linestyle','none');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 1],'ytick',0:.5:1,...
        'fontsize', 8,'fontname', 'arial','tickdir','out','ycolor','k')
    datetick('x', 'm', 'keeplimits');      
    ylabel({'species fx'},'fontsize',9); 
    title(yr,'fontsize', 10)   

subplot(4,1,2); 
P=prctile(ymatrix,[25 50 75],1); x=dmatrix'; y1=P(1,:); y2=P(2,:); y3=P(3,:);
    hf=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw

    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    hn=plot(T.dt(idx),val,'s','markersize',2,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.7); hold on;        
    end
hline(3,'k--');

pink=brewermap(2,'RdPu');
    idx=(T.dinoML_microscopy==0);
    hz=plot(T.dt(idx),T.dinoML_microscopy(idx),'^','color',pink(2,:),'markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;                
    hm=plot(T.dt(~idx),T.dinoML_microscopy(~idx),'^','color',pink(2,:),'markerfacecolor',pink(2,:),'Linewidth',.5,'markersize',4); hold on;            
        set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},...
            'ylim',[0 30],'ytick',0:15:30,'fontsize',8,'ycolor','k','box','on');         
    set(gca,'Layer','top'); grid off;   
    ylabel({'cells/mL'},'fontsize',9); hold on;   

subplot(4,1,3)
yyaxis left
idx=~isnan(T.PTX2_pgML);
plot(T.dt(idx),T.DST_pgML(idx),'ko-','Markersize',3,'markerfacecolor','w','linewidth',1); hold on
    set(gca,'ylim',[0 100],'ytick',0:50:100,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'DST (pg/mL)'},'fontsize',9); hold on;
yyaxis right
green=brewermap(2,'Greens');
plot(T.dt(idx),T.PTX2_pgML(idx),'o-','Color',green(2,:),'MarkerFaceColor',green(2,:),'Markersize',2,'linewidth',1); hold on
    set(gca,'ylim',[0 400],'ytick',0:200:400,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor',green(2,:));
    ylabel({'PTX2 (pg/mL)'},'fontsize',9); hold on;    

subplot(4,1,4)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'ko-','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
hline(16,'k-'); hold on;
hline(6,'k--'); hold on;

    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'DST (µg/100g)'},'fontsize',9); hold on;
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_toxin_vs_cell_' yr '.png'],'Resolution',300)    
hold off
