function [data] = extract_specific_IFCB_data(filepath,class2useTB,classbiovolTB,classcountTB,ml_analyzedTB,target,dataformat)
% Extracts correct data format ('carbonml' 'biovolml' 'cellsml) for target
% data (either a classifier class or a grouping, like 'diatom')
%
% %Example Inputs
% filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
% target= 'Akashiwo'; %'diatom' 'all' 'dinoflagellate' 'unclassified' 'otherphyto' 'nonliving' 'nanoplankton' 'zooplankton' 'larvae'
% dataformat='cellsml'; %'carbonml' 'biovolml' 'cellsml';
% class2useTB
% classbiovolTB
% classcountTB
% ml_analyzedTB

% find index
idx=(strcmp(target, class2useTB));

if ~any(idx,'all')
   [idx,~] = get_class_ind(class2useTB,target,filepath);
end

% find associated data
if strcmp(dataformat,'carbonml') % Use Carbon (pgC/ml)
    [ind_diatom,~] = get_class_ind(class2useTB,'diatom',filepath);
    [pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
    ugCml=NaN*pgCcell;
    for i=1:length(pgCcell)
        ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
    end  
    data = sum(ugCml(:,idx),2);

elseif strcmp(dataformat,'biovolcell') %Use Biovolume (cubic microns/cell)
    data = sum(classbiovolTB(:,idx),2)./ml_analyzedTB;

elseif strcmp(dataformat,'cellsml')
    data = sum(classcountTB(:,idx),2)./ml_analyzedTB;    
        
end