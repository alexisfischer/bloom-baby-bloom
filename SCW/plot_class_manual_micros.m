
%class2do_string = 'Akashiwo'; chain=1;
class2do_string = 'Ceratium';  chain=1;
% class2do_string = 'Dinophysis'; chain=1;
% class2do_string = 'Prorocentrum'; chain=1;
% class2do_string = 'Chaetoceros'; chain=1;
% class2do_string = 'Cochlodinium'; chain=2;
% class2do_string = 'Thalassiosira'; chain=1;
% class2do_string = 'Skeletonema'; chain=1;
%class2do_string = 'Pseudo-nitzschia'; chain=7;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_2018'],...
    'class2useTB','ml_analyzedTB','mdateTB','filelistTB','classcountTB_above_optthresh');
classcountTB=classcountTB_above_optthresh;

load([filepath 'Data/IFCB_summary/manual/count_class_manual'],...
    'class2use','classcount','filelist','matdate','ml_analyzed'); 
load([filepath 'Data/SCW_master'],'SC');
load([filepath 'Data/RAI'],'FX','DN','class');
load([filepath 'Data/Microscopy_SCW'],'micro','genus','dnM');

%%%% (1) extract Classifier data for class of interest
idx = strmatch(class2do_string, class2useTB); %classifier index
y_mat=classcountTB(:,idx)./ml_analyzedTB(:); %class
y_mat((y_mat<0)) = 0; y_mat(y_mat==Inf) = NaN; %no negative or Infinite numbers
y_mat(find(y_mat==max(y_mat)))=NaN; %remove that really high point

% % Convert Biovolume (cubic microns/cell) to Carbon (picograms/cell)
% [ ind_diatom, ~ ] = get_diatom_ind_CA( class2useTB, class2useTB );
% [ cellC ] = biovol2carbon(classbiovolTB, ind_diatom ); 
% y_car=cellC(:,idx)./ml_analyzedTB(:)./1000; %convert from carbon/cell to ug/L 
% y_car(find(y_car==max(y_car)))=NaN; %remove that really high point for Pseudo-nitzschia
% y_car((y_car<0)) = 0; y_car(y_car==Inf) = NaN; %no negative or Infinite numbers

%%%% (2) extract Manual data for class of interest
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files
idx = strmatch(class2do_string, class2use); %manual index
[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] = make_day_bins(matdate(im),classcount(im,idx), ml_analyzed(im)); 
[mdate_mat_manual, y_mat_manual, yearlist, yd ] = timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); % Takes the series of day bins and puts it into a year x day matrix.
ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

%%%% (3) extract Microscopy data for class of interest
id=strmatch(class2do_string,genus); %classifier index
m=micro(:,id); chlm=NaN*m;

%%%% (4) extract RAI class of interest
id=strmatch(class2do_string,class); %classifier index
rai=FX(:,id); chlr=NaN*rai;

for i=1:length(DN)
    for j=1:length(SC.dn) 
        if SC.dn(j) == DN(i) % match rai with chlorophyll data
            chlr(i)=SC.CHL(j)*rai(i); 
        else
        end
    end
end

% only take data within these time periods
matdate=[datenum('14-Jan-2018'):datenum('10-Feb-2018'),...
    datenum('14-Feb-2018'):datenum('29-Apr-2018'),...
    datenum('08-May-2018'):datenum('07-Aug-2018'),...
    datenum('16-Aug-2018'):datenum('29-Nov-2018'),...
    datenum('04-Dec-2018'):datenum('31-Dec-2018')]';

[~,im,~] = intersect(DN, matdate); CHLr=chlr(im); DNr=DN(im); %rai
[~,im,~] = intersect(dnM, matdate); M=m(im); DNm=dnM(im); %microscopy

%CHLr(find(CHLr==max(CHLr)))=NaN; %remove that really high point
%M(find(M==max(M)))=NaN; %remove that really high point

clearvars class2useTB ml_analyzedTB filelistTB matdate_bin_auto...
    classcount_bin_auto ml_analyzed_mat_bin_auto im it ind id class...
    DN matdate m dnM DN chlr classcountTB classcount filelist i j  ...
    mdate_val micro rai genus chlm FX ml_analyzed class2use

% Plot automated vs manual classification vs RAI
figure('Units','inches','Position',[1 1 7.5 3],'PaperPositionMode','auto');
xax1=datenum('2018-01-01'); xax2=datenum('2018-12-31');     

col=brewermap(4,'Spectral');

yyaxis left
    h1=stem(mdateTB, y_mat,'k-','Linewidth',.5,'Marker','none'); 
    hold on
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'*','Color',col(1,:),'Markersize',6,'linewidth',1);
    end
    hold on

    if idx == 36
        h3=plot(DNm,M./chain,'d','Color',col(2,:),'MarkerFaceColor',col(2,:),...
            'Linewidth',1,'Markersize',5); %microscopy
        hold on
    else
    end
        
    if idx == 19
        h4=plot(SC.dn,SC.Pn*.001,'o','Color',col(3,:),...
            'MarkerFaceColor',col(3,:),'Linewidth',1,'Markersize',5); %FISH
    else
    end
    
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'tickdir','out','ycolor','k');  
    ylabel('Cells mL^{-1}','fontsize',14,'fontweight','bold');    
    hold on

yyaxis right
    h5=plot(DNr,CHLr,'^','Color',col(4,:),'Markersize',4,'Linewidth',1.5);
    hold on
    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'ycolor',col(4,:),'tickdir','out');  
    datetick('x','m','keeplimits');
    ylabel('Chlorophyll (mg m^{-3}) ','fontsize',14,'fontweight','bold');  
    title(['\it' num2str(class2do_string) '\rm \bf'],'fontsize',16,'fontweight','bold');       
    hold on
    
    if idx == 19
        lh = legend([h1 h2 h5 h4],'Classifier','Manual','RAI','FISH','location','NE');
    elseif idx == 36
        lh = legend([h1 h2 h5 h3],'Classifier','Manual','RAI','Microscopy','location','NE');
    else
        lh = legend([h1 h2 h5],'Classifier','Manual','RAI','location','NE');    
    end    
    set(lh,'fontsize',14,'box','off')
    
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% r2 Ceratium

figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.05],[0.1 0.03], [0.18 .06]);

subplot(2,1,1);
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat); % match up IFCB and FISH data
[~,ia,ib] = intersect(DNm,mdate_mat);
y=M(ia);
x=y_matt(ib);

idx=~isnan(x); x=x(idx); y=y(idx); %remove nans 
idx=~isnan(y); x=x(idx); y=y(idx);

scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',14,'tickdir','out','xlim',[0 4],'xtick',0:1:4,'xticklabel',{}); box on
ylabel('Microscopy')

subplot(2,1,2);
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat);
[~,~,ib] = intersect(DNr,mdate_mat);
y=CHLr;
x=y_matt(ib);

idx=~isnan(x); x=x(idx); y=y(idx);%remove nans 
idx=~isnan(y); x=x(idx); y=y(idx);

scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',14,'tickdir','out','xlim',[0 4],'xtick',0:1:4); box on
xlabel('IFCB')
ylabel('RAI')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/' num2str(class2do_string) '_RAI_IFCB_FISH.tif']);
hold off


%% r2 Pseudo-nitzschia 

figure('Units','inches','Position',[1 1 3.5 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.05],[0.1 0.03], [0.18 .06]);

subplot(2,1,1);
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat); % match up IFCB and FISH data
[~,ia,ib] = intersect(SC.dn,mdate_mat);
y=SC.Pn(ia)*.001;
x=y_matt(ib);

idx=~isnan(x); x=x(idx); y=y(idx); %remove nans 
idx=~isnan(y); x=x(idx); y=y(idx);

scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',14,'tickdir','out','xlim',[0 4],'xtick',0:1:4,'xticklabel',{}); box on
ylabel('FISH')

subplot(2,1,2);
[mdate_mat,y_matt,~,~] = timeseries2ydmat(mdateTB,y_mat);
[~,ia,ib] = intersect(DNr,mdate_mat);
y=CHLr;
x=y_matt(ib);

idx=~isnan(x); x=x(idx); y=y(idx);%remove nans 
idx=~isnan(y); x=x(idx); y=y(idx);

scatter(x,y,20,'linewidth',2); hold on
 set(gca,'fontsize',14,'tickdir','out','xlim',[0 4],'xtick',0:1:4); box on
xlabel('IFCB')
ylabel('RAI')
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[filepath 'Figs/Pseudo-nitschia_RAI_IFCB_FISH.tif']);
hold off