%% import pCO2 data and timestamps from 2021 Shimada cruise data
% process these data like a .csv file
% Alexis D. Fischer, NWFSC, October 2022
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/'; %USER
indir= '~/Documents/Shimada2019/2019_pco2datagap/'; %USER
outpath=[filepath 'NOAA/Shimada/Data/']; %USER

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


%% merge with lat lon
load([outpath 'lat_lon_time_Shimada2019'],'DT','LON','LAT');

[~,ia,ib]=intersect(dt,DT);
DT=dt(ia); LAT=LAT(ib); LON=LON(ib); 
TYPE=type(ia); ERROR=error(ia); EQUTEMP=equTemp(ia); STDVAL=stdVal(ia); 
CO2AW=CO2aW(ia); CO2BW=CO2bW(ia); CO2UMM=CO2Umm(ia); H2OAW=H2OaW(ia); 
H2OBW=H2ObW(ia); H2OMMM=H2OMmm(ia); LICORTEMP=licorTemp(ia); LICORPRESS=licorPress(ia); 
DRYDRUCK=dryDruck(ia); EQUPRESS=equPress(ia); H2OFLOW=H2OFlow(ia); 
LICORFLOW=licorFlow(ia); EQUPUMP=equPump(ia); VENTFLOW=ventFlow(ia); 
ATMCOND=atmCond(ia); EQUCOND=equCond(ia); DRIP1=drip1(ia); CONDTEMP=condTemp(ia);
DRYBOXTEMP=dryBoxTemp(ia); O2UMM=O2Umm(ia); O2SAT=O2Sat(ia); O2TEMP=O2Temp(ia);
PHTEMP=pHTemp(ia); FETINTV=FETIntV(ia); FETEXTV=FETExtV(ia); ATMPRESSURE=AtmPressure(ia); 
INTAKETEMP=IntakeTemp(ia); SALINITY=Salinity(ia); AIRTEMP=AirTemp(ia);

T=table(DT,LAT,LON,TYPE,ERROR,EQUTEMP,STDVAL,...
CO2AW,CO2BW,CO2UMM,H2OAW,H2OBW,H2OMMM,LICORTEMP,LICORPRESS,...
DRYDRUCK,EQUPRESS,H2OFLOW,LICORFLOW,EQUPUMP,VENTFLOW,...
ATMCOND,EQUCOND,DRIP1,CONDTEMP,DRYBOXTEMP,O2UMM,O2SAT,...
O2TEMP,PHTEMP,FETINTV,FETEXTV,ATMPRESSURE,INTAKETEMP,SALINITY,AIRTEMP);

writetable(T,[outpath 'raw_pCO2_Shimada2019.csv'])
