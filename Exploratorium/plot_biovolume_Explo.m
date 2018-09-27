%% Plot biovolume for Exploratorium
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

year=2018; %USER

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Exploratorium/';

load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB' num2str(year) ''],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');

load([filepath 'Data/IFCB_summary/class/summary_biovol_allcells' num2str(year)],...
    'matdate', 'ml_analyzed', 'biovol_sum', 'filelist','eqdiam',...
    'notes1', 'notes2');

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

%%%% Step 3: Determine what fraction of Cell-derived carbon is 
% Dinoflagellates vs Diatoms vs Classes of interest

%select total living biovolume 
[ ind_cell, ~ ] = get_cell_ind_CA( class2useTB, class2useTB );
[xmat, ymat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_cell),2));
[xmat ymat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only diatoms
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
[xdiat, ydiat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_diatom),2));
[xdiat ydiat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only dinoflagellates
[ ind_dino, ~ ] = get_dino_ind_CA( class2useTB, class2useTB );
[xdino, ydino ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_dino),2));
[xdino ydino_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only nanoplankton
[ ind_nano, ~ ] = get_nano_ind_CA( class2useTB, class2useTB );
[xnano, ynano ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_nano),2));
[xnano ynano_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

% extract biovolume and carbon for each class
for i=1:length(class2useTB)
    BIO(i).class = class2useTB(i);
    [~,BIO(i).bio ] = timeseries2ydmat(mdateTB, volB(:,i));
    [~,BIO(i).car ] = timeseries2ydmat(mdateTB, volC(:,i));    
end

clearvars i ind_cell ind_diatom ind_dino mdateTB micron_factor
%[~, cind] = sort(sum(x), 'descend'); %rank order biomass    

%%%% Step 4: Bin Equivalent Sphaerical Diameter
diambins=0:5:30; %decide what kind of size bins you want to look at
clear bincount
bincount=NaN(length(eqdiam),length(diambins));

%bincount is a matrix of counts/ml for each diameter bin (as specified in
%diambin) by each file....or essentially histogram values
for i=1:length(eqdiam)
    [d,bins]=hist(eqdiam{i,1},diambins); %This looks at equivalent spherical diameter, change this if you want to look at something else
    bincount(i,:)=d./ml_analyzed(i);
end

%creates your daybins for each diambin
for i=1:length(diambins)
    [matdate_bin, classcount_bin, ml_analyzed_mat_bin] = make_day_bins(matdate,bincount(:,i),ml_analyzed);
    daybin_perml(:,i)=classcount_bin./ml_analyzed_mat_bin; 
end


%% plot fraction biovolume of select species
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.08 0.04], [0.11 0.3]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(['' num2str(year) '-05-20']); xax2=datenum(['' num2str(year) '-07-10']);     

% binned Eqdiam
subplot(3,1,1);
plot(matdate_bin,daybin_perml,'.','linewidth',5,'markersize',20);

cstr=[brewermap(6,'Paired');[50 50 50]/255];
ax=get(gca); cat = ax.Children;
for ii = 1:length(cat)
    set(cat(ii), 'Color', cstr(ii,:))
end

datetick('x', 3, 'keeplimits')
set(gca,'xticklabel',{},'xgrid','on','ylim',[0 150],'ytick',0:50:150,'xlim',[xax1 xax2],...
     'FontSize',14,'XAxisLocation','bottom','TickDir','out'); 

ylabel('Counts mL^{-1}', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
h=legend('0-5 \mum','5-10 \mum','10-15 \mum','15-20 \mum','20-25 \mum',...
    '25-30 \mum');
set(h,'FontSize',14,'box','off',...
    'Position',[0.72048611111111 0.711371527777777 0.164930555555556 0.221354166666667]);
hold on

%total cell-derived biovolume
subplot(3,1,2);
plot(xmat,ymat./ymat_ml,'ko-','linewidth', 2,'markersize',4);
hold on
datetick('x', 3, 'keeplimits')
xlim([xax1 xax2])
set(gca,'xgrid','on','xticklabel',{},...
    'fontsize', 14, 'fontname', 'arial','tickdir','out')
ylabel('Carbon (\mug L^{-1})', 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
hold all

%Fraction dinos and diatoms and nanoplankton
subplot(3,1,3);
fx_other=(ymat-(ydino+ydiat+ynano))./ymat; %fraction not dinos or diatoms or nanoplankton

bar(xmat, [ydiat./ymat ydino./ymat ynano./ymat fx_other], 0.5, 'stack');
ax = get(gca);
cat = ax.Children;

ax=get(gca); cat = ax.Children;
cstr=flipud(brewermap(4,'Set2'));

for ii = 1:length(cat)
    set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
end

datetick('x','mmmdd', 'keeplimits')
xlim([xax1 xax2])
ylim([0;1])
set(gca, 'fontsize', 14, 'fontname', 'arial','tickdir','out')
ylabel({'Fraction of biomass'}, 'fontsize', 16, 'fontname', 'arial','fontweight','bold')
h=legend('diatoms','dinoflagellates','nanoplankton','other cell-derived');
set(h,'FontSize',14,'box','off',...
    'Position',[0.712673612605106 0.162905093465707 0.276041666666666 0.142361111111111]);
hold on
datetick('x','mmmdd', 'keeplimits')


% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/FxBiovolume_IFCB_Explo_' num2str(year) '.tif']);
hold off

