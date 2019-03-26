filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

%% load in Climatology data
load([filepath 'Data/SCW_master'],'SC');

dn=SC.dn;
n=4;

var = SC.PDO; varname = 'PDO'; [PDO] = extractClimatology_incompletedata(var,dn,filepath,varname,n);

var = SC.NPGO; varname = 'NPGO'; [NPGO] = extractClimatology(var,dn,filepath,varname,n);

var = SC.mld5S; varname = 'MixedLayerDepth_S'; [MLD] = extractClimatology(var,dn,filepath,varname,n);

var = SC.upwell; varname = 'UpwellingIndex'; [upwell] = extractClimatology(var,dn,filepath,varname,n);

var = SC.Tsensor; varname = 'Temperature'; [temp] = extractClimatology(var,dn,filepath,varname,n);

var = log(SC.river); varname = 'Discharge'; [river] = extractClimatology(var,dn,filepath,varname,n);

idx=isnan(SC.fxDino); SC.CHL(idx)=NaN; %make sure CHL and DINO have same points
var = SC.fxDino.*log(SC.CHL); varname = 'Dinoflagellate Chl'; [dinoC] = extractClimatology_incompletedata(var,dn,filepath,varname,n);

var = SC.windU; varname = 'U wind-vector'; [Uwind] = extractClimatology(var,dn,filepath,varname,n);

var = SC.windV; varname = 'V wind-vector'; [Vwind] = extractClimatology(var,dn,filepath,varname,n);

%% prep ifcb data

%%%% Step 1: Load in data
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');
    
%%%% Step 2: Convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 
volC=zeros(size([cellC])); %convert from per cell to per mL
volB=zeros(size([cellC])); %convert from per cell to per mL
for i=1:length(cellC)
    volC(i,:)=cellC(i,:)./ml_analyzedTB(i);
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end  
volC=volC./1000; %convert from pg/mL to ug/L 

%%%% Step 3: Take daily average and determine what fraction of Cell-derived carbon is 
%select only dinoflagellates
[ ind_dino, class_label_dino ] = get_dino_ind_CA( class2useTB, class2useTB );
[~, ydino ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_dino),2));
[xdino, ydino_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%%%% Step 4: Interpolate data for small data gaps 
n=4;
for i=1:length(ydino)
    [ydino] = interp1babygap(ydino,n);
    [ydino_ml] = interp1babygap(ydino_ml,n);
end

%% IFCB dinoflagellate climatology
Y = log(ydino./ydino_ml);
i0=~isnan(Y);

istart=find(dinoC.dn14d>=datenum('01-Jan-2017'),1);
iend=find(dinoC.dn14d>=datenum('31-Dec-2017'),1);
DN=dinoC.dn14d(istart:iend)+365; % set to 2018

ti=stineman(xdino(i0), Y(i0), DN); ti=ti';
ti9 =smooth(ti,9); 
tAnom = ti-dinoC.t14d(istart:iend); %anomaly

% type='Anom';
% y=tAnom;

 type='Raw';
 y=ti9;

 n=6;
X=NaN*ones(length(y),n);
[X(:,1)] = match_dates(temp.dn14d, temp.ti9, DN);
[X(:,2)] = match_dates(upwell.dn14d, upwell.ti9, DN);
[X(:,3)] = match_dates(river.dn14d, river.ti9, DN);
[X(:,4)] = match_dates(MLD.dn14d, MLD.ti9, DN);
[X(:,5)] = match_dates(Uwind.dn14d, Uwind.ti9, DN);
[X(:,6)] = match_dates(Vwind.dn14d, Vwind.ti9, DN);
[X(:,7)] = match_dates(NPGO.dn14d, NPGO.ti9, DN);
[X(:,8)] = match_dates(PDO.dn14d, PDO.ti9, DN);

% [X(:,1)] = match_dates(temp.dn14d, temp.tAnom, DN);
% [X(:,2)] = match_dates(upwell.dn14d, upwell.tAnom, DN);
% [X(:,3)] = match_dates(river.dn14d, river.tAnom, DN);
% [X(:,4)] = match_dates(MLD.dn14d, MLD.tAnom, DN);
% [X(:,5)] = match_dates(Uwind.dn14d, Uwind.tAnom, DN);
% [X(:,6)] = match_dates(Vwind.dn14d, Vwind.tAnom, DN);
% [X(:,7)] = match_dates(NPGO.dn14d, NPGO.tAnom, DN);
% [X(:,8)] = match_dates(PDO.dn14d, PDO.tAnom, DN);

t=X(:,8);
t(isnan(t))=.09; 
X(:,8)=t;

X(91,:)=[];
y(91)=[];
DN(91)=[];

[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,y,n);

%% plot component loadings
figure('Units','inches','Position',[1 1 11 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.18 .09], [0.16 0.01]);

subplot(1,6,1);
barh(XL(:,1),'k')
set(gca,'yaxislocation','left','yticklabel',{'Temperature','Upwelling',...
    'River Discharge','MLD','U wind-vector','V wind-vector','NPGO','PDO'},'fontsize',16)
title('1st','fontsize',16)

subplot(1,6,2);
barh(XL(:,2),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
title('2nd','fontsize',16)

subplot(1,6,3);
barh(XL(:,3),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
title('3rd','fontsize',16)

subplot(1,6,4);
barh(XL(:,4),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
title('4th','fontsize',16)

subplot(1,6,5);
barh(XL(:,5),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
title('5th','fontsize',16)

subplot(1,6,6);
barh(XL(:,6),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
title('6th','fontsize',16)
% 
% subplot(1,7,7);
% barh(XL(:,7),'k')
% set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
% title('7th','fontsize',16)

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [filepath 'Figs\FactorLoadings_dino_2018_IFCB_' num2str(type) '.tif']);    
hold off

%% plot MSE, residuals
figure('Units','inches','Position',[1 1 3.5 5.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04],[0.11 0.03], [0.24 .06]);

subplot(2,1,1);
plot(0:n,[0,cumsum(100*PCTVAR(2,:))],'-o','linewidth',2);
set(gca,'fontsize',14,'xlim',[0 n],'xticklabel',{},'tickdir','out');
%xlabel('Number of components','fontsize',16,'fontweight','bold');
ylabel('% Variance Explained in y','fontsize',14,'fontweight','bold');
hold on

subplot(2,1,2);
plot(0:n,MSE(2,:),'-o','linewidth',2);
set(gca,'fontsize',14,'xlim',[0 n],'xtick',0:1:n,'tickdir','out');
xlabel('Component Number','fontsize',14,'fontweight','bold');
ylabel('Estimated MSE','fontsize',14,'fontweight','bold');
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [filepath 'Figs\PLSR_dino_2018_IFCB_' num2str(type) '.tif']);        
hold off

%% statistics on environmental drivers
figure('Units','inches','Position',[1 1 9 5.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.12 0.02], [0.12 0.04], [0.06 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

yax1=0; yax2=1.7;   
%yax1=-3; yax2=3;   

subplot(2,4,1);
scatter(DN, y, 4)
datetick('x','m')
set(gca,'ylim',[yax1 yax2],'xlim',[datenum('01-Jan-2018') datenum('31-Dec-2018')])
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold')
xlabel('Day of year','fontsize',10,'fontweight','bold')
box on

subplot(2,4,2);
scatter(X(:,1), y, 4)
set(gca,'ylim',[yax1 yax2],'yticklabel',{})
xlabel('Temperature (^oC)','fontsize',10,'fontweight','bold')
box on

subplot(2,4,3);
scatter(X(:,2), y, 4)
set(gca,'ylim',[yax1 yax2],'yticklabel',{})
xlabel('Upwelling Index','fontsize',10,'fontweight','bold')
box on

subplot(2,4,4);
scatter(X(:,3), y, 4)
set(gca,'ylim',[yax1 yax2],'yticklabel',{})
xlabel('River Discharge','fontsize',10,'fontweight','bold')
box on

subplot(2,4,5);
scatter(X(:,4), y, 4)
set(gca,'ylim',[yax1 yax2])
xlabel('Mixed Layer depth @SCW (m)','fontsize',10,'fontweight','bold')
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold')
box on

subplot(2,4,6);
scatter(X(:,5), y, 4)
set(gca,'ylim',[yax1 yax2],'yticklabel',{})
xlabel('U wind-vector','fontsize',10,'fontweight','bold')
box on

subplot(2,4,7);
scatter(X(:,6), y, 4)
set(gca,'ylim',[yax1 yax2],'yticklabel',{})
xlabel('V wind-vector','fontsize',10,'fontweight','bold')
box on
 
subplot(2,4,8);
scatter(X(:,7), y, 4)
set(gca,'ylim',[yax1 yax2],'yticklabel',{})
xlabel('NPGO','fontsize',10,'fontweight','bold')
box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\Scatter_dino_2018_IFCB_' num2str(type) '.tif']);
hold off
