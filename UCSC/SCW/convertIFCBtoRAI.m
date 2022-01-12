function [rai_car,rai_fx] = convertIFCBtoRAI(phytoTotal,carbonml)
%% convertIFCBtoRAI converts IFCB carbon data to RAI scores

%convert data into fraction of carbon
fx=carbonml./phytoTotal;

%convert that fraction to RAI (min values)
rai=fx; rai(rai>=0 & rai<.01)=0; rai(rai>=.01 & rai<.1)=1; rai(rai>=.1 & rai<.5)=10; rai(rai>=.5 & rai<1)=50; 

%normalize data based on total RAI score
total=sum(rai,2); rai_fx=rai./total;

%multiply by carbon
rai_car=rai_fx.*phytoTotal;

end

