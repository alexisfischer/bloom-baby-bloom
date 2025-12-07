%% Import WA Dept Ecology Water Temperature data for Puget Sound
% https://ecology.wa.gov/footer-pages/online-tools-publications/online-tools-databases
% Budd Inlet: BUD005
% Sequim Bay: SEQ002 - 0nly 2014 data
% Discovery Bay: DIS001 - no data
% Quartermaster Harbor: QMH002- no data
% Mystery Bay - no nearby site
% Liberty Bay: POD007 - no data

clear
filepath = 'C:\Users\alexis.fischer\OneDrive - SePRO Corporation\Documents\MATLAB\bloom-baby-bloom\BuddInlet\';
addpath(genpath(filepath));
addpath(genpath('C:\Users\alexis.fischer\OneDrive - SePRO Corporation\Documents\MATLAB\bloom-baby-bloom\'));

opts = delimitedTextImportOptions("NumVariables", 30);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Study_ID", "Study_Name", "Location_ID", "Study_Specific_Location_ID", "Location_Name", "Instrument_ID", "Field_Collection_Type", "Field_Collector", "Time_Zone", "Field_Collection_Date", "Field_Collection_Time", "Field_Collection_Date_Time", "Field_Collection_Comment", "Matrix", "Source", "Depth_Value", "Depth_Value_Units", "Result_Parameter_Name", "Result_Value", "Result_Value_Units", "Result_Data_Qualifier", "Result_Method", "Result_Method_Description", "Result_Comment", "Result_Data_Review_Status", "Calculated_Latitude_Decimal_Degrees_NAD83HARN", "Calculated_Longitude_Decimal_Degrees_NAD83HARN", "Calculated_Land_Surface_Elevation_NAVD88_FT", "Record_Created_On", "Continuous_Result_System_ID"];
opts.SelectedVariableNames = ["Location_ID", "Instrument_ID", "Field_Collection_Date_Time", "Depth_Value", "Result_Value", "Calculated_Latitude_Decimal_Degrees_NAD83HARN", "Calculated_Longitude_Decimal_Degrees_NAD83HARN"];
opts.VariableTypes = ["string", "string", "categorical", "string", "string", "categorical", "string", "string", "string", "string", "string", "datetime", "string", "string", "string", "double", "string", "string", "double", "string", "string", "string", "string", "string", "string", "double", "double", "string", "string", "string"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Study_ID", "Study_Name", "Study_Specific_Location_ID", "Location_Name", "Field_Collection_Type", "Field_Collector", "Time_Zone", "Field_Collection_Date", "Field_Collection_Time", "Field_Collection_Comment", "Matrix", "Source", "Depth_Value_Units", "Result_Parameter_Name", "Result_Value_Units", "Result_Data_Qualifier", "Result_Method", "Result_Method_Description", "Result_Comment", "Result_Data_Review_Status", "Calculated_Land_Surface_Elevation_NAVD88_FT", "Record_Created_On", "Continuous_Result_System_ID"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Study_ID", "Study_Name", "Location_ID", "Study_Specific_Location_ID", "Location_Name", "Instrument_ID", "Field_Collection_Type", "Field_Collector", "Time_Zone", "Field_Collection_Date", "Field_Collection_Time", "Field_Collection_Comment", "Matrix", "Source", "Depth_Value_Units", "Result_Parameter_Name", "Result_Value_Units", "Result_Data_Qualifier", "Result_Method", "Result_Method_Description", "Result_Comment", "Result_Data_Review_Status", "Calculated_Land_Surface_Elevation_NAVD88_FT", "Record_Created_On", "Continuous_Result_System_ID"], "EmptyFieldRule", "auto");
opts = setvaropts(opts, "Field_Collection_Date_Time", "InputFormat", "MM/dd/yyyy hh:mm:ss aa", "DatetimeFormat", "preserveinput");
T = readtable([filepath 'Data\EIM_data\EIMContinuousDepthSeriesData_2025Dec07_20170.csv'], opts);

T=renamevars(T,'Location_ID','site');
T=renamevars(T,'Depth_Value','depth_m');
T=renamevars(T,'Result_Value','temp_C');
T=renamevars(T,'Calculated_Latitude_Decimal_Degrees_NAD83HARN','lat');
T=renamevars(T,'Calculated_Longitude_Decimal_Degrees_NAD83HARN','lon');
T=renamevars(T,'Field_Collection_Date_Time','dt');
T.dt=datetime(T.dt,'Format','yyyy-MM-dd');
[~,idx]=sort(T.dt); T=T(idx,:);
T(T.dt<datetime('01-Jan-2014'),:)=[]; %remove data before 2014
T(T.depth_m>3,:)=[]; %remove data deeper than 3m
T(T.site~='BUD005',:)=[]; %remove everything that's not BUD005
%% averag
dailyAvg = varfun(@mean,T,"InputVariables","temp_C","GroupingVariables","dt");

DR=timetable(T.dt,T.depth_m,T.temp_C,);

DR=retime(DR,'daily');


% % testing
% figure
% idx=find(T.depth_m<=3);
% h2= scatter(T.dt(idx),T.temp_C(idx)); hold on;
% %legend([h1, h2],'all','shallow')

%% Clear temporary variables
clear opts