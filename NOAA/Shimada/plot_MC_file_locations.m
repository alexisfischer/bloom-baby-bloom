% Plot location of manual files on a map
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

filepath = '/Users/afischer/MATLAB/NOAA/Shimada/';
load('/Users/afischer/MATLAB/bloom-baby-bloom/IFCB-Data/Shimada/manual/class_eqdiam_biovol_manual_2019','BiEq','class2use_manual')
load([filepath 'Data/IFCB_Lat_Lon_coordinates_2019'],'L');

%%%% find lat lon coordinate of each file
mdate=[BiEq.matdate]';
filelist=({BiEq.filename})'; filelist=cellfun(@(X) X(1:end-4),filelist,'Uniform',0);

lat=NaN*mdate; lon=NaN*mdate;
for i=1:length(filelist)
    idx=(strcmp(filelist(i), L.headerfile));      
    lat(i)=L.Lat_dd(idx);
    lon(i)=L.Lon_dd(idx);
end

%%%% extract biovolume
volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
ind_diatom = get_diatom_ind_PNW(class2use_manual);
for i=1:length(class2use_manual)
    for j=1:length(BiEq)
        idx=find([BiEq(j).class]==i); %find indices of a particular class
        b=nansum(BiEq(j).biovol(idx)); %match and sum biovolume
        volB(j,i)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
    end
end

%%%% find and exclude files that have not been fully classified
sampletotal=repmat(nansum(volB,2),1,size(volB,2));
total=log10(sampletotal(:,1));
fxC_all=volB./sampletotal;
idx=find(fxC_all(:,1)>.7);
mdate(idx)=[]; filelist(idx)=[]; lat(idx)=[]; lon(idx)=[]; total(idx)=[]; volB(idx,:)=[];
clearvars ind_diatom b i BiEq idx L j fxC_all sampletotal volB filelist class2use_manual

MC.lat=lat; MC.lon=lon;
save([filepath 'Data/MC_filelocations'],'MC');


%% plot biovolume
states=load([filepath 'Data/USwestcoast_pol']);
load([filepath 'Data/coast_CCS','coast']);

data=total; cax=[5 7]; label={'Log Biovolume';'(um^3/mL)'}; varname='Biovol';

% set mask for data
ii=~isnan(data+lat+lon); lon=lon(ii); lat=lat(ii); data=data(ii);  
[LON,LAT] = meshgrid(-127:.1:-123.8, 34.3:.1:48.6);
DATA = griddata(lon,lat',data,LON,LAT);

clearvars isin lonR lonL latR latL ii i idx data land;

% plot
figure('Units','inches','Position',[1 1 2.5 5],'PaperPositionMode','auto'); 
pcolor(LON,LAT,DATA); shading flat; hold on; 

plot(lon,lat,'k.','Markersize',5); hold on

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
print(gcf,'-dpng','-r300',[filepath 'Figs/MappedIFCBShimada_MC_filelocations.png']);
hold off 
