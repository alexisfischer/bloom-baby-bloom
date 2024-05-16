%% import relationship between Deschutes River and Percival Creek discharge 
% and Capitol Lake Outflow
clear
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
filename=[filepath 'Data/DeschutesPercivalLakeOutletFlows_1997.xlsx'];

opts = spreadsheetImportOptions("NumVariables", 4);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:D7965";
opts.VariableNames = ["Date", "PercivalCfs", "DeschutesCfs", "LakeOutletCfs"];
opts.VariableTypes = ["datetime", "double", "double", "double"];
T = readtable(filename, opts, "UseExcel", false);
clear opts

figure('Units','inches','Position',[1 1 3.5 3],'PaperPositionMode','auto');
plot(T.Date, T.LakeOutletCfs,'k-'); hold on;
plot(T.Date, [T.DeschutesCfs T.PercivalCfs],'linewidth',2);
ylabel('Discharge (ft^3/s)')
legend('Lake Outlet','Deschutes R','Percival Cr')

set(gcf,'color','w');
print(gcf,'-dpng','-r200',[filepath 'Figs/BI_Deschutes_LakeOutflow.png']);
hold off
