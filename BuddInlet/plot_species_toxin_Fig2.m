%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2023'; % '2023'
ydinolim=[0 4]; ymesolim=[0 10]; 
load([filepath 'Data/BuddInlet_data_summary'],'T','fli','dmatrix','ymatrix');

% %%%% figure out Dinophysis species biomass
% T(isnan(T.dinoML_microscopy),:)=[];
% T((T.dinoML_microscopy==0),:)=[];
% m=sum(T.dinoML_microscopy.*([T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
%     T.fx_Drotundata T.fx_Dparva T.fx_Dacuta]),1);
% Acum=m(1)./sum(m)
% Fort=m(2)./sum(m)
% Norv=m(3)./sum(m)
% Rest=sum(m(4:end))./sum(m)

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
fli(~(fli.dt.Year==str2double(yr)),:)=[];
idx=~(dmatrix.Year==str2double(yr)); dmatrix(idx)=[]; ymatrix(:,idx)=[];

col=(brewermap(7,'Accent'));
c=[col(1,:);col(6,:);col(2,:);col(4,:);col(3,:);col(5,:);col(7,:);];
c(2,:)=[.1 .1 .1];

% Total Dinophysis
figure('Units','inches','Position',[1 1 3 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.11], [0.16 0.24]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(4,1,1);
h = bar(T.dt,[T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',3.5,'linestyle','none');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 1],'ytick',0:.5:1,...
        'fontsize', 8,'fontname', 'arial','tickdir','out','ycolor','k')
    datetick('x', 'm', 'keeplimits');      
    ylabel({'species fx'},'fontsize',10); 
    title(yr,'fontsize', 10)   

subplot(4,1,2); 
P=prctile(ymatrix,[25 50 75],1); x=dmatrix'; y1=P(1,:); y2=P(2,:); y3=P(3,:);
    hf=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw

    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    hn=plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.7); hold on;        
    end
hline(3,'k--');

    idx=(T.dinoML_microscopy==0);
    hz=plot(T.dt(idx),T.dinoML_microscopy(idx),'r^','markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;                
    hm=plot(T.dt(~idx),T.dinoML_microscopy(~idx),'r^','markerfacecolor','r','Linewidth',.5,'markersize',4); hold on;            
    ylabel({'cells/mL'},'fontsize',11); hold on;   
        set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},...
            'ylim',[0 15],'ytick',0:7:14,'fontsize',8,'ycolor','k','box','on');         
set(gca,'Layer','top'); grid off;   

%%%% blooms
% vline(datetime('2022-06-26'))
% vline(datetime('2022-07-07'))
% 
% vline(datetime('2022-07-25'))
% vline(datetime('2022-08-05'))
% 
% vline(datetime('2022-08-28'))
% vline(datetime('2022-09-10'))
% 
% vline(datetime('2022-09-21'))
% vline(datetime('2022-09-28'))
% 
% vline(datetime('2023-07-04'))
% vline(datetime('2023-08-19'))

subplot(4,1,3)
yyaxis left
idx=~isnan(T.PTX2Ng);
plot(T.dt(idx),T.DSTng(idx),'ko-','Markersize',3,'markerfacecolor','w','linewidth',1); hold on
    set(gca,'ylim',[0 300],'ytick',0:150:300,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'DST (ng)'},'fontsize',10); hold on;
yyaxis right
plot(T.dt(idx),T.PTX2Ng(idx),'o-','Color',c(1,:),'MarkerFaceColor',c(1,:),'Markersize',2,'linewidth',1); hold on
    set(gca,'ylim',[0 1600],'ytick',0:800:1600,'xlim',[xax(1) xax(2)],'xticklabel',{},...
        'fontsize', 8,'tickdir','out','ycolor',c(1,:));
    ylabel({'PTX2 (ng)'},'fontsize',10); hold on;    

subplot(4,1,4)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'ko-','Markersize',3,'markerfacecolor','w','linewidth',1); hold on;
hline(16,'k--'); hold on;
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k');
    ylabel({'DST (µg/100g)'},'fontsize',11); hold on;
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_toxin_vs_cell_' yr '.png'],'Resolution',300)    
hold off


%% v2 small vs large Dinophysis
figure('Units','inches','Position',[1 1 2.8 4.7],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.05 0.09], [0.15 0.21]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];

subplot(5,1,1);
h = bar(T.dt,[T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',3.5,'linestyle','none');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xaxislocation','top','xlim',xax,'ylim',[0 1],'ytick',0:.5:1,...
        'fontsize', 8,'fontname', 'arial','tickdir','out','ycolor','k')
    datetick('x', 'm', 'keeplimits');      
    ylabel({'species fx'},'fontsize',10); 
    title(yr,'fontsize', 10)   

subplot(5,1,2); 
plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.7); hold on;        
    end
    
    idx=(T.dinoML_microscopy==0);
    plot(T.dt(idx),T.dinoML_microscopy(idx),'r^','markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;                
    plot(T.dt(~idx),T.dinoML_microscopy(~idx),'r^','markerfacecolor','r','Linewidth',.5,'markersize',4); hold on;            
    set(gca,'tickdir','out','xlim',xax,'xticklabel',{},...
        'ylim',[0 15],'ytick',0:7:14,'fontsize',8,'ycolor','k','box','on');         
    ylabel({'cells/mL'},'fontsize',10); hold on;       
    
vline(datetime('02-Jul-2023')); hold on
vline(datetime('27-Aug-2023')); hold on

subplot(5,1,3); 
%yyaxis left
    p1=plot(fli.dt,fli.dinoLarge,'.','Color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.7); hold on;        
    end
  
    idx=(T.fx_Dfortii.*T.dinoML_microscopy==0);
    plot(T.dt(idx),T.fx_Dfortii(idx).*T.dinoML_microscopy(idx),'^','color',c(1,:),'markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;                
    plot(T.dt(~idx),T.fx_Dfortii(~idx).*T.dinoML_microscopy(~idx),'^','color',c(1,:),'markerfacecolor',c(1,:),'Linewidth',.5,'markersize',4); hold on;            
        
    set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},'ylim',[0 15],...
        'ytick',0:7:14,'fontsize',8,'ycolor','k','box','on'); grid off;           
    ylabel({'large/mL'},'fontsize',10); hold on;   
 
% yyaxis right
%     idx=~isnan(T.PTX2Ng);
%     p2=plot(T.dt(idx),T.PTX2Ng(idx),':','color','k','MarkerFaceColor','k','Markersize',7,'linewidth',1); hold on
%     set(gca,'ylim',[0 2100],'ytick',0:1000:2000,'xlim',[xax(1) xax(2)],...
%         'xticklabel',{},'fontsize', 8,'tickdir','out','ycolor','k');
%     ylabel({'PTX2 (ng)'},'fontsize',10); hold on;    
% 
%     % put left axis in background    
%     p1.ZData = zeros(size(p1.XData));
%     p2.ZData = ones(size(p2.XData));

subplot(5,1,4); 
%yyaxis left
    p1=plot(fli.dt,fli.dinoSmall,'.','Color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.7); hold on;        
    end
    
    idx=(T.fx_Dacuminata.*T.dinoML_microscopy==0);
    plot(T.dt(idx),T.fx_Dacuminata(idx).*T.dinoML_microscopy(idx),'^','color',c(2,:),'markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;                
    plot(T.dt(~idx),T.fx_Dacuminata(~idx).*T.dinoML_microscopy(~idx),'^','color',c(2,:),'markerfacecolor',c(2,:),'Linewidth',.5,'markersize',4); hold on;            
    
    set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},'ylim',[0 15],...
        'ytick',0:7:14,'fontsize',8,'ycolor','k','box','on'); grid off;           
    ylabel({'small/mL'},'fontsize',10); hold on;   
 
% yyaxis right
%     idx=~isnan(T.DSTng);
%     p2=plot(T.dt(idx),T.DSTng(idx),':','color','k','MarkerFaceColor','k','Markersize',7,'linewidth',1); hold on
%     set(gca,'ylim',[0 300],'ytick',0:150:300,'xlim',[xax(1) xax(2)],...
%         'xticklabel',{},'fontsize', 8,'tickdir','out','ycolor','k');
%     ylabel({'DST (ng)'},'fontsize',10); hold on;    
% 
%     % put left axis in background    
%     p1.ZData = zeros(size(p1.XData));
%     p2.ZData = ones(size(p2.XData));

subplot(5,1,5)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'ko:','Markersize',2.5,'linewidth',1.2); hold on;
hline(16,'k:'); hold on;
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize',8,'tickdir','out','ycolor','k');
    ylabel({'DST (µg/100g)'},'fontsize',10); hold on;
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_toxin_vs_dinosize_' yr '.png'],'Resolution',300)    
hold off

%% v1 small vs large Dinophysis
figure('Units','inches','Position',[1 1 3 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.05 0.09], [0.2 0.16]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];
%col=(brewermap(7,'Paired')); c=[col(2:3,:);col(6:7,:);col(1,:);col(4:5,:)];
col=(brewermap(7,'Accent'));
c=[col(1,:);col(6,:);col(2,:);col(7,:);col(3,:);col(5,:);col(4,:);];

subplot(5,1,1); 
plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,...
        'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'-','color','k','linewidth',2.7); hold on;        
    end

    idx=(T.dinoML_microscopy==0);
    plot(T.dt(idx),T.dinoML_microscopy(idx),'r^','markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;                
    plot(T.dt(~idx),T.dinoML_microscopy(~idx),'r^','markerfacecolor','r','Linewidth',.5,'markersize',4); hold on;            
    set(gca,'xaxislocation','top','tickdir','out','xlim',xax,...
        'ylim',[0 15],'ytick',0:7:14,'fontsize',10,'ycolor','k','box','on');         
    datetick('x', 'm', 'keeplimits');  
    ylabel({'cells/mL'},'fontsize',11); hold on;       
    title(yr,'fontsize', 11)   

subplot(5,1,2);
h = bar(T.dt,[T.fx_Dfortii T.fx_Dacuminata T.fx_Dnorvegica T.fx_Dodiosa...
    T.fx_Drotundata T.fx_Dparva T.fx_Dacuta],'stack','Barwidth',3.5,'linestyle','none');
    for i=1:length(h), set(h(i),'FaceColor',c(i,:)); end  
    set(gca,'xlim',xax,'ylim',[0 1],'ytick',0:.5:1,'xticklabel',{},...
        'fontsize', 10,'fontname', 'arial','tickdir','out','ycolor','k')
    ylabel({'species fx'},'fontsize',11); 

subplot(5,1,3); 
yyaxis right
    p1=plot(fli.dt,fli.dinoLarge,'.','Color',c(1,:),'markersize',4,'Linewidth',.5); hold on; %raw
    set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},'ylim',[0 15],...
        'ytick',0:7:14,'fontsize',10,'ycolor',c(1,:),'box','on'); grid off;           
    ylabel({'large/mL'},'fontsize',11); hold on;   
 
yyaxis left
    idx=~isnan(T.PTX2Ng);
    p2=plot(T.dt(idx),T.PTX2Ng(idx),'k.:','MarkerFaceColor','k','Markersize',10,'linewidth',1.5); hold on
    set(gca,'ylim',[0 2100],'ytick',0:1000:2000,'xlim',[xax(1) xax(2)],...
        'xticklabel',{},'fontsize', 10,'tickdir','out','ycolor','k');
    set(gca,'SortMethod', 'depth');
    ylabel({'PTX2 (ng)'},'fontsize',11); hold on;    
  
    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dinoSmall_fl)); val=0.12*ones(size(idx));
    plot(T.dt(idx),val,'ks','markersize',3,'linewidth',.5,'markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dinoSmall_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'k-','linewidth',2.7); hold on;        
    end

    % put left axis in background    
    p1.ZData = zeros(size(p1.XData));
    p2.ZData = ones(size(p2.XData));

subplot(5,1,4); 
yyaxis right
    p1=plot(fli.dt,fli.dinoSmall,'.','Color',c(2,:),'markersize',4,'Linewidth',.5); hold on; %raw
    set(gca,'xgrid','on','tickdir','out','xlim',xax,'xticklabel',{},'ylim',[0 15],...
        'ytick',0:7:14,'fontsize',10,'ycolor',c(2,:),'box','on'); grid off;           
    ylabel({'small/mL'},'fontsize',11); hold on;   
 
yyaxis left
    idx=~isnan(T.DSTng);
    p2=plot(T.dt(idx),T.DSTng(idx),'k.:','MarkerFaceColor','k','Markersize',10,'linewidth',1.5); hold on
    set(gca,'ylim',[0 300],'ytick',0:150:300,'xlim',[xax(1) xax(2)],...
        'xticklabel',{},'fontsize', 10,'tickdir','out','ycolor','k');
    set(gca,'SortMethod', 'depth');
    ylabel({'DST (ng)'},'fontsize',11); hold on;    
  
    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dinoSmall_fl)); val=0.12*ones(size(idx));
    plot(T.dt(idx),val,'ks','markersize',3,'linewidth',.5,'markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dinoSmall_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.13*ones(size(dti));
        plot(dti,val,'k-','linewidth',2.7); hold on;        
    end

    % put left axis in background    
    p1.ZData = zeros(size(p1.XData));
    p2.ZData = ones(size(p2.XData));

subplot(5,1,5)
idx=~isnan(T.DST);
plot(T.dt(idx),T.DST(idx),'ko:','Markersize',3,'linewidth',1.5); hold on;
hline(16,'k:'); hold on;
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize',10,'tickdir','out','ycolor','k');
    ylabel({'DST (µg/100g)'},'fontsize',11); hold on;
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_toxin_vs_dinosize_' yr '.png'],'Resolution',300)    
hold off


