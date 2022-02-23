function [ ] = summarize_cells_from_manual( manualpath, datapath, summary_dir,yr)
%function [ ] = summarize_cells_from_manual( manualpath, datapath, summary_dir)
%
% summarizes class results for a series of manual annotation files (as saved by startMC)
%  Alexis D. Fischer, University of California - Santa Cruz, January 2019
%
%Example inputs:
% manualpath = 'F:\IFCB104\manual\'; %manual file location
% datapath = 'F:\IFCB104\data\'; %where to access data (hdr files)
% summary_dir = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SCW\Data\IFCB_summary\manual\'; %where summary file goes

%make sure input paths end with filesep
if ~isequal(manualpath(end), filesep)
    manualpath = [manualpath filesep];
end
if ~isequal(datapath(end), filesep)
    datapath = [datapath filesep];
end

filelist = dir([manualpath 'D*.mat']);

%calculate date
matdate = IFCB_file2date({filelist.name});

load([manualpath filelist(1).name]) %read first file to get classes
numclass = length(class2use_manual);
class2use_manual_first = class2use_manual;
classcount = NaN(length(filelist),numclass);  %initialize output
ml_analyzed = NaN(length(filelist),1);
for filecount = 1:length(filelist)
    filename = filelist(filecount).name;
    disp(filename)
    hdrname = [datapath filesep filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
    ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);
     
    load([manualpath filename])
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
            classcount(filecount,classnum) = size(find(classlist(:,2) == classnum | (isnan(classlist(:,2)) & classlist(:,3) == classnum)),1);
            %classcount(filecount,classnum) = size(find(classlist(:,2) == classnum),1); %manual only
    end
    clear class2use_manual class2use_auto class2use_sub* classlist
end

class2use = class2use_manual_first;

save([summary_dir 'count_class_manual_' yr], 'matdate', 'ml_analyzed', 'classcount', 'filelist', 'class2use')

disp('Summary cell count file stored here:')
disp([summary_dir 'count_class_manual_' yr])

return

