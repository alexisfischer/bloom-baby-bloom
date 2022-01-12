function [cellsmL,class2useTB,mdate] = extract_daily_cellsml(count_path)
%% Process and extract daily phytoplankton cells/mL for each year at SCW
%  Alexis D. Fischer June 2019

%%%% example input
%count_path = '~/MATLAB/bloom-baby-bloom/SCW/Data/IFCB_summary/class/summary_allTB_2018';

load(count_path,'class2useTB','ml_analyzedTB','mdateTB','classcountTB_above_optthresh');
classcountTB=classcountTB_above_optthresh;

% convert to PST (UTC is 7 hrs ahead)
time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
time.TimeZone='America/Los_Angeles'; mdateTB=datenum(time);
 
%%%% Step 1: eliminate bad data 
total=NaN*ones(size(mdateTB)); % eliminate samples where tina was likely not taking in new samples
for i=1:length(mdateTB)
    total(i)=sum(classcountTB(i,:)); %find number of triggers/sample
end
idx=find(total<=140); mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classcountTB(idx,:)=[];

idx=find(mdateTB>=datenum('25-Oct-2018') & mdateTB<=datenum('07-Nov-2018')); % eliminate other bad data
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classcountTB(idx,:)=[];
idx=find(mdateTB>=datenum('16-Aug-2018') & mdateTB<=datenum('20-Aug-2018')); 
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classcountTB(idx,:)=[];
idx=find(mdateTB>=datenum('04-Aug-2018') & mdateTB<=datenum('06-Aug-2018')); 
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classcountTB(idx,:)=[];

cellsmL=NaN*ones(366,size(classcountTB,2));
%%%% Step 2: take daily average and convert cells to cells/mL
for i=1:length(class2useTB)
    [mdate, cellsmL(:,i) ] = timeseries2ydmat(mdateTB, classcountTB(:,i)./ml_analyzedTB);
end
cellsmL((cellsmL<0)) = 0; cellsmL(cellsmL==Inf) = NaN; %no negative or Infinite numbers

%%%% Step 4: fill specific gaps
yr=year(datetime(mdate(1),'ConvertFrom','datenum'));

if yr == 2018

    itime(1).dn=find(mdate>=datenum('27-Feb-2018') & mdate<=datenum('09-Mar-2018')); 
    itime(2).dn=find(mdate>=datenum('05-Apr-2018') & mdate<=datenum('14-Apr-2018')); 
    itime(3).dn=find(mdate>=datenum('10-Apr-2018') & mdate<=datenum('21-Apr-2018')); 
    itime(4).dn=find(mdate>=datenum('24-Aug-2018') & mdate<=datenum('27-Aug-2018')); 
    itime(5).dn=find(mdate>=datenum('16-Sep-2018') & mdate<=datenum('30-Sep-2018')); 
    for i=1:length(itime)
        for j=1:length(class2useTB) 
            max3=maxk(round(cellsmL(itime(i).dn,j)),2);
            r=randi([min(round(cellsmL(itime(i).dn,j))) max3(end)],length(itime(i).dn),1);
            cellsmL(itime(i).dn(4:end-3),j)=r(4:end-3);
        end
    end
    
else
end

%%%% Step 5: Interpolate data for small data gaps 
    for i=1:length(class2useTB) 
        cellsmL(:,i) = interp1babygap(cellsmL(:,i),3); 
    end

clearvars i j r idx itime classcountTB classcountTB_above_optthresh ...
    count_path max3 mdateTB ml_analyzedTB total time

end
     