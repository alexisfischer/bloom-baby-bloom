function [ybin,nbin,ystd]=binavg(x,xbin,y)
%
% function [ybin,nbin,ystd]=binavg(x,xbin,y);
%
% take data (y) and average it in bins of variable (x), return data (ybin)
% corresponding to xbin w/ number of data points in each bin (nbin)

% get orientation right in case matrix y
if size(y,2)~=length(x);
    y=y';
end
nj = size(y,1);

ind=bindex(x,xbin);

ybin=NaN*ones(nj,length(xbin));
nbin=zeros(nj,length(xbin));
ystd=ybin;
for i=1:length(xbin);
    for j=1:nj;
        ybin(j,i)=nanmean(y(j,ind==i));
    end
end

if nargout>1
    for i=1:length(xbin);
        for j=1:nj;
            nbin(j,i)=nansum(ind==i);
        end
    end
end
if nargout>2
    for i=1:length(xbin);
        for j=1:nj;
            ystd(:,i)=nanstd(y(j,ind==i));
        end
    end
end