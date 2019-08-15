function [  y_wkmat, mdate_wkmat, yd_wk ] = ydmat2interval( y_ydmat, yearlist, days)
%function [ y_wkmat, mdate_wkmat, yd_wk ] = ydmat2weeklymat( y_ydmat, yearlist )
%accept an input matrix of mean values for each yeardays by year (y_ydmat)
%output a matrix of mean values for some dayserval per year (y_wkmat) 

numyrs = length(yearlist);
mdate_year = datenum(yearlist,0,0);
yd_wk = (1:days:364)';
total=length(yd_wk);
mdate_wkmat = repmat(yd_wk,1,numyrs)+repmat(mdate_year,length(yd_wk),1);
%yeardays_all = mdate-datenum(dv(:,1),0,0);
y_wkmat = NaN(total,numyrs);
for j = 1:total-1
    ii = j*days-(days-1) : j*days;
    y_wkmat(j,:) = nanmean(y_ydmat(ii,:));
end

%include last days (or two if leap year) in final week
ii = yd_wk(end):366;
y_wkmat(j+1,:) = nanmean(y_ydmat(ii,:));
end
