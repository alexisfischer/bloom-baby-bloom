clear;
% class2do_string = 'Akashiwo'; chain=1;
% class2do_string = 'Ceratium'; chain=1;
% class2do_string = 'Skeletonema'; chain=1;
% class2do_string = 'Pseudo-nitzschia'; chain=5;
% class2do_string = 'Prorocentrum';chain=1; %not great microscopy
% class2do_string = 'Scrip_Het'; chain=1; %not great

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_2018'],...
    'class2useTB','ml_analyzedTB','mdateTB','filelistTB','classcountTB_above_optthresh');
classcountTB=classcountTB_above_optthresh;
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/RAI'],'DN','MAX','AVG','MIN','class');
load([filepath 'Data/Microscopy_SCW'],'micro','genus','dnM','err');

%%%% (1) process and extract Classifier data for class of interest
% convert to PST (UTC is 7 hrs ahead)
time=datetime(mdateTB,'ConvertFrom','datenum'); time=time-hours(7); 
time.TimeZone='America/Los_Angeles'; mdateTB=datenum(time);
 
% eliminate samples where tina was likely not taking in new samples
total=NaN*ones(size(mdateTB));
for i=1:length(mdateTB)
    total(i)=sum(classcountTB(i,:)); %find number of triggers per sample
end
idx=find(total<=100); %find totals where tina was likely not taking in new samples 
mdateTB(idx)=[]; filelistTB(idx)=[]; ml_analyzedTB(idx)=[]; classcountTB(idx,:)=[];

% extract data of interest
idx = strmatch(class2do_string, class2useTB); %classifier index
y_mat=classcountTB(:,idx)./ml_analyzedTB(:); %class
y_mat((y_mat<0)) = 0; y_mat(y_mat==Inf) = NaN; %no negative or Infinite numbers
y_mat(y_mat==max(y_mat))=NaN; %remove that really high point

%%%% (2) extract Microscopy data for class of interest
idx = strmatch(class2do_string,'Scrip_Het'); %classifier index
if idx==1   
    id=strmatch('Scrippsiella',genus); %classifier index
    m1=micro(:,id); e1=err(:,id).*m1*.01;     
    id=strmatch('Heterocapsa',genus); %classifier index   
    m2=micro(:,id); e2=err(:,id).*m2*.01; 
    m=nansum([m1,m2],2); e=nansum([e1,e2],2);
else
    id=strmatch(class2do_string,genus); %classifier index
    m=micro(:,id); e=err(:,id).*m*.01;
end

%%%% (3) extract RAI class of interest
idx = strmatch(class2do_string,'Scrip_Het'); %classifier index
if idx==1    
    id=strmatch('Scrippsiella',class); %classifier index
    rai1=AVG(:,id); max1=MAX(:,id); min1=MIN(:,id); pos1=max1-rai1; neg1=rai1-min1;    
    id=strmatch('Heterocapsa',class); %classifier index   
    rai2=AVG(:,id); max2=MAX(:,id); min2=MIN(:,id); pos2=max1-rai1; neg2=rai1-min1;
    rai=nansum([rai1,rai2],2); max=nansum([max1,max2],2); min=nansum([min1,min2],2); pos=nansum([pos1,pos2],2); neg=nansum([neg1,neg2],2);
else
    id=strmatch(class2do_string,class); %classifier index
    rai=AVG(:,id); max=MAX(:,id); min=MIN(:,id); pos=max-rai; neg=rai-min;
end

%%%% (4) calculate errors for FISH
dnF=SC.dn; Pnml=SC.Pn*.001; %convert from cells/L to cells/mL
Pnml(Pnml<1)=0; %eliminate values less than 0
iD=isnan(Pnml); dnF(iD)=[]; Pnml(iD)=[]; %eliminate NaNs
n_Pn=Pnml.*10; %determine n, since 10 mLs was counted
err_Pn=200./sqrt(n_Pn); % percent error for each species (Willen, 1976, Lund et al. 1958)
%iD=find(err>=20); err_Pn(iD)=[]; dnF(iD)=[]; Pnml(iD)=[]; % restrict data to +/- 20% 
err_Pn(err_Pn==Inf)=0;

% only take data within these time periods
matdate=[datenum('14-Jan-2018'):datenum('10-Feb-2018'),...
    datenum('14-Feb-2018'):datenum('29-Apr-2018'),...
    datenum('08-May-2018'):datenum('07-Aug-2018'),...
    datenum('16-Aug-2018'):datenum('29-Nov-2018'),...
    datenum('04-Dec-2018'):datenum('31-Dec-2018')]';

[~,im,~] = intersect(DN, matdate); rai=rai(im); pos=pos(im); neg=neg(im); dnr=DN(im); %rai
[~,im,~] = intersect(dnM, matdate); M=m(im); DNm=dnM(im); ERR=e(im); %microscopy
[~,im,~] = intersect(dnF, matdate); Pnml=Pnml(im); dnF=dnF(im); err_Pn=err_Pn(im); %microscopy

iD=~isnan(SC.CHL); chl=SC.CHL(iD); dnC=SC.dn(iD); %remove NaNs
matdate=datenum('01-Jan-2018'):datenum('31-Dec-2018');
[~,im,~] = intersect(dnC, matdate); chl=chl(im); dnC=dnC(im);

clearvars class2useTB ml_analyzedTB filelistTB matdate_bin_auto...
    classcount_bin_auto ml_analyzed_mat_bin_auto im it ind id class...
    DN matdate m dnM DN classcountTB classcount filelist i j err e...
    mdate_val micro genus ml_analyzed class2use max MAX min MIN AVG

% Plot automated vs manual classification vs RAI vs FISH vs microscopy with chlorophyll!
figure('Units','inches','Position',[1 1 8 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.07], [0.11 -0.5], [0.1 0.17]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     
col=(brewermap(3,'Dark2'));

subplot(2,1,1)
    X=dnC; Y=[1,2]; C=[chl';0*chl']; cax=[0 20];
    pcolor(X,Y,C); caxis(cax); colormap(flipud(gray));
    datetick('x','m','keeplimits'); shading flat;
    set(gca,'xlim',[xax1 xax2],'ylim',[1 2],'ytick',1:1:2,...
        'xticklabel',{},'yticklabel',{},'tickdir','out'); box on
    h=colorbar('south'); 
    h.Label.String = 'Chlorophyll';
    hp=get(h,'pos'); 
    hp(1)=.73+hp(1); hp(2)=1.1*hp(2); hp(3)=.2*hp(3); hp(4)=.7*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    h.Ticks=linspace(cax(1),cax(2),3); 
    h.Label.FontSize = 11;               
    h.Label.FontWeight = 'bold';       
    hold on

subplot(2,1,2)
yyaxis left
    h1=stem(mdateTB, y_mat.*chain,'k-','Linewidth',.5,'Marker','none'); 
    hold on
    h2=errorbar(DNm,M,ERR,'*','Color',col(2,:),'Linestyle','none',...
        'MarkerFaceColor',col(2,:),'Linewidth',1,'Markersize',6); %microscopy
    ylabel(['\it' num2str(class2do_string) '\rm\bf cells mL^{-1}'],...
        'fontsize',13,'fontweight','bold');   
    limsy=get(gca,'YLim'); set(gca,'Ylim',[0 limsy(2)],'fontsize',12);    
    hold on

    idx = strmatch(class2do_string,'Pseudo-nitzschia'); %classifier index
    if idx == 1    
        h3 = errorbar(dnF,Pnml,err_Pn,'d','Linestyle','none','Linewidth',1,...
            'Color',col(3,:),'MarkerFaceColor',col(3,:),'Markersize',5); hold on  
        set(gca,'ylim',[0 250],'fontsize',12);
    else
    end
    
    set(gca,'xlim',[xax1 xax2],'fontsize',13,'tickdir','out','ycolor','k');  
    hold on

yyaxis right
    h4=errorbar(dnr,rai,neg,pos,'^','Color',col(1,:),'Linewidth',1,...
        'Linestyle','none','Markersize',4); hold on
    set(gca,'ylim',[0 100],'ytick',0:25:100,...
        'xlim',[xax1 xax2],'fontsize',12,'ycolor',col(1,:),'tickdir','out');  
    datetick('x','m','keeplimits');
    ylabel('Relative percent of cells','fontsize',13,'fontweight','bold');  
    hold on
    
    idx = strmatch(class2do_string,'Pseudo-nitzschia'); %classifier index
    if idx == 1   
        lh = legend([h1 h2 h4 h3],'Classifier','Microscopy','RAI','FISH','location','NE');
    else
        lh = legend([h1 h2 h4],'Classifier','Microscopy','RAI','location','NE');    
    end    
    set(lh,'fontsize',12,'box','off')

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Manual_automated_micro_rai_' num2str(class2do_string) '.tif']);
hold off

%% chi squared test
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat*chain); %take daily average IFCB
y_matt(isnan(y_matt))=0; Pnml(isnan(Pnml))=0; M(isnan(M))=0; rai(isnan(rai))=0;

% chi2 is the value of the chi-squared test statistic for a Pearson's chi-squared test of independence. 
% p is an approximate p-value based on the chi-squared distribution

% IFCB vs Microscopy
[~,ia,ib] = intersect(DNm,mdate_mat); x1=M(ia); x2=y_matt(ib); [tbl,chi2stat,pval] = crosstab(x1,x2)
% chi2 = 438
% p = 0.0925 
% at the 5% significance level, crosstab fails to reject the null hypothesis that table is independent in each dimension.
% therefore the data are the same

% IFCB vs FISH
[~,ia,ib] = intersect(dnF,mdate_mat); x1=Pnml(ia); x2=y_matt(ib); [tbl,chi2stat,pval] = crosstab(x1,x2)
% chi2 = 320
% p = 0.1631
% at the 5% significance level, crosstab fails to reject the null hypothesis that table is independent in each dimension.
% therefore the data are the same

% IFCB vs RAI
[~,ia,ib] = intersect(dnr,mdate_mat); x1=rai(ia); x2=y_matt(ib); [tbl,chi2stat,pval] = crosstab(x1,x2)
% chi2 = 84.9
% p = 0.4513
% at the 5% significance level, crosstab fails to reject the null hypothesis that table is independent in each dimension.
% therefore the data are the same

%FISH vs Microscopy
[~,ia,ib] = intersect(dnF,DNm); x1=Pnml(ia); x2=M(ib); [tbl,chi2stat,pval] = crosstab(x1,x2)
% chi2 = 387.3
% p = 6.9477e-21
% at the 5% significance level, crosstab rejects the null hypothesis that table is independent in each dimension.
% therefore the data are independent

%FISH vs RAI
[~,ia,ib] = intersect(dnF,dnr); x1=Pnml(ia); x2=rai(ib); [tbl,chi2stat,pval] = crosstab(x1,x2)
% chi2 = 74.7
% p = 0.0026
% at the 5% significance level, crosstab rejects the null hypothesis that table is independent in each dimension.
% therefore the data are independent

%Microscopy vs RAI
[~,ia,ib] = intersect(DNm,dnr); x1=M(ia); x2=rai(ib); [tbl,chi2stat,pval] = crosstab(x1,x2)
% chi2 = 81.5
% p = 0.0147
% at the 5% significance level, crosstab rejects the null hypothesis that table is independent in each dimension.
% therefore the data are independent


%% r2 Pseudo-nitzschia  FISH vs microscopy
figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03],[0.1 0.03], [0.2 .06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

subplot(2,1,1); % FISH vs Microscopy
[~,ia,ib] = intersect(dnF,DNm); x=Pnml(ia); y=M(ib); 
scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',12,'tickdir','out','xlim',[0 40],'xtick',0:10:40,'xticklabel',{}); box on
ylabel('Microscopy cells/mL','fontsize',14)

subplot(2,1,2); % FISH vs RAI
[~,ia,ib] = intersect(dnF,dnr); x=Pnml(ia); y=rai(ib);
scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',12,'tickdir','out','xlim',[0 40],'xtick',0:10:40); box on
ylabel('Relative percent of cells','fontsize',14)
xlabel('FISH cells/mL','fontsize',14)

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Pseudo-nitschia_FISH_micro_rai.tif']);
hold off

%% FISH vs Microscopy vs RAI vs IFCB
figure('Units','inches','Position',[1 1 3.5 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03],[0.07 0.03], [0.2 .06]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat*chain); %take daily average IFCB

subplot(3,1,1); %IFCB vs FISH
[~,ia,ib] = intersect(dnF,mdate_mat); y=Pnml(ia); x=y_matt(ib);
scatter(x,y,20,'linewidth',2); hold on
set(gca,'fontsize',12,'tickdir','out','xlim',[0 15],'xtick',0:5:15,'xticklabel',{}); box on
ylabel('FISH cells/mL','fontsize',14)

subplot(3,1,2); % IFCB vs Microscopy
[~,ia,ib] = intersect(DNm,mdate_mat); y=M(ia); x=y_matt(ib);
scatter(x,y,20,'linewidth',2); hold on
set(gca,'fontsize',12,'tickdir','out','xlim',[0 15],'xtick',0:5:15,'xticklabel',{}); box on
ylabel('Microscopy cells/mL','fontsize',14)

subplot(3,1,3); % IFCB vs RAI
[~,ia,ib] = intersect(dnr,mdate_mat); y=rai(ia); x=y_matt(ib);
scatter(x,y,20,'linewidth',2); hold on
set(gca,'fontsize',12,'tickdir','out','xlim',[0 15],'xtick',0:5:15); box on
ylabel('Relative percent of cells','fontsize',14)
xlabel('IFCB cells/mL','fontsize',14)

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Pseudo-nitschia_RAI_IFCB_FISH.tif']);
hold off

%% Probability distribution (not using)
figure('Units','inches','Position',[1 1 9 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.02 0.02],[0.17 0.03], [0.08 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat*chain); %take daily average IFCB

df=5;
subplot(1,4,1); % IFCB
ifcb=y_mat*chain; x=sort(ifcb); y = chi2pdf(x,df);

plot(x,y,'.-'); set(gca,'xlim',[0 40],'ylim',[0 .16],'tickdir','out')
xlabel('IFCB cells/mL','fontsize',14)
ylabel('Probability Density (df = 5)','fontsize',14)
hold on

subplot(1,4,2); %FISH
x=sort(Pnml); y = chi2pdf(x,df);
plot(x,y,'.-','Markersize',10); set(gca,'xlim',[0 40],'ylim',[0 .16],'tickdir','out','yticklabel',{})
xlabel('FISH cells/mL','fontsize',14)
hold on

subplot(1,4,3); % Microscopy
x=sort(M); y = chi2pdf(x,df); 
plot(x,y,'.-','Markersize',10); set(gca,'xlim',[0 40],'ylim',[0 .16],'tickdir','out','yticklabel',{});
xlabel('Microscopy cells/mL','fontsize',14)
hold on

subplot(1,4,4); % RAI
x=sort(rai); y = chi2pdf(x,df); 
plot(x,y,'.-','Markersize',10); set(gca,'xlim',[0 40],'ylim',[0 .16],'tickdir','out','yticklabel',{})
xlabel('Relative percent of cells','fontsize',14)
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Pseudo-nitschia_Probability_density.tif']);
hold off
