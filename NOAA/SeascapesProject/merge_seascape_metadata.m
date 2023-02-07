%% Create file of filename, lat, lon, timestamp, seascape, instrument# 
clear;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/SeascapesProject/'; %USER
addpath(genpath(filepath)); 

S=load([filepath 'Data/OSU_seascape_Sep2018']);
M=load([filepath 'Data/OSU_seascape_May2019']);
load([filepath 'Data/SCAPES_NOAA_UCSC']); NOAA.dt(4486:end)=[]; %remove extras

L=(length(S.META)+length(M.META));

dt1=datetime(S.META(:,1),S.META(:,2),S.META(:,3),S.META(:,4),S.META(:,5),S.META(:,6),'Format','yyyy-MM-dd HH:mm:ss');
dt2=datetime(M.META(:,1),M.META(:,2),M.META(:,3),M.META(:,4),M.META(:,5),M.META(:,6),'Format','yyyy-MM-dd HH:mm:ss');
dt=[NOAA.dt;UCSC.dt;dt1;dt2];

filename1=cellfun(@(x) ['D' x(1:4) x(6:7) x(9:10) 'T' x(12:13) x(15:16) x(18:19) '_IFCB122'],cellstr(string([dt1;dt2])),'UniformOutput',false);
filename2=[NOAA.filelist;UCSC.filelist;filename1];
filename=cellfun(@(x) [x '.mat'],cellstr(filename2),'UniformOutput',false);

%%
lat=[NOAA.lat;UCSC.lat;S.META(:,7);M.META(:,7)];
lon=[NOAA.lon;UCSC.lon;S.META(:,8);M.META(:,8)];

group1=repmat({'NOAA'},length(NOAA.dt),1);
group2=repmat({'UCSC'},length(UCSC.dt),1);
group3=repmat({'OSU'},L,1);
group=[group1;group2;group3];

ifcb=cellfun(@(x),cellfun(@(x) x(end-6:end-4),filename,'UniformOutput',false));

ss=[SSOUT8NWFSC_5km;SSOUT8UCSC_10km;S.SS8out;M.SS8out];
% ssM=NaN*ss8;
% ssM(end-L+1:end)=[S.SSMout;M.SSMout];

clearvars L S M filename1 ifcb1 ifcb2 group1 group2 group3 dt1 dt2 SSOUT8UCSC_10km SSOUT8UCSC_20km SSOUT8NWFSC_5km NOAA UCSC

S=table(dt,lat,lon,ss,ifcb,group,filename);
idx=isnan(ss); S(idx,:)=[]; %remote the SS nans

S = sortrows(S,'ss','ascend');

save([filepath 'Data/SeascapeSummary_NOAA-OSU-UCSC'],'S');

%% group by group
[gc,ss]=groupcounts(S.ss);
topSS=ss(gc>200); %find top seascapes, 200 occurences

% summarize each dataset
N=table(ss,gc); N.gc=NaN*N.gc; O=N; U=N;
for i=1:length(ss)
    idx=find((S.ss==N.ss(i)) & strcmp(S.group,{'NOAA'}));
    N.gc(i)=numel(idx);
end
for i=1:length(ss)
    idx=find((S.ss==O.ss(i)) & strcmp(S.group,{'OSU'}));
    O.gc(i)=numel(idx);
end
for i=1:length(ss)
    idx=find((S.ss==U.ss(i)) & strcmp(S.group,{'UCSC'}));
    U.gc(i)=numel(idx);
end

clearvars dt filename group ifcb lat lon ss idx i gc topSS

%% plot
figure('Units','inches','Position',[1 1 7 4],'PaperPositionMode','auto');
col=[(brewermap(3,'Set2'));[.1 .1 .1]]; 
b = bar([N.gc O.gc U.gc],'stack','linestyle','none','Barwidth',.7);
for i=1:3
    set(b(i),'FaceColor',col(i,:));
end  
set(gca,'xticklabel',ss,'tickdir','out');
xlabel('Seascape')
ylabel('IFCB files')
lh=legend('NWFSC dataset','OSU training set','UCSC training set','Location','NorthOutside');

set(gcf,'color','w');
print(gcf,'-dpng','-r100',[filepath 'Figs/SeascapeImages_UCSC_OSU_NWFSC.png']);
hold off


%%
figure; histogram(S.ss)
xlabel('Seascape')
ylabel('frequency')
%set(gca,'xlim',[11 28],'xtick',12:1:27);


