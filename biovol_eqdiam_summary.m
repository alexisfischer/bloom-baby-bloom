function [ ] = biovol_eqdiam_summary(out_dir,roibasepath,feapath_base)
% Gives you a summary file of counts and biovolume from feature files
%  Alexis D. Fischer, University of California - Santa Cruz, April 2018

% out_dir = 'C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\SFB\Data\IFCB_summary\';
% roibasepath = 'F:\IFCB113\data\'; %USER
% feapath_base = 'F:\IFCB113\features\2019\'; %USER

micron_factor = 1/3.4; %USER PUT YOUR OWN microns per pixel conversion
filelist = dir([feapath_base 'D*.csv']);
yr = feapath_base(21:24);
matdate = IFCB_file2date({filelist.name}); %calculate date
ml_analyzed = NaN(length(filelist),1);

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

    BiEq(i).filename=filename;
    BiEq(i).matdate=matdate(i);
    BiEq(i).ml_analyzed=ml_analyzed(i);    
    BiEq(i).roi=roi;
    BiEq(i).eqdiam=eqdiam*micron_factor;
    BiEq(i).biovol=biovol*micron_factor.^3;    
    
    clearvars roi eqdiam biovol hdrname feastruct ind;
end

note1 = 'Biovolume: cubed micrometers';
note2= 'Equivalent spherical diameter: micrometers';
save([out_dir 'eqdiam_biovol_' yr], 'BiEq', 'note1', 'note2')

disp('Summary file stored here:')
disp([out_dir 'eqiam_biovol_' yr])

end
