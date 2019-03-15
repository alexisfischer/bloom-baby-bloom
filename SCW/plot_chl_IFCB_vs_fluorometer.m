%% plot chlorophyll r2 comparison
%addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/'; % MAC 
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB2018'],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');
    
%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 

%convert from per cell to per mL
volC=zeros(size([cellC]));
volB=zeros(size([cellC]));

for i=1:length(cellC)
    volC(i,:)=cellC(i,:)./ml_analyzedTB(i);
    volB(i,:)=classbiovolTB(i,:)./ml_analyzedTB(i);    
end
    
%convert from pg/mL to ug/L 
volC=volC./1000;

%%%% Step 3: select total living biovolume 
[ ind_cell, ~ ] = get_cell_ind_CA( class2useTB, class2useTB );
[~, ymat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_cell),2));
[xmat, ymat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%%% Step 4: select correct 2018 time period for all data
DN=SC.dn; extract=SC.CHL; fluor=SC.CHLsensor; carbon=ymat./ymat_ml;
i0=find(DN>=datenum('01-Jan-2018'),1);
iend=find(DN>=datenum('17-Oct-2018'),1);
DN=DN(i0:iend); extract=extract(i0:iend); fluor=fluor(i0:iend);

i0=find(xmat>=datenum('01-Jan-2018'),1);
iend=find(xmat>=datenum('17-Oct-2018'),1);
xmat=xmat(i0:iend); carbon=carbon(i0:iend);

% remove nans and Inf from IFCB data
idx=~isnan(carbon); carbon=carbon(idx); fluor=fluor(idx); extract=extract(idx);  DN=DN(idx); 
idx=~(carbon==Inf); carbon=carbon(idx); fluor=fluor(idx); extract=extract(idx); DN=DN(idx); 

clearvars ind_cell ind_diatom class2useTB classcountTB classbiovolTB ...
    ml_analyzedTB mdateTB filelistTB volC volB cellC i xmat ymat ymat_ml...
    iend i0 idx;

%% r2 chlorophyll fluorometer

%remove nans from fluorometer data
idx=~isnan(fluor); x=log(carbon(idx)); y=log(fluor(idx));

b1 = x\y; %least-squares regression
yCalc1 = b1*x;
b1=round(b1,2,'significant');

Rsq1 = 1-sum((y - yCalc1).^2)/sum((y - mean(y)).^2);

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on
%ln=plot(x,yCalc1,'-',x,yCalc2,'-');

ln=plot(x,yCalc1,'-','linewidth',2);
legend(ln,['y=' num2str(b1) 'x'],'Location','SouthEast'); legend boxoff;

set(gca,'xlim',[0 3.2],'xtick',0:1:3,'ylim',[0 3.2],'ytick',0:1:3,...
    'fontsize',14,'tickdir','out');
box on
xlabel('Carbon (IFCB)')
ylabel('Chlorophyll fluorescence')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/IFCB_vs_ChlFluorometer.tif']);
hold off

%% r2 chlorophyll extract chlorophyll

idx=~isnan(extract); x=log(carbon(idx)); y=log(extract(idx)); 
b1 = x\y;
yCalc1 = b1*x;
b1=round(b1,2,'significant');
Rsq1 = round(1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2),2,'significant');

X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
Rsq2 = round(1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2),2,'significant');

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on
ln1=plot(x,yCalc1,'-','linewidth',2);
hold on
%legend(ln,['y=' num2str(b1) 'x'],'Location','SouthEast'); legend boxoff;
ln2=plot(x,yCalc1,'-',x,yCalc2,'-'); hold on
legend({ln1,ln2},['y=' num2str(b1) 'x'],...
    ['y=' num2str(b(2)) 'x + ' num2str(b(1)) ' (r^2=' num2str(Rsq2) ')'],...    
    'Location','SouthEast')

set(gca,'xlim',[0 3.2],'xtick',0:1:3,'ylim',[0 3.2],'ytick',0:1:3,...
    'fontsize',14,'tickdir','out');
box on
xlabel('Carbon (IFCB)')
ylabel('Extracted Chlorophyll')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/lFCB_vs_ChlExtracted.tif']);
hold off