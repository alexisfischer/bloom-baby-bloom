load USwestcoast_shore;
load USwestcoast_pol;
plot(USwestcoast_shore(:,1),USwestcoast_shore(:,2),'k'); hold on;
plot(USwestcoast_pol(:,1),USwestcoast_pol(:,2),'k'); MapAspect(40)
hold on;

axis([-130 -115 30 50]);
makescale('southeast')

%1: Grays Harbor (Westport)
plot(-124-((6+(10/60))/60),46+((53+(25/60))/60),'ok'); hold on;
%2: Baker's Bay (Chinook)
plot(-123-((56+(39/60))/60),46+((16+(23/60))/60),'ok'); hold on;
%3: Astoria (Astoria)
plot(-124.080981,46.252203,'ok'); hold on;
%4: Garibaldi (Garibaldi)
plot(-123.911203,45.559817,'ok'); hold on;
%5: Newport (Newport)
plot(-124.013909,44.653307,'ok'); hold on;
%6: Winchester Bay (Winchester Bay)
plot(-124.174837,43.677061,'ok'); hold on;
%7: Coos Bay (North Bend)
plot(-124.224273,43.406505,'ok'); hold on;
%8: Port Orford (Port Orford)
plot(-124.497907,42.739417,'ok'); hold on;
%9: Brookings (Brookings)
plot(-124.284071,42.052372,'ok'); hold on;
%10: Crescent City (Crescent City)
plot(-124-((12+(02/60))/60),41+((45+(22/60))/60),'ok'); hold on;
%11: Arcata Bay (Trinidad)
plot(-124-((08+(29/60))/60),41+((03+(43/60))/60),'ok'); hold on;
%12: Fort Bragg (Fort Bragg)
plot(-123-((48+(19/60))/60),39+((26+(45/60))/60),'ok'); hold on;
%13: Bodega Bay (Bodega Bay)
plot(-123.047773,38.333049,'ok'); hold on;
%14: Half Moon Bay (El Granada)
plot(-122-((28+(06/60))/60),37+((30+(10/60))/60),'ok'); hold on;
%15: Monterey Bay (Monterey)
plot(-121-((53+(39/60))/60),36+((36+(01/60))/60),'ok'); hold on;
%16: Morro Bay (Morro Bay)
plot(-120-((51+(03/60))/60),35+((22+(39/60))/60),'ok'); hold on;














