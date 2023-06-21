%%merge HAB data from 2019 and 2021 Hake cruises
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';

load([filepath 'NOAA/Shimada/Data/Shimada_HAB_2019'],'HA19');
load([filepath 'NOAA/Shimada/Data/Shimada_HAB_2021'],'HA21');

dt=[HA19.dt;HA21.dt];
st=[HA19.StationID;HA21.StationID];
lat=[HA19.Lat_dd;HA21.Latitude];
lon=[HA19.Lon_dd;HA21.Longitude];
chlA_ugL=[HA19.Chl_agL;HA21.chlA_ugL];
pDA_ngL=[HA19.pDAngL;HA21.pDA_ngL];
NitrateM=[HA19.NitrateM;HA21.NO3AveConcM];
PhosphateM=[HA19.PhosphateM;HA21.PO4AveConcM];
SilicateM=[HA19.SilicateM;HA21.SiAveConcM];
PNcellsmL=[HA19.Total_PNcellsL;NaN*HA21.StationID]./1000;

fx_deli=[0*HA19.StationID;HA21.fx_deli];
fx_pseu=[HA19.fx_pseu;HA21.fx_pseu];
fx_heim=[HA19.fx_heim;HA21.fx_heim];
fx_pung=[HA19.fx_pung;HA21.fx_pung];
fx_mult=[HA19.fx_mult;HA21.fx_mult];
fx_frau=[HA19.fx_frau;HA21.fx_frau];
fx_aust=[HA19.fx_aust;HA21.fx_aust];

HA=table(dt,st,lat,lon,chlA_ugL,pDA_ngL,NitrateM,PhosphateM,SilicateM,PNcellsmL,...
    fx_deli,fx_pseu,fx_heim,fx_pung,fx_mult,fx_frau,fx_aust);

save([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
