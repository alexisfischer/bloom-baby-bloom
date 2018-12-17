%function [ ] = biovol_eqdiam_summary_manual(resultpath,out_dir,roibasepath,feapath_base)
% Gives you a summary file of counts and biovolume from manually classified results
%  Alexis D. Fischer, University of California - Santa Cruz, April 2018

 resultpath = 'F:\IFCB113\manual\'; %USER
 out_dir = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\IFCB_summary\manual\';
 roibasepath = 'F:\IFCB113\data\'; %USER
 feapath_base = 'F:\IFCB113\features\XXXX\'; %USER
micron_factor = 1/3.4; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([resultpath 'D*.mat']);

%calculate date
matdate = IFCB_file2date({filelist.name});

load([resultpath filelist(1).name]) %read first file to get classes
numclass = length(class2use_manual);
class2use_manual_first = class2use_manual;
classcount = NaN(length(filelist),numclass);  %initialize output
classbiovol = classcount;
ml_analyzed = NaN(length(filelist),1);

for filecount = 1:length(filelist)

    filename = filelist(filecount).name;
    disp(filename)
    hdrname = [roibasepath filesep filename(2:5) filesep filename(1:9) filesep regexprep(filename, 'mat', 'hdr')]; 
    ml_analyzed(filecount) = IFCB_volume_analyzed(hdrname);
     
    load([resultpath filename])
    yr = str2num(filename(2:5)); % changed this from filename(7:10)
    clear targets
   feapath = regexprep(feapath_base, 'XXXX', filename(2:5)); % changed this from filename(7:10)
    [~,file] = fileparts(filename);
    feastruct = importdata([feapath file '_fea_v2.csv'], ',');
    ind = strmatch('Biovolume', feastruct.colheaders);
    biovol = feastruct.data(:,ind);
    ind = strmatch('roi_number', feastruct.colheaders);
    targets = feastruct.data(:,ind);
    ind = strmatch('EquivDiameter', feastruct.colheaders);
    eqdiam = feastruct.data(:,ind);
        
    % preferentially take manual files over class files

    list=nan*[targets,targets,targets];    
    for i=1:length(classlist)
        for j=1:length(targets)
            if targets(j) == classlist(i,1)
                list(j,1)=classlist(i,1);      
                list(j,2)=classlist(i,2);      
                list(j,3)=classlist(i,3);      
            else
            end
        end
    end

    count=nan*(list(:,1));
    for i=1:length(list)
        if ~isnan(list(i,2))
            count(i) = list(i,2);  
        else
            count(i) = list(i,3);
        end
    end
    
    BiEq(filecount).filename=filename;
    BiEq(filecount).matdate=matdate(filecount);
    BiEq(filecount).ml_analyzed=ml_analyzed(filecount);    
    BiEq(filecount).targets=list(:,1);
    BiEq(filecount).count=count;
    BiEq(filecount).eqdiam=eqdiam*micron_factor;
    BiEq(filecount).biovol=biovol*micron_factor.^3;
    
    clear rois count eqdiam biovol;
end

class2use = class2use_manual_first';
datestr = date; datestr = regexprep(datestr,'-','');
note1 = 'Biovolume in units of cubed micrometers';
note2= 'Equivalent spherical diameter in micrometers';
save([out_dir 'count_eqdiam_biovol_manual_' datestr], 'BiEq', 'class2use', 'note1', 'note2')

disp('Summary cell count file stored here:')
disp([resultpath 'count_biovol_manual_' datestr])

%end
