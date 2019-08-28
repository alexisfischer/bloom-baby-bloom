%% extract carbon for ACIDD data
clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

filepath = '~/MATLAB/bloom-baby-bloom/ACIDD2017/Data/IFCB_summary/manual/';
load([filepath 'count_biovol_manual']);

%%%% Convert Biovolume (cubic microns/cell) to carbonml (picograms/cell)
[ind_diatom,~] = get_diatom_ind_CA(class2use,class2use); %select all classified cells
[cellC] = biovol2carbon(classbiovol,ind_diatom); 
carbonml=NaN*cellC;
for i=1:length(cellC)
    carbonml(i,:)=.001*(cellC(i,:)./ml_analyzed(i)); %convert from pg/cell to pg/mL to ug/L 
end  

clearvars i ind_diatom notes

%%
note1='carbonml: ug/L';
note2='classcount: cells';
note3='classbiovol: um^3';

save([filepath 'count_biovol_carbon_manual'],'matdate','filelist','ml_analyzed',...
    'class2use','carbonml','classcount','classbiovol','note1','note2','note3');
