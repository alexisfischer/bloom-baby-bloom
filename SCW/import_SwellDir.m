%import Mean Wave Direction

filepath='/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/';

%% Point Sur 
%%%% Import annual data 2008-2018
yr=(2008:2018)';

for i=1:length(yr)
    filename = [filepath 'Data/PointSurBuoy/PointSur_' num2str(yr(i)) '.txt'];
    
    startRow = 3;
    formatSpec = '%4f%3f%3f%3f%3f%4f%5f%5f%6f%6f%6f%4f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);

    YY = dataArray{:, 1};
    MM = dataArray{:, 2};
    DD = dataArray{:, 3};
    hh = dataArray{:, 4};
    mm = dataArray{:, 5};
    mwd = dataArray{:, 12}; 

    dnn=datenum(YY,MM,DD,hh,mm,zeros(size(YY)));
    dn=datenum(datestr(datenum(dnn),'dd-mmm-yyyy'));

    for j=1:length(dn)
        if mwd(j) == 999
            mwd(j) = NaN;        
        end 
    end
    
    [DN,MWD,~] = ts_aggregation(dn,mwd,1,'day',@mean);

    swell(i).YR=YY(end);
    swell(i).DN=DN;
    swell(i).MWD=MWD;

    clearvars ans dataArray fileID filename formatSpec hh j mm MM mwd DD...
        MWD DN dn startRow YY;
end

%%%% Combine data into single column
DN=swell(1).DN;
SWD=swell(1).MWD;

for i=2:length(swell)    
    DN=[DN;swell(i).DN];
    SWD=[SWD;swell(i).MWD];
end

%%
save([filepath 'Data/SwellDirection'],'DN','SWD');
