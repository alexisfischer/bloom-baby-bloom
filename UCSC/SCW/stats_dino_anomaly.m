%% PLSR 
clear;

filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); 
addpath(genpath('~/MATLAB/ifcb-analysis/')); 
load([filepath 'Data/SCW_master'],'SC');

gap=30; n=14; dn=SC.dn;

var= SC.DINOrai; varname = 'Dinoflagellate Chl'; [dinoC] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.windU; varname = 'Alongshore wind'; [Uwind] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.windV; varname = 'Crossshore wind'; [Vwind] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.NPGO; varname = 'NPGO'; [NPGO] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.MEI; varname = 'MEI'; [MEI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.Tsensor; varname = 'Temperature'; [temp] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var=log10(SC.sanlorR); var(var<0)=0; varname = 'Discharge'; [sanlorR] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.nitrate; varname = 'Nitrate'; [nitrate] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.upwell; varname = 'UI'; [UI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

var = SC.BEUTI; varname = 'BEUTI'; [BEUTI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);
var = SC.CUTI; varname = 'CUTI'; [CUTI] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

clearvars var varname gap n dn SC;
%% set input parameters
clearvars X wind spring yrrange;

%%%% 1) anomaly or regular?
%type=''; idx=~isnan(dinoC.ti9); y = dinoC.ti9(idx); DN = dinoC.dn14d(idx);
type='Anom'; Y = dinoC.tAnom; DN = dinoC.dn14d;

%%%% 2) what range of years?
% yrrange = 0111; id=find(DN>=datenum('01-Jan-2001') & DN<=datenum('30-Dec-2011'));
yrrange = 1219; id=find(DN>=datenum('01-Jan-2012'));
% yrrange = 0119; id=find(DN>=datenum('01-Jan-2001'));

%%%% 3) just wind?
wind=1; 
%wind=0;

%%%% 4) just spring?
%spring=1;
spring=0;

% run PLSR
DN=DN(id); Y=Y(id);    

if spring == 1
    season='Jan-May';
    [~,M] = datevec(DN);
    id = find(ismember(M,1:5)); %only select Jan-May months
    DN=DN(id); Y=Y(id);
else
    season='all';
end

istart=datestr(DN(1))
iend=datestr(DN(end))

n=2;     
if yrrange == 1219
    [X(:,1)] = match_dates(Vwind.dn14d, Vwind.tAnom, DN);    
    [X(:,2)] = match_dates(Uwind.dn14d, Uwind.tAnom, DN);    
    [X(:,3)] = match_dates(sanlorR.dn14d, sanlorR.tAnom, DN);
    [X(:,4)] = match_dates(temp.dn14d, temp.tAnom, DN);      
    [X(:,5)] = match_dates(nitrate.dn14d, nitrate.tAnom, DN);             
    [X(:,6)] = match_dates(NPGO.dn14d, NPGO.ti9, DN);    
    [X(:,7)] = match_dates(MEI.dn14d, MEI.tAnom, DN);      
    
    label={'Cross-shore wind','Alongshore wind','River Discharge','SST','Nitrate','NPGO','MEI'};
    labelst='Local wind, River Discharge, SST, Nitrate, NPGO, MEI';  
else    
    [X(:,1)] = match_dates(UI.dn14d, UI.tAnom, DN);
    [X(:,2)] = match_dates(sanlorR.dn14d, sanlorR.tAnom, DN);
    [X(:,3)] = match_dates(temp.dn14d, temp.tAnom, DN);      
    [X(:,4)] = match_dates(nitrate.dn14d, nitrate.tAnom, DN);             
    [X(:,5)] = match_dates(NPGO.dn14d, NPGO.ti9, DN);    
    [X(:,6)] = match_dates(MEI.dn14d, MEI.tAnom, DN);  
    label={'Upwelling Index','River Discharge','SST','Nitrate','NPGO','MEI'};
    labelst='River Discharge, SST, NPGO, MEI, Nitrate, Upwelling Index';      
end

if wind == 1
    n=1;
    clearvars X;
    [X(:,1)] = match_dates(Vwind.dn14d, Vwind.tAnom, DN);    
    [X(:,2)] = match_dates(Uwind.dn14d, Uwind.tAnom, DN);    
    label={'Cross-shore wind','Alongshore wind'};
    labelst='Local Wind';  
else
end

X=fillmissing(X,'linear');

% calculate stats]
[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,Y,n);
[N,~] = size(X);
Yfit = [ones(N,1) X]*beta; %compute the fitted response values
Yfit(1)=[]; Yfit(end)=[]; Y(1)=[]; Y(end)=[]; X(1,:)=[]; X(end,:)=[]; DN(1)=[]; 
DN(end)=[]; XS(1,:)=[]; XS(end,:)=[]; YS(1,:)=[]; YS(end,:)=[]; N=N-2;
%residuals = Y - Yfit;
YfitPLS = [ones(N,1) X]*beta;
TSS = sum((Y-mean(Y)).^2);
RSS_PLS = sum((Y-YfitPLS).^2);
rsquaredPLS = round(1 - RSS_PLS/TSS,2,'significant')

component1=PCTVAR(end,1);
component2=PCTVAR(end,end);

clearvars beta YfitPLS TSS RSS_PLS XL YL XS YS MSE istart iend id M N;

%% plot timeseries 
figure('Units','inches','Position',[1 1 4.5 3],'PaperPositionMode','auto');

if wind == 1 && spring == 1
    plot(DN,Y,'ko',DN,Yfit,'b*','linewidth',2)
elseif wind == 1 && spring == 0
    plot(DN,Y,'k-',DN,Yfit,'b-','linewidth',2)  
elseif wind == 0 && spring == 1
    plot(DN,Y,'ko',DN,Yfit,'r*','linewidth',2)   
elseif wind == 0 && spring == 0
    plot(DN,Y,'k-',DN,Yfit,'r-','linewidth',2)       
end

if yrrange == 1219
    set(gca,'xlim',[datenum('01-Jan-2012') datenum('01-Jan-2019')],'ylim',[-2 2.3],'xgrid','on','fontsize',14); box on
elseif yrrange ==0111
    set(gca,'xlim',[datenum('01-Jan-2004') datenum('01-Jan-2012')],'xgrid','on','fontsize',14); box on
end

if spring == 1
    set(gca,'ylim',[-1 2]);
else
end

datetick('x','yy','keeplimits')
%legend('Obs.',['Pre. (R^2=' num2str(rsquaredPLS) ')'],'location','NW'); 
ylabel({'Dinoflagellate';'Chlorophyll Anomaly'},'fontsize',16)
hold on

% set figure parameters
set(gcf,'color','w');
if wind == 1
    print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_wind_' num2str(season) '_' num2str(yrrange) '_' num2str(type) '_Timeseries.tif']);        
else
    print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_' num2str(season) '_' num2str(yrrange) '_' num2str(type) '_Timeseries.tif']);    
end
    hold off

%% plots weights
% The PLS weights are the linear combinations of the original variables
% that that define the PLS components, i.e., they describe how strongly
% each component in the PLSR depends on the original variables, and in what direction.
figure('Units','inches','Position',[1 1 6 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.15 .09], [0.28 0.04]);

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
if wind == 1
    print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_wind_' num2str(season) '_' num2str(yrrange) '_' num2str(type) '_Weights.tif']);        
else
    print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_' num2str(season) '_' num2str(yrrange) '_' num2str(type) '_Weights.tif']);    
end
    hold off

%% other plots, not using
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

subplot(2,1,2);
plot(0:n,MSE(2,:),'-o','linewidth',2);
set(gca,'fontsize',12,'xlim',[0 n],'xtick',0:1:n,'tickdir','out');
xlabel('Component Number','fontsize',14,'fontweight','bold');
ylabel({'Estimated Mean Squared';'Prediction Error'},'fontsize',14,'fontweight','bold');
hold on

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
