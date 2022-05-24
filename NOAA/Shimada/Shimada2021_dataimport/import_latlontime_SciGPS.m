%% import lat lon and timestamps from 2021 Shimada cruise GPS data
% The ship records GPS data every second and writes it to a text file for each day. 
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, May 2022

clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/GPS - Science GP170/'; %USER
outpath=[filepath 'NOAA/Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
LATdir=dir([indir '*_SciGPS-Derived-DD-Lat-Message.RAW.log']);
LONdir=dir([indir '*_SciGPS-Derived-DD-Lon-Message.RAW.log']);

DT=[];
LAT=[];
LON=[];
for i=1:length(LATdir)
    namelat=LATdir(i).name;
    namelon=LONdir(i).name;    
    filelat = [indir namelat];
    filelon = [indir namelon];    
    disp(namelat);
    date=datetime(namelat(1:8),'InputFormat','yyyyMMdd');

    if date < datetime(2021,08,13)
        opts = delimitedTextImportOptions("NumVariables", 5, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [",", "Z"];
        opts.VariableNames = ["ACQTimestampServerTimeInUTC", "Var2", "Var3", "VarName4", "VarName5"];
        opts.SelectedVariableNames = ["ACQTimestampServerTimeInUTC", "VarName4", "VarName5"];
        opts.VariableTypes = ["datetime", "char", "char", "double", "double"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts.ConsecutiveDelimitersRule = "join";
        opts = setvaropts(opts, ["Var2", "Var3"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var2", "Var3"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQTimestampServerTimeInUTC", "InputFormat", "yyyy-MM-dd HH:mm:ss");       

        tbl = readtable(filelat, opts);    
        dt = tbl.ACQTimestampServerTimeInUTC;
        dt.Format='yyyy-MM-dd HH:mm:ss';        
        lat = tbl.VarName4;
        tbl = readtable(filelon, opts);         
        lon = tbl.VarName4;  

        if length(lat) == length(lon)
        else
            disp('different length lat and lon files')
        end

    else
        opts = delimitedTextImportOptions("NumVariables", 6, "Encoding", "UTF-8");
        opts.DataLines = [2, Inf];
        opts.Delimiter = [",", "Z"];
        opts.VariableNames = ["ACQTimestampServerTimeInUTC", "Var2", "Var3", "Var4", "VarName5", "Var6"];
        opts.SelectedVariableNames = ["ACQTimestampServerTimeInUTC", "VarName5"];
        opts.VariableTypes = ["datetime", "char", "char", "char", "double", "char"];
        opts.ExtraColumnsRule = "ignore";
        opts.EmptyLineRule = "read";
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var6"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["Var2", "Var3", "Var4", "Var6"], "EmptyFieldRule", "auto");
        opts = setvaropts(opts, "ACQTimestampServerTimeInUTC", "InputFormat", "yyyy-MM-dd'T'HH:mm:ss.SSS");

        tbl = readtable(filelat, opts);
        dt = tbl.ACQTimestampServerTimeInUTC;
        dt.Format='yyyy-MM-dd HH:mm:ss';
        lat = tbl.VarName5;
        tbl = readtable(filelon, opts);
        lon = tbl.VarName5;     

        if length(lat) == length(lon)
        else
            disp('different length lat and lon files')
        end        

    end
    DT=[DT;dt];
    LAT=[LAT;lat];
    LON=[LON;lon];    
    clearvars opts tbl fileid lat lon dt name date

end

DT = dateshift(DT, 'start', 'second');

%% find and remove outliers
idx=find(LAT<=33); LAT(idx)=[]; LON(idx)=[]; DT(idx)=[];
idx=find(LAT>=49); LAT(idx)=[]; LON(idx)=[]; DT(idx)=[];
%figure; plot(LAT); set(gca, 'ylim',[20 55]);

idx=find(LON<=-127); LAT(idx)=[]; LON(idx)=[]; DT(idx)=[];
idx=find(LON>=-120); LAT(idx)=[]; LON(idx)=[]; DT(idx)=[];
%figure; plot(LON); set(gca, 'ylim',[-128 -119]);

idx=isoutlier(LON(1:500000),'percentiles',[5 95]);
LAT(idx)=[]; LON(idx)=[]; DT(idx)=[];
idtemp=isoutlier(LON(2100000:2400000),'percentiles',[2 98]);
idx=logical(0*LAT); idx(2100000:2400000)=idtemp; 
LAT(idx)=[]; LON(idx)=[]; DT(idx)=[];
%figure; plot(LON); set(gca, 'ylim',[-128 -118]);

figure; plot(LON,LAT); %sanity check plot

%%
save([outpath 'lat_lon_time_Shimada2021'],'DT','LON','LAT');
