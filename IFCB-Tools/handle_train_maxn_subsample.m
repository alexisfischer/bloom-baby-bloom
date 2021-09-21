function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% function [ n, class_all, varargin ] = handle_train_maxn( class2use, maxn, class_all, varargin )
% ifcb-analysis; function called by compile_train_features*; randomly subsample a training set to limit maximum number of cases in any
% one class
%   Alexis D. Fischer, NOAA NWFSC, September 2021

fileID=find(endsWith(files_all,'IFCB104')); %only select SCW files

for i = 1:length(class2use)
    i=104
    class2use(i)
    ii = find(class_all == i);
    n(i) = length(ii) %total number of images
    n2del = n(i)-maxn %number of images that need to be deleted
    
    if n2del > 0 %if your images exceeds the maxn...
        scw_ind=intersect(fileID,ii) %find file subset that are SCW and that class
        scw_total=length(scw_ind)      
            
        if n2del > scw_total %if files to delete exceeeds all the SCW files
            
            n2delnext=n2del-scw_total %remaining number to delete            
            class_all(scw_ind) = []; %set those classes as []
            idx = find(class_all == i);
            shuffle_ind = randperm(length(idx))
            shuffle_ind = shuffle_ind(1:n2delnext)
            class_all(ii(shuffle_ind)) = []; %set those classes as [] 
            
        else  %if files to delete are equal to or fewer than the SCW files              
            shuffle_ind = randperm(length(scw_ind)) %shuffle SCW files to delete
            shuffle_ind = shuffle_ind(1:n2del)
            class_all(ii(shuffle_ind)) = []; %set those classes as []            
        end
        
        for vc = 1:length(varargin)
            varargin{vc}(ii(shuffle_ind),:) = [];
        end
        n(i) = maxn;
    end
end

end

