function [ ] = summarize_cells_from_classifier(ifcbdir, summarydir, yrrange)
%function [ ] = summarize_cells_from_classifier(ifcbdir, summarydir, yrrange)
% Inputs automatic classified results and summarizes class results for a series of classifier output files (TreeBagger)
% Alexis D. Fischer, University of California - Santa Cruz, June 2018
%
%Example inputs:
clear
ifcbdir='D:\test\';
summarydir = 'D:\Shimada\LabData\summary\';
yrrange = 2021:2022;  %one value or range (e.g., 2017:2018)

addpath(genpath(ifcbdir));
addpath(genpath(summarydir));

%check whether in directory
urlflag = 0;
if strcmp('http', ifcbdir(1:4))
    urlflag = 1;
end
%make sure input paths end with filesep
classpath_generic = [ifcbdir 'class\classXXXX_v1\']; %leave xxxx in place of 4 digit year
if ~isequal(classpath_generic(end), filesep)
    classpath_generic = [classpath_generic filesep];
end

in_dir = [ifcbdir 'data\']; %where to access data (hdr files)
if (~isequal(in_dir(end), filesep) && ~urlflag)
    in_dir = [in_dir filesep];
end

classfiles = [];
filelist = [];
for yrcount = 1:length(yrrange)
    yr = yrrange(yrcount);
    classpath = regexprep(classpath_generic, 'XXXX', num2str(yr));
    %temp = [dir([classpath 'I*.mat']); dir([classpath 'D*.mat'])];
    temp = dir([classpath 'D*.mat']);
    if ~isempty(temp)
        pathall = repmat(classpath, length(temp),1);
        temp = char(temp.name);
        classfiles = [classfiles; cellstr([pathall temp])];
        filelist = [filelist; temp(:,1:24)];
    end
    clear temp pathall classpath
end

%%
if urlflag
    hdrfiles = cellstr(strcat( in_dir, filelist, '.hdr'));
    %hdrfiles = cellstr([repmat(in_dir,length(filelist),1) filelist repmat('.hdr', length(filelist), 1)]);
else
    fsep = repmat(filesep, size(filelist,1),1);
    %determine data subdir structure
    if exist([in_dir filelist(1,:) '.hdr'], 'file') %presume all files in top level of in_dir
        hdrfiles = cellstr(strcat(in_dir, fsep, filelist, '.hdr'));   
%        hdrfiles = cellstr([repmat(in_dir,size(filelist,1),1) fsep filelist repmat('.hdr', size(filelist,1), 1)]);   
    elseif exist([in_dir filelist(1,2:5) filesep filelist(1,:) '.hdr'], 'file') %presume all files in subdir by year
        hdrfiles = cellstr(strcat(in_dir, filelist(:,2:5), fsep, filelist, '.hdr'));
        %hdrfiles = cellstr([repmat(in_dir,size(filelist,1),1) filelist(:,2:5) fsep filelist repmat('.hdr', size(filelist,1), 1)]);
    elseif exist([in_dir filelist(1,2:5) filesep filelist(1,1:9) filesep filelist(1,:) '.hdr'], 'file') %presume all files in subdir by year then day
        hdrfiles = cellstr(strcat(in_dir, filelist(:,2:5), fsep, filelist(:,1:9), fsep, filelist, '.hdr'));
        %hdrfiles = cellstr([repmat(in_dir,size(filelist,1),1) filelist(:,2:5) fsep filelist(:,1:9) fsep filelist repmat('.hdr', size(filelist,1), 1)]);
    else
        disp('First hdr file not found. Check input directory.')
        return
    end
end;
mdate = IFCB_file2date(filelist);

%presumes all class files have same class2useTB list
temp = load(classfiles{1}, 'class2useTB');
class2use = temp.class2useTB; clear temp classfilestr
classcount = NaN(length(classfiles),length(class2use));
classcount_above_optthresh = classcount;
classcount_above_adhocthresh = classcount;
num2dostr = num2str(length(classfiles));
ml_analyzed = NaN(size(classfiles));
adhocthresh = 0.5.*ones(size(class2use)); %assign all classes the same adhoc decision threshold between 0 and 1
%adhocthresh(strmatch('Karenia', class2use, 'exact')) = 0.8; %reassign value for specific class
for filecount = 1:length(classfiles)
    if ~rem(filecount,10), disp(['reading ' num2str(filecount) ' of ' num2dostr]), end;
    ml_analyzed(filecount) = IFCB_volume_analyzed(hdrfiles{filecount});
    if exist('adhocthresh', 'var'),
        [classcount(filecount,:), classcount_above_optthresh(filecount,:), classcount_above_adhocthresh(filecount,:)] = summarize_TBclass(classfiles{filecount}, adhocthresh);
    else
        [classcount(filecount,:), classcount_above_optthresh(filecount,:)] = summarize_TBclass(classfiles{filecount});
    end;
end;

if ~exist(summarydir, 'dir'),
    mkdir(summarydir)
end;

ml_analyzedTB = ml_analyzed;
mdateTB = mdate;
filelistTB = filelist;
class2useTB = class2use;
classcountTB = classcount;
classcountTB_above_optthresh = classcount_above_optthresh;

yrrangestr = num2str(yrrange(1));
if length(yrrange) > 1
    yrrangestr = [yrrangestr '_' num2str(yrrange(end))];
end

clear mdate filelist class2use classcount classcount_above_optthresh filecount yrrange yrcount yr classfiles in_dir num2dostr

if exist('adhocthresh', 'var'),
    classcountTB_above_adhocthresh = classcount_above_adhocthresh;
    save([summarydir 'summary_allTB_' yrrangestr] , 'class2useTB', 'classcountTB', 'classcountTB_above_optthresh', 'classcountTB_above_adhocthresh', 'ml_analyzedTB', 'mdateTB', 'filelistTB', 'adhocthresh', 'classpath_generic')
else
    save([summarydir 'summary_allTB_' yrrangestr] , 'class2useTB', 'classcountTB', 'classcountTB_above_optthresh', 'ml_analyzedTB', 'mdateTB', 'filelistTB', 'classpath_generic')
end

disp('Summary cell count file stored here:')
disp([summarydir 'summary_allTB_' yrrangestr])

return
% %example plotting code for all of the data (load summary file first)
% figure
% classind = 2;
% plot(mdateTB, classcountTB(:,classind)./ml_analyzedTB, '.-')
% hold on
% plot(mdateTB, classcountTB_above_optthresh(:,classind)./ml_analyzedTB, 'g.-')
% plot(mdateTB, classcountTB_above_adhocthresh(:,classind)./ml_analyzedTB, 'r.-')
% legend('All wins', 'Wins above optimal threshold', 'Wins above adhoc threshold')
% ylabel([class2useTB{classind} ', mL^{ -1}'])
% datetick('x')