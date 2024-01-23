%% find depth of stratification
% 
%NB:Because of smoothing used here to overcome noise in data (ie density inversions), 
%method of Fisher (unpub) has been modified so that the upper pycnocline
%must be deeper than the 5-point running average (ie STN_dpts(ss,6)>dp+smth/2)

clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

opts = delimitedTextImportOptions("NumVariables", 18);
opts.DataLines = [1, Inf];
opts.Delimiter = "\t";
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6", "VarName7", "VarName8", "NaN", "NaN1", "NaN2", "NaN3", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
HCB004 = readtable([filepath 'Data/HCB004.txt'], opts);
HCB004=table2array(HCB004); %convert from table to array

sigma1=0.1;
sigma2=0.2;
smth=5; % 5 points for smoothing
dp=1.5; %excluding depths <2m
bot=4;

%HCB004 Depth where maximum stratification occurs (i.e. pycnocline)
tt=find(HCB004(:,6)>dp);
HCB004_dpt=HCB004(tt,:);

%why do you calculate buoyancy frequency twice? N and UN
%what are these variables NDPTH and UDPTH
%HCB004_N = buoyancy frequency

%HCB004_NDPTH =??
%HCB004_UDPTH = upper pycnocline depth
%HCB004_LDPTH = lower pycnocline depth


for i=1990:2002
%    i=1995
    for j=1:12
%        j=1
        s=find(HCB004_dpt(:,4)==i & HCB004_dpt(:,2)==j);
        if max(size(s))>smth
            HCB004_dpts=HCB004_dpt(s,:); %broke into a smaller data chunk, 1 month of 1 year
            for k=1:max(size(s))-1 %dTdz calculation
                HCB004_dpts=sortrows(HCB004_dpts,6); %making sure depths are in correct oder
                HCB004_dpts(1,19)=0; % add a new column
                HCB004_dpts(k+1,19)=(HCB004_dpts(k+1,16)-HCB004_dpts(k,16))/(HCB004_dpts(k+1,6)-HCB004_dpts(k,6)); %dTdz
            end
            K=isnan(HCB004_dpts(:,19)); %if there's a nan...
            if K>0
                KK=find(K==1);
                HCB004_dpts(KK,:)=[];
            end
            HCB004_dpts(1:end-bot,19)=smooth(HCB004_dpts(1:end-bot,19),smth); %smooth dataset except for last 4 points
            ss=find(HCB004_dpts(1:end-bot,19)>sigma1); %find points that exceed density threshold
            if ss>0
                ss_s=find(HCB004_dpts(ss+1,19)>0 & HCB004_dpts(ss,6)>=dp+smth/2); %only looking at depths > 4m...why?
                if ss_s>0
                    HCB004_UDPTH(i-1989,j)=min(HCB004_dpts(ss(ss_s),6));
                    un=find(HCB004_dpts(:,6)==HCB004_UDPTH(i-1989,j));
                    HCB004_UN(i-1989,j)=sqrt((9.8/(1000+HCB004_dpts(un,16)))*HCB004_dpts(un,19))*(3600/(2*pi));
                    pp=find(HCB004_dpts(:,19)==max(HCB004_dpts(ss(ss_s),19)));
                    pp_p=find(HCB004_dpts(pp,6)>=dp+smth/2);
                    HCB004_N(i-1989,j)=sqrt((9.8/(1000+HCB004_dpts(min(pp(pp_p)),16)))*HCB004_dpts(min(pp(pp_p)),19))*(3600/(2*pi));
                    HCB004_NDPTH(i-1989,j)=HCB004_dpts(min(pp(pp_p)),6);
                else
                    HCB004_UDPTH(i-1989,j)=0;
                    HCB004_UN(i-1989,j)=0;
                    HCB004_N(i-1989,j)=0;
                    HCB004_NDPTH(i-1989,j)=0;
                end
            else
                HCB004_UDPTH(i-1989,j)=0;
                HCB004_UN(i-1989,j)=0;
                HCB004_N(i-1989,j)=0;
                HCB004_NDPTH(i-1989,j)=0;
            end
            sss=find(HCB004_dpts(1:end-bot,19)>sigma2);
            ssx=find(sss>1);
            if sss(ssx)>0 & HCB004_UDPTH(i-1989,j)>0 & HCB004_dpts(end-bot,19)<sigma2 | HCB004_dpts(end-(bot+1),19)<sigma2 & HCB004_dpts(sss(ssx)-1,19)>0
                xx=HCB004_dpts(sss(ssx),6);
                xxx=find(xx>HCB004_UDPTH(i-1989,j)+smth/2);
                if xxx>0
                    HCB004_LDPTH(i-1989,j)=xx(max(xxx));
                else
                    HCB004_LDPTH(i-1989,j)=0;
                end
            else
                HCB004_LDPTH(i-1989,j)=0;
            end
        else
            HCB004_UDPTH(i-1989,j)=NaN;
            HCB004_UN(i-1989,j)=0;
            HCB004_LDPTH(i-1989,j)=NaN;
            HCB004_N(i-1989,j)=NaN;
            HCB004_NDPTH(i-1989,j)=NaN;
        end
    end
end
 