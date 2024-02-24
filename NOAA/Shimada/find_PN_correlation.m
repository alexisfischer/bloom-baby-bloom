%% factors associated with high cellular toxicity
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%%%%USER
fprint=1; %0=don't print, 1=print
type=1; %1=discrete, 2=sensor
%yr='2019';
%yr='2021';
yr='2019 & 2021';

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
%P(P.PN_cell==0,:)=[];
P(isnan(P.pDA_pgmL),:)=[];

if length(yr)==4
    if strcmp(yr,'2019')    
        P=P(P.DT<datetime('01-Jan-2020'),:);    
    elseif strcmp(yr,'2021')    
        P=P(P.DT>datetime('01-Jan-2020'),:);      
    end
else
end

if type==1
    X=[P.TEMP,P.SAL,P.PCO2,P.Nitrate_uM,P.Silicate_uM,P.Phosphate_uM,P.S2N,P.P2N];
    Xlabel={'Temperature' 'Salinity' 'pCO2' 'Nitrate' 'Silicate' 'Phosphate' 'Si:N' 'P:N' };
    Y=[P.PN_cell,P.pDA_pgmL];
    Ylabel={'PN' 'pDA'};
    pos=[1 1 2.5 4.3];
elseif type==2    
    X=[P.TEMP,P.SAL,P.PCO2];
    Xlabel={'Temperature' 'Salinity' 'pCO2'};
    Y=[P.PN_cell];
    Ylabel={'cells/mL'};    
    pos=[1 1 2. 2.5];
end

%[rho,pval] = corr(X,Y,'Type','Pearson','Rows','complete');
[rho,pval] = corr(X,Y,'Type','Pearson','Rows','pairwise');

if type==1 && strcmp(yr,'2019')
    rho(6,1)=rho(6,1)+.05;
end

fig=figure; set(gcf,'color','w','Units','inches','Position',pos); 
imagesc(rho);
xtickangle(45)
col=flipud(brewermap(256,'RdBu'));col(120:136,:)=[]; 
colormap(gca,col); h=colorbar('XTick',-1:.5:1);
    hp=get(h,'pos');     
    hp=[1.05*hp(1) hp(2) .8*hp(3) .85*hp(4)]; % [left, bottom, width, height].

    %    hp=[1.05*hp(1) hp(2) .8*hp(3) .6*hp(4)]; % [left, bottom, width, height].
    set(h,'pos',hp,'xaxisloc','right','tickdir','out','fontsize',10);
clim([-1 1]);
title(yr,'fontsize',12);
axis tight; axis equal; 
set(gca,'Xtick',1:1:length(rho),'xticklabel',Ylabel,'xaxislocation','top',...
   'ytick',1:1:length(rho),'yticklabel',Xlabel,'fontsize',11,'tickdir','out')

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

