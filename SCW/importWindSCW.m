%%
resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/wind_SCW_M1_2016_2018']);

%% M1 data

%2018 import
TIME=datenum([YY;YY1;YY2],[MM;MM1;MM2],[DD;DD1;DD2]);
WINDDIR=[WDI;WDI1;WDI2];
WINDSPEED=[RWSP;RWSP1;RWSP2];
TEMP=[WTMP;WTMP1;WTMP2];

for i=1:length(TEMP)
    if TEMP(i) == 999
        TEMP(i) = NaN;
    end
    if WINDDIR(i) == 999
        WINDDIR(i) = NaN;        
    end
    if WINDSPEED(i) == 999
        WINDSPEED(i) = NaN;        
    end    
end

[~,wdir,~] = ts_aggregation(TIME,WINDDIR,1,'day',@mean);
[~,wsp,~] = ts_aggregation(TIME,WINDSPEED,1,'day',@mean);
[dn,t,~] = ts_aggregation(TIME,TEMP,1,'day',@mean);

U=0*wsp;
V=0*wsp;
for i=1:length(wsp)
    U(i)=-wsp(i)*sin(wdir(i)*pi/180);
    V(i)=-wsp(i)*cos(wdir(i)*pi/180);
end

for i=1:length(t)
    if t(i) == 0
        t(i) = NaN;
    end 
end

M1(3).yr=2018;
M1(3).DN=dn;
M1(3).U=U;
M1(3).V=V;
M1(3).T=t;

%% M1 2016 and 2017 import
TIME=datenum(YY,MM,DD);
WINDDIR=WDI;
WINDSPEED=RWSP;
TEMP=WTMP;
    
for i=1:length(TEMP)
    if TEMP(i) == 999
        TEMP(i) = NaN;
    end
    if WINDDIR(i) == 999
        WINDDIR(i) = NaN;        
    end
    if WINDSPEED(i) == 999
        WINDSPEED(i) = NaN;        
    end    
end

[~,wdir,~] = ts_aggregation(TIME,WINDDIR,1,'day',@mean);
[~,wsp,~] = ts_aggregation(TIME,WINDSPEED,1,'day',@mean);
[dn,t,~] = ts_aggregation(TIME,TEMP,1,'day',@mean);

U=0*wsp;
V=0*wsp;
for i=1:length(wsp)
    U(i)=-wsp(i)*sin(wdir(i)*pi/180);
    V(i)=-wsp(i)*cos(wdir(i)*pi/180);
end

for i=1:length(t)
    if t(i) == 0
        t(i) = NaN;
    end 
end

M1(1).yr=2016;
M1(1).DN=dn;
M1(1).U=U;
M1(1).V=V;
M1(2).T=t;

%% SCW
[~,wdir,~] = ts_aggregation(TIME,WINDDIR,1,'day',@mean);
[dn,wsp,~] = ts_aggregation(TIME,WINDSPEED,1,'day',@mean);

wsp=wsp*0.44704; %convert from mph to m/s
U=0*wsp;
V=0*wsp;
for i=1:length(wsp)
    U(i)=-wsp(i)*sin(wdir(i)*pi/180);
    V(i)=-wsp(i)*cos(wdir(i)*pi/180);
end

SC(2).yr=2017;
SC(2).DN=dn;
SC(2).U=U;
SC(2).V=V;

