%% find the environmental factors correlated with the large toxic PN patches
% vs all the other PN patches
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=0; %0=don't print, 1=print
type=1; %1=discrete, 2=sensor

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');

P.PN=sum([P.Pseudonitzschia_large,P.Pseudonitzschia_medium,P.Pseudonitzschia_small],2);

P.PN19=zeros(size(P.PN)); P.PN21=zeros(size(P.PN));
P.pDA19=zeros(size(P.PN)); P.pDA21=zeros(size(P.PN));

    idx=P.DT<datetime('01-Jan-2020'); 
    P.PN19(idx)=P.PN(idx); P.pDA19(idx)=P.pDA_ngL(idx);    
    idx=P.DT>datetime('01-Jan-2020'); 
    P.PN21(idx)=P.PN(idx); P.pDA21(idx)=P.pDA_ngL(idx);   

if type==1
    idD=isnan(P.SilicateM); P(idD,:)=[]; %remove nans from discrete dataset    
    X=[P.TEMP,P.SAL,P.PCO2,P.NitrateM,P.PhosphateM,P.Pstar,P.SilicateM,P.Sstar];
    Xlabel={'Temperature' 'Salinity' 'pCO2' 'Nitrate' 'Phosphate' 'P*' 'Silicate' 'Si*' };
    pos=[1 1 4 4.5];
elseif type==2    
    X=[P.TEMP,P.SAL,P.PCO2];
    Xlabel={'Temperature' 'Salinity'};
    pos=[1 1 3.5 2.5];
end

Y=[P.PN19,P.pDA19,P.PN21,P.pDA21];
Ylabel={'PN-19' 'pDA-19' 'PN-21' 'pDA-21'};
[rho,pval] = corr(X,Y,'Type','Pearson','Rows','complete');

fig=figure; set(gcf,'color','w','Units','inches','Position',pos); 
imagesc(rho);
xtickangle(45)
col=flipud(brewermap(256,'RdBu')); colormap(gca,col); colorbar();
clim([-1 1]);
title(['(n = ' num2str(length(Y)) ')']);
axis tight; axis equal; 
set(gca,'Xtick',1:1:length(rho),'xticklabel',Ylabel,'xaxislocation','top',...
   'ytick',1:1:length(rho),'yticklabel',Xlabel)

for i=1:size(pval,2)
    for j=1:size(pval,1)
        if pval(j,i)<=0.05
            text(i,j,'*','fontsize',16);
        else
        end
    end
end

if fprint
    if type==1
        exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PN_correlation_discrete.png'],'Resolution',300)    
    elseif type==2
        exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PN_correlation_continuous.png'],'Resolution',300)    
    end
end
hold off 

