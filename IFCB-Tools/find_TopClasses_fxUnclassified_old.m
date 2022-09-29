% Use MC files to find who is representing the biomass to determine which classes should be used in classifier
clear;

CCS=1;

%filepath = '~/Documents/MATLAB/bloom-baby-bloom/IFCB-Data/';
% addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
% addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\')); % add new data to search path
addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\')); % add new data to search path

if CCS==1
%    load([filepath 'IFCB-Data/Shimada/manual/class_eqdiam_biovol_manual_2019'])
    load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'])
    outdir=[filepath 'IFCB-Data/Shimada/manual/'];
    num=35;
else
    load([filepath 'IFCB-Data/BuddInlet/manual/class_eqdiam_biovol_manual_2021'])
    outdir=[filepath 'IFCB-Data/BuddInlet/manual/'];    
    num=25;
end

%% concatenate biovolume for each class in each sample
volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
for i=1:length(class2use_manual)
    for j=1:length(BiEq)     
        idx=find([BiEq(j).class]==i); %find indices of a particular class
        b=sum(BiEq(j).biovol(idx)); %match and sum biovolume
        volB(j,i)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
    end
end

% Exclude nonliving
volB(:,get_class_ind(class2use_manual,'nonliving',filepath))=NaN;

clearvars i j idx b note1 note2 

% find files with <60% of biomass annotated
% and remove those files from top classses estimate
sampletotal=repmat(nansum(volB,2),1,size(volB,2));
idx=(strcmp('unclassified',class2use_manual));
un=1-volB(:,idx)./sampletotal(:,idx); 
filename={BiEq.filename}';
idx=(un<.6);
filename_unclassified=filename(idx);

volB(idx,:)=[]; sampletotal(idx,:)=[];

% find highest biomass cells
fxC_all=volB./sampletotal;
classtotal=sum(volB,1);
[~,idx]=maxk(classtotal,num); %find top biomass classes
fxC=fxC_all(:,idx);
class=class2use_manual(idx);

%remove select classes
idx=find(ismember(class,{'unclassified' 'Dinophyceae_pointed'...
    'Pseudo-nitzschia_external_parasite'...
    'Chaetoceros_external_pennate' 'Dinophyceae_round' 'flagellate'...
    'Heterocapsa_triquetra' 'ciliate' 'centric' 'nanoplankton'}));
class(idx)=[];

% add select classes
new={'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
    'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
    'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'...
    'Pseudo-nitzschia_large_narrow' 'Pseudo-nitzschia_large_wide' ...
    'Pseudo-nitzschia_small' 'Pseudo-nitzschia'...
    'Thalassiosira_chain' 'Thalassiosira_single'...
    'Chaetoceros_chain' 'Chaetoceros_single'};
class=[class new];

if CCS==1
    idx=find(ismember(class,{'Pseudo-nitzschia'}));
    class(idx)=[];
    class(get_class_ind(class,'zooplankton',filepath))=[]; %remove zooplankton
else
    class{end+1}='Mesodinium';
end
class2use=unique(class);
class2use=(sort(class2use))';

save([outdir 'TopClasses'],'class2use');
