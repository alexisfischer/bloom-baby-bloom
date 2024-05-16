%% import pCO2 data and timestamps from 2021 Shimada cruise data
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, October 2022
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Shimada2019/2019_pco2datagap/'; %USER
outpath=[filepath 'Shimada/Data/']; %USER

addpath(genpath(outpath)); 
addpath(genpath([filepath 'Misc-Functions/'])); 
Tdir=dir([indir 'GO6_2019-*dat.txt']);

dt=[]; type=[]; error=[]; equTemp=[]; stdVal=[]; CO2aW=[]; CO2bW=[]; CO2Umm=[];
H2OaW=[]; H2ObW=[]; H2OMmm=[]; licorTemp=[]; licorPress=[]; dryDruck=[]; equPress=[];
H2OFlow=[]; licorFlow=[]; equPump=[]; ventFlow=[]; atmCond=[]; equCond=[];
drip1=[]; condTemp=[]; dryBoxTemp=[]; O2Umm=[]; O2Sat=[]; O2Temp=[];
pHTemp=[]; FETIntV=[]; FETExtV=[]; AtmPressure=[]; IntakeTemp=[]; Salinity=[]; AirTemp=[];

for i=1:length(Tdir)
    name=Tdir(i).name;    
    filename = [indir name];    
    disp(name);      

    opts = delimitedTextImportOptions("NumVariables", 43);
    opts.DataLines = [2, Inf];
    opts.Delimiter = "\t";
    opts.VariableNames = ["Type", "error", "PCDate", "PCTime", "equTemp", "stdVal", "CO2aW", "CO2bW", "CO2Umm", "H2OaW", "H2ObW", "H2OMmm", "licorTemp", "licorPress", "dryDruck", "equPress", "H2OFlow", "licorFlow", "equPump", "ventFlow", "atmCond", "equCond", "drip1", "Var24", "condTemp", "dryBoxTemp", "O2Umm", "O2Sat", "O2Temp", "pHTemp", "FETIntV", "FETExtV", "Var33", "Var34", "Var35", "Var36", "AtmPressure", "IntakeTemp", "Var39", "Salinity", "Var41", "Var42", "AirTemp"];
    opts.SelectedVariableNames = ["Type", "error", "PCDate", "PCTime", "equTemp", "stdVal", "CO2aW", "CO2bW", "CO2Umm", "H2OaW", "H2ObW", "H2OMmm", "licorTemp", "licorPress", "dryDruck", "equPress", "H2OFlow", "licorFlow", "equPump", "ventFlow", "atmCond", "equCond", "drip1", "condTemp", "dryBoxTemp", "O2Umm", "O2Sat", "O2Temp", "pHTemp", "FETIntV", "FETExtV", "AtmPressure", "IntakeTemp", "Salinity", "AirTemp"];
    opts.VariableTypes = ["categorical", "double", "datetime", "datetime", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "double", "double", "char", "double", "char", "char", "double"];
    opts.ExtraColumnsRule = "ignore";
    opts.EmptyLineRule = "read";
    opts = setvaropts(opts, ["Var24", "Var33", "Var34", "Var35", "Var36", "Var39", "Var41", "Var42"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["Type", "Var24", "Var33", "Var34", "Var35", "Var36", "Var39", "Var41", "Var42"], "EmptyFieldRule", "auto");
    opts = setvaropts(opts, "PCDate", "InputFormat", "dd/MM/yy");
    opts = setvaropts(opts, "PCTime", "InputFormat", "HH:mm:ss");
    opts = setvaropts(opts, ["AtmPressure", "IntakeTemp", "Salinity", "AirTemp"], "TrimNonNumeric", true);
    opts = setvaropts(opts, ["AtmPressure", "IntakeTemp", "Salinity", "AirTemp"], "ThousandsSeparator", ","); 
    tbl = readtable(filename, opts);

    d = tbl.PCDate; d.Format='yyyy-MM-dd HH:mm:ss';
    h = tbl.PCTime; dur=duration(string(h),'InputFormat','hh:mm:ss');
    dti=d+dur;

    dt=[dt;dti];
    type=[type;tbl.Type];
    error=[error;tbl.error];
    equTemp=[equTemp;tbl.equTemp];
    stdVal=[stdVal;tbl.stdVal];
    CO2aW=[CO2aW;tbl.CO2aW];
    CO2bW=[CO2bW;tbl.CO2bW];
    CO2Umm=[CO2Umm;tbl.CO2Umm];
    H2OaW=[H2OaW;tbl.H2OaW];
    H2ObW=[H2ObW;tbl.H2ObW];
    H2OMmm=[H2OMmm;tbl.H2OMmm];
    licorTemp=[licorTemp;tbl.licorTemp];
    licorPress=[licorPress;tbl.licorPress];
    dryDruck=[dryDruck;tbl.dryDruck];
    equPress=[equPress;tbl.equPress];
    H2OFlow=[H2OFlow;tbl.H2OFlow];
    licorFlow=[licorFlow;tbl.licorFlow];
    equPump=[equPump;tbl.equPump];
    ventFlow=[ventFlow;tbl.ventFlow];
    atmCond=[atmCond;tbl.atmCond];
    equCond=[equCond;tbl.equCond];
    drip1=[drip1;tbl.drip1];
    condTemp=[condTemp;tbl.condTemp];
    dryBoxTemp=[dryBoxTemp;tbl.dryBoxTemp];
    O2Umm=[O2Umm;tbl.O2Umm];
    O2Sat=[O2Sat;tbl.O2Sat];
    O2Temp=[O2Temp;tbl.O2Temp];
    pHTemp=[pHTemp;tbl.pHTemp];
    FETIntV=[FETIntV;tbl.FETIntV];
    FETExtV=[FETExtV;tbl.FETExtV];
    AtmPressure=[AtmPressure;tbl.AtmPressure];
    IntakeTemp=[IntakeTemp;tbl.IntakeTemp];
    Salinity=[Salinity;tbl.Salinity]; 
    AirTemp=[AirTemp;tbl.AirTemp];
    clearvars opts tbl dur d h    
end

T=timetable(dt,AirTemp, atmCond, AtmPressure, CO2aW, CO2bW, CO2Umm, condTemp, drip1, dryBoxTemp, dryDruck, equCond, equPress, equPump, equTemp, error, FETExtV, FETIntV, H2OaW, H2ObW, H2OFlow, H2OMmm, IntakeTemp, licorFlow, licorPress, licorTemp, O2Sat, O2Temp, O2Umm, pHTemp, Salinity, stdVal, type, ventFlow);
T=removevars(T,{'AirTemp','AtmPressure','IntakeTemp','Salinity'});
clearvars name indir Tdir i dti dt AirTemp atmCond AtmPressure CO2aW CO2bW CO2Umm condTemp drip1 dryBoxTemp dryDruck equCond equPress equPump equTemp error FETExtV FETIntV H2OaW H2ObW H2OFlow H2OMmm IntakeTemp licorFlow licorPress licorTemp O2Sat O2Temp O2Umm pHTemp stdVal Salinity type ventFlow;

%% merge with lat lon
T.dt=dateshift(T.dt,'start','minute');
load([filepath 'Shimada/Data/environ_Shimada2019'],'DT','LON','LAT','TEMP','SAL','AIRTEMP','ATMP');
IntakeTemp_TSG45=TEMP;
Salinity_TSG45=SAL;
AirTemp_SAMOS=AIRTEMP;
AtmPressure_SAMOS=ATMP;

TT=timetable(DT,LAT,LON,IntakeTemp_TSG45,Salinity_TSG45,AirTemp_SAMOS,AtmPressure_SAMOS);
T=synchronize(T,TT,'first');
dt=T.dt;

T=timetable2table(T);
day=dt; day.Format='yyyy-MM-dd';      
time=dt; time.Format='HH:mm:ss';    

T=addvars(T,day,'Before','dt');
T=addvars(T,time,'Before','dt');
T=removevars(T,'dt');

%%
writetable(T,[outpath 'raw_pCO2_Shimada2019.csv'])
