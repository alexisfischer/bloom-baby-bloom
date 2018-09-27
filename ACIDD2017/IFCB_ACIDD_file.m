%Sasha Kramer
%20180925
%UCSB IGPMS

in_dir_base='F:\IFCB113\ACIDD2017\datai\2017\';

daydir = dir([in_dir_base 'D*']);
bins = [];
in_dir = [];
out_dir_blob = [];
for ii = 1:length(daydir)

end
%%%IFCB file processing for Alexis
cd 'F:\IFCB113\ACIDD2017\data\2017\D20171217\' %insert your folder path here

%Load all of your IFCB files into a structure
filein = dir('*.hdr'); %put your file extension after the period (.txt, .hdr)
nfiles = length(filein);

%Now you should have a structure with all of the IFCB files
%The spreadsheet shows me there should be 177 samples (matches dashboard)
%I'm assuming the files are sorted in time order based on file name
remove = [1:3,51:56,69:78,85:90,97:98,111:122,147:156]';

filein(remove) = [];
%This leaves the files you want in the directory - you can load them as desired
