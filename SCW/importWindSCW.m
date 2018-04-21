%%
resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/wind_SCW_M1_2016_2018']);

%% M1 data

%2018 import
TIME=datenum([YY;YY1;YY2],[MM;MM1;MM2],[DD;DD1;DD2]);
WINDDIR=[WDI;WDI1;WDI2];
WINDSPEED=[RWSP;RWSP1;RWSP2];
%TEMP=[WTMP;WTMP1;WTMP2];

for i=1:length(TIME)
%     if TEMP(i) == 999
%         TEMP(i) = NaN;
%     end
    if WINDDIR(i) == 999
        WINDDIR(i) = NaN;        
    end
    if WINDSPEED(i) == 999
        WINDSPEED(i) = NaN;        
    end    
end

u=0*WINDDIR;
v=0*WINDDIR;
for i=1:length(u)
    u(i)=-WINDSPEED(i)*sin(WINDDIR(i)*pi/180);
    v(i)=-WINDSPEED(i)*cos(WINDDIR(i)*pi/180);
end

[~,U,~] = ts_aggregation(TIME,u,1,'day',@mean);
[dn,V,~] = ts_aggregation(TIME,v,1,'day',@mean);
% [dn,t,~] = ts_aggregation(TIME,TEMP,1,'day',@mean);

% for i=1:length(t)
%     if t(i) == 0
%         t(i) = NaN;
%     end 
% end

M1(3).yr=2018;
M1(3).DN=TIME;
M1(3).dn=dn;
M1(3).U=u;
M1(3).V=v;
%M1(3).T=t;

%% M1 2017 import
TIME=datenum(YY,MM,DD);
WINDDIR=WDI;
WINDSPEED=RWSP;
%TEMP=WTMP;
    
for i=1:length(TIME)
%     if TEMP(i) == 999
%         TEMP(i) = NaN;
%     end
    if WINDDIR(i) == 999
        WINDDIR(i) = NaN;        
    end
    if WINDSPEED(i) == 999
        WINDSPEED(i) = NaN;        
    end    
end

u=0*WINDDIR;
v=0*WINDDIR;
for i=1:length(u)
    u(i)=-WINDSPEED(i)*sin(WINDDIR(i)*pi/180);
    v(i)=-WINDSPEED(i)*cos(WINDDIR(i)*pi/180);
end

[~,U,~] = ts_aggregation(TIME,u,1,'day',@mean);
[dn,V,~] = ts_aggregation(TIME,v,1,'day',@mean);
%[dn,t,~] = ts_aggregation(TIME,TEMP,1,'day',@mean);

% for i=1:length(t)
%     if t(i) == 0
%         t(i) = NaN;
%     end 
% end

%M1(2).yr=2017;
M1(2).DN=TIME;
M1(2).dn=dn;
M1(2).U=u;
M1(2).V=v;
%M1(3).T=t;

%% SCW
WINDSPEED=WINDSPEED*0.44704; %convert from mph to m/s
u=0*WINDSPEED;
v=0*WINDSPEED;
for i=1:length(WINDSPEED)
    u(i)=-WINDSPEED(i)*sin(WINDDIR(i)*pi/180);
    v(i)=-WINDSPEED(i)*cos(WINDDIR(i)*pi/180);
end

[~,U,~] = ts_aggregation(TIME,u,1,'day',@mean);
[dn,V,~] = ts_aggregation(TIME,v,1,'day',@mean);

SC(2).yr=2017;
SC(2).DN=dn;
SC(2).U=U;
SC(2).V=V;
