%% plot Dino chl vs Z(max dT/dz)

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');

%Load and rename structures
load([filepath 'Data/Climatology_Dinoflagellate log(CHL)'],'C'); logdino=C;
load([filepath 'Data/Climatology_Discharge'],'C'); river=C;
load([filepath 'Data/Climatology_Temperature'],'C'); T=C;
load([filepath 'Data/Climatology_Windspeed_SC'],'C'); windSC=C;
load([filepath 'Data/Climatology_NPGO'],'C'); NPGO=C;
load([filepath 'Data/Climatology_PDO'],'C'); PDO=C;

%load([filepath 'Data/Climatology_Silicate'],'C'); sil=C;
%load([filepath 'Data/Climatology_Ammonium'],'C'); ammon=C;
%load([filepath 'Data/Climatology_log(Chlorophyll)'],'C'); chl=C;
load([filepath 'Data/Climatology_UpwellingIndex'],'C'); upwell=C;

load([filepath 'Data/Climatology_Zmax'],'C'); Zmax=C;
load([filepath 'Data/Climatology_Zmax_S'],'C'); ZmaxS=C;
load([filepath 'Data/Climatology_MixedLayerDepth'],'C'); MLD=C;
load([filepath 'Data/Climatology_MixedLayerDepth_S'],'C'); MLDS=C;

%% partial least squares regression raw data
n=4;
idx=~isnan(logdino.tAnom);
y = logdino.tAnom(idx);
DN = logdino.dn14d(idx);
idx=find(DN==datenum('01-Jan-2004'));
DN=DN(idx:end);
y=y(idx:end);

X=NaN*ones(length(y),n);

[ mdate_mat, y_mat, ~, yd ] = timeseries2ydmat( DN, y );
day=repmat(yd,size(y_mat,2),1); %find day number
y_mat = reshape(y_mat,[],1);
mdate_mat = reshape(mdate_mat,[],1);
DAY=day(~isnan(y_mat)); % only take non nans

[X(:,1)] = match_dates(T.dn14d, T.tAnom, DN);
[X(:,2)] = match_dates(upwell.dn14d, upwell.tAnom, DN);
[X(:,3)] = match_dates(river.dn14d, river.tAnom, DN);
[X(:,4)] = match_dates(Zmax.dn14d, Zmax.tAnom, DN);
[X(:,5)] = match_dates(PDO.dn14d, PDO.tAnom, DN);
[X(:,6)] = match_dates(NPGO.dn14d, NPGO.tAnom, DN);

X(377:end,:)=[];
y(377:end)=[];
X(369:end,6)=[-2;-2;-2;-2;-2;-2;-2;-2];

%X(377:end,5)=[.07;.07;.07;.07;.07;.07];
[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,y,n);


% [B,FitInfo] = lasso(X,y,'CV',10,'PredictorNames', {'Temperature','Upwelling','River Discharge','Mixed Layer Depth','PDO'}) 
% lassoPlot(B,FitInfo,'PlotType','CV');
% legend('show') % Show legend

%% plot component loadings
figure('Units','inches','Position',[1 1 11 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.18 .07], [0.14 0.01]);

%    {'Windspeed','Temperature','Upwelling','River Discharge',...
%   'Mixed Layer Depth','Salinity'},'fontsize',12)

subplot(1,4,1);
barh(XL(:,1),'k')
set(gca,'yaxislocation','left','yticklabel',{'Temperature','Upwelling',...
    'River Discharge','Mixed Layer Depth','PDO','NPGO'},'fontsize',12)
xlabel('Factor loadings','fontsize',12);
title('1st component')

subplot(1,4,2);
barh(XL(:,2),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',12)
xlabel('Factor loadings','fontsize',12);
title('2nd component')

subplot(1,4,3);
barh(XL(:,3),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',12)
xlabel('Factor loadings','fontsize',12);
title('3rd component','fontsize',12)

subplot(1,4,4);
barh(XL(:,4),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',12)
xlabel('Factor loadings','fontsize',12);
title('4th component')

% subplot(1,5,5);
% barh(XL(:,5),'k')
% set(gca,'yaxislocation','left','yticklabel',{},'fontsize',12)
% xlabel('Factor loadings','fontsize',12);
% title('5th component')
% 
% subplot(1,6,6);
% barh(XL(:,6),'k')
% set(gca,'yaxislocation','left','yticklabel',{},'fontsize',12)
% xlabel('Factor loadings','fontsize',12);
% title('6th component')

% subplot(1,7,7);
% barh(XL(:,7),'k')
% set(gca,'yaxislocation','left','yticklabel',{},'fontsize',12)
% xlabel('Factor loadings','fontsize',12);
% title('7th component')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_tAnom_FactorLoadings.tif']);
hold off

%% plot MSE, residuals
figure('Units','inches','Position',[1 1 9 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.12 0.09], [0.08 .02], [0.08 0.03]);

subplot(2,3,1);
plot(1:n,cumsum(100*PCTVAR(2,:)),'-o','linewidth',2);
set(gca,'fontsize',12,'xlim',[1 n])
xlabel('Number of PLS components','fontsize',12,'fontweight','bold');
ylabel('Percent Variance Explained in y','fontsize',12,'fontweight','bold');
hold on

subplot(2,3,2);
yfit = [ones(size(X,1),1) X]*beta;
residuals = y - yfit;
 stem(residuals)
 set(gca,'fontsize',12)
xlabel('Observation','fontsize',12,'fontweight','bold');
ylabel('Residual','fontsize',12,'fontweight','bold');
hold on

subplot(2,3,3);
plot(0:n,MSE(2,:),'-o','linewidth',2);
set(gca,'fontsize',12,'xlim',[0 n],'xtick',0:1:n)
xlabel('Number of components','fontsize',12,'fontweight','bold');
ylabel('Estimated Mean Squared Error','fontsize',12,'fontweight','bold');
hold on

subplot(2,3,4);
[N,p] = size(X);
yfitPLS = [ones(N,1) X]*beta;
TSS = sum((y-mean(y)).^2);
RSS_PLS = sum((y-yfitPLS).^2);
rsquaredPLS = 1 - RSS_PLS/TSS

lim1=-1;
lim2=1;
plot(y,yfitPLS,'o');
set(gca,'xlim',[lim1 lim2],'ylim',[lim1 lim2],'fontsize',12,...
    'ytick',-1:1:1,'xtick',-1:1:1);
xlabel('Observed Response','fontsize',12,'fontweight','bold');
ylabel('Fitted Response','fontsize',12,'fontweight','bold');
legend(['R^2 = ' num2str(rsquaredPLS) ''],'location','NW'); legend boxoff

subplot(2,3,5);
plot(1:n,stats.W,'o-','linewidth',1.5);
set(gca,'fontsize',12,'xlim',[1 n])
legend({'T','Upw','Riv','MLD','PDO','NPGO'},'Location','SW')
legend boxoff
xlabel('Component','fontsize',12,'fontweight','bold');
ylabel('Weight','fontsize',12,'fontweight','bold');


% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_tAnom_PLSR_residuals.tif']);
hold off

%% scatter plot of data 2012-present
figure('Units','inches','Position',[1 1 17.5 3.2],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.2 0.02], [0.04 0.01]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

yax1=-1.5;
yax2=1.5;
idx=find(DN==datenum('01-Jan-2018'));

subplot(1,7,1);
h1=scatter(X(1:idx,1), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,1), y(idx:end), 8,'r');
set(gca,'ylim',[yax1 yax2],'xlim',[0 366],'fontsize',12)
ylabel('Dinoflagellate Chlorophyll','fontsize',14,'fontweight','bold')
xlabel('Day of Year','fontsize',14,'fontweight','bold'); box on
legend([h1 h2],'2012-17','2018','location','nw');
legend boxoff

subplot(1,7,2);
h1=scatter(X(1:idx,2), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,2), y(idx:end), 6,'r');
set(gca,'ylim',[yax1 yax2],'yticklabel',{},'fontsize',12)
xlabel('Windspeed','fontsize',14,'fontweight','bold'); box on

subplot(1,7,3);
h1=scatter(X(1:idx,3), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,3), y(idx:end), 6,'r');
set(gca,'ylim',[yax1 yax2],'yticklabel',{},'fontsize',12)
xlabel('Temperature','fontsize',14,'fontweight','bold'); box on

subplot(1,7,4);
h1=scatter(X(1:idx,4), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,4), y(idx:end), 6,'r');
set(gca,'ylim',[yax1 yax2],'yticklabel',{},'fontsize',12)
xlabel('Upwelling Index','fontsize',14,'fontweight','bold'); box on

subplot(1,7,5);
h1=scatter(X(1:idx,5), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,5), y(idx:end), 6,'r');
set(gca,'ylim',[yax1 yax2],'yticklabel',{},'fontsize',12)
xlabel('River Discharge','fontsize',14,'fontweight','bold'); box on

subplot(1,7,6);
h1=scatter(X(1:idx,6), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,6), y(idx:end), 6,'r');
set(gca,'ylim',[yax1 yax2],'yticklabel',{},'fontsize',12)
xlabel('Mixed Layer Depth','fontsize',14,'fontweight','bold'); box on

subplot(1,7,7);
h1=scatter(X(1:idx,7), y(1:idx), 8,'b');
hold on
h2=scatter(X(idx:end,7), y(idx:end), 6,'r');
set(gca,'ylim',[yax1 yax2],'yticklabel',{},'fontsize',12)
xlabel('Salinity','fontsize',14,'fontweight','bold'); box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_tAnom_scatter_2wk_2012-2018.tif']);
hold off

%% scatter plot of anomalies for ALL data
figure('Units','inches','Position',[1 1 17.5 3.2],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.015 0.015], [0.2 0.02], [0.04 0.01]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,4,1);
[ ~, DINO, ~, X ] = timeseries2ydmat( logdino.dn14d, logdino.tAnom );
for i=1:size(DINO-1,2) 
    h1=scatter(X, DINO(:,i), 6,'b');
    hold on
end
h2=scatter(X, DINO(:,end), 8,'r');
set(gca,'ylim',[-1.5 1.5],'xlim',[0 366],'fontsize',12);
ylabel('Dinoflagellate Chlorophyll','fontsize',14,'fontweight','bold')
xlabel('Day of Year','fontsize',14,'fontweight','bold'); box on
legend([h1 h2],'2003-17','2018','location','sw');
legend boxoff

subplot(2,4,2);
[ ~, var, ~, ~ ] = timeseries2ydmat( windSC.dn14d, windSC.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 6,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{},'fontsize',12);
xlabel('Windspeed','fontsize',14,'fontweight','bold'); box on

subplot(2,4,3);
[ ~, var, ~, ~ ] = timeseries2ydmat( T.dn14d, T.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 6,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{},'fontsize',12);
xlabel('Temperature','fontsize',10,'fontweight','bold'); box on

subplot(2,4,4);
[ ~, var, ~, ~ ] = timeseries2ydmat( upwell.dn14d, upwell.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 6,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{},'fontsize',12);
xlabel('Upwelling','fontsize',14,'fontweight','bold'); box on

subplot(2,4,5);
[ ~, var, ~, ~ ] = timeseries2ydmat( MLDS.dn14d, MLDS.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 6,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r')
set(gca,'ylim',[-1.5 1.5],'fontsize',12);
xlabel('Mixed Layer depth @SCW (m)','fontsize',14,'fontweight','bold')
ylabel('Dinoflagellate log Chl','fontsize',14,'fontweight','bold'); box on

subplot(2,4,6);
[ ~, var, ~, ~ ] = timeseries2ydmat( ZmaxS.dn14d, ZmaxS.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 6,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{},'fontsize',12);
xlabel('Z(max dT/dz) @SCW (m)','fontsize',14,'fontweight','bold'); box on

subplot(2,4,7);
[ ~, var, ~, ~ ] = timeseries2ydmat( river.dn14d, river.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 6,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{},'fontsize',12);
xlabel('log(Discharge) (ft^3s^{-1})','fontsize',14,'fontweight','bold'); box on

subplot(2,4,8);
[ ~, var, ~, ~ ] = timeseries2ydmat( SSS.dn14d, SSS.tAnom );
for i=1:size(var-1,2) 
    h1=scatter(var(:,i),DINO(:,i), 6,'b');
    hold on
end
scatter(var(:,end),DINO(:,end), 8,'r');
set(gca,'ylim',[-1.5 1.5],'yticklabel',{},'fontsize',12);
xlabel('Salinity (g kg^{-1})','fontsize',14,'fontweight','bold'); box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_noSeason_scatter_2003-2018.tif']);
hold off

%% all the historical dino data
figure('Units','inches','Position',[1 1 9 5.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.02], [0.11 0.04], [0.06 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

idx=find(SC.CHL>5);
dino=SC.fxDino(idx).*log(SC.CHL(idx));

subplot(2,4,1);
[ ~, DINO, ~, X ] = timeseries2ydmat( SC.dn(idx), dino );
for i=1:size(DINO-1,2) 
    h1=scatter(X, DINO(:,i), 4,'b');
    hold on
end
h2=scatter(X, DINO(:,end), 5,'r');
set(gca,'ylim',[0 5],'xlim',[0 366])
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold')
xlabel('Day of year','fontsize',10,'fontweight','bold'); box on
legend([h1 h2],'2003-17','2018','location','nw')
legend boxoff

subplot(2,4,2);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.wind(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Wind m/s','fontsize',10,'fontweight','bold'); box on

subplot(2,4,3);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.T(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Temperature (^oC)','fontsize',10,'fontweight','bold'); box on

subplot(2,4,4);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.upwell(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Upwelling Index','fontsize',10,'fontweight','bold'); box on

subplot(2,4,5);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.mld5S(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[0 5])
xlabel('Mixed Layer depth @SCW (m)','fontsize',10,'fontweight','bold')
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold'); box on

subplot(2,4,6);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.ZmaxS(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Z(max dT/dz) @SCW (m)','fontsize',10,'fontweight','bold'); box on

subplot(2,4,7);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.mld5(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Mixed Layer depth @M1 (m)','fontsize',10,'fontweight','bold'); box on

subplot(2,4,8);
[ ~, var, ~, ~ ] = timeseries2ydmat( SC.dn(idx), SC.Zmax(idx) );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b');
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r');
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Z(max dT/dz) @ M1 (m)','fontsize',10,'fontweight','bold'); box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_scatter_2003-2018.tif']);
hold off

%% Just 2018
figure('Units','inches','Position',[1 1 9 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.02], [0.11 0.04], [0.06 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

Y = log(ydino./ymat_ml);
dn = xmat;
    
subplot(2,4,1);
X = xmat;
scatter(X, Y, 4)
datetick('x','m')
set(gca,'ylim',[0 4])
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold')
xlabel('Day of year','fontsize',10,'fontweight','bold')
box on

subplot(2,4,2);
X=NaN*xmat;
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.wind(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 4],'yticklabel',{})
xlabel('Wind m/s','fontsize',10,'fontweight','bold')
box on

subplot(2,4,3);
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.Tsensor(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 4],'yticklabel',{})
xlabel('Temperature (^oC)','fontsize',10,'fontweight','bold')
box on

subplot(2,4,4);
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.upwell(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 5],'yticklabel',{})
xlabel('Upwelling Index','fontsize',10,'fontweight','bold')
box on

subplot(2,4,5);
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.mld5S(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 4])
xlabel('Mixed Layer depth @SCW (m)','fontsize',10,'fontweight','bold')
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold')
box on

subplot(2,4,6);
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.ZmaxS(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 4],'yticklabel',{})
xlabel('Z(max dT/dz) @SCW (m)','fontsize',10,'fontweight','bold')
box on

subplot(2,4,7);
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.mld5(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 4],'yticklabel',{})
xlabel('Mixed Layer depth @M1 (m)','fontsize',10,'fontweight','bold')
box on

subplot(2,4,8);
for i=1:length(dn)
    for j=1:length(SC.dn)
        if SC.dn(j) == dn(i)
            X(i)=SC.Zmax(j);    
        else
        end
    end
end
scatter(X, Y, 4)
set(gca,'ylim',[0 4],'yticklabel',{})
xlabel('Z(max dT/dz) @M1 (m)','fontsize',10,'fontweight','bold')
box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs\dino_scatter_2018.tif']);
hold off

%% 
clearvars BIO CA cellC class2useTB class_label_diat class_label_dino...
    classbiovolTB classcountTB filelistTB filepath i ind_cell ind_diatom...
    ind_dino MB mdateTB ml_analyzedTB ROMS volB volC w xdiat xdino...
    ydiat ydiat_ml year ymat ymat_ml;

yi = log(ydino./ydino_ml);
dni = xmat;

idx=~isnan(yi);
y = yi(idx);
DN = dni(idx);

n=5;
X=NaN*ones(length(y),n);

[X(:,1)] = match_dates(SC.dn, SC.SST, DN);
[X(:,2)] = match_dates(SC.dn,SC.upwell, DN);
[X(:,3)] = match_dates(SC.dn, SC.river, DN);
[X(:,4)] = match_dates(SC.dn, SC.mld5, DN);
[X(:,5)] = match_dates(SC.dn,SC.PDO, DN);
[X(:,6)] = match_dates(SC.dn,SC.wind, DN);

X(377:end,5)=[.07;.07;.07;.07;.07;.07];
[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,y,n);


