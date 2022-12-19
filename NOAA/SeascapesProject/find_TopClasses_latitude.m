%% find top classes that correspond to specific latitudinal gradients
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%USER
r=0; %order classes alphabetically
%r=1; %order classes by presence

un=.1; % fx biomass left unclassified
n=4; % # of regions
top=30; % # of top classes per region

%%%% Shimada 2019 and 2021
% load in lat lon coordinates
I19=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2019']);
I21=load([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2021']);
dtI=[I19.dtI;I21.dtI]; latI=[I19.latI;I21.latI]; lonI=[I19.lonI;I21.lonI];
filelistTB=[I19.filelistTB;I21.filelistTB];

% load in IFCB manual files 
load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],'class2use','classcount','classbiovol','filelist','ml_analyzed')
cellsmli=classcount./ml_analyzed; %convert to cells/mL
bvmli=classbiovol./ml_analyzed; %convert to biovol/mL
filelisti=cellfun(@(X) X(1:end-4),({filelist.name})','Uniform',0);

% exclude files with >un fx left unannotated
total=sum(cellsmli,2); fx_un=cellsmli(:,1)./total; idx=find(fx_un>un);
filelisti(idx)=[]; cellsmli(idx,:)=[]; bvmli(idx,:)=[]; 

% match data with lat lon coordinates
[filelistS,ia,ib]=intersect(filelisti,filelistTB);
dt=dtI(ib); latS=latI(ib); lonS=lonI(ib); 
cellsmlS=cellsmli(ia,:); bvmlS=bvmli(ia,:);
clearvars idx fx_un filelisti total classcount classbiovol filelist cellsmli bvmli dt latI lonI filelistTB ia ib I19 I21 dtI ml_analyzed 

%%%% UCSC 
load([filepath 'IFCB-Data/SCW/manual/count_class_biovol_manual'],'classcount','classbiovol','filelist','ml_analyzed')
cellsmli=classcount./ml_analyzed; %convert to cells/mL
bvmli=classbiovol./ml_analyzed; %convert to biovol/mL
filelistU=cellfun(@(X) X(1:end-4),({filelist.name})','Uniform',0);

% exclude files with >un fx left unannotated
total=sum(bvmli,2); fx_un=bvmli(:,1)./total; idx=find(fx_un>un);
filelistU(idx)=[]; cellsmli(idx,:)=[]; bvmli(idx,:)=[]; 

[idxSC] = convert_classnum_UCSC2NWFSC(1:width(cellsmli)); %convert classes
cellsmlU=NaN*ones(length(cellsmli),width(class2use));
bvmlU=cellsmlU;
for i=1:length(class2use)
    idx=idxSC==i;
    cellsmlU(:,i)=sum(cellsmli(:,idx),2);
    bvmlU(:,i)=sum(bvmli(:,idx),2);
end

latU=36.96149*ones(size(filelistU));
lonU=-122.02187*ones(size(filelistU));
clearvars classcount classbiovol cellsmli bvmli idx i idxSC ml_analyzed filelist fx_un total

%%%% merge
bvml=[bvmlU;bvmlS];
cellsml=[cellsmlU;cellsmlS];
lat=[latU;latS];
lon=[lonU;lonS];
filelist=[filelistU;filelistS];

[ia,~]=find(cellsml==Inf);
filelist(ia)=[]; cellsml(ia,:)=[]; bvml(ia,:)=[]; lat(ia)=[]; lon(ia)=[];
clearvars bvmlU bvmlS cellsmlU cellsmlS latU latS lonU lonS filelistU filelistS ia

%% class manipulation
% exlude nonliving data and select classes
id1=get_class_ind(class2use,'nonliving',filepath);
id2=get_class_ind(class2use,'zooplankton',filepath);
id3=get_class_ind(class2use,'larvae',filepath);
IDX=unique([id1;id2;id3]);
cellsml(:,IDX)=NaN; bvml(:,IDX)=NaN;

% merge select classes
id1=ismember(class2use,{'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
        'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
        'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'});
id2=ismember(class2use,{'Dinophysis'});
val=sum(cellsml(:,id1),2); cellsml(:,id2)=sum([cellsml(:,id2),val],2); cellsml(:,id1)=NaN;
val=sum(bvml(:,id1),2); bvml(:,id2)=sum([bvml(:,id2),val],2); bvml(:,id1)=NaN;

id1=ismember(class2use,{'Pseudo-nitzschia_large_narrow' 'Pseudo-nitzschia_large_wide' 'Pseudo-nitzschia_small'});
id2=ismember(class2use,{'Pseudo-nitzschia'});
val=sum(cellsml(:,id1),2); cellsml(:,id2)=sum([cellsml(:,id2),val],2); cellsml(:,id1)=NaN;
val=sum(bvml(:,id1),2); bvml(:,id2)=sum([bvml(:,id2),val],2); bvml(:,id1)=NaN;

clearvars id1 id2 id3 id4 IDX val idx fx_un total

%% Find top classes for each latitude region
irem=find(ismember(class2use,{'unclassified' 'centric' 'flagellate' ...
    'Dinophyceae_pointed' 'Dinophyceae_round' 'Chaetoceros_external_pennate' 'Pseudo-nitzschia_external_pennate'}));

d=(max(lat)-min(lat))./n;
for i=1:n
    latmin=min(lat)+(i-1)*d;
    latmax=min(lat)+i*d;
    region(i).latmin=latmin;
    region(i).latmax=latmax;
    region(i).idx=find(lat>=latmin & lat<latmax);
    region(i).label=['' num2str(round(region(i).latmin,1)) '-' num2str(round(region(i).latmax,1)) '^oN'];
    region(i).MCnum=length(region(i).idx);  
    region(i).uncell=nansum(cellsml(region(i).idx,irem));
    region(i).unbiovol=nansum(bvml(region(i).idx,irem));
end

%%
%set unclassified to NaNs
cellsml(:,irem)=NaN; bvml(:,irem)=NaN;

% find top classes
for i=1:length(region)
    C=cellsml(region(i).idx,:); %by cells
    classtotalC=sum(C,1);    
    [~,idx]=maxk(classtotalC,top); %find top biomass classes
    region(i).topregionclassC=(class2use(idx))';
    region(i).cellsml=(classtotalC(idx))';
    region(i).fxtotalcells=nansum(region(i).cellsml)./nansum([classtotalC,region(i).uncell]);    
   
    B=bvml(region(i).idx,:); %by biovolume
    classtotalB=sum(B,1);      
    [~,idx]=maxk(classtotalB,top); %find top biomass classes
    region(i).topregionclassB=(class2use(idx))';
    region(i).bvml=(classtotalB(idx))';  
    region(i).fxtotalbiovol=nansum(region(i).bvml)./nansum([classtotalB,region(i).unbiovol]);      
end

%%%% find total and intersection
totalC=[region.topregionclassC]; totalC=totalC(:); classC=unique(totalC);
totalB=[region.topregionclassB]; totalB=totalB(:); classB=unique(totalB);
for i=1:length(region)
    [~,idx,~]=intersect(classC,region(i).topregionclassC);
    classzero=zeros(size(classC));
    classzero(idx)=1;
    region(i).idxC=classzero;

    [~,idx,~]=intersect(classB,region(i).topregionclassB);
    classzero=zeros(size(classB));
    classzero(idx)=1;
    region(i).idxB=classzero;    
end

if r==1 % reorder in highest to lowest classes
    [classtotalC,idxC]=sort(sum([region.idxC],2),'descend'); classC=classC(idxC);
    [classtotalB,idxB]=sort(sum([region.idxB],2),'descend'); classB=classB(idxB);
    for i=1:length(region)
        region(i).idxC=region(i).idxC(idxC);
        region(i).topclassC=classC;        
        region(i).idxB=region(i).idxB(idxB);  
        region(i).topclassB=classB;            
    end
else
end

%%%% find different classes in by cells and by biovolume
classBC=intersect(classC,classB);
[c,ic]=setdiff(classC,classBC);
[b,ib]=setdiff(classB,classBC);

save([filepath 'NOAA/Shimada/Data/topclasses_bylatitude_CCS'],'classC','classB','classBC');

clearvars dt classtotalC classtotalB filelist ic ib bvml cellsml d B i idx latmin latmax classzero lat lon totalB totalC C idxB idxC

%% plot # annotated files
figure('Units','inches','Position',[1 1 3 3],'PaperPositionMode','auto');   
bar([region.MCnum],'Barwidth',.5,'linestyle','none'); hold on
set(gca,'xtick',1:length([region.MCnum]),...
    'xticklabel', {region.label},'tickdir','out'); hold on
ylabel(['# files with >' num2str(100*(1-un)) '% rois annotated'])

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/ShimadaAnnotatedFiles.png']);
hold off 

%% plot top classes using cells/ml
[~,class_label ] = get_class_ind(classC,'all', filepath);

figure('Units','inches','Position',[1 1 8 3],'PaperPositionMode','auto');   
plot(1:length(class_label),[1*region(1).idxC 2*region(2).idxC 3*region(3).idxC 4*region(4).idxC],'*'); hold on
set(gca,'ycolor','k','ylim',[.8 4.2],'ytick',1:length(region),'yticklabel', {region.label},...
    'xlim',[0 (length(class_label)+1)],'xtick', 1:length(class_label),'xticklabel', class_label,'tickdir','out'); hold on
title(['Top CCS classes that comprise a mean of ' num2str(round(mean(100*[region.fxtotalcells]),0)) '% fluorescing cells/sample'])

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/topclass_CCS_cellcount.png']);
hold off 

%% plot top classes using biovolume
[~,class_label ] = get_class_ind(classB,'all', filepath);

figure('Units','inches','Position',[1 1 8 3],'PaperPositionMode','auto');   
plot(1:length(class_label),[1*region(1).idxB 2*region(2).idxB 3*region(3).idxB 4*region(4).idxB],'*'); hold on
set(gca,'ycolor','k','ylim',[.8 4.2],'ytick',1:length(region),'yticklabel', {region.label},...
    'xlim',[0 (length(class_label)+1)],'xtick', 1:length(class_label),'xticklabel', class_label,'tickdir','out'); hold on
title(['Top CCS classes that comprise a mean of ' num2str(round(mean(100*[region.fxtotalbiovol]),0)) '% fluorescing biovolume/sample'])

% set figure parameters
print(gcf,'-dpng','-r100',[filepath 'NOAA/Shimada/Figs/topclass_CCS_biovolume.png']);
hold off 

