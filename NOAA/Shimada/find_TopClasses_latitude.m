%% find top classes that correspond to specific latitudinal gradients
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

% do this for UCSC and OSU

yr=[2019,2021];
for i=1:length(yr)
    % extract biovolume from manual files
    load([filepath 'IFCB-Data/Shimada/manual/class_eqdiam_biovol_manual_' num2str(yr(i)) ''],'BiEq','class2use_manual')
    mdate=[BiEq.matdate]'; filelist=({BiEq.filename})'; filelist=cellfun(@(X) X(1:end-4),filelist,'Uniform',0);
    
    volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
    for k=1:length(class2use_manual)
        for j=1:length(BiEq)
            idx=find([BiEq(j).class]==k); %find indices of a particular class
            b=sum(BiEq(j).biovol(idx)); %match and sum biovolume
            volB(j,k)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
        end
    end
    volB(:,get_class_ind(class2use_manual,'nonliving',filepath))=NaN; % Exclude nonliving

    % match data with lat lon coordinates
    I=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada' num2str(yr(i)) '']);
    [~,ia,ib]=intersect(filelist,I.filelistTB);
    M(i).yr=yr(i);    
    M(i).dt=I.dtI(ib);  
    M(i).filelist=I.filelistTB(ib);     
    M(i).lat=I.latI(ib); 
    M(i).lon=I.lonI(ib); 
    M(i).volB=volB(ia,:);

end

lat=[M(1).lat;M(2).lat];
lon=[M(1).lon;M(2).lon];
filelist=[M(1).filelist;M(2).filelist];
dt=[M(1).dt;M(2).dt];
volB=[M(1).volB;M(2).volB];
clearvars M i yr  I ia ib idx j k mdate BiEq b

%% exclude files with >10% left unannotated
th=.1;
total=nansum(volB,2);
fx_un=volB(:,1)./total;
idx=find(fx_un>th);
dt(idx)=[]; filelist(idx)=[]; lat(idx)=[]; lon(idx)=[]; total(idx)=[]; volB(idx,:)=[]; 
clearvars idx th fx_un

%% split into 4 equal sized regions
n=4;
d=(max(lat)-min(lat))./n;
for i=1:n
    latmin=max(lat)-i*d;
    latmax=max(lat)-(i-1)*d;
    region(i).latmin=latmin;
    region(i).latmax=latmax;
    region(i).idx=find(lat>=latmin & lat<latmax);
    region(i).label=['' num2str(round(region(i).latmin,1)) '-' num2str(round(region(i).latmax,1)) '^oN'];
end

%% find highest biomass classes to select if it goes in classifier
%remove select classes
idx=find(ismember(class2use_manual,{'unclassified' 'Dinophyceae_pointed'...
    'Pseudo-nitzschia_external_parasite' 'Euglenoids'...
    'Chaetoceros_external_pennate' 'Dinophyceae_round' 'flagellate'...
    'Heterocapsa_triquetra' 'ciliate' 'centric' }));
class2use_manual(idx)=[]; volB(:,idx)=[]; 
idx=get_class_ind(class2use_manual,'zooplankton',filepath); %remove zooplankton
class2use_manual(idx)=[]; volB(:,idx)=[]; 
idx=get_class_ind(class2use_manual,'larvae',filepath); %remove larvae
class2use_manual(idx)=[]; volB(:,idx)=[]; 

%merge select classes
idx=ismember(class2use_manual,{'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
        'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
        'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'});
class2use_manual(idx)={'Dinophysis'};

idx=ismember(class2use_manual,{'Pseudo-nitzschia' 'Pseudo-nitzschia_large_narrow' ...
    'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'});
class2use_manual(idx)={'Pseudo-nitzschia'};

%%
th=30;
for i=1:length(region)
    B=volB(region(i).idx,:);
    classtotal=sum(B,1);
    [~,idx]=maxk(classtotal,th); %find top biomass classes
    region(i).topclass=(class2use_manual(idx))';
    region(i).volB=(classtotal(idx))';
end

%% find total and intersection
total=[region.topclass];
total=total(:);

class=unique(total);
for i=1:length(region)
    [~,idx,~]=intersect(class,region(i).topclass);
    classzero=zeros(size(class));
    classzero(idx)=1;
    region(i).class=classzero;
end

%reorder in highest to lowest classes
[classtotal,idx]=sort(sum([region.class],2),'descend');
class=class(idx);
for i=1:length(region)
    region(i).class=region(i).class(idx);
end

%% classes present in at least 2 regions
idx=find(classtotal>=2);
TopClasses=class(idx);
save([filepath 'NOAA/Shimada/Data/TopClasses_CCS'],'TopClasses');

%% plot
[~,class_label ] = get_class_ind(class,'all', filepath);

figure('Units','inches','Position',[1 1 10 5],'PaperPositionMode','auto');   
b=bar([region.class],'stacked','Barwidth',1,'linestyle','none'); hold on
set(gca,'ycolor','k','ytick',[],'xtick', 1:length(class_label), 'xticklabel', class_label); hold on
ylabel(['Present in top ' num2str(th) ' classes of region'])
legend(b,region(1).label,region(2).label,region(3).label,region(4).label,'Location','eastoutside');

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/TopClasses_CCS.png']);
hold off 

