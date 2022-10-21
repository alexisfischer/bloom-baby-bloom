function [X,Y,C] = griddata4pcolor(D,Y,F,span)
%Grids data in a matrix by a span of your choice for pcolor plotting
%D=date
%Y=depth
%F=variable
%span=duration (days) that you'd like data gridded by

[~,y_ydmat,yearlist,~]=timeseries2ydmat(D,F(:,1));
[~,mdate_wkmat,~]=ydmat2interval(y_ydmat,yearlist,span);    
X=reshape(mdate_wkmat,[size(mdate_wkmat,1)*size(mdate_wkmat,2),1]);
C=NaN*ones(length(Y),length(X)); %preallocate
for i=1:length(Y) %organize data into a week x location matrix 
    [~, y_ydmat,yearlist,~]=timeseries2ydmat(D,F(:,i));
    [y_wkmat,~,~]=ydmat2interval(y_ydmat,yearlist,span);           
    C(i,:) = reshape(y_wkmat,[length(C),1]);
    clearvars y_ydmat yearlist y_wkmat;
end

