%% find top classes that correspond to specific latitudinal gradients
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

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

clearvars M i yr  I ia ib idx j k mdate volB BiEq b filelist

%%
% find highest biomass cells
fxC_all=volB./sampletotal;
classtotal=sum(volB,1);
[~,idx]=maxk(classtotal,num); %find top biomass classes
fxC=fxC_all(:,idx);
class=class2use_manual(idx);
