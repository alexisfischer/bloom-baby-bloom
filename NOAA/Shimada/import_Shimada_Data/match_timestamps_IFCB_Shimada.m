function [idI,idS] = match_timestamps_IFCB_Shimada(dtI,DT)
%% find lat lon coordinates of each IFCB sample on 2021 Shimada cruise GPS data
% match IFCB timestamps with underway timestamps 
% inputs need to be in datetime
% dtI = IFCB time
% DT = Shiptime
% Alexis D. Fischer, NWFSC, May 2022

dtI.Format='yyyy-MM-dd HH:mm:ss';        
DT.Format='yyyy-MM-dd HH:mm:ss';        

idS=NaN*ones(size(dtI));
for i=1:length(dtI)
    ia=find(dtI(i)==DT,1);
    if isempty(ia)
        ib=find(dtI(i)<=DT,1);
        ic=find(dtI(i)>=DT,1);
        d1=abs(minus(dtI(i),DT(ib))); %find difference
        d2=abs(minus(dtI(i),DT(ic)));
        if d1<d2
            disp('prior underway coordinate')
            idS(i)=ib;
        elseif d1>d2
            disp('next underway coordinate')            
            idS(i)=ic;
        end
    else
        disp('perfect match w an underway coordinate')
        idS(i)=ia;
    end
    disp(dtI(i));

    clearvars ia ib ic d1 d2
end

idI=isnan(idS); idS(idI)=[];

%latI=LAT(idS);
%lonI=LON(idS);
%tempI=TEMP(idS);
%save([filepath 'NOAA/Shimada/Data/IFCB_underway_Shimada2021'],'dtI','lonI','latI','tempI','filelistTB');
end
