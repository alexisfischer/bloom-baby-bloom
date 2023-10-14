%% find the environmental factors correlated with the large toxic PN patches
% vs all the other PN patches
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=0; %0=don't print, 1=print
type=1; %1=discrete, 2=sensor
yr=2019; %2019, 2021, 1921

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
y19=load([filepath 'NOAA/Shimada/Data/Patch_2019'],'lat_range_tox','lat_range_pn');
y21=load([filepath 'NOAA/Shimada/Data/Patch_2021'],'lat_range_tox','lat_range_pn');

P.PN=sum([P.Pseudonitzschia_large,P.Pseudonitzschia_medium,P.Pseudonitzschia_small],2);


if yr==2019    
    P=P(P.DT<datetime('01-Jan-2020'),:);    
    idT=(P.LAT>=y19.lat_range_pn(1,1) & P.LAT<=y19.lat_range_pn(1,end));
    idN=(P.LAT>=y19.lat_range_pn(2,1) & P.LAT<=y19.lat_range_pn(2,end));
elseif yr==2021
    P=P(P.DT>datetime('01-Jan-2020'),:);      
    idT=(P.LAT>=y21.lat_range_tox(1) & P.LAT<=y21.lat_range_tox(end));
    idN1=find(P.LAT>=y21.lat_range_pn(1,1) & P.LAT<=y21.lat_range_pn(1,end));
    idN2=find(P.LAT>=y21.lat_range_pn(2,1) & P.LAT<=y21.lat_range_pn(2,end));  
    idN=[idN1;idN2];
end

P.toxicP=zeros(size(P.PN)); P.toxicP(idT)=P.PN(idT); 
P.nonP=zeros(size(P.PN)); P.nonP(idN)=P.PN(idN); 
P.nonPA=zeros(size(P.PN)); P.nonPA(~idT)=P.PN(~idT); 

if type==1
    idD=isnan(P.SilicateM); P(idD,:)=[]; %remove nans from discrete dataset    
    X=[P.TEMP,P.SAL,P.PCO2,P.NitrateM,P.PhosphateM,P.Pstar,P.SilicateM,P.Sstar];
    Xlabel={'Temperature' 'Salinity' 'pCO2' 'Nitrate' 'Phosphate' 'P*' 'Silicate' 'Si*' };
    pos=[1 1 3.5 5];
elseif type==2    
    X=[P.TEMP,P.SAL,P.PCO2];
    Xlabel={'Temperature' 'Salinity'};
    pos=[1 1 3.5 2.5];
end

Y=[P.nonPA,P.nonP,P.toxicP,P.pDA_ngL];
Ylabel={'nontoxic all' 'nontoxic patch' 'toxic patch' 'pDA'};
[rho,pval] = corr(X,Y,'Type','Pearson','Rows','complete');

fig=figure; set(gcf,'color','w','Units','inches','Position',pos); 
imagesc(rho);
xtickangle(45)
col=flipud(brewermap(256,'RdBu')); colormap(gca,col); colorbar();
clim([-1 1]);
title([num2str(yr) ' (n = ' num2str(length(Y)) ')']);
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
%        title({num2str(yr);['Discrete (n = ' num2str(length(Y)) ')']});
        exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PN_correlation_discrete' num2str(yr) '.png'],'Resolution',300)    
    elseif type==2
       % title({num2str(yr);['Sensor (n = ' num2str(length(Y)) ')']});
        exportgraphics(fig,[filepath 'NOAA/Shimada/Figs/PN_correlation_continuous' num2str(yr) '.png'],'Resolution',300)    
    end
end
hold off 

%% plot pairwise comparisons
figure; set(gcf,'color','w','Units','inches','Position',[1 1 6 6]); 
subplot(2,2,1)
plot(P.Sstar,P.Pseudonitzschia_toxic,'ro',P.Sstar,P.Pseudonitzschia_nontoxic,'bo')
xlabel('Si*');
ylabel('PN')
legend('toxic','nontoxic')

subplot(2,2,2)
plot(P.SilicateM,P.Pseudonitzschia_toxic,'ro',P.SilicateM,P.Pseudonitzschia_nontoxic,'bo')
xlabel('Si');
legend('toxic','nontoxic')

subplot(2,2,3)
plot(P.NitrateM,P.Pseudonitzschia_toxic,'ro',P.NitrateM,P.Pseudonitzschia_nontoxic,'bo')
xlabel('Nitrate');
ylabel('PN')
legend('toxic','nontoxic')


