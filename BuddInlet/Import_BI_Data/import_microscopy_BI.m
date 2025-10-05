%% import Dinophysis microscopy excel spreadsheet data from Brian
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';
filename=[filepath 'OYC Phyto-Enviro-Sample Data.xlsx'];
opts = spreadsheetImportOptions("NumVariables", 37);
opts.Sheet = "BuddInlet";
opts.DataRange = "A2:AK71";
opts.VariableNames = ["Date", "Time", "SampleDepthm", "IFCBDepthm", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Dino_cellsL", "Var19", "Var20", "Var21", "Var22", "Var23", "Mesodinium_cellsL", "Acum", "Fort", "Norv", "Odio", "Rotu", "Parv", "Acut", "Var32", "Var33", "Var34", "Var35", "Var36", "AmmoniaM"];
opts.SelectedVariableNames = ["Date", "Time", "SampleDepthm", "IFCBDepthm", "Dino_cellsL", "Mesodinium_cellsL", "Acum", "Fort", "Norv", "Odio", "Rotu", "Parv", "Acut", "AmmoniaM"];
opts.VariableTypes = ["datetime", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "double"];
opts = setvaropts(opts, ["Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var19", "Var20", "Var21", "Var22", "Var23", "Var32", "Var33", "Var34", "Var35", "Var36"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var19", "Var20", "Var21", "Var22", "Var23", "Var32", "Var33", "Var34", "Var35", "Var36", "AmmoniaM"], "EmptyFieldRule", "auto");
T = readtable(filename, opts, "UseExcel", false);
clearvars opts

T.DinoML_micro=.001*T.Dino_cellsL;
T.MesoML_micro=.001*T.Mesodinium_cellsL;

T.DAcumML=.001*T.Acum;
T.DFortML=.001*T.Fort;
T.DNorvML=.001*T.Norv;
T.DOdioML=.001*T.Odio;
T.DParvML=.001*T.Parv;
T.DAcutML=.001*T.Acut;

T.Time=datetime(T.Time,'ConvertFrom','datenum','Format','HH:mm:ss');
T.Time(isnat(T.Time))=datetime(11,00,00); % add 11am if no time available
T.dt=T.Date+timeofday(T.Time);

T=movevars(T,'dt','Before','Date');

T=removevars(T,{'Time','Date','Acum','Rotu','Fort','Norv','Odio','Parv','Acut','Dino_cellsL','Mesodinium_cellsL'});

idx=find(T.dt==datetime('02-Jun-2021 10:45:00'));
T(idx(2),:)=[]; %remove duplicate data point on 2 June 2021

T.dt=datetime(T.dt,'Format','dd-MMM-yyyy HH:mm:ss')+hours(8); %input was PDT, convert to UTC;
TT=table2timetable(T);

save([filepath 'DinophysisMicroscopy_BI'],'TT');