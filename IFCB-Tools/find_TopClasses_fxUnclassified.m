% Use MC files to find who is representing the biomass to determine which classes should be used in classifier
clear;

CCS=1;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path

% filepath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\';
% addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\ifcb-analysis\')); % add new data to search path
% addpath(genpath('C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\')); % add new data to search path

if CCS==1
%    load([filepath 'IFCB-Data/Shimada/manual/class_eqdiam_biovol_manual_2019'])
    load([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'])
    outdir=[filepath 'IFCB-Data/Shimada/manual/'];
    num=39;
else
    load([filepath 'IFCB-Data/BuddInlet/manual/count_class_biovol_manual'])
    outdir=[filepath 'IFCB-Data/BuddInlet/manual/'];    
    num=60;
end

% Exclude nonliving
classbiovol(:,get_class_ind(class2use,'nonliving',filepath))=NaN;

% find files with <60% of biomass annotated
% and remove those files from top classses estimate
sampletotal=repmat(nansum(classbiovol,2),1,size(classbiovol,2));
idx=(strcmp('unclassified',class2use));
un=1-classbiovol(:,idx)./sampletotal(:,idx); 
filename={filelist.name}';
idx=(un<.6);
filename_unclassified=filename(idx);

classbiovol(idx,:)=[]; sampletotal(idx,:)=[];

% find highest biomass cells
fxC_all=classbiovol./sampletotal;
classtotal=sum(classbiovol,1);
[~,idx]=maxk(classtotal,num); %find top biomass classes
fxC=fxC_all(:,idx);
class=class2use(idx);

fxCC=classtotal./(nansum(classtotal));
fxCC=fxCC(idx);

%class=class';
%fxCC=fxCC';
% remove select classes
idx=find(ismember(class,{'unclassified' 'Dinophyceae_pointed'...
    'Pseudo-nitzschia_external_parasite'...
    'Chaetoceros_external_pennate' 'Dinophyceae_round' 'flagellate'...
    'ciliate' 'zooplankton'}));
class(idx)=[];
fxCC(idx)=[];

% add select classes
new={'Dinophysis' 'Dinophysis_acuminata' 'Dinophysis_acuta' 'Dinophysis_caudata'...
    'Dinophysis_fortii' 'Dinophysis_norvegica' 'Dinophysis_odiosa' ...
    'Dinophysis_parva' 'Dinophysis_rotundata' 'Dinophysis_tripos'...
    'Pseudo-nitzschia_large_narrow' 'Pseudo-nitzschia_large_wide' ...
    'Pseudo-nitzschia_small' 'Pseudo-nitzschia'...
    'Thalassiosira_chain' 'Thalassiosira_single'...
    'Chaetoceros_chain' 'Chaetoceros_single'};
class=[class new];
%%
if CCS==1
    idx=find(ismember(class,{'Pseudo-nitzschia'}));
    class(idx)=[]; fxCC(idx)=[];
    class(get_class_ind(class,'zooplankton',filepath))=[]; %remove zooplankton
else
    class{end+1}='Mesodinium';
end
[class2use,idx]=unique(class,'stable');

%%
%class2use=(sort(class2use))';

save([outdir 'TopClasses'],'class2use');
