%% import LOTT nutrient data

clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
fn=[filepath 'LOTT_4- 2021_10-2023.xlsx'];
opts = spreadsheetImportOptions("NumVariables", 29);
opts.DataRange = "A6:AC36";
opts.VariableNames = ["DATE", "Var2", "FLOW", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19", "NH3", "NH1", "NO3NO2", "NO3NO1", "TKN", "TKN1", "TIN", "TIN1", "TN", "TN1"];
opts.SelectedVariableNames = ["DATE", "FLOW", "NH3", "NH1", "NO3NO2", "NO3NO1", "TKN", "TKN1", "TIN", "TIN1", "TN", "TN1"];
opts.VariableTypes = ["char", "char", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, ["DATE", "Var2", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["DATE", "Var2", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "Var18", "Var19"], "EmptyFieldRule", "auto");
shts=sheetnames(fn);

dt=[];
NH3_mgL=[];
NO3NO2_mgL=[];
TKN_mgL=[];
for i=1:numel(shts)
    T=readtable(fn,opts,'Sheet',shts(i));

    T(strcmp(T.DATE,{''}),:)=[];
    dt=[dt;datetime(T.DATE,'InputFormat','MM/dd/yy')];
    NH3_mgL=[NH3_mgL;T.NH3];
    NO3NO2_mgL=[NO3NO2_mgL;T.NO3NO2];
    TKN_mgL=[TKN_mgL;T.TKN];
end

clear opts shts i T fn

save([filepath 'LOTT_nutrients'],'dt','NH3_mgL','NO3NO2_mgL','TKN_mgL');
