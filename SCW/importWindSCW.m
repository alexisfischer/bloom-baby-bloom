%%
resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/Weatherstation_SCW'],'SC');
load([resultpath 'Data/M1_buoy']);

%% Import 46042 data (2012-2017)
%change filename based off of what you are importing
ind=6;
filename = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/46042/46042_2017.txt';
startRow = 3;
formatSpec = '%4f%3f%3f%3f%3f%4f%5f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

YY = dataArray{:, 1};
MM = dataArray{:, 2};
DD = dataArray{:, 3};
hh = dataArray{:, 4};
mm = dataArray{:, 5};
WDI = dataArray{:, 6};
RWSP = dataArray{:, 7};

DN=datenum(YY,MM,DD,hh,mm,zeros(size(YY)));

for i=1:length(DN)
    if WDI(i) == 999
        WDI(i) = NaN;        
    end
    if RWSP(i) == 999
        RWSP(i) = NaN;        
    end    
end

[U,V] = UVfromDM(WDI,RWSP);

coast(ind).yr=YY(end);
coast(ind).DN=DN;
coast(ind).WINDDIR=WDI;
coast(ind).WINDSPEED=RWSP;
coast(ind).U=U;
coast(ind).V=V;

clearvars DD DGD GTIME hh mm MM RGST RWSP WDI YY U V DN i filename startRow formatSpec fileID dataArray ans;
save('/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/coastal_46042','coast');

%% Import 46042 data (2018 month by month )
%change filename based off of what you are importing
ind=7;
filename = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/46042/46042_May_2018.txt';
startRow = 3;
formatSpec = '%4f%3f%3f%3f%3f%4f%5f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

YY = dataArray{:, 1};
MM = dataArray{:, 2};
DD = dataArray{:, 3};
hh = dataArray{:, 4};
mm = dataArray{:, 5};
WDI = dataArray{:, 6};
RWSP = dataArray{:, 7};

DN=datenum(YY,MM,DD,hh,mm,zeros(size(YY)));

for i=1:length(DN)
    if WDI(i) == 999
        WDI(i) = NaN;        
    end
    if RWSP(i) == 999
        RWSP(i) = NaN;        
    end    
end

[U,V] = UVfromDM(WDI,RWSP);


%coast(ind).yr=YY(end);
coast(ind).DN=[coast(ind).DN;DN];
coast(ind).WINDDIR=[coast(ind).WINDDIR;WDI];
coast(ind).WINDSPEED=[coast(ind).WINDSPEED;RWSP];
coast(ind).U=[coast(ind).U;U];
coast(ind).V=[coast(ind).V;V];

clearvars DD DGD GTIME hh mm MM RGST RWSP WDI YY U V DN i filename startRow formatSpec fileID dataArray ans;
save('/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/coastal_46042','coast');


%% Import M1 Apr 2018 data

DN=datenum(YY,MM,DD);
Dir=WDI;
Mag=RWSP;
TEMP=WTMP;

for i=1:length(DN)
    if Dir(i) == 999
        Dir(i) = NaN;        
    end
    if Mag(i) == 999
        Mag(i) = NaN;        
    end    
end

[U,V] = UVfromDM(Dir,Mag);

% u=0*WINDDIR;
% v=0*WINDDIR;
% for i=1:length(u)
%     u(i)=-WINDSPEED(i)*sin(WINDDIR(i)*pi/180);
%     v(i)=-WINDSPEED(i)*cos(WINDDIR(i)*pi/180);
% end
% 
% [~,U,~] = ts_aggregation(TIME,u,1,'day',@mean);
% [dn,V,~] = ts_aggregation(TIME,v,1,'day',@mean);

[dn,t,~] = ts_aggregation(DN,TEMP,1,'day',@mean);

% for i=1:length(t)
%     if t(i) == 0
%         t(i) = NaN;
%     end 
% end

Um=pl66tn(U);
Vm=pl66tn(U);
 
M1(1).dn=[datenum('2016-01-01'):datenum('2016-12-30')]';
M1(2).dn=[datenum('2017-01-01'):datenum('2017-12-30')]';
M1(3).dn=[datenum('2018-01-01'):datenum('2018-05-31')]';

M1(3).DN=[M1(3).DN;DN];
M1(3).Dir=[M1(3).Dir;Dir];
M1(3).Mag=[M1(3).Mag;Mag];
M1(3).U=[M1(3).U;U];
M1(3).V=[M1(3).V;V];
M1(3).T=[M1(3).T;t];

%% Import M1 Jan, Feb, Mar
%2018 import
DN=datenum([YY;YY1;YY2],[MM;MM1;MM2],[DD;DD1;DD2]);
Dir=[WDI;WDI1;WDI2];
Mag=[RWSP;RWSP1;RWSP2];
TEMP=[WTMP;WTMP1;WTMP2];

for i=1:length(DN)
    if Dir(i) == 999
        Dir(i) = NaN;        
    end
    if Mag(i) == 999
        Mag(i) = NaN;        
    end    
end

[U,V] = UVfromDM(Dir,Mag);

% u=0*WINDDIR;
% v=0*WINDDIR;
% for i=1:length(u)
%     u(i)=-WINDSPEED(i)*sin(WINDDIR(i)*pi/180);
%     v(i)=-WINDSPEED(i)*cos(WINDDIR(i)*pi/180);
% end
% 
% [~,U,~] = ts_aggregation(TIME,u,1,'day',@mean);
% [dn,V,~] = ts_aggregation(TIME,v,1,'day',@mean);
% % [dn,t,~] = ts_aggregation(TIME,TEMP,1,'day',@mean);

% for i=1:length(t)
%     if t(i) == 0
%         t(i) = NaN;
%     end 
% end

Um=pl66tn(U);
Vm=pl66tn(U);
 
M1(3).yr=2018;
M1(3).DN=DN;
M1(3).Dir=Dir;
M1(3).Mag=Mag;
M1(3).U=U;
M1(3).V=V;
M1(3).Um=Um;
M1(3).Vm=Vm;
M1(2).T=WTMP;

M1(1).dn=[datenum('2016-01-01'):datenum('2016-12-30')]';
M1(2).dn=[datenum('2017-01-01'):datenum('2017-12-30')]';
M1(3).dn=[datenum('2018-01-01'):datenum('2018-03-31')]';


%% M1 other year import
DN=datenum(YY,MM,DD);
Dir=WDI;
Mag=RWSP;
    
for i=1:length(DN)
    if Dir(i) == 999
        Dir(i) = NaN;        
    end
    if Mag(i) == 999
        Mag(i) = NaN;        
    end    
end

[U,V] = UVfromDM(Dir,Mag);

% [~,Um,~] = ts_aggregation(DN,U,1,'day',@mean);
% [dn,Vm,~] = ts_aggregation(DN,V,1,'day',@mean);

Um=pl66tn(U);
Vm=pl66tn(U);
 
M1(2).yr=2017;
M1(2).DN=DN;
M1(2).Dir=Dir;
M1(2).Mag=Mag;
M1(2).U=U;
M1(2).V=V;
M1(2).Um=Um;
M1(2).Vm=Vm;

%% SCW

Windspeed=WINDSPEED*0.44704; %convert from mph to m/s
[U,V] = UVfromDM(WINDDIR,Windspeed);

SC(7).yr=2018;
SC(7).DN=TIME;
SC(7).WINDDIR=WINDDIR;
SC(7).WINDSPEED=Windspeed;
SC(7).U=U;
SC(7).V=V;
SC(7).PAR=PAR;
SC(7).RAINFALL=RAINFALL;
SC(7).AIRTEMP=AIRTEMP;
SC(7).BAROMETER=BAROMETER;
SC(7).DEWPOINT=DEWPOINT;
SC(7).HUMIDITY=HUMIDITY;

clearvars AIRTEMP BAROMETER DEWPOINT HUMIDITY PAR RAINFALL TIME U V WINDDIR Windspeed WINDSPEED;
save('/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/Weatherstation_SCW','SC');

%% import by monthly
DIR=WindSpeed_ms_WVc2;
[U,V] = UVfromDM(DIR,WindSpeed_ms_Avg);
TIME = datenum(datetime(RecDateTime,'InputFormat','MM/dd/yy HH:mm'));

SC(7).DN=[SC(7).DN;TIME];
SC(7).WINDDIR=[SC(7).WINDDIR;DIR];
SC(7).WINDSPEED=[SC(7).WINDSPEED;WindSpeed_ms_Avg];
SC(7).U=[SC(7).U;U];
SC(7).V=[SC(7).V;V];
SC(7).RAINFALL=[SC(7).RAINFALL;RainYearly_mm];

clearvars AIRTEMP BAROMETER DEWPOINT HUMIDITY PAR RAINFALL TIME U V WINDDIR Windspeed WINDSPEED;
save('/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/Weatherstation_SCW','SC');
