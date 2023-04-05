function [PNcount_above_optthresh,PNcount,opt_cell1,opt_cell2,opt_cell3,opt_cell4,wta_cell1,wta_cell2,wta_cell3,wta_cell4]=TBclass_summarize_PN_width(classfile,feafile)
%function [PNcount_above_optthresh,PNcount,PNwidth_above_optthresh,PNwidth,opt_cell1,opt_cell2,opt_cell3,opt_cell4,wta_cell1,wta_cell2,wta_cell3,wta_cell4]=TBclass_summarize_PN_width(classfile,feafile)
%
% Alexis D. Fischer, NOAA, April 2023
%%
% % % %Example inputs for testing
% i=122; 
% classfile=classfiles{i}
% feafile=feafiles{i};

load(classfile,'roinum','TBclass','TBclass_above_threshold')

if strcmp(char(classfile(45:51)),'IFCB777') 
    micron_factor=1/3.7695;
elseif strcmp(char(classfile(45:51)),'IFCB117') 
    micron_factor=1/3.8617;
elseif strcmp(char(classfile(45:51)),'IFCB150') 
    micron_factor=1/3.8149;
end

feastruct = importdata(feafile);
ind = strcmp('MinorAxisLength',feastruct.textdata);
targets.MinorAxisLength = feastruct.data(:,ind)*micron_factor;

opt_cell1=targets.MinorAxisLength(contains(TBclass_above_threshold,'1cell'))';
opt_cell2=targets.MinorAxisLength(contains(TBclass_above_threshold,'2cell'))';
opt_cell3=targets.MinorAxisLength(contains(TBclass_above_threshold,'3cell'))';
opt_cell4=targets.MinorAxisLength(contains(TBclass_above_threshold,'4cell'))';
PNcount_above_optthresh=size(opt_cell1,2)+2*size(opt_cell2,2)+3*size(opt_cell3,2)+4*size(opt_cell4,2);

wta_cell1=targets.MinorAxisLength(contains(TBclass,'1cell'))';
wta_cell2=targets.MinorAxisLength(contains(TBclass,'2cell'))';
wta_cell3=targets.MinorAxisLength(contains(TBclass,'3cell'))';
wta_cell4=targets.MinorAxisLength(contains(TBclass,'4cell'))';
PNcount=size(wta_cell1,2)+2*size(wta_cell2,2)+3*size(wta_cell3,2)+4*size(wta_cell4,2);

%%
end

