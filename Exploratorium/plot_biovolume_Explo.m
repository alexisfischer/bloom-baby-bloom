%% Plot biovolume for Exploratorium
% parts modified from "compile_biovolume_summaries"
%  Alexis D. Fischer, University of California - Santa Cruz, June 2018

year=2018; %USER

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/Exploratorium/';

load([filepath 'Data/IFCB_summary/class/summary_biovol_allTB' num2str(year) ''],...
    'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB','filelistTB');
    
%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, class_label ] = get_diatom_ind_CA( class2useTB, class2useTB );
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
[ ind_cell, class_label ] = get_cell_ind_CA( class2useTB, class2useTB );
[xmat, ymat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_cell),2));
[xmat ymat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only diatoms
[ ind_diatom, class_label ] = get_diatom_ind_CA( class2useTB, class2useTB );
[xdiat, ydiat ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_diatom),2));
[xdiat ydiat_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

%select only dinoflagellates
[ ind_dino, class_label ] = get_dino_ind_CA( class2useTB, class2useTB );
[xdino, ydino ] = timeseries2ydmat(mdateTB, nansum(volC(:,ind_dino),2));
[xdino ydino_ml ] = timeseries2ydmat(mdateTB, ml_analyzedTB);

% extract biovolume and carbon for each class
for i=1:length(class2useTB)
    BIO(i).class = class2useTB(i);
    [~,BIO(i).bio ] = timeseries2ydmat(mdateTB, volB(:,i));
    [~,BIO(i).car ] = timeseries2ydmat(mdateTB, volC(:,i));    
end

clearvars i ind_cell ind_diatom ind_dino mdateTB micron_factor
%[~, cind] = sort(sum(x), 'descend'); %rank order biomass    

%% plot fraction biovolume of select species
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.08 0.04], [0.11 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum(['' num2str(year) '-05-20']); xax2=datenum(['' num2str(year) '-07-10']);     

%Fraction dinos and diatoms
subplot(2,1,1);
fx_other=(ymat-(ydino+ydiat))./ymat; %fraction not dinos or diatoms

bar(xmat, [ydino./ymat ydiat./ymat fx_other], 0.5, 'stack');
ax = get(gca);
cat = ax.Children;

cstr = [ [220 220 220]/255; [110 110 110]/255; [0 0 0]/255]; %black/dk grey/lt grey
for ii = 1:length(cat)
    set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
end

datetick('x', 3, 'keeplimits')
xlim([xax1 xax2])
ylim([0;1])
set(gca,'xticklabel',{}, 'fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel({'Fraction';'of biomass'}, 'fontsize', 11, 'fontname', 'arial','fontweight','bold')
h=legend('dinoflagellates','diatoms','other cell-derived');
set(h,'Position',[0.810763891876882 0.890190973968452 0.166666663678673 0.0651041649204368]);
hold on

%total cell-derived biovolume
subplot(2,1,2);
plot(xmat,ymat./ymat_ml,'k.-','linewidth', 1);
hold on
datetick('x', 3, 'keeplimits')
xlim([xax1 xax2])
set(gca,'xgrid','on',...
    'fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Carbon (\mug L^{-1})', 'fontsize', 11, 'fontname', 'arial','fontweight','bold')
hold all

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/FxBiovolume_IFCB_Explo_' num2str(year) '.tif']);
hold off

