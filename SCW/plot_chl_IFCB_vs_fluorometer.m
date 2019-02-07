%% plot chlorophyll r2 comparison

year=2018; %USER

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

%% r2 chlorophyll sensor

DN=SC.dn;
chlM=SC.CHL;
chlS=SC.CHLsensor;
chlI=ymat./ymat_ml;
i0=find(DN>=datenum('01-Jan-2018'),1);
iend=find(DN>=datenum('17-Oct-2018'),1);
DN=DN(i0:iend); chlM=chlM(i0:iend); chlS=chlS(i0:iend);
i0=find(xmat>=datenum('01-Jan-2018'),1);
iend=find(xmat>=datenum('17-Oct-2018'),1);
xmat=xmat(i0:iend); chlI=chlI(i0:iend);

idx=~isnan(chlI); chlI=chlI(idx); chlS=chlS(idx);  DN=DN(idx);
idx=~isnan(chlS); chlI=log(chlI(idx)); chlS=log(chlS(idx));  DN=DN(idx);

x=chlI; y=chlS;
b1 = x\y;
yCalc1 = b1*chlI;

X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
b=b;
b1=round(b1,2,'significant');

Rsq1 = round(1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2),2,'significant');
Rsq2 = round(1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2),2,'significant');

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on
%ln=plot(x,yCalc1,'-',x,yCalc2,'-');

ln=plot(x,yCalc1,'-','linewidth',2)
legend(ln,['y=' num2str(b1) 'x'],...
    ['y=' num2str(b(2)) 'x + ' num2str(b(1)) ' (r^2=' num2str(Rsq2) ')'],...    
    'Location','NorthOutside')
legend boxoff

set(gca, 'xlim',[0 3.2],'ylim',[0 3.2],'fontsize',14)
box on
xlabel('IFCB calculated')
ylabel('in situ sensor')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/logChlorophyll_compare_IFCB_sensor.tif']);
hold off

%% r2 chlorophyll manual

DN=SC.dn;
chlM=SC.CHL;
chlS=SC.CHLsensor;
chlI=ymat./ymat_ml;
i0=find(DN>=datenum('01-Jan-2018'),1);
iend=find(DN>=datenum('10-Oct-2018'),1);
DN=DN(i0:iend); chlM=chlM(i0:iend); chlS=chlS(i0:iend);
i0=find(xmat>=datenum('01-Jan-2018'),1);
iend=find(xmat>=datenum('10-Oct-2018'),1);
xmat=xmat(i0:iend); chlI=chlI(i0:iend);

idx=~isnan(chlI); chlI=chlI(idx); chlM=chlM(idx);  DN=DN(idx);
idx=~isnan(chlM); chlI=log(chlI(idx)); chlM=log(chlM(idx));  DN=DN(idx);

x=chlI; y=chlM;
b1 = x\y;
yCalc1 = b1*chlI;

X = [ones(length(x),1) x];
b = X\y;
yCalc2 = X*b;
b=b;
b1=round(b1,5,'significant');

Rsq1 = round(1 - sum((y - yCalc1).^2)/sum((y - mean(y)).^2),2,'significant');
Rsq2 = round(1 - sum((y - yCalc2).^2)/sum((y - mean(y)).^2),2,'significant');

figure('Units','inches','Position',[1 1 4 4.5],'PaperPositionMode','auto');
scatter(x,y,20,'linewidth',2)
hold on
ln=plot(x,yCalc1,'-','linewidth',2);
legend(ln,['y=' num2str(b1) 'x'])
%ln=plot(x,yCalc1,'-',x,yCalc2,'-');
% legend(ln,['y=' num2str(b1) 'x'],...
%     ['y=' num2str(b(2)) 'x + ' num2str(b(1)) ' (r^2=' num2str(Rsq2) ')'],...    
%     'Location','NorthOutside')
legend boxoff

set(gca, 'xlim',[0 3.2],'ylim',[0 3.2],'fontsize',14)
box on
xlabel('IFCB calculated')
ylabel('manual (fluorometer)')

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/logChlorophyll_compare_IFCB_manual.tif']);
hold off