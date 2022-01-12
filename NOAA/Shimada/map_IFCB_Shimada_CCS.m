%% Plot biomass composition from classifier
clear;
yr=2019;

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
filepath = '/Users/afischer/MATLAB/';
load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_biovol_allTB' num2str(yr) ''],...
    'filelistTB','class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB')

%%%% find lat lon coordinate of each file
load([filepath 'NOAA/Shimada/Data/IFCB_Lat_Lon_coordinates_2019'],'L');
lat=NaN*mdateTB; lon=NaN*mdateTB;
for i=1:length(filelistTB)
    idx=(strcmp(filelistTB(i), L.headerfile));      
    lat(i)=L.Lat_dd(idx);
    lon(i)=L.Lon_dd(idx);
end

%%%% Convert Biovolume (cubic microns/cell) to ug carbon/ml
ind_diatom = get_diatom_ind_PNW(class2useTB);
[pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
ugCml=NaN*pgCcell;
for i=1:length(pgCcell)
    ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
end  

%%%% Find fraction of each group
[ind_dino,label_dino] = get_dino_ind_PNW(class2useTB); 
[ind_diatom,label_diatom] = get_diatom_ind_PNW(class2useTB); 
[ind_nano,label_nano] = get_nano_ind_PNW(class2useTB);
[ind_otherphyto,label_otherphyto] = get_otherphyto_ind_PNW(class2useTB);
[ind_phyto,~] = get_phyto_ind_PNW(class2useTB); 

dino = sum(ugCml(:,ind_dino),2);
diat = sum(ugCml(:,ind_diatom),2);
nano = (ugCml(:,ind_nano));
otherphyto = (ugCml(:,ind_otherphyto));
phytoTotal = sum(ugCml(:,ind_phyto),2);
% 
% fx_dino=dino./phytoTotal;
% fx_diat=diat./phytoTotal;
% fx_nano=nano./phytoTotal; 
% fx_otherphyto=otherphyto./phytoTotal;

idx=(strcmp('Pseudo-nitzschia', class2useTB));
PN=classcountTB(:,idx)./ml_analyzedTB;

clearvars filelistTB idxheader idx i L ind_diatom ml_analyzedTB mdateTB class2useTB classbiovolTB classcountTB;


filepath = '~/MATLAB/NOAA/Shimada/';
states=load([filepath 'Data/USwestcoast_pol']);
load([filepath 'Data/coast_CCS','coast']);

%%%% plot underway data
%data=PN; cax=[0 30]; label={'Pseudo-nitzschia';'(cells/mL)'}; varname='PN';
data=diat; cax=[0 70]; label={'Diatoms';'(pg C/mL)'}; varname='diat';
%data=dino; cax=[0 5]; label={'Dinoflagellates';'(pg C/mL)'}; varname='dino';

% set mask for data
ii=~isnan(data+lat+lon);lon=lon(ii); lat=lat(ii); data=data(ii);  
[LON,LAT] = meshgrid(-127:.1:-123.8, 34.3:.1:48.6);
DATA = griddata(lon,lat',data,LON,LAT);

clearvars isin lonR lonL latR latL ii i idx data land;

% plot
figure('Units','inches','Position',[1 1 2.5 5],'PaperPositionMode','auto'); 
pcolor(LON,LAT,DATA); shading flat; hold on; 

plot(lon,lat,'k.','Markersize',5); hold on

% optional to plot location of MC files
% load([filepath 'Data/MC_filelocations'],'MC');
% plot(MC.lon,MC.lat,'k.','Markersize',5); hold on

fillseg(coast); dasp(42); hold on;
plot(states(:,1),states(:,2),'k'); hold on;
set(gca,'ylim',[34 49],'xlim',[-127 -120],'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

colormap(parula);  caxis(cax);    
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 12;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.9*hp(2); hp(3)=.5*hp(3); hp(4)=.6*hp(4);
    set(h,'pos',hp,'xaxisloc','top','fontsize',9); 
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dpng','-r300',[filepath 'Figs/MappedIFCBShimada' num2str(yr) '_' varname '.png']);
hold off 