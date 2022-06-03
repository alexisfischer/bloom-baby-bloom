%% find top classes that correspond to specific latitudinal gradients
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%% Shimada 2019 and 2021
% load in lat lon coordinates
I19=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2019']);
I21=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2021']);
dtI=[I19.dtI;I21.dtI]; latI=[I19.latI;I21.latI]; lonI=[I19.lonI;I21.lonI];
filelistTB=[I19.filelistTB;I21.filelistTB];

% load in IFCB manual files
load([filepath 'IFCB-Data/Shimada/manual/count_class_manual'],'class2use','classcount','filelist','matdate','ml_analyzed')
cellsmli=classcount./ml_analyzed; %convert to cells/mL
filelisti=cellfun(@(X) X(1:end-4),({filelist.name})','Uniform',0);

% match data with lat lon coordinates
[filelist,ia,ib]=intersect(filelisti,filelistTB);
dt=dtI(ib); lat=latI(ib); lon=lonI(ib); 
cellsml=cellsmli(ia,:);

clearvars filelisti classcount cellsmli latI lonI filelistTB ia ib I19 I21 dtI ml_analyzed matdate

%% class manipulation
% exclude files with >th fx left unannotated
th=.1;
total=sum(cellsml,2);
fx_un=cellsml(:,1)./total;
idx=find(fx_un>th);
dt(idx)=[]; filelist(idx)=[]; lat(idx)=[]; lon(idx)=[]; cellsml(idx,:)=[]; 

% exlude nonliving data and select classes
cellsml(:,get_class_ind(class2use,'nonliving',filepath))=NaN;
cellsml(:,get_class_ind(class2use,'zooplankton',filepath))=NaN;
cellsml(:,get_class_ind(class2use,'larvae',filepath))=NaN;
cellsml(:,ismember(class2use,{'unclassified' 'Dinophyceae_pointed'...
    'Pseudo-nitzschia_external_parasite' 'Euglenoids'...
    'Chaetoceros_external_pennate' 'Dinophyceae_round' 'flagellate'...
    'Heterocapsa_triquetra' 'ciliate' 'centric' }))=NaN; 

% merge select classes
id1=ismember(class2use,{'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
        'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
        'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'});
id2=ismember(class2use,{'Dinophysis'});
val=sum(cellsml(:,id1),2); cellsml(:,id2)=sum([cellsml(:,id2),val],2); cellsml(:,id1)=NaN;

id1=ismember(class2use,{'Pseudo-nitzschia_large_narrow' 'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'});
id2=ismember(class2use,{'Pseudo-nitzschia'});
val=sum(cellsml(:,id1),2); cellsml(:,id2)=sum([cellsml(:,id2),val],2); cellsml(:,id1)=NaN;

clearvars id1 id2 val idx th fx_un total

%% Find top classes for each latitude region
% split into 4 equal sized regions
n=4;
d=(max(lat)-min(lat))./n;
for i=1:n
    latmin=max(lat)-i*d;
    latmax=max(lat)-(i-1)*d;
    region(i).latmin=latmin;
    region(i).latmax=latmax;
    region(i).idx=find(lat>=latmin & lat<latmax);
    region(i).label=['' num2str(round(region(i).latmin,1)) '-' num2str(round(region(i).latmax,1)) '^oN'];
    region(i).MCnum=length(region(i).idx);  
end

% find top 30 classes
th=30;
for i=1:length(region)
    B=cellsml(region(i).idx,:);
    classtotal=sum(B,1);
    [~,idx]=maxk(classtotal,th); %find top biomass classes
    region(i).topclass=(class2use(idx))';
    region(i).cellsml=(classtotal(idx))';
end

% find total and intersection
total=[region.topclass];
total=total(:);
class=unique(total);
for i=1:length(region)
    [~,idx,~]=intersect(class,region(i).topclass);
    classzero=zeros(size(class));
    classzero(idx)=1;
    region(i).class=classzero;
end

% reorder in highest to lowest classes
[classtotal,idx]=sort(sum([region.class],2),'descend');
class=class(idx);
for i=1:length(region)
    region(i).class=region(i).class(idx);
end

% find classes present in at least 2 regions
% idx=find(classtotal>=2);
% TopClasses=class(idx);
save([filepath 'NOAA/Shimada/Data/TopClasses_CCS'],'class');

clearvars n d B i idx latmin latmax

%%

figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');   
bar([region.MCnum],'Barwidth',.5,'linestyle','none'); hold on
set(gca,'xtick',1:length([region.MCnum]),...
    'xticklabel', {region.label},'tickdir','out'); hold on
ylabel('Number of annotated files')

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/ShimadaAnnotatedFiles.png']);
hold off 


%% plot
[~,class_label ] = get_class_ind(class,'all', filepath);

figure('Units','inches','Position',[1 1 10 5],'PaperPositionMode','auto');   
b=bar([region.class],'stacked','Barwidth',1,'linestyle','none'); hold on
set(gca,'ycolor','k','ytick',[],'xtick', 1:length(class_label),...
    'xticklabel', class_label,'tickdir','out'); hold on
ylabel(['Present in top ' num2str(th) ' classes of region'])
legend(b,{region.label},'Location','eastoutside');

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/TopClasses_CCS.png']);
hold off 


%% biovolume
% yr=[2019,2021];
% for i=1:length(yr)
%     % extract biovolume from manual files
%     load([filepath 'IFCB-Data/Shimada/manual/class_eqdiam_biovol_manual_' num2str(yr(i)) ''],'BiEq','class2use_manual')
%     mdate=[BiEq.matdate]'; filelist=({BiEq.filename})'; filelist=cellfun(@(X) X(1:end-4),filelist,'Uniform',0);
%     
%     volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
%     for k=1:length(class2use_manual)
%         for j=1:length(BiEq)
%             idx=find([BiEq(j).class]==k); %find indices of a particular class
%             b=sum(BiEq(j).biovol(idx)); %match and sum biovolume
%             volB(j,k)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
%         end
%     end
% 
%     % match data with lat lon coordinates
%     I=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada' num2str(yr(i)) '']);
%     [~,ia,ib]=intersect(filelist,I.filelistTB);
%     M(i).yr=yr(i);    
%     M(i).dt=I.dtI(ib);  
%     M(i).filelist=I.filelistTB(ib);     
%     M(i).lat=I.latI(ib); 
%     M(i).lon=I.lonI(ib); 
%     M(i).volB=volB(ia,:);
% 
% end
% 
% lat=[M(1).lat;M(2).lat];
% lon=[M(1).lon;M(2).lon];
% filelist=[M(1).filelist;M(2).filelist];
% dt=[M(1).dt;M(2).dt];
% volB=[M(1).volB;M(2).volB];
% clearvars M i yr  I ia ib idx j k mdate BiEq b

