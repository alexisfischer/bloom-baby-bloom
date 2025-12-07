%% Find if there's a suitable index of stratification intensity in HOBO data
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/Misc-Functions/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));

load([filepath 'Data/BuddInlet_data_summary'],'T');
load([filepath 'Data/BuddInlet_TSChl_profiles'],'B','dt');

[~,ia,ib]=intersect(dt,T.dt);
X=[B(ia).N]; 

%% plot buoy frequency vs salinity
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
Y=T.s1(ib);
mdl=fitlm(X,Y,'RobustOpts','on');
scatter(X,Y); hold on
h=plot(X,mdl.Fitted,'-');
set(gca,'fontsize',10,'ylim',[20 32],'xlim',[0 0.06]); %s
axis square; box on;
text(0.045,31.5,['R^2 = ' num2str(round(mdl.Rsquared.Ordinary,3))],'fontsize',10)
text(0.045,30.5,['p = ' num2str(round(mdl.Coefficients.pValue(2),3))],'fontsize',10)
xlabel('max buoy. freq.','fontsize',11)
ylabel('Salinity','fontsize',11)

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/buoyfreq_vs_sal.png'],'Resolution',100)    
hold off

%% plot buoy frequency vs salinity
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
Y=T.sigmat1(ib);
mdl=fitlm(X,Y,'RobustOpts','on');
scatter(X,Y); hold on
h=plot(X,mdl.Fitted,'-');
set(gca,'fontsize',10,'ylim',[14 24],'ytick',15:3:24,'xlim',[0 0.06]); %s
axis square; box on;
text(0.045,23.5,['R^2 = ' num2str(round(mdl.Rsquared.Ordinary,3))],'fontsize',10)
text(0.045,22.5,['p = ' num2str(round(mdl.Coefficients.pValue(2),3))],'fontsize',10)
xlabel('max buoy. freq.','fontsize',11)
ylabel('sigma-t','fontsize',11)

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/buoyfreq_vs_sigmat.png'],'Resolution',100)    
hold off

%% plot buoy frequency vs temperature
figure('Units','inches','Position',[1 1 3.5 3.5],'PaperPositionMode','auto');
Y=T.t1(ib);
mdl=fitlm(X,Y,'RobustOpts','on');
scatter(X,Y); hold on
h=plot(X,mdl.Fitted,'-');
set(gca,'fontsize',10,'ylim',[8 23],'xlim',[0 0.06]); %t
axis square; box on;
text(0.001,22,['R^2 = ' num2str(round(mdl.Rsquared.Ordinary,3))],'fontsize',10)
text(0.001,21,['p = ' num2str(round(mdl.Coefficients.pValue(2),3))],'fontsize',10)
xlabel('max buoy. freq.','fontsize',11)
ylabel('Temperature','fontsize',11)

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/buoyfreq_vs_temp.png'],'Resolution',100)    
hold off
