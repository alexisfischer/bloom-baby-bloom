function[filelist,matdate,ml_analyzed,BiEq]=merge_BiEq_3yrsIFCB(filepath,yrrange)
% merge 3 yrs of IFCB biovolume files 

%Example inputs
%filepath = '~/MATLAB/bloom-baby-bloom/SFB/';
%yrrange=2017:2019;

%load in data
for i=1:length(yrrange)
    S(i)=load([filepath 'Data/IFCB_summary/eqdiam_biovol_' num2str(yrrange(i))],'BiEq'); 
end

% filelist and matdate
filename={S(1).BiEq.filename}'; %start with yr1
mdate=[S(1).BiEq.matdate]';
ml_analyzed=[S(1).BiEq.ml_analyzed]';
for i=2:length(yrrange) %add rest of the years
    filename=[filename;{S(i).BiEq.filename}'];
    mdate=[mdate;[S(i).BiEq.matdate]'];
    ml_analyzed=[ml_analyzed;[S(i).BiEq.ml_analyzed]'];
end

%remove _fea_v2.csv from end
filelist=strings(length(filename),1);
for i=1:length(filename)
    val=char(filename(i));
    filelist(i)=convertCharsToStrings(val(1:24));
end

%remove hh:mm:ss from date
matdate=datenum(datestr(datenum(mdate),'dd-mmm-yyyy'));

%merge eqdiam and biovol
for i=1:length(S(1).BiEq)
    BiEq(i).eqdiam=[S(1).BiEq(i).eqdiam];
    BiEq(i).biovol=[S(1).BiEq(i).biovol];
end

for i=1:length(S(2).BiEq)
    BiEq(i+length(S(1).BiEq)).eqdiam=[S(2).BiEq(i).eqdiam];
    BiEq(i+length(S(1).BiEq)).biovol=[S(2).BiEq(i).biovol];
end

for i=1:length(S(3).BiEq)
    BiEq(i+length(S(1).BiEq)+length(S(2).BiEq)).eqdiam=[S(3).BiEq(i).eqdiam];
    BiEq(i+length(S(1).BiEq)+length(S(2).BiEq)).biovol=[S(3).BiEq(i).biovol];
end

clearvars S i mdate val filename

%% convert biovolume to carbon 

for i=1:length(BiEq)
    biovol=BiEq(i).biovol;
    cellC = NaN(size(biovol));  
    cellC = vol2C_nondiatom(biovol);
    %idx=find(biovol>=3000); %not including the large diatom component right now
    %cellC(idx) = vol2C_lgdiatom(biovol(idx));
    BiEq(i).carbon=cellC; %picograms per cell
end

%%
save([filepath 'Data/summary_biovol_' num2str(yrrange(1)) '-' num2str(yrrange(end))],...
    'filelist','matdate','ml_analyzed','BiEq');

end




