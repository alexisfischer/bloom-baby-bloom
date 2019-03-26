
%class2do_string = 'Akashiwo';
%class2do_string = 'Ceratium';  
% class2do_string = 'Dinophysis';
% class2do_string = 'Prorocentrum'; 
% class2do_string = 'Chaetoceros'; 
% class2do_string = 'Cochlodinium';
% class2do_string = 'Thalassiosira'; 
% class2do_string = 'Skeletonema';
class2do_string = 'Pseudo-nitzschia';

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_2018'],...
    'classcountTB','filelistTB','ml_analyzedTB','mdateTB','class2useTB'); 
load([filepath 'Data/IFCB_summary/manual/count_manual_05Feb2019']); 
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/RAI'],'FX','DN','class');

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

%%%% Makes day bins for the matched automated counts.
[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] = make_day_bins(mdateTB(it),classcountTB(it),ml_analyzedTB(it)); 

% Takes the series of day bins for automated counts and puts it into a year x day matrix.
[ mdate_mat_match, y_mat_match, ~, ~ ] = timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); 

idx = strmatch(class2do_string, class2useTB); %classifier index
y_mat=classcountTB(:,idx)./ml_analyzedTB(:);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

%%%% Makes day bins for the matched manual counts.
idx = strmatch(class2do_string, class2use); %manual index
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] = make_day_bins(matdate(im),classcount(im,idx), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] = timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

% extract RAI class of interest
if idx == 19
    class2do_string = 'Pseudonitzschia';
else
end

id=strmatch(class2do_string,class); %classifier index
rai=FX(:,id);
chlr=NaN*rai;

% match up with chlorophyll
for i=1:length(DN)
    for j=1:length(SC.dn)
        if SC.dn(j) == DN(i)
            chlr(i)=SC.CHL(j)*rai(i);
        else
        end
    end
end

%reset
if idx == 19
    class2do_string = 'Pseudo-nitzschia';
else
end

% eliminate data if within data gaps
%matdate=unique(round(mdateTB)); %strictly associated with IFCB
%looser version
matdate=[datenum('14-Jan-2018'):datenum('10-Feb-2018'),...
    datenum('14-Feb-2018'):datenum('29-Apr-2018'),...
    datenum('08-May-2018'):datenum('07-Aug-2018'),...
    datenum('16-Aug-2018'):datenum('29-Nov-2018'),...
    datenum('04-Dec-2018'):datenum('31-Dec-2018')]';

[~,im,~] = intersect(DN, matdate); %finds the matched files between automated and manually classified files
CHLr=chlr(im);
DNr=DN(im);

% clearvars filelistTB matdate_bin_auto classcount_bin_auto ml_analyzed_mat_bin_auto...
%     matdate_bin_match classcount_bin_match ml_analyzed_mat_bin_match...
%     mdate_val mdate_mat_match ind id im it y_mat_match rai j ...
%     filelist classcountTB class2useTB class2use class classcount i FX matdate
    
%% Plot automated vs manual classification vs RAI
figure('Units','inches','Position',[1 1 7.5 3],'PaperPositionMode','auto');
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

col=brewermap(4,'RdYlBu');

yyaxis left
    h1=stem(mdateTB, y_mat,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
    hold on
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'*','Color',col(1,:),'Markersize',6,'linewidth',1);
    end
    hold on
    
    if idx == 19
        h4=plot(SC.dn,SC.Pn*.001,'o','Color',col(2,:),...
            'MarkerFaceColor',col(2,:),'Linewidth',1,'Markersize',5); %FISH
    else
    end
    
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'tickdir','out','ycolor','k');  
    ylabel('Cells mL^{-1}','fontsize',14,'fontweight','bold');    
    hold on

yyaxis right
    h3=plot(DNr,CHLr,'^','Color',col(4,:),'Markersize',5,'Linewidth',1.5);
    hold on
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'ycolor',col(4,:),'tickdir','out');  
    datetick('x','m','keeplimits');
    ylabel('Chlorophyll (mg m^{-3}) ','fontsize',14,'fontweight','bold');  
    title(['\it' num2str(class2do_string) '\rm \bf'],'fontsize',16,'fontweight','bold');       
    hold on
    
    if idx == 19
        lh = legend([h1,h2,h4,h3],'Classifier','Manual','FISH','RAI','location','NE');
    else
        lh = legend([h1,h2,h3],'Classifier','Manual','RAI','location','NE');    
    end    
    set(lh,'fontsize',14,'box','off')
    
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% r2 Pseudo-nitzschia 

figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.05],[0.1 0.03], [0.18 .06]);

subplot(2,1,1);
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat); % match up IFCB and FISH data
[~,ia,ib] = intersect(SC.dn,mdate_mat); %finds the matched files between automated and manually classified files
y=SC.Pn(ia)*.001;
x=y_matt(ib);

idx=~isnan(x); x=x(idx); y=y(idx); %remove nans 
idx=~isnan(y); x=x(idx); y=y(idx);
x(x==Inf)=max(x); y(y==Inf)=max(y);

scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',14,'tickdir','out','xlim',[0 4],'xtick',0:1:4,'xticklabel',{}); box on
ylabel('FISH')

subplot(2,1,2);
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat);
[~,ia,ib] = intersect(DNr,mdate_mat); %finds the matched files between automated and manually classified files
y=CHLr;
x=y_matt(ib);

idx=~isnan(x); x=x(idx); y=y(idx);%remove nans 
idx=~isnan(y); x=x(idx); y=y(idx);
x(x==Inf)=max(x); y(y==Inf)=max(y);

scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',14,'tickdir','out','xlim',[0 4],'xtick',0:1:4); box on
xlabel('IFCB')
ylabel('RAI')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Pseudo-nitschia_RAI_IFCB_FISH.tif']);
hold off