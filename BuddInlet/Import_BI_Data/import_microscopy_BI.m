%% import Dinophysis microscopy excel spreadsheet data from Brian
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';
filename=[filepath 'OYC Phyto-Enviro-Sample Data.xlsx'];
opts = spreadsheetImportOptions("NumVariables", 36);
opts.Sheet = "BuddInlet";
opts.DataRange = "A2:AJ71";
opts.VariableNames = ["Date", "Time", "SampleDepthm", "IFCBDepthm", "ChlMaxLower1", "ChlMaxUpper1", "ChlMaxLower2", "ChlMaxUpper2", "ChlMaxDepthm", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Dinophysis_cellsL", "Var18", "Var19", "Var20", "Var21", "Var22", "Mesodinium_cellsL", "fx_Dacuminata", "fx_Dfortii", "fx_Dnorvegica", "fx_Dodiosa", "fx_Drotundata", "fx_Dparva", "fx_Dacuta", "Var31", "Var32", "Var33", "Var34", "Var35", "AmmoniaM"];
opts.SelectedVariableNames = ["Date", "Time", "SampleDepthm", "IFCBDepthm", "ChlMaxLower1", "ChlMaxUpper1", "ChlMaxLower2", "ChlMaxUpper2", "ChlMaxDepthm", "Dinophysis_cellsL", "Mesodinium_cellsL", "fx_Dacuminata", "fx_Dfortii", "fx_Dnorvegica", "fx_Dodiosa", "fx_Drotundata", "fx_Dparva", "fx_Dacuta", "AmmoniaM"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var18", "Var19", "Var20", "Var21", "Var22", "Var31", "Var32", "Var33", "Var34", "Var35"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var18", "Var19", "Var20", "Var21", "Var22", "Var31", "Var32", "Var33", "Var34", "Var35"], "EmptyFieldRule", "auto");
T = readtable(filename, opts, "UseExcel", false);
clearvars opts

T.dinoML_microscopy=.001*T.Dinophysis_cellsL;
T.mesoML_microscopy=.001*T.Mesodinium_cellsL;

T.fx_Dacuminata=T.fx_Dacuminata*.01;
T.fx_Dfortii=T.fx_Dfortii*.01;
T.fx_Dnorvegica=T.fx_Dnorvegica*.01;
T.fx_Dodiosa=T.fx_Dodiosa*.01;
T.fx_Drotundata=T.fx_Drotundata*.01;
T.fx_Dparva=T.fx_Dparva*.01;
T.fx_Dacuta=T.fx_Dacuta*.01;

%%%% put 0 for species fx if 0 for microscopy
idx=find(T.dinoML_microscopy==0);
T.fx_Dacuminata(idx)=0;
T.fx_Dfortii(idx)=0;
T.fx_Dnorvegica(idx)=0;
T.fx_Dodiosa(idx)=0;
T.fx_Drotundata(idx)=0;
T.fx_Dparva(idx)=0;
T.fx_Dacuta(idx)=0;

%%%% put Nan for species fx if Nan for microscopy
idx=isnan(T.dinoML_microscopy);
T.fx_Dacuminata(idx)=NaN;
T.fx_Dfortii(idx)=NaN;
T.fx_Dnorvegica(idx)=NaN;
T.fx_Dodiosa(idx)=NaN;
T.fx_Drotundata(idx)=NaN;
T.fx_Dparva(idx)=NaN;
T.fx_Dacuta(idx)=NaN;

T.Time=datetime(T.Time,'ConvertFrom','datenum','Format','HH:mm:ss');
T.Time(isnat(T.Time))=datetime(11,00,00); % add 11am if no time available
T.dt=T.Date+timeofday(T.Time);

T=movevars(T,'dt','Before','Date');
T=movevars(T,{'ChlMaxDepthm','ChlMaxLower1','ChlMaxUpper1','ChlMaxLower2','ChlMaxUpper2'},'After','mesoML_microscopy');

T=removevars(T,{'Time','Date','Dinophysis_cellsL','Mesodinium_cellsL'});

idx=find(T.dt==datetime('02-Jun-2021 10:45:00'));
T(idx(2),:)=[]; %remove duplicate data point on 2 June 2021

T.dt=datetime(T.dt,'Format','dd-MMM-yyyy HH:mm:ss')+hours(8); %input was PDT, convert to UTC;
TT=table2timetable(T);

save([filepath 'DinophysisMicroscopy_BI'],'TT');