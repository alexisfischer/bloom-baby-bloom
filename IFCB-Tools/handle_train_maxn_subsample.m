function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% ifcb-analysis; function called by compile_train_features*; 
%
% This is a function that replaces ‘handle_train_maxn’ within 
% compile_train_features. If number of images exceed the USER defined maxn, 
% this randomly removes excess images from UCSC training set first. If the 
% number of images still exceeds maxn, then it randomly removes excess 
% images from the NWFSC set.
%   Alexis D. Fischer, NOAA NWFSC, September 2021

% %Example inputs for testing
varargin{1}=fea_all;
varargin{2}=files_all;
varargin{3}=roinum;
    idN=find(endsWith(varargin{2},'IFCB777') | endsWith(varargin{2},'IFCB117') | endsWith(varargin{2},'IFCB150')); %find Shimada files
    idU=find(endsWith(varargin{2},'IFCB104')); %find UCSC files from      
    idO=find(endsWith(varargin{2},'IFCB122')); %find OSU files         

n=NaN*ones(length(class2use),1);
for i = 1:length(class2use)
    i=13
    j = find(class_all == i);
    n(i) = length(j) %total number of images
    n2del = n(i)-maxn %number of images that need to be deleted
   
    if n2del > 0 %if your images exceeds the maxn...
        NWC_ind=(intersect(idN,j)); %find file subset that are NWFSC and that class
        UCSC_ind=(intersect(idU,j)); %find file subset that are UCSC and that class
        OSU_ind=(intersect(idO,j)); %find file subset that are OSU and that class
        
        %find fx of NOAA files
        fxN=length(NWC_ind)./n(i)
        fxU=length(UCSC_ind)./n(i)
        fxO=length(OSU_ind)./n(i)
        
        s(i) = length(UCSC_ind); %total number of images       
        r2del=n2del-s(i); %remaining to delete from PNW
        
        if r2del > 0  %number of UCSC images is less than n2del, so you also need to delete PNW images
            pnw_ind=setdiff(j,UCSC_ind); %find all the files that are not UCSC
            shuffle_ind = randperm(length(pnw_ind));
            shuffle_ind = shuffle_ind(1:r2del);
            idx2del=[UCSC_ind;pnw_ind(shuffle_ind)];       
        else %number of UCSC images exceeds or is equal to n2del, so you can just delete UCSC images
            shuffle_ind = randperm(s(i));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=UCSC_ind(shuffle_ind);
        end          
        class_all(idx2del) = []; %set those classes as []                  
        for vc = 1:length(varargin)
            varargin{vc}(idx2del,:) = [];
        end
        n(i) = maxn;
    end
end

end

