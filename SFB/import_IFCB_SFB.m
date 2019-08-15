%import and format 2017-2019 IFCB data from SFB cruises

filepath = '~/MATLAB/bloom-baby-bloom/SFB/';

% (1) merge 3 yrs of IFCB biovolume files 
%[filelist,matdate,ml_analyzed,BiEq]=merge_BiEq_3yrsIFCB(filepath,2017:2019);

% (2) bin ESD data  and match with lat lon coordinates
[B,Bi] = format_IFCB_SFBcoordinates([filepath 'Data/summary_biovol_2017-2019'],[filepath 'Data/parameters'],[filepath 'Data/']);

