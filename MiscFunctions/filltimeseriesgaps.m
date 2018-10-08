function [ MMDATE_mat, YY_mat ] = filltimeseriesgaps( mdate, y )
%function [ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( mdate, y )
%accept an input time series (vector of dates in mdate; vector of y-values
%in y) and output a matrix of mean values for each yearday by year 
% Alexis Fischer 

yd = (1:366)';
dv = datevec(mdate); 
yearlist = (dv(1,1):dv(end,1));
mdate_year = datenum(yearlist,0,0);
mdate_mat = repmat(yd,1,length(yearlist))+repmat(mdate_year,length(yd),1);
yearday_all = mdate-datenum(dv(:,1),0,0);
y_mat = NaN(size(mdate_mat));

for count = 1:length(yearlist),    
    iii = find(dv(:,1) == yearlist(count));
    for day = yd(1):yd(end),
        ii = find(floor(yearday_all(iii)) == day);
        if ~isempty(ii),
            y_mat(day,count) = nanmean(y(iii(ii)),1);
        end;
    end;
end;

Y_mat = reshape(y_mat,[],1);
MDATE_mat = reshape(mdate_mat,[],1);

t_0=find(MDATE_mat==floor(mdate(1)));
t_end=find(MDATE_mat==floor(mdate(end)));

YY_mat=Y_mat(t_0:t_end);
MMDATE_mat=MDATE_mat(t_0:t_end);

end