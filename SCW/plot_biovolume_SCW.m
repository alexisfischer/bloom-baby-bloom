%% Plot biovolume for dinoflagellates vs diatoms
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

%% Step 1: Load in data
figpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
resultpath = 'F:\IFCB104\class\summary\'; %Where you want the summary file to go
load([resultpath 'summary_biovol_allTB2018']);

% convert to cubic microns
micron_factor = 1/3.4; %microns per pixel
classbiovolTB = classbiovolTB*micron_factor^3;

%% Alternate Step 1
% Only use if have not already extracted biovolume from class files for specific year
figpath = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\';
resultpath = 'F:\IFCB104\class\summary\'; %Where you want the summary file to go
classpath_generic = 'F:\IFCB104\class\classxxxx_v1\';
feapath_generic = 'F:\IFCB104\features\xxxx\'; %Put in your featurepath byyear
roibasepath_generic = 'F:\IFCB104\data\xxxx\'; %Where you raw data is
year = 2018;

extract_biovolume_class(resultpath,classpath_generic,feapath_generic,roibasepath_generic,year)
% can modify compile_biovolume_yrs or compile_biovolume_summaries if need to compile multiple years of s

% convert to cubic microns
micron_factor = 1/3.4; %microns per pixel
classbiovolTB = classbiovolTB*micron_factor^3;

%% Step 2: Determine what fraction of Cell-derived biovolume is 
% Dinoflagellates vs Diatoms vs Classes of interest

%select total living biovolume 
[ ind_cell, class_label ] = get_cell_ind_CA( class2useTB, class2useTB );
[xmat, ymat ] = timeseries2ydmat(mdateTB, nansum(classbiovolTB(:,ind_cell),2));
[xmat ymat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only diatoms
[ ind_diatom, class_label ] = get_diatom_ind_CA( class2useTB, class2useTB );
[xdiat, ydiat ] = timeseries2ydmat(mdateTB, nansum(classbiovolTB(:,ind_diatom),2));
[xdiat ydiat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only dinoflagellates
[ ind_dino, class_label ] = get_dino_ind_CA( class2useTB, class2useTB );
[xdino, ydino ] = timeseries2ydmat(mdateTB, nansum(classbiovolTB(:,ind_dino),2));
[xdino ydino_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

ind = 1; %Akashiwo 
    [~,yAKA ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yAKA_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
    
ind = 9; %Ceratium 
    [~,yCER ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yCER_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

ind = 33; %Dinophysis 
    [~,yDINO ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yDINO_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
    
ind = 24; %Gymnodinium 
    [~,yGYM ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yGYM_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

ind = 33; %Prorocentrum 
    [~,yPRO ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yPRO_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);    
    
    
ind = 10; %Chaetoceros 
    [~,yCHAET ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yCHAET_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
    
ind = 8; %Centric
    [~,yC ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yC_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
    
ind = 17; %Det_Cer_Lau
    [~,yDETO ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yDETO_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
    
ind = 22; %Eucampia
    [~,yEUC ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yEUC_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
    
ind = 23; %Guin_Dact
    [~,yGUIN ] = timeseries2ydmat(mdateTB, classbiovolTB(:,ind));
    [~,yGUIN_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);  

%% plot fraction biovolume of select species
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.04], [0.09 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

%Fraction dinos and diatoms
subplot(3,1,1);
fx_other=[ymat-[ydino+ydiat]]./ymat; %fraction not dinos or diatoms

bar(xmat, [ydino./ymat ydiat./ymat fx_other], 0.5, 'stack');
ax = get(gca);
cat = ax.Children;

cstr = [ [220 220 220]/255; [110 110 110]/255; [0 0 0]/255];
for ii = 1:length(cat)
    set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
end

datetick('x', 3, 'keeplimits')
xlim(datenum(['01-Jan-2018'; '01-Jul-2018']))
ylim([0;1])
set(gca,'xticklabel',{}, 'fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Fraction of total biovolume', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
h=legend('dinoflagellates','diatoms','other cell-derived');
set(h,'Position',[0.810763891876882 0.890190973968452 0.166666663678673 0.0651041649204368]);
hold on

%Fraction dinos and diatoms
subplot(3,1,2);
fx_dino=[ydino-[yAKA+yCER+yDINO+yGYM+yPRO]]./ymat; %fraction other dinos
fx_diat=[ydiat-[yCHAET+yC+yDETO+yEUC+yGUIN]]./ymat; %fraction other diatoms
fx_other=[ymat-[ydino+ydiat]]./ymat; %fraction not dinos or diatoms

bar(xmat,[yAKA./ymat yCER./ymat yDINO./ymat yGYM./ymat yPRO./ymat...
    yCHAET./ymat yDETO./ymat yEUC./ymat yGUIN./ymat yC./ymat...
    fx_dino fx_diat fx_other], 0.5, 'stack');
ax = get(gca);
cat = ax.Children;

cstr = [[177,89,40]/255; [255,255,153]/255; [166,206,227]/255; [31,120,180]/255;...
    [178,223,138]/255; [51,160,44]/255; [251,154,153]/255; [227,26,28]/255;...
    [253,191,111]/255; [255,127,0]/255; [202,178,214]/255; [150 150 150]/255; [106,61,154]/255 ];

for ii = 1:length(cat)
    set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
end

datetick('x', 3, 'keeplimits')
xlim(datenum(['01-Jan-2018'; '01-Jul-2018']))
ylim([0;1])
set(gca,'xticklabel',{}, 'fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Fraction of total biovolume', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
h=legend('Akashiwo','Ceratium','Dinophysis','Gymnodinium','Prorocentrum',...
    'Chaetoceros','Detonula','Eucampia','Guinardia','Centric diatoms',...
    'other dinos','other diatoms','other cell-derived');
set(h,'Position',[0.808159725831097 0.399956604207141 0.187499996391125 0.246744784681747]);
hold on

%total cell-derived biovolume
subplot(3,1,3);
plot(xmat, ymat./ymat_ml,'k.-','linewidth', 1);
hold on
datetick('x', 3, 'keeplimits')
xlim(datenum(['01-Jan-2018'; '01-Jul-2018']))
ylim([0;3.2*10^5])
set(gca,'xgrid','on','fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Biovolume (\mum^{-3} mL^{-1})', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
hold all

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[figpath 'Figs\FxBiovolume_IFCB_SCW_2018.tif']);
hold off

%% plot dinos vs diatoms
figure, %set(gcf, 'position', [360 278 500 250])
cstr = ['rbkgcmy']; %order of colors

ph = plot(xdino, ydino./ydino_ml,'.-', xdiat, ydiat./ydiat_ml,'.-','linewidth', 1);
for ii = 1:length(ph)
    set(ph(ii), 'color', cstr(ii))
end
datetick('x', 3, 'keeplimits')
xlim(datenum(['01-Jan-2018'; '01-Jul-2018']))
ylabel('Biovolume ( \mum^{ -3} mL^{ -1})', 'fontsize', 16, 'fontname', 'arial')
legend('dinoflagellates','diatoms','Location','NorthEast')
set(gca, 'fontsize', 16, 'fontname', 'arial','tickdir','out')
set(gcf, 'position', [360 278 750 375])

%% plot dino and diatoms in proportion to total biovolume
figure('Units','inches','Position',[1 1 8 5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.08 0.04], [0.09 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

fx_other=[ymat-[ydino+ydiat]]./ymat; %fraction not dinos or diatoms

%Fraction dinos and diatoms
subplot(2,1,1);
bar(xmat, [ydino./ymat ydiat./ymat fx_other], 0.5, 'stack');
ax = get(gca);
cat = ax.Children;

cstr = [ [166,206,227]/255; [31,120,180]/255; [178,223,138]/255;...
    [51,160,44]/255; [251,154,153]/255; [227,26,28]/255;...
    [253,191,111]/255; [255,127,0]/255; [202,178,214]/255; [106,61,154]/255 ];

for ii = 1:length(cat)
    set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
end

datetick('x', 3, 'keeplimits')
xlim(datenum(['01-Jan-2018'; '01-Jul-2018']))
ylim([0;1])
set(gca,'xticklabel',{}, 'fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Fraction of total biovolume', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
h=legend('dinoflagellates','diatoms','other');
set(h,'Position',[0.810763891876882 0.718055558349523 0.166666663678673 0.104166663872699]);
hold on

%total cell-derived biovolume
subplot(2,1,2);
plot(xmat, ymat./ymat_ml,'k.-','linewidth', 1);
hold on
datetick('x', 3, 'keeplimits')
xlim(datenum(['01-Jan-2018'; '01-Jul-2018']))
ylim([0;3.2*10^5])
set(gca,'xgrid','on','fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Biovolume (\mum^{-3} mL^{-1})', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
hold all

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[figpath 'Figs\Diatom_Dino_IFCB_2018.tif']);
hold off

