%% PLSR 
clear;

filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); 
addpath(genpath('~/MATLAB/ifcb-analysis/')); 
load([filepath 'Data/SCW_master'],'SC');

dn=SC.dn; n=14; gap=30;

%%%% load in Climatology data
idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate Chl'; [dinoC] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.windU; varname = 'Alongshore wind'; [Uwind] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.windV; varname = 'Crossshore wind'; [Vwind] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
%Uwind.tAnom(1)=Uwind.tAnom(2); Vwind.tAnom(1)=Vwind.tAnom(2);

var = SC.wind42V; varname = 'Upwelling wind'; [UpwellW] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.curU; varname = 'Alongshore current'; [Ucur] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.curV; varname = 'Crossshore current'; [Vcur] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.N2; varname = 'N2'; [N2] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.NPGO; varname = 'NPGO'; [NPGO] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.MEI; varname = 'MEI'; [MEI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.Tsensor; varname = 'Temperature'; [temp] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var=log(SC.sanlorR); varname = 'Discharge'; [sanlorR] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.PDO; varname = 'PDO'; [PDO] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.ammonia; varname = 'Ammonium'; [ammon] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.nitrate; varname = 'Nitrate'; [nitrate] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.upwell; varname = 'UI'; [UI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

%% set input parameters
clearvars X;
%type=''; lim1=0; lim2=3;  idx=~isnan(dinoC.ti9); y = dinoC.ti9(idx); DN = dinoC.dn14d(idx);
type='Anom'; lim1=-1; lim2=1; idx=~isnan(dinoC.tAnom); Y = dinoC.tAnom(idx); DN = dinoC.dn14d(idx);

yrrange = 0411; id=find(DN>=datenum('01-Jan-2004') & DN<=datenum('01-Jan-2012'));
%yrrange = 1219; id=find(DN>=datenum('01-Jan-2012'));
%yrrange = 0419; id=find(DN>=datenum('01-Jan-2004'));

DN=DN(id); Y=Y(id);

    n=2;     
%     [X(:,1)] = match_dates(Vwind.dn14d, Vwind.tAnom, DN);    
 %    [X(:,2)] = match_dates(Uwind.dn14d, Uwind.tAnom, DN);    
    [X(:,1)] = match_dates(UI.dn14d, UI.tAnom, DN);     
    [X(:,2)] = match_dates(sanlorR.dn14d, sanlorR.tAnom, DN);
    [X(:,3)] = match_dates(temp.dn14d, temp.tAnom, DN);      
    [X(:,4)] = match_dates(nitrate.dn14d, nitrate.tAnom, DN);             
    [X(:,5)] = match_dates(NPGO.dn14d, NPGO.ti9, DN);    
    [X(:,6)] = match_dates(MEI.dn14d, MEI.tAnom, DN);  
%    
   X=fillmissing(X,'linear');

% X(end,:)=[]; Y(end)=[]; DN(end)=[];    
% X(end,6)=X(end-1,6);
% X(end-5:end,7)=X(end-6,7);
% 
  label={'Upwelling Index','River Discharge','Temperature','Nitrate','NPGO','MEI'};
  labelst='River Discharge, Temperature, NPGO, MEI, Nitrate, Upwelling';  

%  label={'Cross-shore wind','Alongshore wind',...
%      'River Discharge','Temperature','Nitrate','NPGO','MEI'};
%  labelst='Local Wind, River Discharge, Temperature, NPGO, MEI, Nitrate';  

[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,Y,n);

% calculate stats
[N,~] = size(X);
%test=[ones(N,1) X];

Yfit = [ones(N,1) X]*beta; %compute the fitted response values
Yfit(1)=[]; Yfit(end)=[]; Y(1)=[]; Y(end)=[]; X(1,:)=[]; X(end,:)=[]; DN(1)=[]; 
DN(end)=[]; XS(1,:)=[]; XS(end,:)=[]; YS(1,:)=[]; YS(end,:)=[]; N=N-2;
residuals = Y - Yfit;
YfitPLS = [ones(N,1) X]*beta;
TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-YfitPLS).^2);
rsquaredPLS = round(1 - RSS_PLS/TSS,2,'significant')

%% plot timeseries (season) just one variable
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

plot(DN,Y,'k-',DN,Yfit,'b-','linewidth',2)
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[datenum('01-Jan-2012') datenum('01-Jan-2019')],...
    'xgrid','on','fontsize',14); box on
legend('Observed',['Predicted (R^2=' num2str(rsquaredPLS) ')'],'location','NW'); 
%title(labelst,'fontsize',16,'fontweight','bold')
ylabel({'Dinoflagellate';'Chlorophyll Anomaly'},'fontsize',16)
hold on

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',...
    [filepath 'Figs\dino_' num2str(labelst) '_wind_' num2str(yrrange) '_' num2str(type) '_Timeseries.tif']);    
hold off

%% plot timeseries (all)
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

%plot(DN,XS(:,1),'r:',DN,XS(:,2),'b:','linewidth',2)

plot(DN,Y,'k-',DN,Yfit,'r-','linewidth',2)
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[datenum('01-Jan-2004') datenum('31-Dec-2011')],...
    'xgrid','on','fontsize',14); box on
legend('Observed',['Predicted (R^2=' num2str(rsquaredPLS) ')'],'location','NW'); 
%title(labelst,'fontsize',16,'fontweight','bold')
ylabel({'Dinoflagellate';'Chlorophyll Anomaly'},'fontsize',16)
hold on

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_Timeseries.tif']);    
hold off

%% plots weights
% The PLS weights are the linear combinations of the original variables
% that that define the PLS components, i.e., they describe how strongly
% each component in the PLSR depends on the original variables, and in what direction.
figure('Units','inches','Position',[1 1 6 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.15 .09], [0.31 0.02]);

    subplot(1,n,1); barh(stats.W(:,1),'k')
    set(gca,'yaxislocation','left','yticklabel',label,'fontsize',14)
    title(['Component ' num2str(1) ''],'fontsize',16)
    
for i=2:n
    subplot(1,n,i); barh(stats.W(:,i),'k')
    set(gca,'yaxislocation','left','yticklabel',{},'fontsize',14)
    title(['Component ' num2str(i) ''],'fontsize',16)
end

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_Weights.tif']);    
hold off

%% plot stats
% plot MSE, residuals
figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.05],[0.1 0.03], [0.26 .06]);

subplot(2,1,1);
plot(0:n,[0,cumsum(100*PCTVAR(2,:))],'-o','linewidth',2);
set(gca,'fontsize',12,'xlim',[0 n],'xticklabel',{},'tickdir','out');
%xlabel('Number of components','fontsize',16,'fontweight','bold');
ylabel('% Variance Explained in Y','fontsize',14,'fontweight','bold');
hold on

% subplot(2,2,2);
% stem(residuals); set(gca,'fontsize',12)
% xlabel('Observation','fontsize',14,'fontweight','bold');
% ylabel('Residual','fontsize',14,'fontweight','bold');
% hold on

subplot(2,1,2);
plot(0:n,MSE(2,:),'-o','linewidth',2);
set(gca,'fontsize',12,'xlim',[0 n],'xtick',0:1:n,'tickdir','out');
xlabel('Component Number','fontsize',14,'fontweight','bold');
ylabel({'Estimated Mean Squared';'Prediction Error'},'fontsize',14,'fontweight','bold');
hold on

% subplot(2,2,4);
% plot(Y,YfitPLS,'o');
% set(gca,'xlim',[lim1 lim2],'ylim',[lim1 lim2],'fontsize',12);
% xlabel('Observed Response','fontsize',14,'fontweight','bold');
% ylabel('Fitted Response','fontsize',14,'fontweight','bold');
% legend(['R^2 = ' num2str(rsquaredPLS) ''],'location','NW'); legend boxoff

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_PLSR.tif']);
hold off

%% plots Loadings
figure('Units','inches','Position',[1 1 6 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.15 .09], [0.31 0.02]);

    subplot(1,n,1); barh(XL(:,1),'k')
    set(gca,'yaxislocation','left','yticklabel',label,'fontsize',14)
    title(['Component ' num2str(1) ''],'fontsize',16)
    
for i=2:n
    subplot(1,n,i); barh(XL(:,i),'k')
    set(gca,'yaxislocation','left','yticklabel',{},'fontsize',14)
    title(['Component ' num2str(i) ''],'fontsize',16)
end

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_Loadings.tif']);    
hold off

%%
figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');

plot(stats.W(:,1),stats.W(:,2),'o','Linewidth',2,'Markersize',5);
ylabel('PLS Weight','fontsize',16);
% legend({'1st Component' '2nd Component' '3rd Component'},  ...
% 	'location','NW'); legend boxoff
set(gca,'xlim',[-.07 .07],'xtick',-0.05:.05:.05,'ylim',[-.07 .07],'ytick',-0.05:.05:.05,'fontsize',14)

