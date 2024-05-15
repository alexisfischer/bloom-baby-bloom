%% plot fx PN species composition bar charts by latitude using SEM data
% Shimada 2019 and 2021
% Fig. 3 in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear; 

%%%%USER
fprint=0; % 1 to print; 0 to not
yr=2019; % 2019; 2021
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/'; %enter filepath

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
load([filepath 'Data/HAB_merged_Shimada19-21'],'HA');
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples
HA((HA.lat<41),:)=[]; %remove CA stations

% select year of data
P(~(P.DT.Year==yr),:)=[];    
HA(~(HA.dt.Year==yr),:)=[];    

% adjust plotting location of bars
if yr==2019
    val=4.3;
    HA.stlabel(:)=fliplr(1:1:length(HA.st)); %add stations   
    HA.lat(end-1)=HA.lat(end-1)-.18;
    HA.lat(end-2)=HA.lat(end-2)-.2;
elseif yr==2021
    val=4.0;    
    HA.stlabel(:)=9+fliplr(1:1:length(HA.st)); %add stations  
    HA.lat(end-1)=HA.lat(end-1)-.3;
    HA.lat(end)=HA.lat(end)+.1;    
end

c=brewermap(7,'Set3'); col=[c(4,:);c(6,:);c(1,:);c(3,:);c(2,:);c(5,:);c(7,:)];

%% plot species composition for each year
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1.7 3.85]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.14 0.14], [0.12 0.03], [0.06 0.06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(1,2,1)
 stem(P.LAT,P.PN_cell,'k','marker','none');
 set(gca,'ylim',[0 100],'ytick',50:50:100,'xlim',[39.9 49],'tickdir','out',...
     'xticklabel',{},'fontsize',9);
 ylabel('PN cells/mL','fontsize',10); hold on;
 view([90 -90]);

subplot(1,2,2)
b=bar(HA.lat,[HA.fx_aust,HA.fx_mult,HA.fx_frau,HA.fx_heim,HA.fx_pseu,HA.fx_pung,HA.fx_deli],...
    'stacked','FaceColor','flat'); hold on;
for i=1:length(col)
    set(b(i),'FaceColor',col(i,:)); hold on;
end
set(gca,'ylim',[0 1],'ytick',.5:.5:1,'xlim',[39.9 49],'xtick',HA.lat,...
    'xticklabel',num2str(HA.stlabel),'fontsize',9);
% legend({'australis','multiseries','fraudulenta','heimii','pseudodeli.',...
%     'pungens','delicatatisi.'},'Location','NorthOutside','fontsize',9);legend boxoff; hold on;
ylabel('fx of sample','fontsize',10); hold on;
view([90 -90])

if fprint
    exportgraphics(fig,[filepath 'Figs/SEM_bar_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 


%% plot the SEM legend of species names
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1.7 3.85]); 

b=bar(HA.lat,[HA.fx_aust,HA.fx_mult,HA.fx_frau,HA.fx_heim,HA.fx_pseu,HA.fx_pung,HA.fx_deli],...
    'stacked','FaceColor','flat'); hold on;
for i=1:length(col)
    set(b(i),'FaceColor',col(i,:)); hold on;
end
set(gca,'ylim',[0 1],'ytick',.5:.5:1,'xlim',[39.9 49],'xtick',HA.lat,...
    'xticklabel',num2str(HA.stlabel),'fontsize',9);
 legend({'\itaustralis','\itmultiseries','\itfraudulenta','\itheimii','\itpseudodeli.',...
     '\itpungens','\itdelicatatiss.'},'Location','NorthOutside','fontsize',9);legend boxoff; hold on;
ylabel('fx of sample','fontsize',10); hold on;
view([90 -90])

if fprint
    exportgraphics(fig,[filepath 'Figs/SEM_legend.png'],'Resolution',300)    
end
hold off 
