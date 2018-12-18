%% prepare 15 Mar 2018, st 18 USGS cruise data for Cloern and Jassby

%% Biovolume data
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));

%%%% Step 1: Load in data
filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/'; 
load([filepath 'Data/IFCB_summary/manual/count_eqdiam_biovol_manual_17Dec2018'],...
    'BiEq','class2use','note1','note2');

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/'; 
load([filepath 'Data/IFCB_summary/manual/count_biovol_manual_17Dec2018'],...
    'classcount','classbiovol','ml_analyzed','matdate','filelist');

%%%% Step 2: Convert Biovolume to Carbon
% convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
[ ind_diatom, ~ ] = get_diatom_ind_CA( class2use, class2use );
[ cellC ] = biovol2carbon(classbiovol, ind_diatom ); 

% convert from per cell to per mL
volC=zeros(size(cellC));
volB=volC;
cellmL=volC;
for i=1:length(cellC) 
    volC(i,:)=cellC(i,:)./ml_analyzed(i);
    volB(i,:)=classbiovol(i,:)./ml_analyzed(i);    
    cellmL(i,:)=classcount(i,:)./ml_analyzed(i);    
end
    
volC=volC./1000; %convert from pg/mL to ug/L 

%%%% Step 3: Only select specific data
for i=1:length(filelist)
    if filelist(i).name == 'D20180315T175935_IFCB113.mat'
        ww=i;
    end
    if filelist(i).name == 'D20180315T182329_IFCB113.mat'
        nt=i;
    end
end

targets=BiEq(nt).targets;
count=BiEq(nt).count;
eqdiam=BiEq(nt).eqdiam;
biovol=BiEq(nt).biovol;
ml=ml_analyzed(ww,:);
carbon=volC(ww,:);

numclass=(1:length(class2use))';
class=cell(size(count));
for i=1:length(count)
    for j=1:length(numclass)
        if numclass(j) == count(i)            
            class(i)=class2use(j);      
        else
        end
    end
end
