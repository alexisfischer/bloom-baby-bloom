function [phytoTotal,dino,diat,nano,zoop,carbonml,class2useTB,mdate] = extract_daily_carbon(biovol_path)
%% Process and extract daily phytoplankton-specific carbon for each year at SCW
%  Alexis D. Fischer June 2019

%%%% example inputs
%biovol_path = '~/MATLAB/bloom-baby-bloom/SCW/Data/IFCB_summary/class/summary_biovol_allTB2017';

load(biovol_path,'class2useTB','classcountTB','classbiovolTB','ml_analyzedTB','mdateTB');

% convert to PST (UTC is 7 hrs ahead)
time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
time.TimeZone='America/Los_Angeles'; mdateTB=datenum(time);
 
%%%% Step 1: eliminate bad data 
total=NaN*ones(size(mdateTB)); % eliminate samples where tina was likely not taking in new samples
for i=1:length(mdateTB)
    total(i)=sum(classcountTB(i,:)); %find number of triggers/sample
end
idx=find(total<=140); mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classbiovolTB(idx,:)=[];

idx=find(mdateTB>=datenum('25-Oct-2018') & mdateTB<=datenum('07-Nov-2018')); % eliminate other bad data
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classbiovolTB(idx,:)=[];
idx=find(mdateTB>=datenum('16-Aug-2018') & mdateTB<=datenum('20-Aug-2018')); 
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classbiovolTB(idx,:)=[];
idx=find(mdateTB>=datenum('04-Aug-2018') & mdateTB<=datenum('06-Aug-2018')); 
mdateTB(idx)=[]; ml_analyzedTB(idx)=[]; classbiovolTB(idx,:)=[];

%%%% Step 2: take daily average
[mdate, ml_analyzed ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
classbiovol=NaN*ones(366,length(class2useTB));
for i=1:length(class2useTB)
    [mdate, classbiovol(:,i) ] = timeseries2ydmat(mdateTB, classbiovolTB(:,i));
end
    
%%%% Step 3: Convert Biovolume (cubic microns/cell) to carbonml (picograms/cell)
[ind_diatom,~] = get_diatom_ind_CA(class2useTB,class2useTB); %select all classified cells
[cellC] = biovol2carbon(classbiovol,ind_diatom); 
carbonml=NaN*cellC;
for i=1:length(cellC)
    carbonml(i,:)=.001*(cellC(i,:)./ml_analyzed(i)); %convert from pg/cell to pg/mL to ug/L 
end  

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
            max3=maxk(round(carbonml(itime(i).dn,j)),2);
            r=randi([min(round(carbonml(itime(i).dn,j))) max3(end)],length(itime(i).dn),1);
            carbonml(itime(i).dn(4:end-3),j)=r(4:end-3);
        end
    end
    
else
end

%%%% Step 5: Interpolate data for small data gaps 
    for i=1:length(class2useTB) 
        carbonml(:,i) = interp1babygap(carbonml(:,i),3); 
    end

%%%% Step 6: find daily fraction of each group
[ind_phyto,~] = get_phyto_ind_CA(class2useTB,class2useTB); %select all classified cells
[ind_dino,~] = get_dino_ind_CA(class2useTB,class2useTB); %select all classified cells
[ind_nano,~] = get_nano_ind_CA(class2useTB,class2useTB); %select all classified cells
[ind_zoop,~] = get_zoop_ind_CA(class2useTB,class2useTB); %select all classified cells

dino = sum(carbonml(:,ind_dino),2);
diat = sum(carbonml(:,ind_diatom),2);
nano = sum(carbonml(:,ind_nano),2);
zoop = sum(carbonml(:,ind_zoop),2);
phytoTotal = sum(carbonml(:,ind_phyto),2);

clearvars time idx i j max3 mdateTB classbiovolTB classbiovol classcountTB cellC...
    ml_analyzedTB ml_analyzed itime n r ind_cell ind_dino ind_diatom ind_nano

end
     