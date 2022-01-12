%% imports all the data (except wind and IFCB) from Santa Cruz Wharf
% T, SSS, Chl, nit, amm, urea, ammon, phos, sil, DA, STX, RAI
clear;
addpath(genpath('~/MATLAB/bloom-baby-bloom/Misc-Functions/'));
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/UCSC/SCW/')); % add new data to search path

filepath='/Users/afischer/MATLAB/UCSC/SCW/';
load([filepath 'Data/SCW_master'],'SC');

dn=(datenum('01-Jan-2001'):1:datenum('10-May-2020'))';

%%
SC.dn=dn;

% preallocate space
SC.SST=nan(size(SC.dn));
SC.T=nan(size(SC.dn));
SC.N2=nan(size(SC.dn));
SC.SSS=nan(size(SC.dn));
SC.CHL=nan(size(SC.dn));
SC.nitrate=nan(size(SC.dn));
SC.ammonium=nan(size(SC.dn));
SC.urea=nan(size(SC.dn));
SC.phosphate=nan(size(SC.dn));
SC.silicate=nan(size(SC.dn));
SC.DA=nan(size(SC.dn));
SC.STX=nan(size(SC.dn));
SC.Alex=nan(size(SC.dn));
SC.dinophysis=nan(size(SC.dn));
SC.Pn=nan(size(SC.dn));
SC.Paust=nan(size(SC.dn));
SC.Pmult=nan(size(SC.dn));

SC.DINOrai=nan(size(SC.dn));

SC.Tsensor=nan(size(SC.dn));
SC.CHLsensor=nan(size(SC.dn));
SC.TURsensor=nan(size(SC.dn));

SC.NO3_nemuro=nan(size(SC.dn));
SC.NH4_nemuro=nan(size(SC.dn));
SC.SwD=nan(size(SC.dn));

SC.maxdTdz=nan(size(SC.dn));
SC.Zmax=nan(size(SC.dn));
SC.mld5=nan(size(SC.dn));

SC.maxdTdzS=nan(size(SC.dn));
SC.ZmaxS=nan(size(SC.dn));
SC.mld5S=nan(size(SC.dn));
SC.upwell=nan(size(SC.dn));

SC.pajaroR=nan(size(SC.dn));
SC.salinasR=nan(size(SC.dn));
SC.sanlorR=nan(size(SC.dn));
SC.soquelR=nan(size(SC.dn));
% 
SC.wind=nan(size(SC.dn));
SC.winddir=nan(size(SC.dn));
SC.windU=nan(size(SC.dn));
SC.windV=nan(size(SC.dn));
SC.wind42U=nan(size(SC.dn));
SC.wind42V=nan(size(SC.dn));
SC.windoU=nan(size(SC.dn));
SC.windoV=nan(size(SC.dn));
SC.windM1=nan(size(SC.dn));

SC.PDO=nan(size(SC.dn));
SC.NPGO=nan(size(SC.dn));
SC.MEI=nan(size(SC.dn));

SC.curU=nan(size(SC.dn));
SC.curV=nan(size(SC.dn));

SC.BEUTI=nan(size(SC.dn));
SC.CUTI=nan(size(SC.dn));

%% step 1) import hourly river discharge data 2000-2019, Discharge (cubic feet per second)
list = {'PajaroRiver_2000-2019.txt';'SanLorenzoRiver_2000-2019.txt';'SalinasRiver_2000-2019.txt';'SoquelRiver_2000-2019.txt'};

for h=1:length(list)
    
    filename=list{h};
   
    opts = delimitedTextImportOptions("NumVariables", 6);
    opts.DataLines = [34, Inf];
    opts.Delimiter = "\t";
    opts.VariableNames = ["Var1", "Var2", "datetime", "Var4", "VarName5", "Var6"];
    opts.SelectedVariableNames = ["datetime", "VarName5"];
    opts.VariableTypes = ["string", "string", "datetime", "string", "double", "string"];
    opts = setvaropts(opts, 3, "InputFormat", "yyyy-MM-dd HH:mm");
    opts = setvaropts(opts, [1, 2, 4, 6], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, [1, 2, 4, 6], "EmptyFieldRule", "auto");
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    T = readtable([filepath 'Data/' filename], opts); % Import the data
    
    %ensure dataset starts on 01 Jan 2000
    idx=find(T.datetime=={'2000-01-01 00:00'});
    dt=T.datetime(idx:end);
    r=T.VarName5(idx:end);
    
    Ri=pl33tn(r); % low pass filter
    [dn, R]=filltimeseriesgaps( datenum(dt), Ri ); % fill time gaps with NaNs
    R=interp1babygap(R,4); %interpolate data unless gaps >4 
    
    if strcmp(filename,'PajaroRiver_2000-2019.txt')    
        for i=1:length(SC.dn)
            for j=1:length(dn)
                if dn(j) == SC.dn(i)
                    SC.pajaroR(i)=R(j);       
                else
                end
            end
        end
        
    elseif strcmp(filename,'SanLorenzoRiver_2000-2019.txt')
        for i=1:length(SC.dn)
            for j=1:length(dn)
                if dn(j) == SC.dn(i)
                    SC.sanlorR(i)=R(j);       
                else
                end
            end
        end      
        
    elseif strcmp(filename,'SalinasRiver_2000-2019.txt')
        for i=1:length(SC.dn)
            for j=1:length(dn)
                if dn(j) == SC.dn(i)
                    SC.salinasR(i)=R(j);       
                else
                end
            end
        end   
        
    elseif strcmp(filename,'SoquelRiver_2000-2019.txt')
        for i=1:length(SC.dn)
            for j=1:length(dn)
                if dn(j) == SC.dn(i)
                  SC.soquelR(i)=R(j);       
                else
                end
            end
        end             
    end
    
    clearvars opts R Ri T dt dn filename i j   
end

% figure; plot(SC.dn,SC.pajaroR,'-b'); datetick('x','yyyy');
% figure; plot(SC.dn,SC.soquelR,'-b'); datetick('x','yyyy');
% figure; plot(SC.dn,SC.sanlorR,'-b'); datetick('x','yyyy');
% figure; plot(SC.dn,SC.salinasR,'-b'); datetick('x','yyyy');

%% step 2) import weekly Temperature from SCOOS spreadsheet 2005-2019
[~, ~, raw] = xlsread('/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/SCW_temp_2005-2018.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));
dn = data(:,1) + 693960; %convert excel to matlab format
T = data(:,2);
T((T==-999))=NaN; %convert -999 to NaNs

[~,~,ib]=intersect(dn,[SC.dn]); %find where matches dn in dataset
for i=1:length(ib)    
    SC.T(ib(i))=T(i);
end

% idx=~isnan(SC.T);
% figure; plot(SC.dn(idx),SC.T(idx)); datetick('x','yyyy');

clearvars data raw R dn ib T i idx;


%% step 3) Import SCW parameters (Temp, Chl, Alex, DA) 2000-2009

[~,~,raw]=xlsread('/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/SCW_Jester_2000-2009.xlsx','Sheet1');
raw = raw(2:end,:);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
data = reshape([raw{:}],size(raw));

dn = data(:,1) +693960;

T = data(:,3);
SSS = data(:,2);
Paust = data(:,4);
Pmult = data(:,5);
Pn = data(:,6);
Alex = data(:,7);
DA = data(:,8);
STX = data(:,9);
CHL = data(:,10);
silicate = data(:,11);
nitrate = data(:,12);
phosphate = data(:,13);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.SSS(i)=SSS(j);
            SC.T(i)=T(j);            
            SC.Paust(i)=Paust(j);
            SC.Pmult(i)=Pmult(j);            
            SC.Pn(i)=Pn(j);            
            SC.Alex(i)=Alex(j);            
            SC.DA(i)=DA(j);            
            SC.STX(i)=STX(j);            
            SC.CHL(i)=CHL(j);            
            SC.silicate(i)=silicate(j);            
            SC.nitrate(i)=nitrate(j);            
            SC.phosphate(i)=phosphate(j);            
        else
        end
    end
end

% idx=~isnan(nitrate);
% figure; plot(dn(idx),nitrate(idx)); datetick('x','yyyy'); title('nitrate')

% idx=~isnan(CHL);
% figure; plot(dn(idx),CHL(idx)); datetick('x','yyyy'); title('CHL') 

% idx=~isnan(SC.CHL);
% figure; plot(SC.dn(idx),SC.CHL(idx)); datetick('x','yyyy');

clearvars data raw stringVectors R dn nitrate Paust phosphate Pmult Pn silicate STX T i j;

%% step 4) import weekly Chl, select nutrients, PN and Alex from DOD 2005-2015

filename = [filepath 'Data/SCW_DODserver_2005-2015.txt'];
delimiter = ',';
startRow = 18;
formatSpec = '%{yyyy-MM-dd HH:mm:ss.S}D%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');

textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false, 'EndOfLine', '\r\n');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'ReturnOnError', false);
fclose(fileID);

dt = dataArray{:, 1};
    dn=datenum(datestr(dt,'yyyy-mm-dd'));
CHL = dataArray{:, 2};
    CHL((CHL==-999))=NaN; %convert -999 to NaNs
urea = dataArray{:, 3};
nitrate = dataArray{:, 5};
ammonium = dataArray{:, 4};
phosphate = dataArray{:, 6};
silicate = dataArray{:, 7};
Pn = dataArray{:, 8};
Paust = dataArray{:, 9};
Pmult = dataArray{:, 10};
Alex = dataArray{:, 11};

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.urea(i)=urea(j);
            SC.ammonium(i)=ammonium(j);
            SC.phosphate(i)=phosphate(j);
            SC.silicate(i)=silicate(j);
            SC.Pn(i)=Pn(j);
            SC.Paust(i)=Paust(j);
            SC.Pmult(i)=Pmult(j);
            SC.Alex(i)=Alex(j);
        else
        end
    end
end
     
%merge nitrate dataset
idx=find(dn>=datenum('01-Jan-2006'),1);
dni=dn(idx:end); nitrate = nitrate(idx:end); nitrate(nitrate<0)=0;

for i=1:length(SC.dn)
    for j=1:length(dni)
        if dni(j) == SC.dn(i)
            SC.nitrate(i)=nitrate(j);
        else
        end
    end
end
  
%idx=~isnan(SC.nitrate);
%figure; plot(SC.dn(idx),SC.nitrate(idx)); datetick('x','yyyy'); title('nitrate')

% merge Chl dataset
idx=find(dn>=datenum('20-Dec-2006'),1);
dni=dn(idx:end); CHL = CHL(idx:end);

for i=1:length(SC.dn)
    for j=1:length(dni)
        if dni(j) == SC.dn(i)
            SC.CHL(i)=CHL(j);
        else
        end
    end
end
  
%idx=~isnan(SC.CHL);
%figure; plot(SC.dn(idx),SC.CHL(idx)); datetick('x','yyyy'); title('CHL')
 
clearvars Alex ammonium CHL DA dataArray delimiter dni dt fileID filename...
    formatSpec i idx j nitrate Paust phosphate Pmult Pn silicate SSS startRow urea

%% step 5) import weekly Chl, T, nutrients, PN and Alex from SCOOS Website 2011-present
filename = "/Users/afischer/MATLAB/UCSC/SCW/Data/HABs-SantaCruzWharf_ERDDAP.csv";

opts = delimitedTextImportOptions("NumVariables", 40);
opts.DataLines = [3, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "time", "Temp", "Var8", "Var9", "Var10", "Var11", "Var12", "Avg_Chloro", "Var14", "Var15", "Var16", "Phosphate", "Silicate", "Var19", "Var20", "Ammonium", "Nitrate", "Var23", "pDA", "Var25", "Var26", "Var27", "Var28", "Alexandrium_spp", "Dinophysis_spp", "Var31", "Var32", "Var33", "Pseudo_nitzschia_seriata_group", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40"];
opts.SelectedVariableNames = ["time", "Temp", "Avg_Chloro", "Phosphate", "Silicate", "Ammonium", "Nitrate", "pDA", "Alexandrium_spp", "Dinophysis_spp", "Pseudo_nitzschia_seriata_group"];
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "double", "string", "string", "string", "double", "double", "string", "string", "double", "double", "string", "double", "string", "string", "string", "string", "double", "double", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "time", "Var8", "Var9", "Var10", "Var11", "Var12", "Var14", "Var15", "Var16", "Var19", "Var20", "Var23", "Var25", "Var26", "Var27", "Var28", "Var31", "Var32", "Var33", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "time", "Var8", "Var9", "Var10", "Var11", "Var12", "Var14", "Var15", "Var16", "Var19", "Var20", "Var23", "Var25", "Var26", "Var27", "Var28", "Var31", "Var32", "Var33", "Var35", "Var36", "Var37", "Var38", "Var39", "Var40"], "EmptyFieldRule", "auto");
T = readtable(filename, opts);

time=strrep(T.time,"T"," "); time=strrep(time,"Z","");
dn=round(datenum(datetime(time,'Format','yyyy-MM-dd HH:mm:ss')));

Temp=T.Temp;
Chl=T.Avg_Chloro;
phosphate = T.Phosphate;
silicate = T.Silicate;
ammonium = T.Ammonium;
nitrate = T.Nitrate;
pDA = T.pDA;
Alex = T.Alexandrium_spp;
dinophysis = T.Dinophysis_spp;
Pn = T.Pseudo_nitzschia_seriata_group;

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.Alex(i)=Alex(j);
            SC.ammonia(i)=ammonium(j);
            SC.CHL(i)=Chl(j);
            SC.dinophysis(i)=dinophysis(j);
            SC.DA(i)=pDA(j);
            SC.nitrate(i)=nitrate(j);            
            SC.phosphate(i)=phosphate(j);
            SC.Pn(i)=Pn(j);            
            SC.silicate(i)=silicate(j);
            SC.T(i)=Temp(j);            
        else
        end
    end
end

% idx=~isnan(SC.CHL);
% figure; plot(SC.dn(idx),SC.CHL(idx)); datetick('x','yyyy');

clearvars T Alex CHL DA data dn i j nitrate phosphate ammonium day dinophysis month year Pn R raw silicate idx;

%% step 6) import RAI fx Dinoflagellates

load([filepath 'Data/RAI'],'DN','DINOrai');

for i=1:length(SC.dn)
    for j=1:length(DN)
        if DN(j) == SC.dn(i)
            SC.DINOrai(i)=DINOrai(j);      
        else
        end
    end
end

idx=~isnan(SC.DINOrai);
figure; plot(SC.dn(idx),SC.DINOrai(idx),'-k');...
    set(gca,'xlim',[datenum('01-Jan-2001') datenum('01-Jan-2019')]); datetick('x','yy');

clearvars DN DINOrai DIATrai RAIchl class id i j PN DI CE AK;

%% step 7) Import Swell direction from Point Sur
load([filepath 'Data/SwellDirection'],'DN','SWD');

for i=1:length(SC.dn)
    for j=1:length(DN)
        if DN(j) == SC.dn(i)
            SC.SwD(i)=SWD(j);       
        else
        end
    end
end

%idx=~isnan(SC.SwD);
%figure; plot(SC.dn(idx),SC.SwD(idx)); datetick('x','yyyy');

%% step 8) Import Temp, Chl, Turbidity SCW sensor data from ERDDAP CENCOOS portal

filename = [filepath 'Data/SCW_weatherstation_cencoos/sensors_SCW_09-18.csv'];
delimiter = ',';
startRow = 3;
formatSpec = '%s%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
time = dataArray{:, 1};
mass_concentration_of_chlorophyll_in_sea_water = dataArray{:, 2};
sea_water_temperature = dataArray{:, 3};
turbidity = dataArray{:, 4};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;

%%%% convert to useable format
%deal with weird date format, flip vector direction, convert from F to Celcius
dn = flipud(datenum(datetime(time,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z')));

[sst,dnn]=plfilt(sea_water_temperature,dn);

[~,CHL,~] = ts_aggregation(dn,flipud(mass_concentration_of_chlorophyll_in_sea_water),1,'day',@mean);
[~,T_F,~] = ts_aggregation(dn,flipud(sea_water_temperature),1,'day',@mean);
T=(T_F-32)*.5556;
[DN,TUR,~] = ts_aggregation(dn,flipud(turbidity),1,'day',@mean);

for i=1:length(DN)
    if CHL(i) <=0
        CHL(i) = NaN;        
    end
    if T(i) <= 0
        T(i) = NaN;        
    end    
    if TUR(i) <= 0
        TUR(i) = NaN;        
    end       
end

%remove the extra minutes. just keep the day
d = dateshift(datetime(datestr(DN)),'start','day');
d.Format = 'dd-MMM-yyyy';
dn = datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.Tsensor(i)=T(j);
            SC.CHLsensor(i)=CHL(j);
            SC.TURsensor(i)=TUR(j);            
        else
        end
    end
end

idx=~isnan(SC.T);
Ti=interp1([SC.dn(idx)],[SC.T(idx)],[SC.dn]);

for i=1:length(SC.Tsensor)
   if  isnan(SC.Tsensor(i))
        SC.Tsensor(i) = Ti(i);
    else
    end
end
SC.Tsensor=smooth(SC.Tsensor,8);
SC.Tsensor(1:5)=NaN;

% figure; plot(SC.dn(idx),SC.T(idx),SC.dn,SC.Tsensor); datetick('x','yyyy');

clearvars CHL d dn DN i mass_concentration_of_chlorophyll_in_sea_water sea_water_temperature T T_F time TUR turbidity j;

%% step 9) import NEMURO modeled nutrients
load([filepath 'Data/NEMURO'],'DN','NO3','NH4');

for i=1:length(SC.dn)
    for j=1:length(DN)
        if DN(j) == SC.dn(i)
            SC.NO3_nemuro(i)=NO3(j);           
            SC.NH4_nemuro(i)=NH4(j);           
        else
        end
    end
end

%idx=~isnan(SC.NO3_nemuro);
%figure; plot(SC.dn(idx),SC.NO3_nemuro(idx)); datetick('x','yyyy');
%figure; plot(SC.dn(idx),SC.NH4_nemuro(idx)); datetick('x','yyyy');

%% step 9) Import M1 sensor: MLD, dTdz, Tmax, and Zmax
load([filepath 'Data/M1_TS'],'M1R');

M1=M1R;
dn = [M1.dn]';

Zmax=NaN*(ones(size(dn)));
maxdTdz=NaN*(ones(size(dn)));
mld5=NaN*(ones(size(dn)));
for i=1:length(M1)
    Zmax(i)=M1(i).Zmax;
    maxdTdz(i)=M1(i).maxdTdz;
    mld5(i)=M1(i).mld5;    

end

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.Zmax(i)=Zmax(j);      
            SC.maxdTdz(i)=maxdTdz(j);   
            SC.mld5(i)=mld5(j);                
            
        else
        end
    end
end

%figure; plot(SC.dn,SC.Zmax,'*b')
%datetick('x','yyyy');

clearvars data raw R S dn i j M1;

%% step 10) Import ROMS nearest SCW (2010-2018)
load([filepath 'Data/ROMS/SCW_ROMS_TS_MLD_50m'],'ROMS');

dn = [ROMS.dn]';

SST=NaN*(ones(size(dn)));
SSS=NaN*(ones(size(dn)));
Zmax=NaN*(ones(size(dn)));
maxdTdz=NaN*(ones(size(dn)));
mld5=NaN*(ones(size(dn)));
N2=NaN*(ones(size(dn)));

for i=1:length(ROMS)
    SST(i)=ROMS(i).Ti(1);
    SSS(i)=ROMS(i).Si(1);    
    Zmax(i)=ROMS(i).Zmax;
    maxdTdz(i)=ROMS(i).maxdTdz;
    mld5(i)=ROMS(i).mld5;    
    N2(i)=ROMS(i).logN2(1);    
end

N2=smooth(N2,10); %10 pt running average as in Graff & Behrenfeld 2018 and log transform

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.SST(i)=SST(j);      
            SC.SSS(i)=SSS(j);                  
            SC.ZmaxS(i)=Zmax(j);      
            SC.maxdTdzS(i)=maxdTdz(j);   
            SC.mld5S(i)=mld5(j);                
            SC.N2(i)=N2(j);                
        else
        end
    end
end

%idx=~isnan(SC.SST);
%figure; plot(SC.dn(idx),SC.SST(idx),'-k')
%datetick('x','yyyy');

clearvars data raw R S dn i j M1;

%% 11) import Bakun Upwelling index
delimiter = ' ';
startRow = 7;
formatSpec = '%{yyyyMMdd}D%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';
fileID = fopen([filepath 'Data/UpwellingIndex_daily_36N.txt'],'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
    'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN,...
    'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

dt = dataArray{:, 1};
upwell = dataArray{:, 2};
upwell((upwell==-9999))=NaN; %convert -9999 to NaNs


d = dateshift(dt, 'start', 'day');
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.upwell(i)=upwell(j);       
        else
        end
    end
end

%figure; plot(SC.dn,SC.upwell,'-b')
%datetick('x','yyyy');

% Clear temporary variables
clearvars filename delimiter startRow formatSpec upwell dn fileID dataArray ans d dt;

%% 12) Import wind
load([filepath 'Data/Wind_MB'],'w');
[~,spd,~] = ts_aggregation(w.scw.dn,w.scw.spd,1,'day',@mean);
[~,dir,~] = ts_aggregation(w.scw.dn,w.scw.dir,1,'day',@mean);
[~,U,~] = ts_aggregation(w.scw.dn,w.scw.u,1,'day',@mean);
[dn,V,~] = ts_aggregation(w.scw.dn,w.scw.v,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.wind(i)=spd(j);       
            SC.winddir(i)=dir(j);    
            SC.windU(i)=U(j);       
            SC.windV(i)=V(j);       
        else
        end
    end
end

%46042
[~,U,~] = ts_aggregation(w.s42.dn,w.s42.u,1,'day',@mean);
[dn,V,~] = ts_aggregation(w.s42.dn,w.s42.v,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);
[vfilt,~]=plfilt(V,dn); [ufilt,df]=plfilt(U,dn);    
[up,across]=rotate_current(ufilt,vfilt,44);

for i=1:length(SC.dn)
    for j=1:length(df)
        if df(j) == SC.dn(i)
            SC.wind42U(i)=across(j);       
            SC.wind42V(i)=up(j);       
        else
        end
    end
end

% Oneill Sea Odyssey
[~,U,~] = ts_aggregation(w.oso.dn,w.oso.u,1,'day',@mean);
[dn,V,~] = ts_aggregation(w.oso.dn,w.oso.v,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.windoU(i)=U(j);       
            SC.windoV(i)=V(j);       
        else
        end
    end
end

[dn,spd,~] = ts_aggregation(w.M1.dn,w.M1.spd,1,'day',@mean);
d = dateshift(datetime(datestr(dn)),'start','day'); %remove the extra minutes. just keep the day
d.Format = 'dd-MMM-yyyy';
dn=datenum(d);

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.windM1(i)=spd(j);       
        else
        end
    end
end

clearvars d dn DN i j spd SPD w;

%% 13) import PDO
filename = '/Users/afischer/MATLAB/UCSC/SCW/Data/PDO.txt';
startRow = 23;
endRow = 141;
formatSpec = '%4s%9s%7s%7s%7s%7s%7s%7s%7s%7s%7s%7s%s%[^\n\r]';
fileID = fopen(filename,'r');
textscan(fileID, '%[^\n\r]', startRow-1, 'WhiteSpace', '', 'ReturnOnError', false);
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9,10,11,12,13]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

PDOraw = cell2mat(raw);
clearvars filename startRow endRow formatSpec fileID dataArray ans raw...
    col numericData rawData row regexstr result numbers ...
    invalidThousandsSeparator thousandsRegExp R;

PDOraw=PDOraw';
PDOraw=PDOraw(1:end,1:116); %only take through 2018
yr=PDOraw(1,:);
PDO=PDOraw(2:end,:);
PDO=PDO(:);
dn=bsxfun(@(Year,Month) datenum(Year,Month,15),yr',(1:12));
dn=sort(dn(:));

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.PDO(i)=PDO(j);       
        else
        end
    end
end

%figure; plot(SC.dn,SC.PDO,'ok')
%datetick('x','yyyy');

clearvars i j PDO yr;

%% 14) import NPGO
filename = '/Users/afischer/MATLAB/UCSC/SCW/Data/NPGO.txt';
delimiter = {'  '};
startRow = 27;
formatSpec = '%*s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

yr = cell2mat(raw(:, 1));
month = cell2mat(raw(:, 2));
NPGO = cell2mat(raw(:, 3));

dn=datenum(yr,month,15);

figure; plot(dn,NPGO,'-b')
datetick('x','yyyy');

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.NPGO(i)=NPGO(j);       
        else
        end
    end
end

% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans ...
    raw col numericData rawData row regexstr result numbers ...
    invalidThousandsSeparator thousandsRegExp;

%% step 15) import MEIv2
startRow = 2; endRow = 42;
formatSpec = '%4f%9f%9f%9f%9f%9f%9f%9f%9f%9f%9f%9f%f%[^\n\r]';
fileID = fopen('/Users/afischer/MATLAB/UCSC/SCW/Data/meiv2.txt','r');
dataArray = textscan(fileID, formatSpec, endRow-startRow+1, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'HeaderLines', startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
MEIraw = table2array(table(dataArray{1:end-1}));

MEIraw=MEIraw';
yr=MEIraw(1,:);
MEI=MEIraw(2:end,:);
MEI=MEI(:);
MEI(MEI==-999)=NaN;

dn=bsxfun(@(Year,Month) datenum(Year,Month,01),yr',(1:12));
dn=sort(dn(:));
for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.MEI(i)=MEI(j);      
        else
        end
    end
end

%idx=~isnan(SC.MEI);
%figure; plot(SC.dn(idx),SC.MEI(idx),'-k')
%datetick('x','yyyy'); datetick;

%% step 17) import surface currents
load([filepath 'Data/Hfr_daily_SCW_2012-2018'],'dn','u','v','lat','lon');

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.curU(i)=u(j);      
            SC.curV(i)=v(j);      
        else
        end
    end
end

%% step 18) import BEUTI and CUTI
opts = delimitedTextImportOptions("NumVariables", 20);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["year", "month", "day", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "N10", "Var15", "Var16", "Var17", "Var18", "Var19", "Var20"];
opts.SelectedVariableNames = ["year", "month", "day", "N10"];
opts.VariableTypes = ["double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "string", "string", "string", "string", "string", "string"];
opts = setvaropts(opts, [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20], "EmptyFieldRule", "auto");
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
T = readtable("~/MATLAB/UCSC/SCW/Data/BEUTI_daily.csv", opts);

YY = T.year;
MM = T.month;
DD = T.day;
B = T.N10;

dn=datenum(datestr(datenum(YY,MM,DD),'dd-mmm-yyyy'));

T = readtable("~/MATLAB/UCSC/SCW/Data/CUTI_daily.csv", opts);
C = T.N10;

for i=1:length(SC.dn)
    for j=1:length(dn)
        if dn(j) == SC.dn(i)
            SC.BEUTI(i)=B(j);      
            SC.CUTI(i)=C(j);      
        else
        end
    end
end

%idx=~isnan(SC.CUTI);
%figure; plot(SC.dn(idx),SC.CUTI(idx),'-k')
%datetick('x','yyyy'); datetick;

clearvars opts i j T C B idx DD MM YY

%%
save([filepath 'Data/SCW_master'],'SC');
