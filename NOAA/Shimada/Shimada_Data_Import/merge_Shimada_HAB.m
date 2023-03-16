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
fx_Paustralis=[HA19.Paustralis;NaN*HA21.StationID];
fx_Pmultiseries=[HA19.Pmultiseries;NaN*HA21.StationID];
fx_Pfraudulenta=[HA19.Pfraudulenta;NaN*HA21.StationID];
fx_Pseriata=[HA19.Pseriata;NaN*HA21.StationID];
fx_Ppseudodelicatissima=[HA19.Ppseudodelicatissima;NaN*HA21.StationID];
fx_Pheimii=[HA19.Pheimii;NaN*HA21.StationID];
fx_Pcuspidata=[HA19.Pcuspidata;NaN*HA21.StationID];
fx_Ppungens=[HA19.Ppungens;NaN*HA21.StationID];

HA=table(dt,st,lat,lon,chlA_ugL,pDA_ngL,NitrateM,PhosphateM,SilicateM,PNcellsmL,...
    fx_Paustralis,fx_Pmultiseries,fx_Pfraudulenta,fx_Pseriata,...
    fx_Ppseudodelicatissima,fx_Pheimii,fx_Pcuspidata,fx_Ppungens);

save([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
