function ann_data = monthly2annual(mon_data)

% input mon_data as <month x lat x lon> (month must be divisible by 12,
% i.e., contain whole years)
% output ann_data is <year x lat x lon>

ann_data=zeros(size(mon_data,1)/12,size(mon_data,2),size(mon_data,3));

for yr=1:(size(mon_data,1)/12)
   ann_data(yr,:,:)=mean(mon_data((yr-1)*12+1:(yr-1)*12+12,:,:),1);
end