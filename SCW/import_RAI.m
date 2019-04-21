%% import RAI data from SCW
% Alexis D. Fischer, March 2019

outdir='/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/';

% 2002-2017
filename ='~/Documents/UCSC_research/SCW_Dino_Project/Data/RAIdata_042417_RR_KH.xlsx';
opts = spreadsheetImportOptions("NumVariables", 70);
opts.Sheet = "KendraCalculation";
opts.DataRange = "A3:BR2033";

% Specify column names and types
opts.VariableNames = ["Date", "VarName2", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Var24", "Var25", "Var26", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Var64", "Var65", "Var66", "Var67", "Var68", "Dino", "Diat"];
opts.SelectedVariableNames = ["Date", "VarName2", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Dino", "Diat"];
opts.VariableTypes = ["datetime", "categorical", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "string", "string", "double", "double"];
opts = setvaropts(opts, [24, 25, 26, 64, 65, 66, 67, 68], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 24, 25, 26, 64, 65, 66, 67, 68], "EmptyFieldRule", "auto");

% Import the data
T = readtable(filename, opts, "UseExcel", false);
class=opts.SelectedVariableNames(3:end); 
dnn=datenum(T.Date); dn=dnn(1:3:end);

% take the 3rd line, and then convert to matrix
rai = table2array(T((1:3:end),3:end)); 
dino=rai(:,end-1);
diat=rai(:,end);
rai=rai(:,1:end-2);

min=rai; min(min==1) = 0; min(min==2) = 1; min(min==3) = 10; min(min==4) = 50;
avg=rai; avg(avg==1) = .5; avg(avg==2) = 5; avg(avg==3) = 30; avg(avg==4) = 75;
max=rai; max(max==1) = .9; max(max==2) = 9; max(max==3) = 49; max(max==4) = 100;

% % find daily fraction of biomass
% dailysum=NaN*ones(length(rai),1);
% fxx=NaN*ones(size(rai));
% std=NaN*ones(size(rai));
% 
% for i=1:length(avg)
%     dailysum(i) = nansum(avg(i,:));
%     fxx(i,:)=avg(i,:)./dailysum(i);
%     std(i,:)=(max(i,:)-min(i,:))./dailysum(i);
% end

% fx=[fxx,Dino,Diat];

clearvars dailysum rai dnn T D opts i filename

% 2017-present

filename="/Users/afischer/Documents/UCSC_research/SCW_Dino_Project/Data/SCW_RAI_190410.xls";

opts = spreadsheetImportOptions("NumVariables", 85);
opts.Sheet = "SCW RAI_Leica";
opts.DataRange = "A4:CG593";

% Specify column names and types
opts.VariableNames = ["Var1", "Month", "Day", "Year", "Var5", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Var64", "Var65", "Var66", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var76", "Var77", "Var78", "Var79", "Var80", "Var81", "Var82", "Var83", "Dino1", "Diat1"];
opts.SelectedVariableNames = ["Month", "Day", "Year", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Dino1", "Diat1"];
opts.VariableTypes = ["string", "double", "double", "double", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "string", "double", "double"];
opts = setvaropts(opts, [1, 5, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 5, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83], "EmptyFieldRule", "auto");

% Import the data
T = readtable(filename, opts, "UseExcel", false);
%class=opts.SelectedVariableNames(2:end); 

dni=datenum(datetime(T.Year,T.Month,T.Day));

% take the 3rd line, and then convert to matrix
rai = table2array(T(:,4:end)); 
dinoi=rai(:,end-1);
diati=rai(:,end);
rai=rai(:,1:end-2);

mini=rai; mini(mini==1) = 0; mini(mini==2) = 1; mini(mini==3) = 10; mini(mini==4) = 50;
avgi=rai; avgi(avgi==1) = .5; avgi(avgi==2) = 5; avgi(avgi==3) = 30; avgi(avgi==4) = 75;
maxi=rai; maxi(maxi==1) = .9; maxi(maxi==2) = 9; maxi(maxi==3) = 49; maxi(maxi==4) = 100;

clearvars dailysum rai dnn T D opts i filename

% find overlapping points
idx = find(dni>dn(end),1); %id for where the points overlap
DN = [dn;dni(idx:end)]; 
MAX = [max;maxi(idx:end,:)];   
AVG = [avg;avgi(idx:end,:)];   
MIN = [min;mini(idx:end,:)];   

DINO = [dino;dinoi(idx:end,:)];   
DIAT = [diat;diati(idx:end,:)];   

id=strmatch('Pseudonitzschia',class);
class(id)={'Pseudo-nitzschia'};

id=strmatch('Scripsiella',class);
class(id)={'Scrippsiella'};

save([outdir 'Data/RAI'],'DN','MAX','AVG','MIN','class','DINO','DIAT');
