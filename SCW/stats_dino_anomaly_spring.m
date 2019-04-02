%% PLSR 
clear;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
load([filepath 'Data/SCW_master'],'SC');

dn=SC.dn;
n=14;

%%%% load in Climatology data
idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate Chl'; [dinoC] = extractClimatology_partial(var,dn,filepath,varname,n);

var = SC.MEI; varname = 'MEI'; [MEI] = extractClimatology(var,dn,filepath,varname,n);

var = SC.NPGO; varname = 'NPGO'; [NPGO] = extractClimatology(var,dn,filepath,varname,n);

var = SC.Tsensor; varname = 'Temperature'; [temp] = extractClimatology(var,dn,filepath,varname,n);

lag=0;vari = [NaN*ones(lag,1);log(SC.river)]; var=vari(1:end-lag); %add lag to upwelling
varname = 'Discharge'; [river] = extractClimatology(var,dn,filepath,varname,n);
%var=log(SC.river); varname = 'Discharge'; [river] = extractClimatology(var,dn,filepath,varname,n);

var = SC.windU; varname = 'U wind-vector'; [Uwind] = extractClimatology(var,dn,filepath,varname,n);

var = SC.windV; varname = 'V wind-vector'; [Vwind] = extractClimatology(var,dn,filepath,varname,n);

var = SC.PDO; varname = 'PDO'; [PDO] = extractClimatology_partial(var,dn,filepath,varname,n);

%var = SC.Zmax; varname = 'Zmax'; [Zmax] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.mld5S; varname = 'MixedLayerDepth'; [MLD] = extractClimatology(var,dn,filepath,varname,n);

%lag=0;vari = [NaN*ones(lag,1);SC.upwell]; var=vari(1:end-lag); %add lag to upwelling
%varname = 'UpwellingIndex'; [upwell] = extractClimatology(var,dn,filepath,varname,n);
var=(SC.upwell); varname = 'UpwellingIndex'; [upwell] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.SwD; varname = 'SwellDirection'; [SwD] = extractClimatology(var,dn,filepath,varname,n);

%var = SC.ammonium; varname = 'Ammonium'; [ammon] = extractClimatology_partial(var,dn,filepath,varname,n);

% set input parameters
%type=''; lim1=0; lim2=3;  idx=~isnan(dinoC.ti9); y = dinoC.ti9(idx); DN = dinoC.dn14d(idx);
type='Anom'; lim1=-1; lim2=1; idx=~isnan(dinoC.tAnom); y = dinoC.tAnom(idx); DN = dinoC.dn14d(idx);

%yrrange = 0411;
yrrange = 1219;
%yrrange = 0419;

%set ranges according to dates
if yrrange == 0419 
   id=find(DN>=datenum('01-Jan-2004'));
elseif yrrange == 0411 
    id=find(DN>=datenum('01-Jan-2004') & DN>=datenum('01-Jan-2012'));
elseif yrrange == 1219 
    id=find(DN>=datenum('01-Jan-2012'));
else
end
DN=DN(id); y=y(id);

% only select winter spring
season='Jan-May';
[~,M] = datevec(DN);
id = find(ismember(M,[1:5])); %only select Jan-May months
DN=DN(id); y=y(id);

% if lim1 == -1 %if anomaly
%     n=2; 
%     [x(:,1)] = match_dates(Uwind.dn14d, Uwind.tAnom, DN);
%     [x(:,2)] = match_dates(Vwind.dn14d, Vwind.tAnom, DN);
%     [x(:,3)] = match_dates(NPGO.dn14d, NPGO.tAnom, DN);    
%     [x(:,4)] = match_dates(MEI.dn14d, MEI.tAnom, DN);    
%     [x(:,5)] = match_dates(river.dn14d, river.tAnom, DN);
%     [x(:,6)] = match_dates(temp.dn14d, temp.tAnom, DN);      
%     
% else %if regular data
%     n=3;   
%     [x(:,1)] = match_dates(Uwind.dn14d, Uwind.ti9, DN);
%     [x(:,2)] = match_dates(Vwind.dn14d, Vwind.ti9, DN);
%     [x(:,3)] = match_dates(NPGO.dn14d, NPGO.ti9, DN);    
%     [x(:,4)] = match_dates(MEI.dn14d, MEI.ti9, DN);    
%     [x(:,5)] = match_dates(PDO.dn14d, PDO.ti9, DN);    
%     [x(:,6)] = match_dates(river.dn14d, river.ti9, DN);
%     [x(:,7)] = match_dates(temp.dn14d, temp.ti9, DN);      
% end
% 
% label={'Uwind','Vwind','NPGO','MEI','River','Temp'};
% labelst='Wind, NPGO, MEI, River, Temp';   

n=1;
[x(:,1)] = match_dates(Uwind.dn14d, Uwind.tAnom, DN);
[x(:,2)] = match_dates(Vwind.dn14d, Vwind.tAnom, DN);
label={'Uwind','Vwind'};
labelst='Wind';   

Z=zscore([x,y]); %standardize data
X=Z(:,1:end-1); Y=Z(:,end); 

% figure; plot(DN,y,'k-',DN,Y,'r-');
% for i=1:size(X,2)
%     figure; plot(DN,x(:,i),'k-',DN,X(:,i),'r-');
% end

[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,Y,n);

% calculate stats
[N,~] = size(X);
test=[ones(N,1) X];
Yfit = [ones(N,1) X]*beta; %compute the fitted response values
residuals = Y - Yfit;
YfitPLS = [ones(N,1) X]*beta;
TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-YfitPLS).^2);
rsquaredPLS = round(1 - RSS_PLS/TSS,2,'significant')

%% plot timeseries (season)
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

plot(DN,Y,'ko',DN,Yfit,'r*','linewidth',2)
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[datenum('01-Jan-2012') datenum('31-Dec-2018')],...
    'xgrid','on','fontsize',14); box on
legend('Observed',['Predicted (R^2=' num2str(rsquaredPLS) ')'],'location','NW'); 
title(labelst,'fontsize',16,'fontweight','bold')
ylabel(['Dino Chl ' num2str(type) ''],'fontsize',16,'fontweight','bold')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) ' ' num2str(season) '_Timeseries.tif']);    
hold off

%% plot timeseries (season) just one variable
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

plot(DN,Y,'ko',DN,Yfit,'b*','linewidth',2)
datetick('x','yyyy','keeplimits')
set(gca,'xlim',[datenum('01-Jan-2012') datenum('31-Dec-2018')],...
    'xgrid','on','fontsize',14); box on
legend('Observed',['Predicted (R^2=' num2str(rsquaredPLS) ')'],'location','NW'); 
title(labelst,'fontsize',16,'fontweight','bold')
ylabel(['Dino Chl ' num2str(type) ''],'fontsize',16,'fontweight','bold')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',...
    [filepath 'Figs\dino_' num2str(labelst) '_' num2str(yrrange) '_' num2str(type) '_' num2str(season) '_Timeseries.tif']);    
hold off

%% plots Loadings
figure('Units','inches','Position',[1 1 6 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.15 .09], [0.14 0.02]);

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
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_' num2str(season) '_Loadings.tif']);    
hold off

%% plots weights
% The PLS weights are the linear combinations of the original variables
% that that define the PLS components, i.e., they describe how strongly
% each component in the PLSR depends on the original variables, and in what direction.
figure('Units','inches','Position',[1 1 6 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.15 .09], [0.14 0.02]);

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
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_' num2str(season) '_Weights.tif']);    
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
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_' num2str(season) '_PLSR.tif']);
hold off

%%
figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');

plot(stats.W(:,1),stats.W(:,2),'o','Linewidth',2,'Markersize',5);
ylabel('PLS Weight','fontsize',16);
% legend({'1st Component' '2nd Component' '3rd Component'},  ...
% 	'location','NW'); legend boxoff
set(gca,'xlim',[-.07 .07],'xtick',-0.05:.05:.05,'ylim',[-.07 .07],'ytick',-0.05:.05:.05,'fontsize',14)

