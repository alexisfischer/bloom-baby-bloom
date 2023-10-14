%% find the environmental factors correlated with the large toxic PN patches
% vs all the other PN patches
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1; %0=don't print, 1=print
region=2; % 1=th, 2=hb, 3=jdf

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
y19=load([filepath 'NOAA/Shimada/Data/Patch_2019'],'lat_range_tox','lat_range_pn');
y21=load([filepath 'NOAA/Shimada/Data/Patch_2021'],'lat_range_tox','lat_range_pn');

idx=isnan(P.TEMP); P(idx,:)=[]; % remove Nans
idx=isnan(P.SilicateM); P(idx,:)=[]; %remove Nans  

%%%% format PN data
P.PN=sum([P.Pseudonitzschia_large,P.Pseudonitzschia_medium,P.Pseudonitzschia_small],2);
%P.PN=sum([P.Pseudonitzschia_large],2);
P.tox=zeros(size(P.PN)); P.non=P.tox;

if region == 1 % Trinidad Head - 2021:non
    P=P(P.LAT<43,:);
elseif region == 2 % Heceta Bank - 2019:toxic, 2021:non
    P=P(P.LAT>43.5 & P.LAT<45.5,:);
   % idT=(P.DT<datetime('01-Jan-2020') & P.LAT>y19.lat_range_pn(1,1) & P.LAT<y19.lat_range_pn(1,end));
   % P.tox(idT)=P.PN(idT); P.non(~idT)=P.PN(~idT);
    idT=find(P.DT<datetime('01-Jan-2020')); P.tox(idT)=P.PN(idT);        
    idN=find(P.DT>datetime('01-Jan-2020')); P.non(idN)=P.PN(idN);  
    label='Heceta Bank';
    Ylabel={'non-2021' 'tox-2019' 'pDA-both'};    
elseif region == 3 % Juan de Fuca Eddy - 2019:non, 2021:toxic
    P=P(P.LAT>47.5,:);
    idN=find(P.DT<datetime('01-Jan-2020')); P.non(idN)=P.PN(idN);        
    idT=find(P.DT>datetime('01-Jan-2020')); P.tox(idT)=P.PN(idT);
    label='Juan de Fuca Eddy';
    Ylabel={'non-2019' 'tox-2021' 'pDA-both'};   
end

X=[P.TEMP,P.SAL,P.PCO2,P.NitrateM,P.PhosphateM,P.Pstar,P.SilicateM,P.Sstar];
Xlabel={'Temperature' 'Salinity' 'pCO2' 'Nitrate' 'Phosphate' 'P*' 'Silicate' 'Si*'};
Y=[P.non, P.tox, P.pDA_ngL];
[rho,pval] = corr(X,Y,'Type','Pearson','Rows','complete');

fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 5]); 
imagesc(rho);
xtickangle(45)
title(label)
col=flipud(brewermap(256,'RdBu')); colormap(gca,col); colorbar();
clim([-1 1]);
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
    exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PN_correlation_' label '.png'],'Resolution',100)    
end
hold off 

