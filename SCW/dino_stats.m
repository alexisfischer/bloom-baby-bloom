%% plot Dino chl vs Z(max dT/dz)

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');

%% Plot historical dino anomalies
%Load and rename structures
load([filepath 'Data/Climatology_Dinoflagellate log(CHL)'],'C'); dino=C;
%load([filepath 'Data/Climatology_log(Discharge)'],'C'); river=C;
load([filepath 'Data/Climatology_Temperature'],'C'); T=C;
load([filepath 'Data/Climatology_Windspeed_SC'],'C'); windSC=C;
%load([filepath 'Data/Climatology_Silicate'],'C'); sil=C;
%load([filepath 'Data/Climatology_Ammonium'],'C'); ammon=C;
%load([filepath 'Data/Climatology_log(Chlorophyll)'],'C'); chl=C;
load([filepath 'Data/Climatology_UpwellingIndex'],'C'); upwell=C;

%load([filepath 'Data/Climatology_maxdTdz'],'C'); maxdTdz=C;
load([filepath 'Data/Climatology_Zmax'],'C'); Zmax=C;
load([filepath 'Data/Climatology_Zmax_S'],'C'); ZmaxS=C;
load([filepath 'Data/Climatology_MixedLayerDepth'],'C'); MLD=C;
load([filepath 'Data/Climatology_MixedLayerDepth_S'],'C'); MLDS=C;

%%
figure('Units','inches','Position',[1 1 9 5.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.02], [0.11 0.04], [0.06 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,4,1);
[ ~, DINO, ~, X ] = timeseries2ydmat( dino.dn14d, dino.tAnom );
for i=1:size(DINO-1,2) 
    h1=scatter(X, DINO(:,i), 4,'b');
    hold on
end
h2=scatter(X, DINO(:,end), 5,'r');
set(gca,'ylim',[-1.5 1.5],'xlim',[0 366])
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold')
xlabel('Day of year','fontsize',10,'fontweight','bold'); box on
legend([h1 h2],'2003-17','2018','location','sw');
legend boxoff

subplot(2,4,2);
[ ~, var, ~, ~ ] = timeseries2ydmat( windSC.dn14d, windSC.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{})
xlabel('Wind m/s','fontsize',10,'fontweight','bold'); box on

subplot(2,4,3);
[ ~, var, ~, ~ ] = timeseries2ydmat( T.dn14d, T.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{})
xlabel('Temperature (^oC)','fontsize',10,'fontweight','bold'); box on

subplot(2,4,4);
[ ~, var, ~, ~ ] = timeseries2ydmat( upwell.dn14d, upwell.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{})
xlabel('Upwelling Index','fontsize',10,'fontweight','bold'); box on

subplot(2,4,5);
[ ~, var, ~, ~ ] = timeseries2ydmat( MLDS.dn14d, MLDS.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[-1.5 1.5])
xlabel('Mixed Layer depth @SCW (m)','fontsize',10,'fontweight','bold')
ylabel('Dinoflagellate log Chl','fontsize',10,'fontweight','bold'); box on

subplot(2,4,6);
[ ~, var, ~, ~ ] = timeseries2ydmat( ZmaxS.dn14d, ZmaxS.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{})
xlabel('Z(max dT/dz) @SCW (m)','fontsize',10,'fontweight','bold'); box on

subplot(2,4,7);
[ ~, var, ~, ~ ] = timeseries2ydmat( MLD.dn14d, MLD.tAnom );
for i=1:size(var-1,2) 
    scatter(var(:,i),DINO(:,i), 4,'b')
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r')
set(gca,'ylim',[-1.5 1.5],'yticklabel',{})
xlabel('Mixed Layer depth @M1 (m)','fontsize',10,'fontweight','bold'); box on

subplot(2,4,8);
[ ~, var, ~, ~ ] = timeseries2ydmat( Zmax.dn14d, Zmax.tAnom );
for i=1:size(var-1,2) 
    h1=scatter(var(:,i),DINO(:,i), 4,'b');
    hold on
end
scatter(var(:,end),DINO(:,end), 5,'r');
set(gca,'ylim',[-1.5 1.5],'yticklabel',{})
xlabel('Z(max dT/dz) @ M1 (m)','fontsize',10,'fontweight','bold'); box on

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

