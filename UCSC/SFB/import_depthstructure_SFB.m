function[M,Mi]=import_depthstructure_SFB(filename,filepath,distance)
%% import SFB salinity, density, and chlorophyll as a function of depth  
%Example inputs
% filename="/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/density_sal_depth_SFB.xlsx";
% filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
% distance='/Users/afischer/MATLAB/bloom-baby-bloom/SFB/Data/st_lat_lon_distance';

opts = spreadsheetImportOptions("NumVariables", 6);
opts.Sheet = "Sheet1";
opts.DataRange = "A3:F52897";
opts.VariableNames = ["Date", "StationNumber", "Depth", "CalculatedChlorophyll", "Salinity", "Sigmat"];
opts.SelectedVariableNames = ["Date", "StationNumber", "Depth", "CalculatedChlorophyll", "Salinity", "Sigmat"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "");
tbl = readtable(filename, opts, "UseExcel", false);
Date = tbl.Date;
StationNumber = tbl.StationNumber;
Depth = tbl.Depth;
CalculatedChlorophyll = tbl.CalculatedChlorophyll;
Salinity = tbl.Salinity;
SigmaT = tbl.Sigmat;
Date=datenum(Date);
[~,~,D19] = match_st_lat_lon(StationNumber);

% put in structure
phys=struct('dn',NaN*ones(length(Date),1)); %preallocate
for i=1:length(Date)
    phys(i).dn=Date(i);
    phys(i).st=StationNumber(i);
    phys(i).d19=D19(i);        
    phys(i).depth=Depth(i);        
    phys(i).sal=Salinity(i);    
    phys(i).chl=CalculatedChlorophyll(i);
    phys(i).sigmaT=SigmaT(i);
end

clearvars Date StationNumber D19 Salinity CalculatedChlorophyll SigmaT i Depth opts tbl filename;

%% organize by unique surveys
[C,IA,~] = unique([phys.dn],'stable');
p=struct('dn',NaN*ones(length(C),1)); %preallocate 
for i=1:length(C)
    if i<length(C)
        p(i).a=(IA(i):(IA(i+1)-1));        
        p(i).dn=datestr(C(i));
        else
        p(i).a=(IA(i):length(phys));        
        p(i).dn=datestr(C(i));        
    end
end

% organize station data into structures based on survey date
for i=1:length(p)
    p(i).st=[phys(p(i).a).st]';     
    p(i).d19=[phys(p(i).a).d19]';     
    p(i).depth=[phys(p(i).a).depth]';     
    p(i).sal=[phys(p(i).a).sal]';  
    p(i).chl=[phys(p(i).a).chl]';
    p(i).sigmaT=[phys(p(i).a).sigmaT]';  
end
p=rmfield(p,'a');

% eliminate surveys without North Bay datapoints
for i=1:length(p)
    id=isnan(p(i).d19);
    p(i).st(id)=[];
    p(i).d19(id)=[];
    p(i).depth(id)=[];  
    p(i).sal(id)=[];
    p(i).chl(id)=[];    
    p(i).sigmaT(id)=[];    
end
p(cellfun(@isempty,{p.st}))=[]; %remove empty rows

% remove all rows with only 1 station represented
del=zeros(length(p),1);
for i=1:length(p)
    val=sum(~isnan(unique(p(i).st)));
    if val>1
    else
        del(i)=i;        
    end
end
del(del==0)=[]; p(del)=[];

% make sure cruise tracks go from marine to freshwater
for i=1:length(p) 
    if p(i).d19(1) > p(i).d19(end) %flip coordinates if doesn't go from marine to freshwater
        p(i).st=flip(p(i).st);        
        p(i).d19=flip(p(i).d19);        
        p(i).depth=flip(p(i).depth);              
        p(i).sal=flip(p(i).sal);              
        p(i).chl=flip(p(i).chl);              
        p(i).sigmaT=flip(p(i).sigmaT);              
    else
    end
end

clearvars i ib ic id suisun i phys row val del id IA j C ;

%% calculate MLD and integrated salinity
for i=1:length(p)
    [ST,IA,~] = unique(p(i).st,'stable');
    p(i).st=ST;    
    p(i).salI=NaN*ST;
    p(i).chlI=NaN*ST;    
    p(i).mld1=NaN*ST;
    p(i).mld2=NaN*ST;
    p(i).maxdepth=NaN*ST;    
    
    for j=1:length(ST)
        if j<length(ST)
            ID=(IA(j):(IA(j+1)-1));          
        else
            ID=(IA(j):length(p(i).d19));      
        end        
        Depth=p(i).depth(ID);
        
    if Depth(1) > Depth(end) %flip coordinates if depth is not in ascending order
        p(i).d19=flip(p(i).d19);        
        p(i).depth(ID)=flip(p(i).depth(ID));              
        p(i).sal(ID)=flip(p(i).sal(ID));              
        p(i).chl(ID)=flip(p(i).chl(ID));              
        p(i).sigmaT(ID)=flip(p(i).sigmaT(ID)); 
        Depth=p(i).depth(ID); 
    else
    end        
        
        p(i).maxdepth(j)=max(Depth); 
        p(i).salI(j)=nanmean(p(i).sal(ID)); %integrated salinity
        p(i).chlI(j)=nanmean(p(i).chl(ID)); %integrated salinity
        diffs=[abs(diff(p(i).sigmaT(ID)));NaN];
        
        idx=find(diffs>0.03,1);
        if isempty(idx)
            p(i).mld1(j)=p(i).maxdepth(j);   
        else
            p(i).mld1(j)=Depth(idx);          
        end     

        idx=find(diffs==max(diffs),1);        
        if isempty(idx)
            p(i).mld2(j)=p(i).maxdepth(j);   
        else
            p(i).mld2(j)=Depth(idx);        
        end                  
    end
end

clearvars i j IA ID idx ST del diffs val

%% insert existing data into new structure so 20 stations to facilitate pcolor
load(distance,'d19','st'); id=find(d19>0,1); d19(1:id-1)=[]; st(1:id-1)=[];

M=struct('dn',NaN*ones(length(p),1)); %preallocate 
for i=1:length(p)
    M(i).dn=datenum(p(i).dn);
    M(i).st=st; 
    M(i).d19=d19;     
    M(i).salI=NaN*st; 
    M(i).chlI=NaN*st;     
    M(i).mld1=NaN*st;   
    M(i).mld2=NaN*st;       
    M(i).depth=NaN*st;   
end

for i=1:length(p)
    [id,~]=ismember(st,p(i).st);
    M(i).salI(id)=p(i).salI;
    M(i).chlI(id)=p(i).chlI;    
    M(i).mld1(id)=p(i).mld1; 
    M(i).mld2(id)=p(i).mld2;     
    M(i).depth(id)=p(i).maxdepth; 
end

Mi=M; % interpolate
for i=1:length(M)
    Mi(i).salI=fillmissing([M(i).salI],'movmean',5);
    Mi(i).chlI=fillmissing([M(i).chlI],'movmean',5);
    Mi(i).mld1=fillmissing([M(i).mld1],'movmean',5);
    Mi(i).mld2=fillmissing([M(i).mld2],'movmean',5);
end

clearvars d19 st i id distance p

save([filepath 'Data/integratedSal_MLD'],'M','Mi');

end
