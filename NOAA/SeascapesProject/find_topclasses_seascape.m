%% Find topclasses for each seascape
% create a summary file for each seascape
clear;

filepath='~/Documents/MATLAB/bloom-baby-bloom/'; 
addpath(genpath(filepath)); 
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); 
load([filepath 'NOAA/SeascapesProject/Data/SeascapeSummary_NOAA-OSU-UCSC'],'SS');

%manualpath = 'D:\general\classifier\manual_merged\'; % manual annotation file location
%result_path = 'D:\general\classifier\summary\'; 
manualpath = '~/Downloads/test_manual/'; % manual annotation file location
result_path = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/SeascapesProject/Data/'; 

filelist = dir([manualpath 'D*.mat']);
load([manualpath filelist(1).name],'class2use_manual','classlist') %read first file to get classes
numclass = length(class2use_manual);
class2use_manual_first = class2use_manual; 

topSS=[SS.ss];
%for i=1:length(topSS) %create summary file for each SS
    i=2
    filelistSS=SS(i).filename;
    
    classcount = NaN(length(filelistSS),numclass);  %initialize output
    ml_analyzed = NaN(length(filelistSS),1); %initialize output

    %%
    for filecount = 1:length(filelistSS)   
        filename = (filelistSS(filecount));        
        %disp(filename)
        % need OSU raw data files to get ml_analyzed    
        %     hdrname = [datapath filesep filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
        %     ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);    
        ml_analyzed(filecount)=5; %temporary fix
        
        [~,~,idx]=intersect(filename,({filelist.name})');        
        if ~isempty(idx)
            disp(['seascape present for ' filename '!']);
            load([manualpath char(filename)])
            if ~isequal(class2use_manual, class2use_manual_first)
                [t,ii] = min([length(class2use_manual_first), length(class2use_manual)]);
                if ~isequal(class2use_manual(1:t), class2use_manual_first(1:t))
                    disp('class2use_manual does not match previous files!!!')
                    keyboard
                else
                    if ii == 1, class2use_manual_first = class2use_manual; end %new longest list
                end
            end
            for classnum = 1:numclass
                    %classcount(filecount,classnum) = size(find(classlist(:,2) == classnum | (isnan(classlist(:,2)) & classlist(:,3) == classnum)),1);
                    classcount(filecount,classnum) = size(find(classlist(:,2) == classnum),1); %manual only
            end
            clear class2use_manual classlist

        else
            %disp(['no seascape for ' filename ''])
        end
        
    end
    
    class2use = class2use_manual_first;

save([summary_dir 'count_class_manual'], 'matdate','ml_analyzed','classcount','filelist','class2use','runtype','filecomment')

disp('Summary cell count file stored here:')
disp([summary_dir 'count_class_manual'])