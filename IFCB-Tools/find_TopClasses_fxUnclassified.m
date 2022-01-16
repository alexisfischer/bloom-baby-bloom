% Use MC files to find who is representing the biomass to determine which classes should be used in classifier
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

CCS=0;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/IFCB-Data/';

if CCS==1
    load([filepath 'Shimada/manual/class_eqdiam_biovol_manual_2019'])
    outdir=[filepath 'Shimada/manual/'];
    num=34;
else
    load([filepath 'BuddInlet/manual/class_eqdiam_biovol_manual_2021'])
    outdir=[filepath 'BuddInlet/manual/'];    
    num=20;
end

% concatenate biovolume for each class in each sample
volB=NaN*ones(length(BiEq),length(class2use_manual)); %preset biovolume matrix
ind_diatom = get_diatom_ind_PNW(class2use_manual);
for i=1:length(class2use_manual)
    for j=1:length(BiEq)     
        idx=find([BiEq(j).class]==i); %find indices of a particular class
        b=sum(BiEq(j).biovol(idx)); %match and sum biovolume
        volB(j,i)=b./BiEq(j).ml_analyzed; %convert to um^3/mL
    end
end

% Exclude nonliving
volB(:,get_nonliving_ind_PNW(class2use_manual))=NaN;

clearvars i j idx b note1 note2 ind_diatom

%% find files with <60% of biomass annotated
% and remove those files from top classses estimate
sampletotal=repmat(nansum(volB,2),1,size(volB,2));
idx=(strcmp('unclassified',class2use_manual));
un=1-volB(:,idx)./sampletotal(:,idx); 
filename={BiEq.filename}';
idx=(un<.6);
filename_unclassified=filename(idx);

volB(idx,:)=[]; sampletotal(idx,:)=[];

%% find highest biomass cells
fxC_all=volB./sampletotal;
classtotal=sum(volB,1);
[~,idx]=maxk(classtotal,num); %find top biomass classes
fxC=fxC_all(:,idx);
class=class2use_manual(idx);

%remove select classes
idx=find(ismember(class,{'unclassified' 'Unid_pointed_Dino'...
    'Unid_rounded_Dino' 'Flagellate_mix' 'Heterocapsa'}));
class(idx)=[];

% add select classes
new={'Dinophysis' 'D_acuminata' 'D_acuta' 'D_caudata' 'D_fortii' ...
    'D_norvegica' 'D_odiosa' 'D_parva' 'D_rotundata' 'D_tripos'...
    'Pn_large_narrow' 'Pn_large_wide' 'Pn_small' 'Pn_parasite' 'Pseudo-nitzschia'...
    'Thalassiosira_chain' 'Thalassiosira_single'...
    'Chaetoceros_chain' 'Chaetoceros_pennate' 'Chaetoceros_single'};
class=[class new];

if CCS==1
    idx=find(ismember(class,{'Pseudo-nitzschia' 'Pn_parasite'}));
    class(idx)=[];
    class(get_zoop_ind_PNW(class))=[]; %remove zooplankton
    class{end+1}='Gymnodinium';   
    class{end+1}='Cerataulina';   
else
    class{end+1}='Mesodinium';
    class{end+1}='Cryptophyte';
end
class2use=unique(class);
class2use=(sort(class2use))';

save([outdir 'TopClasses'],'class2use');
