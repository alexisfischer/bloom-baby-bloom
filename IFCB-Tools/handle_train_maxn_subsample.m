function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% ifcb-analysis; function called by compile_train_features*; 
% randomly subsample a training set to limit maximum number of cases in any one class
% removes images from SCW training set first (if available), before PNW training set
%   Alexis D. Fischer, NOAA NWFSC, September 2021

% %Example inputs for testing
% varargin{1}=fea_all;
% varargin{2}=files_all;
% varargin{3}=roinum;

for i = 1:length(class2use)
    fileID=find(endsWith(varargin{2},'IFCB104')); %find SCW files from  
    ii = find(class_all == i);
    n(i) = length(ii); %total number of images
    n2del = n(i)-maxn; %number of images that need to be deleted
   
    if n2del > 0 %if your images exceeds the maxn...
        scw_ind=(intersect(fileID,ii)); %find file subset that are SCW and that class
        s(i) = length(scw_ind); %total number of images       
        r2del=n2del-s(i); %remaining to delete from PNW
        
        if r2del > 0  %number of SCW images is less than n2del, so you also need to delete PNW images
            pnw_ind=setdiff(ii,scw_ind); %find all the files that are not SCW
            shuffle_ind = randperm(length(pnw_ind));
            shuffle_ind = shuffle_ind(1:r2del);
            idx2del=[scw_ind;pnw_ind(shuffle_ind)];       
        else %number of SCW images exceeds or is equal to n2del, so you can just delete SCW images
            shuffle_ind = randperm(s(i));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=scw_ind(shuffle_ind);
        end          
        class_all(idx2del) = []; %set those classes as []                  
        for vc = 1:length(varargin)
            varargin{vc}(idx2del,:) = [];
        end
        n(i) = maxn;
    end
end

end

