%% plot Entomoneis and Thalassiosira vs Salinity and statistics
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';

yrrange=1993:2019; 
yrlabel=[num2str(yrrange(1)) '-' num2str(yrrange(end))];

[~,~,g,p,diatom_names,phylum_names,sal,chl]=process_SFB_phyto(filepath,[filepath 'Data/microscopy_SFB_v2'],yrrange);

%%
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [.12 .07], [.15 .03]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
T=g(:,strcmp(diatom_names,'Thalassiosira')); E=g(:,strcmp(diatom_names,'Entomoneis'));

subplot(2,1,1)
iSal=sal(find(cumsum(E)>=(0.965*nansum(E)),1));
plot(sal,E,'bo','markersize',4,'markerfacecolor','b'); hold on
    xline(iSal,'k--','linewidth',2); hold on
    set(gca,'yscale','log','xlim',[0 32],'xtick',0:2:32,'fontsize',12,...
        'ylim',[10^3 2*10^7],'ytick',[10^3,10^4,10^5,10^6,10^7],'xticklabel',{},'tickdir','out');
    xlabel('Salinity (psu)','fontsize',12); hold on;
    ylabel('\itEntomoneis','fontsize',15); hold on;
    title('Biomass (\mum^3 mL^{-1})','fontsize',15); hold on;

subplot(2,1,2)
iSal=sal(find(cumsum(T)>=(0.04*nansum(T)),1));
plot(sal,T,'r^','markersize',4,'markerfacecolor','r'); hold on
    xline(iSal,'k--','linewidth',2); hold on
    set(gca,'yscale','log','xlim',[0 32],'xtick',0:2:32,'fontsize',12,...
        'ylim',[10^3 2*10^7],'ytick',[10^3,10^4,10^5,10^6,10^7],'tickdir','out');
    xlabel('Salinity (psu)','fontsize',15); hold on;
    ylabel('\itThalassiosira','fontsize',15); hold on;  

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'Figs/logEntomoneis_Thalassiosira_vsSAL_' yrlabel '.tif'])
hold off

%% statistics
clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
yrrange=2013:2019; 
[T,~,~,~,~,~,~,~]=process_SFB_phyto(filepath,[filepath 'Data/microscopy_SFB_v2'],yrrange);

%% linear regression
EntT=table(T.Salinity,T.Entomoneis_Biomass,'VariableNames',{'Salinity','Entomoneis_Biomass'});
mdl = fitlm(EntT,'ResponseVar','Entomoneis_Biomass')

ThaT=table(T.Salinity,T.Thalassiosira_Biomass,'VariableNames',{'Salinity','Thalassiosira_Biomass'});
mdl = fitlm(ThaT,'ResponseVar','Thalassiosira_Biomass')

%% prep data for GLM
T.Chlorophyll=log10(T.Chlorophyll); 
T.Delta_Outflow=log10(T.Delta_Outflow); 
T.Diatom_Biomass=log10(T.Diatom_Biomass); 
T.Thalassiosira_Biomass=log10(T.Thalassiosira_Biomass);
T.Entomoneis_Biomass=log10(T.Entomoneis_Biomass);

T.Thalassiosira_Biomass(T.Thalassiosira_Biomass<=0)=-.01; 
 T.Entomoneis_Biomass(T.Entomoneis_Biomass<=0)=-.01;

%% final models (2013-2019)
%glm=fitglm(T,'Chlorophyll~Diatom_Biomass+FvFm+Salinity+Turbidity+Light+Ammonium+Delta_Outflow')
glm=fitglm(T,'Diatom_Biomass~FvFm+Light+Nitrate+Ammonium+Turbidity+Mixed_Layer_Depth')
%glm=fitglm(T,'Thalassiosira_Biomass~FvFm+Salinity')
%glm = fitglm(T,'Entomoneis_Biomass~Salinity+FvFm+Light+Nitrate+Ammonium')

R=glm.Rsquared.Ordinary

%% final models (1993-2019)
glm = fitglm(T,'Chlorophyll~Diatom_Biomass+Salinity+Ammonium+Nitrate+Mixed_Layer_Depth+Delta_Outflow')
%glm = fitglm(T,'Diatom_Biomass~Salinity+Turbidity+Silicate+Light+Mixed_Layer_Depth+Temperature+Ammonium+Delta_Outflow')
%glm = fitglm(T,'Thalassiosira_Biomass~Salinity+Delta_Outflow')
%glm = fitglm(T,'Entomoneis_Biomass~Salinity+Delta_Outflow+Light+Nitrate+Ammonium+Mixed_Layer_Depth')

R=glm.Rsquared.Ordinary

%% GLM eval
figure; plotSlice(glm)
figure; plotDiagnostics(glm)
figure; plotResiduals(glm,'fitted')
figure; plotResiduals(glm,'probability')