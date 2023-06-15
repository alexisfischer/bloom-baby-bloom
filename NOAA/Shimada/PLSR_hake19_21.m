%% PLSR 
clear;

sensor=1; %0
yr=20192021; %yr=2019; %2021
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));

load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'TT','P')

if sensor==1
    X=[TT.TEMP,TT.SAL,TT.PCO2];
    label={'SST','Salinity','pCO2'};
    labelst='SST, Salinity, pCO2';      
else
    idx=isnan(TT.NitrateM); TT(idx,:)=[];
    X=[TT.TEMP,TT.SAL,TT.PCO2,TT.NitrateM,TT.PhosphateM,TT.SilicateM];
    label={'SST','Salinity','pCO2','Nitrate','Phosphate','Silicate'};
    labelst='SST, Salinity, pCO2, Nitrate, Phosphate, Silicate';          
end

if yr==2019
    idx=find(TT.DT<datetime('01-Jan-2020')); TT(idx,:)=[];
elseif yr==2021
    idx=find(TT.DT>datetime('01-Jan-2020')); TT(idx,:)=[];
else
end

LAT=TT.LAT; DT=TT.DT;
%Ys=[TT.Pseudonitzschia_small];
%Yl=[TT.Pseudonitzschia_large];
Y=sum([TT.Pseudonitzschia_large,TT.Pseudonitzschia_small],2);

% PLSR
n=3;       
X=fillmissing(X,'linear');

% calculate stats]
[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,Y,n);
[N,~] = size(X);
Yfit = [ones(N,1) X]*beta; %compute the fitted response values
Yfit(1)=[]; Yfit(end)=[]; Y(1)=[]; Y(end)=[]; X(1,:)=[]; X(end,:)=[]; DT(1)=[]; DT(end)=[]; LAT(1)=[]; 
LAT(end)=[]; XS(1,:)=[]; XS(end,:)=[]; YS(1,:)=[]; YS(end,:)=[]; N=N-2;
%residuals = Y - Yfit;
YfitPLS = [ones(N,1) X]*beta;
TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-YfitPLS).^2);
rsquaredPLS = round(1 - RSS_PLS/TSS,2,'significant')

component1=PCTVAR(end,1);
component2=PCTVAR(end,2);
component3=PCTVAR(end,end);


% plot timeseries 
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');

idx=(DT<datetime('01-Jan-2020'));
subplot(2,1,1)
    plot(LAT(idx),Y(idx),'ko',LAT(idx),Yfit(idx),'r*','linewidth',2)
    set(gca,'xlim',[40 49],'xgrid','on','fontsize',11); box on
    ylabel('2019')
title({'Pseudo-nitzschia spp. cells/mL'})
legend('Obs.',['Pre. (R^2=' num2str(rsquaredPLS) ')'],'location','NW'); 
    
subplot(2,1,2)
    plot(LAT(~idx),Y(~idx),'ko',LAT(~idx),Yfit(~idx),'r*','linewidth',2)
    set(gca,'xlim',[40 49],'xgrid','on','fontsize',11); box on
    ylabel('2021')
    xlabel('latitude [^oN]')

