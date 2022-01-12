%% Plot biomass composition from classifier
clear;
yr=2019; xax1=datenum('2019-07-20'); xax2=datenum('2019-08-20'); %USER enter plot time interval
%yr=2021; xax1=datenum('2021-06-28'); xax2=datenum('2021-09-26'); %USER enter plot time interval

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
filepath = '/Users/afischer/MATLAB/';
load([filepath 'bloom-baby-bloom/IFCB-Data/Shimada/class/summary_biovol_allTB' num2str(yr) ''],...
    'filelistTB','class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB')

%%%% find lat lon coordinate of each file
load([filepath 'NOAA/Shimada/Data/IFCB_Lat_Lon_coordinates_2019'],'L');
lat=NaN*mdateTB; lon=NaN*mdateTB;
for i=1:length(filelistTB)
    idxheader=strfind(L.headerfile,filelistTB(i));
    idx=find(not(cellfun('isempty',idxheader)));    
    lat(i)=L.Lat_dd(idx);
    lon(i)=L.Lon_dd(idx);
end
clearvars filelistTB idxheader idx i L;

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

dino = (ugCml(:,ind_dino));
diat = (ugCml(:,ind_diatom));
nano = (ugCml(:,ind_nano));
otherphyto = (ugCml(:,ind_otherphyto));
phytoTotal = sum(ugCml(:,ind_phyto),2);

fx_dino=dino./phytoTotal;
fx_diat=diat./phytoTotal;
fx_nano=nano./phytoTotal; 
fx_otherphyto=otherphyto./phytoTotal;

%% plot
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.04], [0.08 0.25]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1);
h = bar(mdateTB,[fx_dino fx_diat fx_otherphyto fx_nano],'stack','Barwidth',4);
c=brewermap(23,'Spectral');
    col=[c(1:9,:);c(12:23,:);[.8 .8 .8];[.1 .1 .1]];
%     col_dino=[brewermap(10,'PiYG');flipud(brewermap(7,'YlOrBr'))];
%     col_diat=[brewermap(7,'YlGn');brewermap(7,'Blues');brewermap(5,'Purples')];
%     col=[col_dino(1:2,:);col_dino(4:5,:);col_dino(11:12,:);col_dino(14,:);...
%         col_dino(16:17,:);col_diat(2,:);col_diat(4,:);col_diat(6:7,:);...
%         col_diat(9:10,:);col_diat(12:13,:);col_diat(14,:);col_diat(18,:);...
%         col_diat(19,:);[.6 .6 .6];[.8 .8 .8];[.1 .1 .1]];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end  
    
    ylabel('Fx total Carbon','fontsize',12);
    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    
    lh=legend([label_dino;label_diatom;label_otherphyto;label_nano]);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.25 hp(2)+.04 hp(3) hp(4)]; hold on    
    title(num2str(yr));
subplot(2,1,2);
fx_Tdino=sum(dino,2)./phytoTotal;
fx_Tdiat=sum(diat,2)./phytoTotal;
ratio=fx_Tdino./fx_Tdiat;

plot(mdateTB,smooth(ratio,20),'k-');
set(gca,'ylim',[0 2],'xlim',[xax1 xax2])
yline(1,'--');
datetick('x', 'mm/dd', 'keeplimits');    
ylabel('Dinos:Diatoms Carbon','fontsize',12);
 
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/Shimada/Figs/FxCarbonBiomass_Shimada_class_' num2str(yr) '.tif']);
hold off
