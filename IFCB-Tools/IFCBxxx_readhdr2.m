function [ hdr ] = IFCBxxx_readhdr2( fullfilename )
%import IFCBxxx series header file as separate text lines, parse to get
%target values and return them in structure (hdr)
% 
% Jun2022 - Alexis Fischer modified to spit out FileComments and the runType was fixed
%
t = importdata(fullfilename,'', 150);
%remove temporary file if read from URL
if exist('status', 'var'), delete(filestr); end;
ii = strmatch('runTime:', t);
    
if ~isempty(ii)
    linestr = char(t(ii));  
    colonpos = findstr(':', linestr);
    hdr.runtime = str2num(linestr(colonpos(1)+1:end));
    ii = strmatch('inhibitTime:', t);
    linestr = char(t(ii));  
    colonpos = findstr(':', linestr);
    hdr.inhibittime = str2num(linestr(colonpos(1)+1:end));
else
    ii = strmatch('run time', t);
    linestr = char(t(ii));  
    eqpos = findstr('=', linestr);
    spos = findstr('s', linestr);
    hdr.runtime = str2num(linestr(eqpos(1)+1:spos(1)-1));
    hdr.inhibittime = str2num(linestr(eqpos(2)+1:spos(2)-1));
end
ii=strmatch('runType:',t);
if ~isempty(ii(2))
    linestr = char(t(ii(2)));
    hdr.runtype=regexprep(linestr,'runType: ','');
end
ii = strmatch('FileComment:', t);
if ~isempty(ii)
    linestr = char(t(ii));
    colonpos = findstr(':', linestr);
    hdr.filecomment = linestr(colonpos(1)+1:end);
end
end


