function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% function [ n, class_all, varargin ] = handle_train_maxn_subsample( class2use, maxn, class_all, varargin )
% ifcb-analysis; function called by compile_train_features*; 
%
% This is a function that replaces ‘handle_train_maxn’ within 
% compile_train_features. If number of images exceed the USER defined maxn, 
% this randomly removes excess images from the training set so that images 
% are balanced across NWFSC, UCSC, and OSU. 
%   Alexis D. Fischer, NOAA NWFSC, June 2022

% Example inputs for testing
% varargin{1}=fea_all;
% varargin{2}=files_all;
% varargin{3}=roinum;

id1=find(endsWith(varargin{2},'IFCB777') | endsWith(varargin{2},'IFCB117') | endsWith(varargin{2},'IFCB150')); %find Shimada files
id2=find(endsWith(varargin{2},'IFCB104')); %find UCSC files from      
id3=find(endsWith(varargin{2},'IFCB122')); %find OSU files         
n=NaN*ones(length(class2use),1);
for i = 1:length(class2use)
    j = find(class_all == i);
    n(i) = length(j); %total number of images
    n2del = round(n(i)-maxn,-1); %number of images that need to be deleted

    if n2del > 0 %if your images exceeds the maxn...
        ind_1=(intersect(id1,j)); %find file subset that are NWFSC and that class
        ind_2=(intersect(id2,j)); %find file subset that are UCSC and that class
        ind_3=(intersect(id3,j)); %find file subset that are OSU and that class
        d1=length(ind_1)-round(maxn*.34,0);
        d2=length(ind_2)-round(maxn*.33,0);
        d3=length(ind_3)-round(maxn*.33,0);
        
        if d1<0 && d2<0 %don't delete any from NWC or UCSC
            shuffle_ind = randperm(length(ind_3));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=[ind_3(shuffle_ind)]; 
            disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') only delete OSU'])
        elseif d1<0 && d3<0 %don't delete any from NWC or OSU
            shuffle_ind = randperm(length(ind_2));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=[ind_2(shuffle_ind)];   
            disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') only delete UCSC'])                
        elseif d2<0 && d3<0 %don't delete any from UCSC or OSU
            shuffle_ind = randperm(length(ind_1));
            shuffle_ind = shuffle_ind(1:n2del);
            idx2del=[ind_1(shuffle_ind)];    
            disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') only delete NWFSC'])    

        elseif d1<0 %don't delete any from NWFSC
            val=abs(round(d1./2,0));           
            if d2<val %only delete any from UCSC
                shuffle_ind = randperm(length(ind_2));
                shuffle_ind2 = shuffle_ind(1:d2);
                shuffle_ind = randperm(length(ind_3));
                shuffle_ind3 = shuffle_ind(1:(n2del-d2)); 
                idx2del=[ind_2(shuffle_ind2);ind_3(shuffle_ind3)];  
            elseif d3<val %only delete any from OSU              
                shuffle_ind = randperm(length(ind_3));
                shuffle_ind3 = shuffle_ind(1:d3);
                shuffle_ind = randperm(length(ind_2));
                shuffle_ind2 = shuffle_ind(1:(n2del-d3)); 
                idx2del=[ind_2(shuffle_ind2);ind_3(shuffle_ind3)];  
            else
                shuffle_ind = randperm(length(ind_2));
                shuffle_ind2 = shuffle_ind(1:(d2-val));
                shuffle_ind = randperm(length(ind_3));
                shuffle_ind3 = shuffle_ind(1:(d3-val)); 
                idx2del=[ind_2(shuffle_ind2);ind_3(shuffle_ind3)];  
            end
                disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') delete from UCSC and OSU'])                
            
        elseif d2<0 %don't delete any from UCSC
            val=abs(round(d2./2,0));
            if d1<val %only delete d1 from NWFSC
                shuffle_ind = randperm(length(ind_1));
                shuffle_ind1 = shuffle_ind(1:d1);
                shuffle_ind = randperm(length(ind_3));
                shuffle_ind3 = shuffle_ind(1:(n2del-d1));
                idx2del=[ind_1(shuffle_ind1);ind_3(shuffle_ind3)];            
            elseif d3<val %only delete d3 from OSU        
                shuffle_ind = randperm(length(ind_3));
                shuffle_ind3 = shuffle_ind(1:d3);
                shuffle_ind = randperm(length(ind_1));
                shuffle_ind1 = shuffle_ind(1:(n2del-d3));
                idx2del=[ind_1(shuffle_ind1);ind_3(shuffle_ind3)];                
            else
                shuffle_ind = randperm(length(ind_1));
                shuffle_ind1 = shuffle_ind(1:(d1-val));
                shuffle_ind = randperm(length(ind_3));
                shuffle_ind3 = shuffle_ind(1:(d3-val));
                idx2del=[ind_1(shuffle_ind1);ind_3(shuffle_ind3)];   
            end
                disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') delete from NWFSC and OSU'])                 

        elseif d3<0 %don't delete any from OSU
            val=abs(round(d3./2,0));            
            if d1<val %only delete d1 from NWFSC
                shuffle_ind = randperm(length(ind_1));
                shuffle_ind1 = shuffle_ind(1:d1);                
                shuffle_ind = randperm(length(ind_2));
                shuffle_ind2 = shuffle_ind(1:(n2del-d1));
                idx2del=[ind_1(shuffle_ind1);ind_2(shuffle_ind2)];               
            elseif d2<val %only delete d2 from UCSC            
                shuffle_ind = randperm(length(ind_2));
                shuffle_ind2 = shuffle_ind(1:d2);                
                shuffle_ind = randperm(length(ind_1));
                shuffle_ind1 = shuffle_ind(1:(n2del-d2));
                idx2del=[ind_1(shuffle_ind1);ind_2(shuffle_ind2)];              
            else            
                shuffle_ind = randperm(length(ind_1));
                shuffle_ind1 = shuffle_ind(1:(d1-val));                
                shuffle_ind = randperm(length(ind_2));
                shuffle_ind2 = shuffle_ind(1:(d2-val));
                idx2del=[ind_1(shuffle_ind1);ind_2(shuffle_ind2)];   
            end
                disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') delete from NWFSC and UCSC'])   
        else
            shuffle_ind = randperm(length(ind_1));
            shuffle_ind1 = shuffle_ind(1:d1);            
            shuffle_ind = randperm(length(ind_2));
            shuffle_ind2 = shuffle_ind(1:d2);
            shuffle_ind = randperm(length(ind_3));
            shuffle_ind3 = shuffle_ind(1:d3);
            idx2del=[ind_1(shuffle_ind1);ind_2(shuffle_ind2);ind_3(shuffle_ind3)];   
            disp(['' class2use{i} ' (n2del=' num2str(n2del) ' d1=' num2str(d1) ' d2=' num2str(d2) ' d3=' num2str(d3) ') delete from NWFSC, UCSC, and OSU'])            
        end

        if diff([length(idx2del),n2del])<5
        else
            disp(['ERROR! ' class2use{i} ' idx2del=' num2str(length(idx2del)) ' n2del=' num2str(n2del) '' ])            
        end
    %    disp(num2str(length(idx2del)));
     %   disp(num2str(n2del))        ;

        class_all(idx2del) = []; %set those classes as []                  
        for vc = 1:length(varargin)
            varargin{vc}(idx2del,:) = [];
        end
        j = find(class_all == i);
        n(i) = length(j); %total number of images        
        %n(i) = maxn;
    else
        %disp(['' class2use{i} ': no extra images!'])
        
    end
    clearvars j d1 d2 d3 val idx2del ind_1 ind_2 ind_3 n2del shuffle_ind shuffle_ind1 shuffle_ind2 shuffle_ind3
end


