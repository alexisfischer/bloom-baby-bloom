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
load([filepath 'Data/Climatology_Nitrate'],'C'); nit=C;
load([filepath 'Data/Climatology_Ammonium'],'C'); ammon=C;
%load([filepath 'Data/Climatology_log(Chlorophyll)'],'C'); chl=C;
load([filepath 'Data/Climatology_UpwellingIndex'],'C'); upwell=C;

load([filepath 'Data/Climatology_Zmax'],'C'); Zmax=C;
load([filepath 'Data/Climatology_Zmax_S'],'C'); ZmaxS=C;
load([filepath 'Data/Climatology_MixedLayerDepth'],'C'); MLD=C;
load([filepath 'Data/Climatology_MixedLayerDepth_S'],'C'); MLDS=C;

%% 2004-2018 partial least squares regression raw data
%type='Raw';
type='Anom';

lim1=-1;
lim2=1;
%lim1=0;
%lim2=3;

yrrange='04-11';
%yrrange='12-19';
%yrrange='04-19';

n=4;
idx=~isnan(logdino.tAnom);
y = logdino.tAnom(idx);
DN = logdino.dn14d(idx);
 i0=find(DN>=datenum('01-Jan-2004'));
 iend=find(DN>=datenum('01-Jan-2012'));
% i0=find(DN>=datenum('01-Jan-2012'),1);
% iend=find(DN>=datenum('27-Aug-2018'),1);
DN=DN(i0:iend); y=y(i0:iend);

X=NaN*ones(length(y),n);

[X(:,1)] = match_dates(T.dn14d, T.tAnom, DN);
[X(:,2)] = match_dates(Zmax.dn14d, Zmax.tAnom, DN);
[X(:,3)] = match_dates(upwell.dn14d, upwell.tAnom, DN);
[X(:,4)] = match_dates(river.dn14d, river.tAnom, DN);
[X(:,5)] = match_dates(nit.dn14d, nit.tAnom, DN);
[X(:,6)] = match_dates(PDO.dn14d, PDO.ti9, DN);
[X(:,7)] = match_dates(NPGO.dn14d, NPGO.tAnom, DN);

if yrrange == '12-19' 
    X(end-16:end,5)=-2;
elseif yrrange == '04-19' 
    X(end-16:end,5)=-2;    
else
end
 
[XL,YL,XS,YS,beta,PCTVAR,MSE,stats] = plsregress(X,y,n);

% plot component loadings
figure('Units','inches','Position',[1 1 14 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02], [0.18 .09], [0.16 0.01]);

subplot(1,4,1);
barh(XL(:,1),'k')
set(gca,'yaxislocation','left','yticklabel',{'Temperature','Mixed Layer Depth',...
    'Upwelling','River Discharge','Nitrate','PDO','NPGO'},'fontsize',16)
%xlabel('Factor loadings','fontsize',16);
title('1st component','fontsize',16)

subplot(1,4,2);
barh(XL(:,2),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
%xlabel('Factor loadings','fontsize',16);
title('2nd component','fontsize',16)

subplot(1,4,3);
barh(XL(:,3),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
%xlabel('Factor loadings','fontsize',16);
title('3rd component','fontsize',16)

subplot(1,4,4);
barh(XL(:,4),'k')
set(gca,'yaxislocation','left','yticklabel',{},'fontsize',16)
%xlabel('Factor loadings','fontsize',16);
title('4th component','fontsize',16)

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_FactorLoadings.tif']);    
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

% subplot(2,3,2);
% yfit = [ones(size(X,1),1) X]*beta;
% residuals = y - yfit;
%  stem(residuals)
%  set(gca,'fontsize',16)
% xlabel('Observation','fontsize',16,'fontweight','bold');
% ylabel('Residual','fontsize',16,'fontweight','bold');
% hold on

% subplot(2,2,2);
% [N,p] = size(X);
% yfitPLS = [ones(N,1) X]*beta;
% TSS = sum((y-mean(y)).^2);
% RSS_PLS = sum((y-yfitPLS).^2);
% rsquaredPLS = round(1 - RSS_PLS/TSS,2,'significant')
% 
% plot(y,yfitPLS,'o');
% set(gca,'xlim',[lim1 lim2],'ylim',[lim1 lim2],'fontsize',14,...
%     'ytick',-1:1:1,'xtick',-1:1:1);
% xlabel('Observed Response','fontsize',16,'fontweight','bold');
% ylabel('Fitted Response','fontsize',16,'fontweight','bold');
% legend(['R^2 = ' num2str(rsquaredPLS) ''],'location','NW'); legend boxoff

subplot(2,1,2);
plot(0:n,MSE(2,:),'-o','linewidth',2);
set(gca,'fontsize',14,'xlim',[0 n],'xtick',0:1:n,'tickdir','out');
xlabel('Number of Components','fontsize',14,'fontweight','bold');
ylabel('Estimated MSE','fontsize',14,'fontweight','bold');
hold on
% 
% subplot(3,1,3);
% plot(0:n,[[0;0;0;0;0;0;0],stats.W],'o-','linewidth',1.5);
% set(gca,'fontsize',14,'xlim',[0 n],'tickdir','out');
% l=legend({'SST','MLD',...
%     'Upwelling','River','Nitrate','PDO','NPGO'},'Location','SW');
% set(l,'fontsize',14,'Position',[0.247046105383734 0.192931576608604 0.357638888888889 0.159090909090909]);
% legend boxoff
% xlabel('Component Number','fontsize',16,'fontweight','bold');
% ylabel('Weight','fontsize',16,'fontweight','bold');

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    [filepath 'Figs\dino_' num2str(yrrange) '_' num2str(type) '_PLSR.tif']);
hold off

