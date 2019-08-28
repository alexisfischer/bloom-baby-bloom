%% import RAI data from SCW
% Alexis D. Fischer, March 2019
clear;

outdir='~/MATLAB/bloom-baby-bloom/SCW/';

filename1 ="~/Documents/UCSC_research/SCW_Dino_Project/Data/RAI/SCW_RAI_2000-2004_Jester.xlsx";
filename2 ="~/Documents/UCSC_research/SCW_Dino_Project/Data/RAI/SCW_RAI_2004-2017.xlsx";
filename3="~/Documents/UCSC_research/SCW_Dino_Project/Data/RAI/SCW_RAI_2007-2019.xls";

load([outdir 'Data/SCW_master'],'SC');

%% 2000-2004 Jester

% Specify column names and types
opts = spreadsheetImportOptions("NumVariables", 63);
opts.Sheet = "new";
opts.DataRange = "A4:BK313";
opts.VariableNames = ["Var1", "Month", "Day", "Year", "Var5", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis"];
opts.SelectedVariableNames = ["Month", "Day", "Year", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis"];
opts.VariableTypes = ["char", "double", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, [1, 5], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 5], "EmptyFieldRule", "auto");

% Import the data
T = readtable(filename1, opts, "UseExcel", false);
dn1=datenum(datetime(T.Year,T.Month,T.Day));
class=opts.SelectedVariableNames(4:end); 

% only select data before 29 June 2004
idx=find(dn1>=datenum('29-June-2004'),1);
dn1=dn1(1:idx);
rai = table2array(T(1:idx,4:end)); % convert data to matrix

% convert Jester scale to modern CDPH scale
rai(rai==3.5)=3; rai(rai==2.5)=2; rai(rai==1.5)=1; rai(rai==0.5)=0;
min1=rai; min1(min1==1) = 1; min1(min1==2) = 10; min1(min1==3) = 50;
%avg1=rai; avg1(avg1==1) = 5; avg1(avg1==2) = 30; avg1(avg1==3) = 75;
%max1=rai;max1(max1==1) = 9; max1(max1==2) = 49; max1(max1==3) = 100;

% calculate average fraction dinos
total=nansum(min1,2); dino1=nansum(min1(:,1:21),2)./total;

clearvars rai T opts i filename1 idx total

%% 2004-2017
opts = spreadsheetImportOptions("NumVariables", 70);
opts.Sheet = "KendraCalculation";
opts.DataRange = "A3:BR2033";
opts.VariableNames = ["Date", "Var2", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Var24", "Var25", "Var26", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Var64", "Var65", "Var66", "Var67", "Var68", "Dino", "Diat"];
opts.SelectedVariableNames = ["Date", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Dino", "Diat"];
opts.VariableTypes = ["datetime", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "double", "double"];
opts = setvaropts(opts, 1, "InputFormat", "");
opts = setvaropts(opts, [2, 24, 25, 26, 64, 65, 66, 67, 68], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [2, 24, 25, 26, 64, 65, 66, 67, 68], "EmptyFieldRule", "auto");

% Import the data
T = readtable(filename2, opts, "UseExcel", false);
dn2=datenum(T.Date(1:3:end));  %take the 3rd line
rai = table2array(T((1:3:end),2:end)); %take the 3rd line
%class=opts.SelectedVariableNames(2:end-2); 

% only select data between 29 June 2004 and 5 Sep 2007
i0=find(dn2>=dn1(end),1); iend=find(dn2>=datenum('29-Aug-2007'),1);

dn2=dn2(i0:iend);
RAI=rai(i0:iend,:);

%Dino2=RAI(:,end-1); Diat2=RAI(:,end); 
RAI=RAI(:,1:end-2);

min2=RAI; min2(min2==1) = 1; min2(min2==2) = 1; min2(min2==3) = 10; min2(min2==4) = 50;
%avg2=RAI; avg2(avg2==1) = 5; avg2(avg2==2) = 5; avg2(avg2==3) = 30; avg2(avg2==4) = 75;
%max2=RAI; max2(max2==1) = 9; max2(max2==2) = 9; max2(max2==3) = 49; max2(max2==4) = 100;

total=nansum(min2,2); dino2=nansum(min2(:,1:21),2)./total;

clearvars rai RAI T opt dnn filename2 i0 iend

%% 2007-present
opts = spreadsheetImportOptions("NumVariables", 85);
opts.Sheet = "SCW RAI_Leica";
opts.DataRange = "A4:CG612";
opts.VariableNames = ["Var1", "Month", "Day", "Year", "Var5", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "Var64", "Var65", "Var66", "Var67", "Var68", "Var69", "Var70", "Var71", "Var72", "Var73", "Var74", "Var75", "Var76", "Var77", "Var78", "Var79", "Var80", "Var81", "Var82", "Var83", "VarName84", "VarName85"];
opts.SelectedVariableNames = ["Month", "Day", "Year", "Akashiwo", "Alexandrium", "Amylax", "Boreadinium", "Ceratium", "Cochlodinium", "Dinophysis", "Gonyaulax", "Gymnodinium", "Gyrodinium", "Heterocapsa", "Lingulodinium", "Noctiluca", "Oxyphysis", "Oxytoxum", "Polykrikos", "Prorocentrum", "Protoceratium", "Protoperidinium", "Pyrocystis", "Scripsiella", "Actinoptychus", "Amphiprora", "Asterionellopsis", "Asteromphalus", "Bacteriastrum", "Cerataulina", "Chaetoceros", "Corethron", "Coscinodiscus", "Cylindrotheca", "Dactyliosolen", "Detonula", "Ditylum", "Eucampia", "Fragilariopsis", "Guinardia", "Hemiaulus", "Lauderia", "Leptocylindrus", "Licomorpha", "Lioloma", "Lithodesmium", "Melosira", "Navicula", "Nitzschia", "Odontella", "Paralia", "Pleurosigma", "Proboscia", "Pseudonitzschia", "Rhizosolenia", "Skeletonema", "Stephanopyxis", "Thalassionema", "Thalassiosira", "Thalassiothrix", "Tropidoneis", "VarName84", "VarName85"];
opts.VariableTypes = ["char", "double", "double", "double", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "double", "double"];
opts = setvaropts(opts, [1, 5, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 5, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83], "EmptyFieldRule", "auto");

T = readtable(filename3, opts, "UseExcel", false);
dn3=datenum(datetime(T.Year,T.Month,T.Day));

% only select data after end of dn2 series
idx=find(dn3>dn2(end),1);
dn3=dn3(idx:end);
rai = table2array(T(idx:end,4:end)); % convert data to matrix

rai=rai(:,1:end-2);

min3=rai; min3(min3==1) = 1; min3(min3==2) = 1; min3(min3==3) = 10; min3(min3==4) = 50;
%avg3=rai; avg3(avg3==1) = 5; avg3(avg3==2) = 5; avg3(avg3==3) = 30; avg3(avg3==4) = 75;
%max3=rai; max3(max3==1) = 9; max3(max3==2) = 9; max3(max3==3) = 49; max3(max3==4) = 100;

total=nansum(min3,2); dino3=nansum(min3(:,1:21),2)./total;

clearvars rai dnn T idx opts filename3

%% find overlapping points
dn = [dn1;dn2;dn3]; 
min = [min1;min2;min3];   
dino = [dino1;dino2;dino3];   

id=strcmp('Pseudonitzschia',class); class(id)={'Pseudo-nitzschia'};
id=strcmp('Scripsiella',class); class(id)={'Scrippsiella'};

% delete rows w NaNs
idx=isnan(dino); dn(idx)=[]; min(idx,:)=[]; dino(idx)=[];

clearvars min1 min2 min3 dn1 dn2 dn3 id dino1 dino2 dino3 idx

%% calculate RAI for Dino 
CHL=log(SC.CHL); CHL(CHL<0)=0; DN=SC.dn; id=isnan(CHL); CHL(id)=[]; DN(id)=[]; %select non-nan chl data
id=find(DN==dn(1)); DN=DN(id:end); CHL=CHL(id:end); %start at first rai datapoint

DINOfx=stineman(dn,dino,DN); DINOfx=DINOfx'; DINOrai=CHL.*DINOfx; %dinoflagellates

%% convert fx to RAI for individual taxa
total=nansum(min,2); fx=min./total; %adjust fractions 

FX=NaN*ones(length(DN),length(class)); %preallocate
RAI=NaN*ones(length(DN),length(class));
for i=1:length(class)
    FX(:,i)=stineman(dn,fx(:,i),DN); 
    RAI(:,i)=FX(:,i).*CHL;
end

clearvars i id SC total fx

%%
save([outdir 'Data/RAI'],'DN','class','FX','RAI','DINOrai','DINOfx');
