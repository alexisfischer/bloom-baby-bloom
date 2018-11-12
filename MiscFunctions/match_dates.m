function [VAR] = match_dates(dn,var,DN)
% reorganizes data according to new datenum vector
%   dn = input date
%   var = input variable
%   DN = date you want to match dn to
%   VAR = variable has been organized to correspond to DN 

VAR=NaN*DN;

for i=1:length(DN)
    for j=1:length(dn)
        if dn(j) == DN(i)
            VAR(i)=var(j);    
        else
        end
    end
end

end

