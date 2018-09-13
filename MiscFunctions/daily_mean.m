function [dn_acc,Data_acc] = daily_mean(dn,Data)

dv=datevec(dn);
DV=dv(:,1:3);
[~,ii,jj]=unique(DV,'rows');
Data_acc=accumarray(jj,(1:numel(jj))',[],@(x) nanmean(Data(x,:),1));
dn_acc=dn(ii);

end