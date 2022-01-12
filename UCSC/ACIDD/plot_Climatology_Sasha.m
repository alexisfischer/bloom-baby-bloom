addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path

filepath = '~/MATLAB/UCSC/SCW/';
load([filepath 'Data/SCW_master'],'SC');

gap=30; n=14; dn=SC.dn;

var= SC.DINOrai; varname = 'Dinoflagellate Chl'; 
[dinoC] = extractClimatology_v1(var,dn,filepath,varname,n,gap);

clearvars var varname idx n gap;

%% Plot dinoflagellate climatology

C=dinoC; varname='Dinoflagellate Chl'; units='log Dino Chl (\mug/L)';

figure('Units','inches','Position',[1 1 8 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.08 0.08], [0.05 0.02], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

xax1=datenum('01-Jan-2001');
xax2=datenum('01-Jan-2019');

subplot(3,1,1);
anomaly(C.dn14d,C.tAnom);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14)
datetick('x','yy','keeplimits')
box on
ylabel('Anomalies','fontsize',14)
hold on

subplot(3,1,2);
plot(C.dn,C.t,'o-','linewidth',1.5,'markersize',3);
set(gca,'xlim',[xax1 xax2],'xgrid','on','fontsize',14)
datetick('x','yy','keeplimits')
ylabel({['' num2str(units) '']},'fontsize',14)
legend('weekly raw','Location','N')
legend boxoff
hold on

subplot(3,1,3);
h=plot(C.dn14d,C.t14d,':k',C.dn14d,C.ti3,'-','linewidth',2);
set(h(1),'linewidth',2.5);
set(gca,'xlim',[datenum('01-Jan-2015') datenum('01-Jan-2019')],'xgrid','on','fontsize',14)
datetick('x','yyyy','keeplimits')
ylabel({['' num2str(units) '']},'fontsize',14)
legend('climatology','3pt running average','Location','N')
legend boxoff
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs\Climatology_SCW_' num2str(varname) '.tiff']);
hold off

