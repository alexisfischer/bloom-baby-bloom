clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path

% class2do_string = 'Akashiwo'; chain=1; ymax=100; error=.9; step=25; max=100;
%class2do_string = 'Alexandrium'; chain=1;  ymax=5;  error=.6; 
% class2do_string = 'Dinophysis'; chain=1;  ymax=9.2;  error=.9; step=3; max=9;
% class2do_string = 'Ceratium'; chain=1;  ymax=16;  error=.9; step=4; max=16;
 class2do_string = 'Pseudo-nitzschia'; chain=4; ymax=75; error=.9; step=25; max=75;
% class2do_string = 'Prorocentrum';chain=1; ymax=215; error=1; 
%class2do_string = 'Cochlodinium'; chain=1; ymax=53; error=1; 

filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
[cellsmL,class2useTB,mdate] = extract_daily_cellsml([filepath 'Data/IFCB_summary/class/summary_allTB_2018']);
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/RAI'],'DN','MAX','AVG','MIN','class');
load([filepath 'Data/Microscopy_SCW'],'micro','genus','dnM','err');

%%%% (1) extract Classifier data for class of interest
y_mat=cellsmL(:,strmatch(class2do_string, class2useTB)).*chain; %class
idx=isnan(cellsmL(:,1)); y_mat(idx)=[]; mdate(idx)=[];

%%%% (2) extract Microscopy data for class of interest
m=micro(:,strmatch(class2do_string,genus)); errM=err(:,strmatch(class2do_string,genus)).*m;
idx=(errM>=error); errM(idx)=[]; m(idx)=[]; dnM(idx)=[];
idx=isnan(m); m(idx)=[]; errM(idx)=[]; dnM(idx)=[];
[~,idx,~]=intersect(dnM,mdate); m=m(idx); dnM=dnM(idx); errM=errM(idx); %microscopy   
mcrpy.dn=dnM; mcrpy.cells=m; mcrpy.err=errM.*m;

%%%% (3) extract RAI class of interest
avg=AVG(:,strmatch(class2do_string,class)); 
pos=MAX(:,strmatch(class2do_string,class))-avg; 
neg=avg-MIN(:,strmatch(class2do_string,class));
idx=isnan(avg); avg(idx)=[]; pos(idx)=[]; neg(idx)=[]; DN(idx)=[];
[~,idx,~]=intersect(DN,mdate); avg=avg(idx); pos=pos(idx); neg=neg(idx); DN=DN(idx);
rai.dn=DN; rai.avg=avg; rai.pos=pos; rai.neg=neg;

%%%% (4) calculate errors for FISH
idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1
    dnF=SC.dn;
    iPn = strmatch(class2do_string,'Pseudo-nitzschia'); %classifier index
    iAlex = strmatch(class2do_string,'Alexandrium'); %classifier index
    iDphy = strmatch(class2do_string,'Dinophysis'); %classifier index
    if iPn == 1  
        F=SC.Pn*.001; %convert from cells/L to cells/mL        
        n=F*10; %how many cells in 10mLs?
    elseif iAlex == 1
        F=SC.Alex*.001; 
        n=F*100; %how many cells in 100mLs?
    elseif iDphy == 1
        F=SC.dinophysis*.001; 
        n=F*100; %how many cells in 100mLs?
    end
    iD=isnan(F); dnF(iD)=[]; F(iD)=[]; n(iD)=[]; %eliminate NaNs
    errF=2./sqrt(n); % percent error for each species (Willen, 1976, Lund et al. 1958)    
    errF=errF.*F;
else
end

idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1
    [~,iD,~] = intersect(dnF, mdate); F=F(iD); dnF=dnF(iD); errF=errF(iD); %microscopy
    fish.dn=dnF; fish.cells=F; fish.err=errF;
else
end

idx=~isnan(SC.CHL); chl.c=SC.CHL(idx); chl.dn=SC.dn(idx); %remove NaNs

clearvars cellsmL micro idx iD n iAlex iPn iDphy AVG MIN MAX errM m dnM...
    DN avg pos neg dnF F errF micro genus class err error chain

% Plot automated vs manual classification vs RAI vs FISH vs microscopy with chlorophyll!
figure('Units','inches','Position',[1 1 8.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.11 -0.5], [0.08 0.17]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col=(brewermap(4,'Dark2'));

subplot(2,1,1)
    cax=[0 20];
    pcolor(chl.dn,[1,2],[chl.c';0*chl.c']); caxis(cax); colormap(flipud(gray));
    datetick('x','m','keeplimits'); shading flat;
    set(gca,'xlim',[xax1 xax2],'ylim',[1 2],'ytick',1:1:2,...
        'xticklabel',{},'yticklabel',{}); box on
    h=colorbar('south'); 
    hp=get(h,'pos'); 
    hp(1)=.75+hp(1); hp(2)=hp(2)+.03; hp(3)=.16*hp(3); hp(4)=hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    h.Ticks=linspace(cax(1),cax(2),3); 
    h.Label.FontSize = 11;               
    h.Label.FontWeight = 'bold';       
    hold on

subplot(2,1,2)
yyaxis left
    h1=plot(mdate, y_mat,'ko','Linewidth',1,'markersize',5); hold on
    hold on
    h2=errorbar(mcrpy.dn,mcrpy.cells,mcrpy.err,'o','Color',col(2,:),'Linestyle','none',...
        'MarkerFaceColor',col(2,:),'Linewidth',1.5,'Markersize',5); %microscopy
         set(gca,'Ylim',[0 ymax],'fontsize',12); hold on

    idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
    if idx == 1       
        h3 = errorbar(fish.dn,fish.cells,fish.err,'o','Linestyle','none','Linewidth',1.5,...
            'Color',col(4,:),'MarkerFaceColor',col(4,:),'Markersize',5); hold on  
    else
    end
    set(gca,'xlim',[xax1 xax2],'ytick',0:step:max,'fontsize',13,'ycolor','k');  
    datetick('x','m','keeplimits');

yyaxis right
    errorbar(rai.dn,rai.avg,rai.neg,rai.pos,'Color',col(1,:),'Linewidth',1.5,...
        'Linestyle','none','Markersize',5,'Capsize',0); hold on
       set(gca,'ylim',[0 100],'ytick',0:25:100,'xlim',[xax1 xax2],...
       'fontsize',12,'ycolor',col(1,:));
    datetick('x','m','keeplimits');
    ylabel({'RAI (% total cells)'},'fontsize',14);  
    hold on
    
yyaxis left
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}'],'fontsize',14);   
% 
% if idx == 1
%     lh = legend([h1 h2 h3],'Classifier','Microscopy','FISH','location','NE');
% else
%     lh = legend([h1 h2],'Classifier','Microscopy','location','NE');    
% end    
%     set(lh,'fontsize',12,'box','on')
   
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Manual_automated_micro_rai_' num2str(class2do_string) 'fish_micro.tif']);
hold off

%% chi squared test 
% chi2 is the value of the chi-squared test statistic for a Pearson's chi-squared test of independence. 
% p is an approximate p-value based on the chi-squared distribution
% at the 5% significance level, crosstab fails to reject the null hypothesis that table is independent in each dimension.
% therefore the data are the same

% IFCB vs FISH
[~,ia,ib] = intersect(fish.dn,mdate); x1=fish.cells(ia); x2=y_mat(ib); [~,chi2stat,pval] = crosstab(x1,x2)

% IFCB vs Microscopy
[~,ia,ib] = intersect(mcrpy.dn,mdate); x1=mcrpy.cells(ia); x2=y_mat(ib); [~,chi2stat,pval] = crosstab(x1,x2)

% IFCB vs RAI
[~,ia,ib] = intersect(rai.dn,mdate); x1=rai.avg(ia); x2=y_mat(ib); [~,chi2stat,pval] = crosstab(x1,x2)


%% FISH vs Microscopy vs RAI vs IFCB
figure('Units','inches','Position',[1 1 6 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03],[0.2 0.05], [0.1 .06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(1,2,1); %IFCB vs FISH
[~,ia,ib] = intersect(fish.dn,mdate); x=fish.cells(ia); y=y_mat(ib);
scatter(x,y,20,'linewidth',2); hold on
%set(gca,'fontsize',12,'tickdir','out','xlim',[0 40],'xtick',0:10:40); box on
xlabel('FISH cells/mL','fontsize',14)
ylabel('IFCB cells/mL','fontsize',14)

subplot(1,2,2); % IFCB vs Microscopy
[~,ia,ib] = intersect(mcrpy.dn,mdate); x=mcrpy.cells(ia); y=y_mat(ib);
scatter(x,y,20,'linewidth',2); hold on
%set(gca,'fontsize',12,'tickdir','out','xlim',[0 15],'xtick',0:5:15,'yticklabel',{}); box on
xlabel('Microscopy cells/mL','fontsize',14)

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Pseudo-nitschia_RAI_IFCB_FISH.tif']);
hold off

%% special PN plots
clear;
class2do_string = 'Pseudo-nitzschia'; chain=4; ymax=75; error=.9; step=25; max=75;

filepath = '~/MATLAB/bloom-baby-bloom/SCW/';
[cellsmL,class2useTB,mdate] = extract_daily_cellsml([filepath 'Data/IFCB_summary/class/summary_allTB_2018']);
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/Microscopy_SCW'],'micro','genus','dnM','err');

%%%% (1) extract Classifier data for class of interest
y_mat=cellsmL(:,strmatch(class2do_string, class2useTB)).*chain; %class
idx=isnan(cellsmL(:,1)); y_mat(idx)=[]; mdate(idx)=[];

%%%% (2) extract Microscopy data for class of interest
m=micro(:,strmatch(class2do_string,genus)); errM=err(:,strmatch(class2do_string,genus)).*m;
idx=(errM>=error); errM(idx)=[]; m(idx)=[]; dnM(idx)=[];
idx=isnan(m); m(idx)=[]; errM(idx)=[]; dnM(idx)=[];
[~,idx,~]=intersect(dnM,mdate); m=m(idx); dnM=dnM(idx); errM=errM(idx); %microscopy   
mcrpy.dn=dnM; mcrpy.cells=m; mcrpy.err=errM.*m;

%%%% (4) calculate errors for FISH
idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1
    dnF=SC.dn;
    iPn = strmatch(class2do_string,'Pseudo-nitzschia'); %classifier index
    iAlex = strmatch(class2do_string,'Alexandrium'); %classifier index
    iDphy = strmatch(class2do_string,'Dinophysis'); %classifier index
    if iPn == 1  
        F=SC.Pn*.001; %convert from cells/L to cells/mL        
        n=F*10; %how many cells in 10mLs?
    elseif iAlex == 1
        F=SC.Alex*.001; 
        n=F*100; %how many cells in 100mLs?
    elseif iDphy == 1
        F=SC.dinophysis*.001; 
        n=F*100; %how many cells in 100mLs?
    end
    iD=isnan(F); dnF(iD)=[]; F(iD)=[]; n(iD)=[]; %eliminate NaNs
    errF=2./sqrt(n); % percent error for each species (Willen, 1976, Lund et al. 1958)    
    errF=errF.*F;
else
end

idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
if idx == 1
    [~,iD,~] = intersect(dnF, mdate); F=F(iD); dnF=dnF(iD); errF=errF(iD); %microscopy
    fish.dn=dnF; fish.cells=F; fish.err=errF;
else
end

idx=~isnan(SC.CHL); chl.c=SC.CHL(idx); chl.dn=SC.dn(idx); %remove NaNs

clearvars cellsmL micro idx iD n iAlex iPn iDphy AVG MIN MAX errM m dnM...
    DN avg pos neg dnF F errF micro genus class err error chain

%%
figure('Units','inches','Position',[1 1 8.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.1 0.1], [0.11 -0.5], [0.08 0.17]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col=(brewermap(4,'Dark2'));

subplot(2,1,1)
    cax=[0 20];
    pcolor(chl.dn,[1,2],[chl.c';0*chl.c']); caxis(cax); colormap(flipud(gray));
    datetick('x','m','keeplimits'); shading flat;
    set(gca,'xlim',[xax1 xax2],'ylim',[1 2],'ytick',1:1:2,...
        'xticklabel',{},'yticklabel',{}); box on
    h=colorbar('south'); 
    hp=get(h,'pos'); 
    hp(1)=.75+hp(1); hp(2)=hp(2)+.03; hp(3)=.16*hp(3); hp(4)=hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    h.Ticks=linspace(cax(1),cax(2),3); 
    h.Label.FontSize = 11;               
    h.Label.FontWeight = 'bold';       
    hold on

subplot(2,1,2)
    h1=plot(mdate, y_mat,'ko','Linewidth',1,'markersize',5); hold on
    hold on
    h2=errorbar(mcrpy.dn,mcrpy.cells,mcrpy.err,'o','Color',col(2,:),'Linestyle','none',...
        'MarkerFaceColor',col(2,:),'Linewidth',1.5,'Markersize',5); %microscopy
         set(gca,'Ylim',[0 ymax],'fontsize',12); hold on

    idx=contains(class2do_string,{'Pseudo-nitzschia','Alexandrium','Dinophysis'});
    if idx == 1       
        h3 = errorbar(fish.dn,fish.cells,fish.err,'o','Linestyle','none','Linewidth',1.5,...
            'Color',col(4,:),'MarkerFaceColor',col(4,:),'Markersize',5); hold on  
    else
    end
    set(gca,'xlim',[xax1 xax2],'ylim',[0 max],'ytick',0:step:max,'fontsize',13,'ycolor','k');  
    datetick('x','m','keeplimits');

    ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}'],'fontsize',14);   
   
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Manual_automated_micro_rai_' num2str(class2do_string) 'fish_micro.tif']);
hold off


%% special extract Manual data for class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
idx = strmatch(class2do_string, class2use); %manual index
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] = make_day_bins(matdate(im),classcount(im,idx), ml_analyzed(im)); 
[mdate_mat_manual, y_mat_manual, yearlist, yd ] = timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); % Takes the series of day bins and puts it into a year x day matrix.
ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

% plot manual
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i).*chain,'*','Color',col(1,:),'Markersize',6,'linewidth',1);
    end