%% Import DSP data from all of Puget Sound
% A.D. Fischer, May 2024

clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath(filepath));

opts = spreadsheetImportOptions("NumVariables", 27);
opts.Sheet = "DSP";
opts.DataRange = "A2:AA25841";
opts.VariableNames = ["Var1", "Var2", "DSP", "CollectDate", "Var5", "Var6", "Waterbody", "Var8", "Var9", "SiteName", "Var11", "SiteID", "MonitoringType", "Var14", "Var15", "Var16", "Species", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "DSPTissue", "DSPResult", "DSPDate"];
opts.SelectedVariableNames = ["DSP", "CollectDate", "Waterbody", "SiteName", "SiteID", "MonitoringType", "Species", "DSPTissue", "DSPResult", "DSPDate"];
opts.VariableTypes = ["char", "char", "double", "datetime", "char", "char", "categorical", "char", "char", "categorical", "char", "categorical", "categorical", "char", "char", "char", "categorical", "char", "char", "char", "char", "char", "char", "char", "categorical", "double", "datetime"];
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var6", "Var8", "Var9", "Var11", "Var14", "Var15", "Var16", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var5", "Var6", "Waterbody", "Var8", "Var9", "SiteName", "Var11", "SiteID", "MonitoringType", "Var14", "Var15", "Var16", "Species", "Var18", "Var19", "Var20", "Var21", "Var22", "Var23", "Var24", "DSPTissue"], "EmptyFieldRule", "auto");
T = readtable("/Users/alexis.fischer/Documents/MATLAB/bloom-baby-bloom/BuddInlet/Data/DSP_2012_2023.xlsx", opts, "UseExcel", false);
%%
T(~contains(cellstr(T.Species),'Mussel'),:)=[];
%T(~contains(cellstr(T.MonitoringType),'Monitoring'),:)=[];
T(isnat(T.DSPDate),:)=[]; %remove nans
T.DSPResult(isnan(T.DSPResult))=0; %replace DSP nans with zeros (issue with importing)
[~,idx]=sort(T.DSPDate); T=T(idx,:); % sort by date

%%%% remove sites with <200 entries
[G,TID] = findgroups(T.Waterbody);
[N,~] = histcounts(G,1:1:length(TID)+1);
topgroup=TID(N>250);
for i=1:length(topgroup)
    idx=find(T.Waterbody==topgroup(i));    
    S(i).waterbody=cellstr(T.Waterbody(idx(1)));
    S(i).site=cellstr(T.SiteName(idx));
    S(i).siteID=cellstr(T.SiteID(idx));   
    S(i).dt=T.DSPDate(idx);
    S(i).month=S(i).dt.Month;     
    S(i).dsp=T.DSPResult(idx);
    S(i).csum=cumsum(S(i).dsp);
    S(i).sum=sum(S(i).dsp);
    S(i).mean=mean(S(i).dsp);    
end
[~,ia]=sort([S.sum],'descend'); S=S(ia); %order by DST levels
clearvars G TID idx N i opts 
%%
T1=timetable(S(1).dt,S(1).dsp); T1.Properties.VariableNames = S(1).waterbody; 
T2=timetable(S(2).dt,S(2).dsp); T2.Properties.VariableNames = S(2).waterbody;
T3=timetable(S(3).dt,S(3).dsp); T3.Properties.VariableNames = S(3).waterbody;
T4=timetable(S(4).dt,S(4).dsp); T4.Properties.VariableNames = S(4).waterbody; 
T5=timetable(S(5).dt,S(5).dsp); T5.Properties.VariableNames = S(5).waterbody; 
T6=timetable(S(6).dt,S(6).dsp); T6.Properties.VariableNames = S(6).waterbody;
T7=timetable(S(7).dt,S(7).dsp); T7.Properties.VariableNames = S(7).waterbody;
T8=timetable(S(8).dt,S(8).dsp); T8.Properties.VariableNames = S(8).waterbody;
T9=timetable(S(9).dt,S(9).dsp); T9.Properties.VariableNames = S(9).waterbody; 
T10=timetable(S(10).dt,S(10).dsp); T10.Properties.VariableNames = S(10).waterbody; 
T11=timetable(S(11).dt,S(11).dsp); T11.Properties.VariableNames = S(11).waterbody; 
T12=timetable(S(12).dt,S(12).dsp); T12.Properties.VariableNames = S(12).waterbody;
T13=timetable(S(13).dt,S(13).dsp); T13.Properties.VariableNames = S(13).waterbody;
T14=timetable(S(14).dt,S(14).dsp); T14.Properties.VariableNames = S(14).waterbody; 
T15=timetable(S(15).dt,S(15).dsp); T15.Properties.VariableNames = S(15).waterbody; 
T16=timetable(S(16).dt,S(16).dsp); T16.Properties.VariableNames = S(16).waterbody;
T17=timetable(S(17).dt,S(17).dsp); T17.Properties.VariableNames = S(17).waterbody;
T18=timetable(S(18).dt,S(18).dsp); T18.Properties.VariableNames = S(18).waterbody;
T19=timetable(S(19).dt,S(19).dsp); T19.Properties.VariableNames = S(19).waterbody; 
T20=timetable(S(20).dt,S(20).dsp); T20.Properties.VariableNames = S(20).waterbody; 
T21=timetable(S(21).dt,S(21).dsp); T21.Properties.VariableNames = S(21).waterbody; 
T22=timetable(S(22).dt,S(22).dsp); T22.Properties.VariableNames = S(22).waterbody;
T23=timetable(S(23).dt,S(23).dsp); T23.Properties.VariableNames = S(23).waterbody;
T24=timetable(S(24).dt,S(24).dsp); T24.Properties.VariableNames = S(24).waterbody; 

TT=synchronize(T1,T2);
TT=synchronize(TT,T3);
TT=synchronize(TT,T4);
TT=synchronize(TT,T5);
TT=synchronize(TT,T6);
TT=synchronize(TT,T7);
TT=synchronize(TT,T8);
TT=synchronize(TT,T9);
TT=synchronize(TT,T10);
TT=synchronize(TT,T11);
TT=synchronize(TT,T12);
TT=synchronize(TT,T13);
TT=synchronize(TT,T14);
TT=synchronize(TT,T15);
TT=synchronize(TT,T16);
TT=synchronize(TT,T17);
TT=synchronize(TT,T18);
TT=synchronize(TT,T19);
TT=synchronize(TT,T20);
TT=synchronize(TT,T21);
TT=synchronize(TT,T22);
TT=synchronize(TT,T23);
TT=synchronize(TT,T24);

TR=retime(TT,'monthly','mean');
TR(TR.Time<datetime('01-Jan-2014'),:)=[]; %remove data before 2014

T=table2array(TR);
[DSTsum,ib]=sort(sum(T,'omitnan'),'descend'); DSTsum=DSTsum';
siteid=topgroup(ib);
waterbody=[S(ib).waterbody]; waterbody=waterbody';

Tsum=table(waterbody,DSTsum);

clearvars topgroup TT waterbody topgroup DSTsum ia ib siteid T1 T2 T3 T4 T5 T6 T7 T8 T9 T10 T11 T12 T13 T14 T15 T16 T17 T18 T19 T20 T21 T22 T23 T24 T25

%% split data into sites of interest
D=S(ismember([S.waterbody],{'Quartermaster Harbor','Budd Inlet','Liberty Bay','Sequim Bay','Kilisut Harbor','Discovery Bay'}));

%%%% split data into months
Month=(1:1:12)';
for j=1:length(D)
    n=NaN*ones(12,1); with=n; above16=n; %avg=n; stdv=n;
    for i=1:length(Month)
        idx=D(j).month==i;
        n(i)=sum(idx);
        with(i)=sum((D(j).dsp(idx)>.18)); %0.18 ng/100g mussel tissue detection limit
        above16(i)=sum((D(j).dsp(idx)>=16));
        % avg(i)=mean(D(j).dsp(idx));        
        % stdv(i)=std(D(j).dsp(idx));             
   end
    B=table(Month,n,with,above16);
    B(:,3:end)=B(:,3:end)./B.n; %take fraction 
    S(j).table=B;   
end
QH=S(1).table; BI=S(2).table; LB=S(3).table; SB=S(4).table; MB=S(5).table;  DB=S(6).table;

%%
save([filepath 'Data/DSP_PugetSound'],'S','TR','Tsum','QH','BI','LB','SB','MB','DB');


