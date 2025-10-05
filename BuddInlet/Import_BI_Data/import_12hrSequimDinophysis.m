%% Import data from Sequim Bay 12 hr Dinophysis study
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/';
filename=[filepath 'Sequim_12hr_dinophysis.xlsx'];

%%%% import tide
opts = spreadsheetImportOptions("NumVariables", 6);
opts.Sheet = "tide";
opts.DataRange = "A2:F106";
opts.VariableNames = ["Var1", "Var2", "Var3", "dt", "Var5", "Heightm"];
opts.SelectedVariableNames = ["dt", "Heightm"];
opts.VariableTypes = ["char", "char", "char", "datetime", "char", "double"];
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var5"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var5"], "EmptyFieldRule", "auto");
Tide = readtable(filename, opts, "UseExcel", false);
Tide.time=timeofday(Tide.dt);
Tide.time.Format = 'hh:mm';
clear opts

%%%% import D.acuminata cell counts
opts = spreadsheetImportOptions("NumVariables", 13);
opts.Sheet = "cells";
opts.DataRange = "A3:M7";
opts.VariableNames = ["Var1", "Var2", "dt", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "M4", "M5", "M6", "M7"];
opts.SelectedVariableNames = ["dt", "M4", "M5", "M6", "M7"];
opts.VariableTypes = ["char", "char", "datetime", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double"];
opts = setvaropts(opts, ["Var1", "Var2", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9"], "EmptyFieldRule", "auto");
Dino = readtable(filename, opts, "UseExcel", false);
clear opts spreadsheet
Dino = renamevars(Dino, ["M4", "M5", "M6", "M7"],["D0m", "D05m", "D15m", "D25m"]);
Dino.time=timeofday(Dino.dt);
Dino.time.Format = 'hh:mm';
Dino.D0m=Dino.D0m*.1; %10x concentrated adjustment
Dino.D05m=Dino.D05m*.1; %10x concentrated adjustment
Dino.D15m=Dino.D15m*.1; %10x concentrated adjustment
Dino.D25m=Dino.D25m*.1; %10x concentrated adjustment

%%%% import CTD
opts = spreadsheetImportOptions("NumVariables", 9);
opts.Sheet = "CTD";
opts.DataRange = "A2:I233";
opts.VariableNames = ["dt", "TempC", "Var3", "SalPpt", "DepthMeters", "Var6", "Var7", "ChlUgL", "ChlRFU"];
opts.SelectedVariableNames = ["dt", "TempC", "SalPpt", "DepthMeters", "ChlUgL", "ChlRFU"];
opts.VariableTypes = ["datetime", "double", "char", "double", "double", "char", "char", "double", "double"];
opts = setvaropts(opts, ["Var3", "Var6", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var3", "Var6", "Var7"], "EmptyFieldRule", "auto");
CTD = readtable(filename, opts, "UseExcel", false);
clear opts

%process CTD data
lat=47.04571;
interval=.25;
edges=(0:interval:4)'; 
CTD.DepthMeters(CTD.DepthMeters<0)=0;%remove negative values
ind=discretize(CTD.DepthMeters,edges);

z=edges; %depth
p=gsw_p_from_z(-edges,lat); %calculate pressure from height
t = accumarray(ind,CTD.TempC,[length(edges) 1],@mean,NaN);
s = accumarray(ind,CTD.SalPpt,[length(edges) 1],@mean,NaN);
fl = accumarray(ind,CTD.ChlRFU,[length(edges) 1],@mean,NaN);
chl = accumarray(ind,CTD.ChlUgL,[length(edges) 1],@mean,NaN);

%interpolate data gaps and smooth for a 2m running mean
iend=find(~isnan(t),1,'last');
fl(1:iend)=smooth(fillmissing(fl(1:iend),'linear'),2/interval); 
chl(1:iend)=smooth(fillmissing(chl(1:iend),'linear'),2/interval); 
t(1:iend)=smooth(fillmissing(t(1:iend),'linear'),1/interval); 
s(1:iend)=smooth(fillmissing(s(1:iend),'linear'),1/interval);
[SA,~]= gsw_SA_from_SP(s,p,-122.90702,lat);    
CT=gsw_CT_from_t(SA,t,p);
rho=smooth(gsw_rho(SA,CT,p),1.5/interval); %in-situ density  [ kg m^-3 ]
sigmat=rho-1000; %'Sigma-t' is rho minus 1000
rho_m=[NaN;diff(rho)./diff(z)];   

dt=CTD.dt(1);
S=table(edges,fl,chl,t,s,SA,CT,rho,rho_m,sigmat);
S = renamevars(S,"edges","z");
S(isnan(S.t),:)=[]; %remove nans


save([filepath 'Sequim_12hr'],'Tide','Dino','S','dt');













