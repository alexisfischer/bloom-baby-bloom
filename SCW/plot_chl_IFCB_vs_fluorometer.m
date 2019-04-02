%% plot chlorophyll r2 comparison

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB'],...
    'class2useTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

%convert to PST (UTC is 7 hrs ahead)
time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
time.TimeZone='America/Los_Angeles'; mdateTB=datenum(time);

% % select only 1000 hrs - this was not effective
% hr=time.Hour; idx=hr==10; mdateTB=datenum(time(idx));
% classbiovolTB=classbiovolTB(idx,:); ml_analyzedTB=ml_analyzedTB(idx); filelistTB=filelistTB(idx);

%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 

%convert from per cell to per mL
volC=zeros(size(cellC)); volB=zeros(size(cellC));
for i=1:length(cellC)
    volC(i,:)=cellC(i,:)./ml_analyzedTB(i)./1000; %convert from carbon/cell to ug/L 
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end
    
%%%% Step 3: select total living biovolume 
[ ind_cell, ~ ] = get_cell_ind_CA( class2useTB, class2useTB );
[~, ymat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_cell),2));
[xmat, ymat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
ymat(ymat==Inf)=NaN;

%%% Step 4: select correct 2018 time period for all data
[idx]=~isnan(ymat); carbon=ymat(idx)./ymat_ml(idx); xmat=xmat(idx);
[idx]=~isnan(SC.CHLsensor); fluor=SC.CHLsensor(idx); dnf=SC.dn(idx);
[idx]=~isnan(SC.CHL); extract=SC.CHL(idx); dne=SC.dn(idx);

 clearvars ind_cell ind_diatom class2useTB classbiovolTB ...
    ml_analyzedTB mdateTB filelistTB volC volB cellC i ymat ymat_ml...
    iend i0 idx time idx hr;

%% r2 extract chlorophyll
[~,ia,ib]=intersect(dne,xmat); y=(extract(ia)); x=(carbon(ib));
 id=find(x<1); x(id)=[]; y(id)=[];
Lfit = fitlm(x,y,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),3);
x(outliers)=[]; y(outliers)=[];

Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(0,20,50); 
yfit = m*xfit+b; 

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on 
L=plot(xfit,yfit,'--','linewidth',1.5);

legend(L,['y=' num2str(m) '+' num2str(b) ' (R^2=' num2str(Rsq) ')'],...
    'Location','NorthOutside'); legend boxoff
set(gca,'fontsize',14,'tickdir','out',...
    'xlim',[0 11],'xtick',0:3:12,'ylim',[0 11],'ytick',0:3:12); box on
xlabel('Carbon (IFCB)')
ylabel('Extracted Chlorophyll')
% figure; plotResiduals(Lfit,'probability')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/lFCB_vs_ChlExtracted.tif']);
hold off

%% IFCB vs extract chlorophyll new!
[date,ia,ib]=intersect(dne,xmat); y=(extract(ia)); x=(carbon(ib));
 id=find(x<1); x(id)=[]; y(id)=[];

Lfit = fitlm(x,y,'RobustOpts','on');
[~,outliers] = maxk((Lfit.Residuals.Raw),3);
x(outliers)=[]; y(outliers)=[];

Lfit = fitlm(x,y,'RobustOpts','on');
ypred = predict(mdl,x);

figure; plot(x,y,'o',x,ypred,'x')
legend('Data','Predictions')


% Lfit = fitlm(x,y,'RobustOpts','on');
b = round(Lfit.Coefficients.Estimate(1),2,'significant');
m = round(Lfit.Coefficients.Estimate(2),2,'significant');    
Rsq = round(Lfit.Rsquared.Ordinary,2,'significant')
xfit = linspace(0,20,50); 
yfit = m*xfit+b; 

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on 
L=plot(xfit,yfit,'--','linewidth',1.5);

legend(L,['y=' num2str(m) '+' num2str(b) ' (R^2=' num2str(Rsq) ')'],...
    'Location','NorthOutside'); legend boxoff
set(gca,'fontsize',14,'tickdir','out',...
    'xlim',[0 11],'xtick',0:3:12,'ylim',[0 11],'ytick',0:3:12); box on
xlabel('Carbon (IFCB)')
ylabel('Extracted Chlorophyll')
% figure; plotResiduals(Lfit,'probability')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/lFCB_vs_ChlExtracted.tif']);
hold off


%% r2 fluorometer vs extracted chl
[~,ia,ib]=intersect(dnf,dne); y=log(fluor(ia)); x=log(extract(ib));

b1 = round(x\y,2,'significant');
yCalc1 = b1*x;

X = [ones(length(x),1) x];
b2 = round(X\y,2,'significant');
yCalc2 = X*b2;

Rsq1 = round(1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2),2,'significant')
Rsq2 = round(1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2),2,'significant')

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on 
%l1=plot(x,yCalc1,'linewidth',1.5);
hold on
l2=plot(x,yCalc2,'--','linewidth',1.5);

legend(l2,['y=' num2str(b2(1)) '+' num2str(b2(2)) ' (R^2=' num2str(Rsq2) ')'],'Location','NorthOutside'); legend boxoff
xlabel('log Extracted Chlorophyll');
ylabel('log Chlorophyll Fluorescence')
set(gca,'xlim',[0 3.2],'xtick',0:1:3,'ylim',[0 3.2],'ytick',0:1:3,...
     'fontsize',14,'tickdir','out'); box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Chl_Extract_vs_Fluorometer.tif']);
hold off


%% r2 fluorometer
[~,ia,ib]=intersect(dnf,xmat); y=log(fluor(ia)); x=log(carbon(ib));

b1 = round(x\y,2,'significant');
yCalc1 = b1*x;

X = [ones(length(x),1) x];
b2 = round(X\y,2,'significant');
yCalc2 = X*b2;

Rsq1 = round(1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2),2,'significant')
Rsq2 = round(1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2),2,'significant')

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on 
%l1=plot(x,yCalc1,'linewidth',1.5);
hold on
l2=plot(x,yCalc2,'--','linewidth',1.5);

legend(l2,['y=' num2str(b2(1)) '+' num2str(b2(2)) ' (R^2=' num2str(Rsq2) ')'],'Location','NorthOutside'); legend boxoff
xlabel('log Carbon (IFCB)');
ylabel('log Chlorophyll Fluorescence')
set(gca,'xlim',[-1 3.2],'xtick',-1:1:3,'ylim',[0 3.2],'ytick',0:1:3,...
     'fontsize',14,'tickdir','out'); box on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/IFCB_vs_ChlFluorometer.tif']);
hold off

