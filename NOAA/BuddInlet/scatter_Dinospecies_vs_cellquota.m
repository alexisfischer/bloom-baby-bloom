%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/BuddInlet_data_summary'],'T');

% T(isnan(T.dinoML_microscopy),:)=[];
% T((T.dinoML_microscopy==0),:)=[];
% T.fx_Dacuminata(isnan(T.fx_Dacuminata))=0;
% T.fx_Dfortii(isnan(T.fx_Dfortii))=0;
% T(isnan(T.DSTng),:)=[];

%T.fx_Dacuminata(T.fx_Dacuminata==0)=.0001;
%T.fx_Dfortii(T.fx_Dfortii==0)=.0001;

figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');

dino=T.fx_Dfortii; tox=T.PTX2_pgcell;
%dino=T.fx_Dacuminata; tox=T.DST_pgcell;

mdl = fitlm(dino, tox)

coefs = mdl.Coefficients.Estimate; % 2x1 [intercept; slope]
h1=scatter(dino(T.dt.Year==2021),tox(T.dt.Year==2021),30,'o','linewidth',1.5); hold on;
h2=scatter(dino(T.dt.Year==2022),tox(T.dt.Year==2022),30,'o','linewidth',1.5); hold on;
h3=scatter(dino(T.dt.Year==2023),tox(T.dt.Year==2023),30,'o','linewidth',1.5); hold on;
h=refline(coefs(2),coefs(1)); h.Color='k';
%%
    set(gca,'tickdir','out','xlim',[0 12],'xtick',0:4:12,...
            'ylim',[0 300],'ytick',0:100:300,'fontsize',10,'box','on');
    xlabel('D. acuminata / D. fortii','fontsize',11); hold on;      
    ylabel('DST / PTX2 ','fontsize',11); hold on;        
    legend([h1, h2, h3],'2021','2022','2023','location','nw');


%% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dinophysis_toxin_relationship.png'],'Resolution',300)    
hold off


% scatter plot
% x=T.fx_Dacuminata.*T.dinoML_microscopy;
% X = [ones(length(x),1) x];
% y=T.DSTng;
% b=X\y;
% scatter(x,y,'ko'); hold on;
% plot(x,X*b,'-r')

figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.08 0.03], [0.18 0.05]);

subplot(2,1,1);
mdl = fitlm(T.fx_Dacuminata.*T.dinoML_microscopy,T.DSTng);
coefs = mdl.Coefficients.Estimate; % 2x1 [intercept; slope]
h1=scatter(T.fx_Dacuminata(T.dt.Year==2021).*T.dinoML_microscopy(T.dt.Year==2021),T.DSTng(T.dt.Year==2021),30,'o','linewidth',1.5); hold on;
h2=scatter(T.fx_Dacuminata(T.dt.Year==2022).*T.dinoML_microscopy(T.dt.Year==2022),T.DSTng(T.dt.Year==2022),30,'o','linewidth',1.5); hold on;
h3=scatter(T.fx_Dacuminata(T.dt.Year==2023).*T.dinoML_microscopy(T.dt.Year==2023),T.DSTng(T.dt.Year==2023),30,'o','linewidth',1.5); hold on;
%scatter(T.fx_Dacuminata.*T.dinoML_microscopy,T.DSTng,'ko'); hold on;
h=refline(coefs(2),coefs(1)); h.Color='k';
    set(gca,'tickdir','out','xlim',[0 12],'xtick',0:4:12,...
            'ylim',[0 300],'ytick',0:100:300,'fontsize',10,'box','on');
    xlabel('D. acuminata cells/mL','fontsize',11); hold on;      
    ylabel('DST (ng)','fontsize',11); hold on;        
    legend([h1, h2, h3],'2021','2022','2023','location','nw');

subplot(2,1,2);
mdl = fitlm(T.fx_Dfortii.*T.dinoML_microscopy,T.PTX2Ng);
coefs = mdl.Coefficients.Estimate; % 2x1 [intercept; slope]
scatter(T.fx_Dfortii(T.dt.Year==2021).*T.dinoML_microscopy(T.dt.Year==2021),T.PTX2Ng(T.dt.Year==2021),30,'o','linewidth',1.5); hold on;
scatter(T.fx_Dfortii(T.dt.Year==2022).*T.dinoML_microscopy(T.dt.Year==2022),T.PTX2Ng(T.dt.Year==2022),30,'o','linewidth',1.5); hold on;
scatter(T.fx_Dfortii(T.dt.Year==2023).*T.dinoML_microscopy(T.dt.Year==2023),T.PTX2Ng(T.dt.Year==2023),30,'o','linewidth',1.5); hold on;
%scatter(T.fx_Dfortii.*T.dinoML_microscopy,T.PTX2Ng,'ko'); hold on;
h=refline(coefs(2),coefs(1)); h.Color='k';
    set(gca,'tickdir','out','xlim',[0 12],'xtick',0:4:12,...
            'ylim',[0 2100],'ytick',0:1000:2000,'fontsize',10,'box','on');
    xlabel('D. fortii cells/mL','fontsize',11); hold on;  
    ylabel('PTX2 (ng)','fontsize',11); hold on;        

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dinophysis_toxin_relationship.png'],'Resolution',300)    
hold off
    
%%
figure('Units','inches','Position',[1 1 3 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.07], [0.12 0.19]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(3,1,1);
title('D. acuminata & DST','fontsize',11); hold on;          
yr='2021';
yyaxis left
plot(T.dt,T.fx_Dacuminata.*T.dinoML_microscopy,'r^','Markersize',3); hold on;
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
            'ylim',[0 6],'ytick',0:3:6,'fontsize',9,'ycolor','r','box','on');
    ylabel([yr ' (cells/mL)'],'fontsize',10); hold on;          
yyaxis right
idx=~isnan(T.DSTng);
plot(T.dt(idx),T.DSTng(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 300],'ytick',0:100:300,'xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('DST (ng)','fontsize',10); hold on;        

subplot(3,1,2);
yr='2022';
yyaxis left
plot(T.dt,T.fx_Dacuminata.*T.dinoML_microscopy,'r^','Markersize',3); hold on;
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
            'ylim',[0 6],'ytick',0:3:6,'fontsize',9,'ycolor','r','box','on');
    ylabel([yr ' (cells/mL)'],'fontsize',10); hold on;          
yyaxis right
idx=~isnan(T.DSTng);
plot(T.dt(idx),T.DSTng(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 300],'ytick',0:100:300,'xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('DST (ng)','fontsize',10); hold on;        

subplot(3,1,3);
yr='2023';
yyaxis left
plot(T.dt,T.fx_Dacuminata.*T.dinoML_microscopy,'r^','Markersize',3); hold on;
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
            'ylim',[0 6],'ytick',0:3:6,'fontsize',9,'ycolor','r','box','on');
    ylabel([yr ' (cells/mL)'],'fontsize',10); hold on;          
yyaxis right
idx=~isnan(T.DSTng);
plot(T.dt(idx),T.DSTng(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 300],'ytick',0:100:300,'xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('DST (ng)','fontsize',10); hold on;        
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dacuminata_DST.png'],'Resolution',300)    
hold off

%% D fortii
figure('Units','inches','Position',[1 1 3 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.07 0.07], [0.12 0.19]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(3,1,1);
title('D. fortii & PTX2','fontsize',11); hold on;          

yr='2021';
yyaxis left
plot(T.dt,T.fx_Dfortii.*T.dinoML_microscopy,'r^','Markersize',3); hold on;
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
            'ylim',[0 8],'ytick',0:4:8,'fontsize',9,'ycolor','r','box','on');
    ylabel([yr ' (cells/mL)'],'fontsize',10); hold on;          
yyaxis right
idx=~isnan(T.PTX2Ng);
plot(T.dt(idx),T.PTX2Ng(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 1500],'ytick',0:500:1500,'xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('PTX2 (ng)','fontsize',10); hold on;        

subplot(3,1,2);
yr='2022';
yyaxis left
plot(T.dt,T.fx_Dfortii.*T.dinoML_microscopy,'r^','Markersize',3); hold on;
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
            'ylim',[0 8],'ytick',0:4:8,'fontsize',9,'ycolor','r','box','on');
    ylabel([yr ' (cells/mL)'],'fontsize',10); hold on;          
yyaxis right
idx=~isnan(T.PTX2Ng);
plot(T.dt(idx),T.PTX2Ng(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 1500],'ytick',0:500:1500,'xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('PTX2 (ng)','fontsize',10); hold on;        

subplot(3,1,3);
yr='2023';
yyaxis left
plot(T.dt,T.fx_Dfortii.*T.dinoML_microscopy,'r^','Markersize',3); hold on;
        set(gca,'xgrid','on','tickdir','out','xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
            'ylim',[0 8],'ytick',0:4:8,'fontsize',9,'ycolor','r','box','on');
    ylabel([yr ' (cells/mL)'],'fontsize',10); hold on;          
yyaxis right
idx=~isnan(T.PTX2Ng);
plot(T.dt(idx),T.PTX2Ng(idx),'ko-','Markersize',3,'linewidth',1); hold on
    set(gca,'ylim',[0 1500],'ytick',0:500:1500,'xlim',[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])],'xticklabel',{},...
        'fontsize', 9,'tickdir','out','ycolor','k');
    ylabel('PTX2 (ng)','fontsize',10); hold on;        
    datetick('x', 'm', 'keeplimits');   
             
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Dfortii_PTX2.png'],'Resolution',300)    
hold off

