%% Plot daily IFCB carbon vs chlorophyll Aug 2016-2019 at SCW
%  Alexis D. Fischer, University of California - Santa Cruz, Aug 2019

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

%%%% Load in data
filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; 
indir=[filepath 'Data/IFCB_summary/class/summary_biovol_allTB'];
load([filepath 'Data/SCW_master'],'SC');
[phytoTotal16,~,~,~,~,~,~,mdate16] = extract_daily_carbon([indir '2016']);
[phytoTotal17,~,~,~,~,~,~,mdate17] = extract_daily_carbon([indir '2017']);
[phytoTotal18,~,~,~,~,~,~,mdate18] = extract_daily_carbon([indir '2018']);
[phytoTotal19,~,~,~,~,~,~,mdate19] = extract_daily_carbon([indir '2019']);

phytoTotal=[phytoTotal16;phytoTotal17;phytoTotal18;phytoTotal19];
mdate=[mdate16;mdate17;mdate18;mdate19];

clearvars phytoTotal16 phytoTotal17 phytoTotal18 phytoTotal19 mdate16 mdate17 mdate18 mdate19 indir;

%% plot chlorophyll to carbon comparison
col1=brewermap(1,'Greys');

[idx]=~isnan(SC.CHL); chl=SC.CHL(idx); dne=SC.dn(idx); % remove NaNs
[idx]=~isnan(phytoTotal); carbon=phytoTotal(idx); dni=mdate(idx); % remove NaNs
[~,ia,ib]=intersect(dne,dni); x=log(chl(ia)); y=log(carbon(ib));
Lfit = fitlm(x,y,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),6);
x(outliers)=[]; y(outliers)=[];

Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(min(x),max(x),100); 
yfit = m*xfit+b; 

figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
scatter(x,y,8,'k','linewidth',2,'marker','o','markerfacecolor','k'); hold on 
L=plot(xfit,yfit,'-','Color',col1,'linewidth',1.5);
legend(L,['slope=' num2str(m) '; Int=' num2str(b) '; r^2=' num2str(Rsq) ''],...
    'Location','NorthOutside'); legend boxoff
 set(gca,'fontsize',12,'tickdir','out','ylim',[0 5],'ytick',0:1:5,'xlim',[0 5],'xtick',0:1:5,...
     'yticklabel',{'0.1','1','10','100','1000','10000'},...
     'xticklabel',{'0.1','1','10','100','1000','10000'}); box on
xlabel('Chl \ita\rm (\mug L^{-1})','fontsize',14);
ylabel('C (\mug L^{-1})','fontsize',14);

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/IFCB_vs_ChlExtracted_log.tif']);
hold off