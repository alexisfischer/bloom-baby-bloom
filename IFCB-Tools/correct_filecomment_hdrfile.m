%undo BS_trigger from D20220518T190328_IFCB150 through  D20220520T163514_IFCB150

clear
basepath='~/Downloads/D20220518/';
filelist = dir([basepath 'D*.hdr']);
filename = ({filelist.name})';

dtIFCB=cellfun(@(x) x(2:16),filename,'UniformOutput',false);
dt=datetime(cell2mat(dtIFCB),"InputFormat","yyyyMMdd'T'HHmmss");
dt.Format='yyyy-MM-dd HH:mm:ss'  

error_idx=find(dt>datetime(2022,05,18,19,03,28) & dt<datetime(2022,05,20,16,35,14))
%%
%for i=1:length(error_idx)
i=6
    hdrname = ([basepath filename{i}])    
    hdr=IFCBxxx_readhdr2(hdrname)
    filecomment=hdr.filecomment; 
    tf=ismember('BS_trigger', filecomment);
  %  if tf


