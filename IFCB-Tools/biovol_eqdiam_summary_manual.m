function [ ] = biovol_eqdiam_summary_manual(manualpath,out_dir,roibasepath,feapath_base,yr)
% Gives you a summary file of counts and biovolume from manually classified results
%  Alexis D. Fischer, University of California - Santa Cruz, April 2018

% manualpath = 'F:\IFCB113\ACIDD2017\manual\'; %USER
% out_dir = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Data\IFCB_summary\manual\';
% roibasepath = 'F:\IFCB113\ACIDD2017\data\'; %USER
% feapath_base = 'F:\IFCB113\ACIDD2017\features\2017\'; %USER
% yr='2017';

micron_factor = 1/3.4; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([feapath_base 'D*.csv']);
matdate = IFCB_file2date({filelist.name}); %calculate date
ml_analyzed = NaN(length(filelist),1);

load([manualpath filelist(1).name(1:24) '.mat'],'class2use_manual') %read first file to get classes

for i = 1:length(filelist)

    filename = filelist(i).name;
    disp(filename)
    hdrname = [roibasepath filename(2:5) filesep filename(1:9) filesep regexprep(filename,'_fea_v2.csv','.hdr')];
    ml_analyzed(i) = IFCB_volume_analyzed(hdrname);
     
    [~,file] = fileparts(filename);
    feastruct = importdata([feapath_base file '.csv'], ',');
    ind = strmatch('Biovolume', feastruct.colheaders);
    biovol = feastruct.data(:,ind);
    ind = strmatch('roi_number', feastruct.colheaders);
    roi = feastruct.data(:,ind);
    ind = strmatch('EquivDiameter', feastruct.colheaders);
    eqdiam = feastruct.data(:,ind);
        
        clearvars ind hdrname file

    load([manualpath filename(1:24) '.mat'],'classlist')
    
    list=nan*[roi,roi,roi];
    for ii=1:length(classlist)
        for j=1:length(roi)
            if roi(j) == classlist(ii,1)
                list(j,1)=classlist(ii,1);      
                list(j,2)=classlist(ii,2);      
                list(j,3)=classlist(ii,3);      
            else
            end
        end
    end
    
    % preferentially take manual files over class files
    class=nan*(list(:,1));
    for ii=1:length(list)
        if ~isnan(list(ii,2))
            class(ii) = list(ii,2);  
        else
            class(ii) = list(ii,3);
        end
    end
    
    BiEq(i).filename=[filename(1:24) '.mat'];
    BiEq(i).matdate=matdate(i);
    BiEq(i).ml_analyzed=ml_analyzed(i);    
    BiEq(i).roi=list(:,1);
    BiEq(i).class=class;
    BiEq(i).eqdiam=eqdiam*micron_factor;
    BiEq(i).biovol=biovol*micron_factor.^3;
    
    clearvars roi filename class eqdiam biovol;
end


%%
note1 = 'Biovolume: cubed micrometers';
note2= 'Equivalent spherical diameter: micrometers';
save([out_dir 'class_eqdiam_biovol_manual_' yr], 'BiEq', 'class2use_manual', 'note1', 'note2')

disp('Summary file stored here:')
disp([manualpath 'class_biovol_manual_' yr])

end
