%%merge HAB data from 2019 and 2021 Hake cruises
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';

load([filepath 'NOAA/Shimada/Data/Shimada_HAB_2019'],'HA19');
load([filepath 'NOAA/Shimada/Data/Shimada_HAB_2021'],'HA21');

%%
dt=[HA19.dt;HA21.dt];
st=[HA19.StationID;HA21.StationID];
lat=[HA19.Lat_dd;HA21.Latitude];
lon=[HA19.Lon_dd;HA21.Longitude];
chlA_ugL=[HA19.Chl_agL;HA21.chlA_ugL];
pDA_pgmL=[HA19.pDAngL;HA21.pDA_ngL];
Nitrate_uM=[HA19.NitrateM;HA21.NO3AveConcM];
Phosphate_uM=[HA19.PhosphateM;HA21.PO4AveConcM];
Silicate_uM=[HA19.SilicateM;HA21.SiAveConcM];
PN_mcrspy=[HA19.Total_PNcellsL;NaN*HA21.StationID]./1000;

%%%% take into account limit of detection
Nitrate_uM(Nitrate_uM<0.6)=.01;
Phosphate_uM(Phosphate_uM<0.6)=.01;
Silicate_uM(Silicate_uM<1.1)=.01;

%nitrate deficit relative to silicate, Si* (Si* = Si(OH)4 - NO3−) 
%Sstar=Silicate_uM./15-Nitrate_uM./16;    
%N2S=log10((Nitrate_uM./16)./(Silicate_uM./15));
S2N=log10(Silicate_uM./Nitrate_uM);
for i=1:length(Nitrate_uM)
    if Nitrate_uM(i)==.01 && Silicate_uM(i)==.01
        S2N(i)=0;                
    end
end

%idx=(dt<datetime('01-Jan-2021'));
%figure; plot(lat(idx),S2N(idx),'ro',lat(~idx),S2N(~idx),'bo'); legend('2019','2021')

%nitrate deficit relative to phosphate, P* (P* = PO43− - NO3− / 16), 
%Pstar=Phosphate_uM-Nitrate_uM./16; 
%N2P=log10((Nitrate_uM./16)./Phosphate_uM);   
P2N=log10(Phosphate_uM./(Nitrate_uM./16));   
for i=1:length(Nitrate_uM)
    if Nitrate_uM(i)==.01 && Phosphate_uM(i)==.01
        P2N(i)=0;         
    end
end
%idx=(dt<datetime('01-Jan-2021'));
%figure; plot(lat(idx),P2N(idx),'ro',lat(~idx),P2N(~idx),'bo'); legend('2019','2021')

fx_deli=[HA19.fx_deli;HA21.fx_deli];
fx_pseu=[HA19.fx_pseu;HA21.fx_pseu];
fx_heim=[HA19.fx_heim;HA21.fx_heim];
fx_pung=[HA19.fx_pung;HA21.fx_pung];
fx_mult=[HA19.fx_mult;HA21.fx_mult];
fx_frau=[HA19.fx_frau;HA21.fx_frau];
fx_aust=[HA19.fx_aust;HA21.fx_aust];

HA=table(dt,st,lat,lon,chlA_ugL,PN_mcrspy,pDA_pgmL,Nitrate_uM,Phosphate_uM,Silicate_uM,...
   S2N,P2N,fx_deli,fx_pseu,fx_heim,fx_pung,fx_mult,fx_frau,fx_aust);

save([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');
