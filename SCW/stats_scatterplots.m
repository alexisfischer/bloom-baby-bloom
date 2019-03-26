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

