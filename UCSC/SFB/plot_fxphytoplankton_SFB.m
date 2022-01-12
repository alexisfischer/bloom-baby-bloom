%% plot effect of salinity on diatoms in the Central and North Bay
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';

%yrrange=2013:2019; 
yrrange=1993:2019; 
yrlabel=[num2str(yrrange(1)) '-' num2str(yrrange(end))];

[~,~,g,p,diatom_names,phylum_names,sal,chl]=process_SFB_phyto(filepath,[filepath 'Data/microscopy_SFB_v2'],yrrange);

% bin data
edges=(0:2:33)'; %bin data by salinity
g_bin=NaN*ones(length(edges),size(g,2)); p_bin=NaN*ones(length(edges),size(p,2)); 
diat_bin=NaN*ones(length(edges),1); diat_std=diat_bin; diat=p(:,strcmp(phylum_names,'BACILLARIOPHYTA')); 
chl_bin=diat_bin; chl_std=diat_bin;
[Y,SAL]=discretize(sal,edges,edges(2:end));

for i=2:length(SAL)
    idx=find(Y==SAL(i));
    for j=1:size(g_bin,2)
        g_bin(i,j)=nansum(g(idx,j));        
    end    
    for k=1:size(p_bin,2)
        p_bin(i,k)=nansum(p(idx,k));        
    end     
    diat_bin(i)=nansum(diat(idx));            
    chl_bin(i)=nansum(chl(idx));             
end

idx=isnan(g_bin(:,1)); g_bin(1,:)=[]; p_bin(1,:)=[]; SAL(idx)=[]; diat_bin(idx)=[]; chl_bin(idx)=[]; 
clearvars i j k ib idx edges

%% plot fx of phylum and diatoms with dots for diatoms and chl
figure('Units','inches','Position',[1 1 7. 9.2],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [.07 .01], [.1 .25]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(4,1,1);
    bar(SAL-1,chl_bin,'BarWidth',1,'edgealpha',.1,'facecolor',[.7 .7 .7]); hold on
    plot(sal,chl,'ko','linewidth',.1,'markerfacecolor','k','markersize',3);       
    set(gca,'yscale','log','xlim',[0 32],'xtick',0:2:32,'xticklabel',{},...
        'ylim',[10^0 10^3],'ytick',[10^1,10^2,10^3],'ycolor','k','tickdir','out','fontsize',12);    
    ylabel('Chlorophyll-\ita','fontsize',14); %'\rm(\mug L^{-1})'}

subplot(4,1,2);
total=nansum(p_bin,2);
OTHER=nansum([p_bin(:,strcmp(phylum_names,'CHRYSOPHYCEAE')),...
    p_bin(:,strcmp(phylum_names,'EUGLENOPHYTA')),...
    p_bin(:,strcmp(phylum_names,'EUSTIGMATOPHYCEAE')),...
    p_bin(:,strcmp(phylum_names,'HAPTOPHYTA')),...    
    p_bin(:,strcmp(phylum_names,'RAPHIDOPHYCEAE'))],2);

h=bar(SAL-1,[p_bin(:,strcmp(phylum_names,'BACILLARIOPHYTA'))./total,...
    p_bin(:,strcmp(phylum_names,'CRYPTOPHYTA'))./total,...
    p_bin(:,strcmp(phylum_names,'CHLOROPHYTA'))./total,...
    p_bin(:,strcmp(phylum_names,'DINOPHYCEAE'))./total,...
    p_bin(:,strcmp(phylum_names,'CYANOPHYCEAE'))./total,...
    OTHER./total],'stack','BarWidth',1,'edgealpha',.1); 
    col=[brewermap(length(h)-1,'Set3');[1,1,1]]; 
 
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end
    set(gca,'xlim',[0 32],'xtick',0:2:32,'xticklabel',{},'ylim',[0 1],'ytick',0.2:0.2:1,...
        'tickdir','out','fontsize',12);
    lh=legend("Diatoms","Cryptophytes","Chlorophytes","Dinoflagellates",...
        "Cyanophytes","Other",'Location','East');
    legend boxoff; lh.FontSize = 12; hp=get(lh,'pos');
    lh.Position=[hp(1)+.27 hp(2)+.04 hp(3) hp(4)]; hold on;
    ylabel('fx total biomass','fontsize',14);     

subplot(4,1,3)
    h=bar(SAL-1,diat_bin,'BarWidth',1,'edgealpha',.1,'FaceColor',col(1,:)); hold on
    plot(sal,diat,'k^','linewidth',.1,'markerfacecolor','k','markersize',3);       
    set(gca,'yscale','log','xlim',[0 32],'xtick',0:2:32,'ylim',[10^5 5*10^8],...
        'ytick',[10^5,10^6,10^7,10^8],'xticklabel',{},'ycolor','k','tickdir','out','fontsize',12);    
    ylabel('Diatom biomass','fontsize',14); 
    
subplot(4,1,4)
total=p_bin(:,strcmp(phylum_names,'BACILLARIOPHYTA'));
val=[g_bin(:,strcmp(diatom_names,'Thalassiosira')),g_bin(:,strcmp(diatom_names,'Entomoneis')),...
    g_bin(:,strcmp(diatom_names,'Coscinodiscus')),g_bin(:,strcmp(diatom_names,'Ditylum')),...
    g_bin(:,strcmp(diatom_names,'Skeletonema')),g_bin(:,strcmp(diatom_names,'Aulacoseira')),...
    g_bin(:,strcmp(diatom_names,'Cyclotella')),g_bin(:,strcmp(diatom_names,'Gyrosigma')),...
    g_bin(:,strcmp(diatom_names,'Actinoptychus')),g_bin(:,strcmp(diatom_names,'Nitzschia')),...
    g_bin(:,strcmp(diatom_names,'Ulnaria')),g_bin(:,strcmp(diatom_names,'Paralia'))];
  
h=bar(SAL-1,[val./total,(total-nansum(val,2))./total],'stack','BarWidth',1,'edgealpha',.1); 
    col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
    col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];
    col=[col_diat(9,:);col_dino(1,:);col_diat(14,:);col_dino(14,:);col_dino(2,:);...
        col_dino(4,:);col_diat(18,:);col_dino(11,:);col_diat(3,:);col_diat(6,:);...
        col_dino(12,:);col_dino(16,:);[1,1,1]]; 
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end
    
    set(gca,'xlim',[0 32],'xtick',0:2:32,'ylim',[0 1],'ytick',0.2:0.2:1,...
        'tickdir','out','fontsize',12);
    ylabel('fx total Diatom biomass','fontsize',14); 
    xlabel('Surface Salinity (psu)','fontsize',14); hold on;
    lh=legend('\itThalassiosira','\itEntomoneis','\itCoscinodiscus',...
        '\itDitylum','\itSkeletonema','\itAulacoseira','\itCyclotella',...
        '\itGyrosigma','\itActinoptychus','\itNitzschia','\itUlnaria',...
        '\itParalia','Other','Location','East');
    legend boxoff; lh.FontSize = 12; hp=get(lh,'pos');
    lh.Position=[hp(1)+.27 hp(2)+.04 hp(3) hp(4)]; hold on;

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/bin_fx_diatombiomass_SAL_Chl_' yrlabel '.tif'])
hold off  
    
