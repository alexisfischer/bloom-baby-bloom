%% find IFCB sampling boundary on Shimada
clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

%% 2019
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'dt','lat','lon','class2useTB','cellsmL');
data=cellsmL(:,strcmp('Pseudonitzschia',class2useTB));

    idx=find(dt<datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  

    % Set grid resolution (degrees)
    res = 0.18; % Coarser=0.2; Finer=0.1
    
    % Create grid
    lon_grid = min(lon):res:max(lon)+.5;
    lat_grid = min(lat):res:max(lat)+.5;
    nx = length(lon_grid);
    ny = length(lat_grid);
    
    % Average data on grid
    data_grid = nan(nx,ny);
    for ii = 1:nx
        for jj = 1:ny
            data_grid(ii,jj) = mean(data(lon>=lon_grid(ii)-res/2 & lon<lon_grid(ii)+res/2 & lat>=lat_grid(jj)-res/2 & lat<lat_grid(jj)+res/2),'omitnan');
        end
    end
    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);

    % find boundary
    for i=1:length(data_grid)
        id1=find(~isnan(data_grid(:,i)),1);
        id3=find(~isnan(data_grid(:,i)),1,'last');        
        if isempty(id1)
        else
            lat1(i)=lat_plot(id1,i);
            lon1(i)=lon_plot(id1,i);
        end
        if isempty(id3)
        else
            lat3(i)=lat_plot(id3,i);
            lon3(i)=lon_plot(id3,i);
        end        
    end
    lon1=flipud(smooth(lon1,.3)-.15); lon1(32:40)=lon1(32:40)-.05; lon1(35:39)=lon1(35:39)-.1;    
    lat1=flipud(lat1');

    lon3=smooth(lon3,.3)+.15; lat3=lat3';
    lat3(end+1)=lat1(1)+.1; lon3(end+1)=lon3(end)-.3;    
    lat3(end+1)=lat1(1); lon3(end+1)=lon1(1);
    bndry19.lon=[lon1;lon3]; bndry19.lat=[lat1;lat3];

clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res...
lat1 lat3 9 id1 id3 idx lon1 lon3 i cellsmL class2useTB data dt lat lon
     
%% 2021
load([filepath 'NOAA/Shimada/Data/summary_19-21Hake_4nicheanalysis.mat'],'dt','lat','lon','class2useTB','cellsmL');
data=cellsmL(:,strcmp('Pseudonitzschia',class2useTB));

    idx=find(dt>datetime('01-Jan-2020'));
    data=data(idx); lat = lat(idx); lon = lon(idx);  

    % Set grid resolution (degrees)
    res = 0.18; % Coarser=0.2; Finer=0.1
    
    % Create grid
    lon_grid = min(lon):res:max(lon)+.5;
    lat_grid = min(lat):res:max(lat)+.5;
    nx = length(lon_grid);
    ny = length(lat_grid);
    
    % Average data on grid
    data_grid = nan(nx,ny);
    for ii = 1:nx
        for jj = 1:ny
            data_grid(ii,jj) = mean(data(lon>=lon_grid(ii)-res/2 & lon<lon_grid(ii)+res/2 & lat>=lat_grid(jj)-res/2 & lat<lat_grid(jj)+res/2),'omitnan');
        end
    end
    
    [lat_plot,lon_plot] = meshgrid(lat_grid,lon_grid);
    % find boundary
    for i=1:length(data_grid)
        id1=find(~isnan(data_grid(:,i)),1);
        id3=find(~isnan(data_grid(:,i)),1,'last');        
        if isempty(id1)
        else
            lat1(i)=lat_plot(id1,i);
            lon1(i)=lon_plot(id1,i);
        end
        if isempty(id3)
        else
            lat3(i)=lat_plot(id3,i);
            lon3(i)=lon_plot(id3,i);
        end        
    end
    lon1=flipud(smooth(lon1,.3)-.15); %lon1(32:40)=lon1(32:40)-.05; lon1(35:39)=lon1(35:39)-.1;    
    lat1=flipud(lat1'); lat1(end)=lat1(end)-.1;

    lon3=smooth(lon3,.3)+.15; lat3=lat3';
    lat3(end+1)=lat1(1); lon3(end+1)=lon1(1);
    bndry21.lon=[lon1;lon3]; bndry21.lat=[lat1;lat3];
    
clearvars lat_plot lon_plot ii jj nx ny lon_grid lat_grid data_grid res...
lat1 lat3 9 id1 id3 idx lon1 lon3 i cellsmL class2useTB data dt lat lon 
    %%
    save([filepath 'NOAA/Shimada/Data/samplingboundary_Shimada'],'bndry19','bndry21');
