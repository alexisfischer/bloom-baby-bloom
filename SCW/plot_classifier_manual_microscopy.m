
%class2do_string = 'Akashiwo';
%class2do_string = 'Ceratium';  
% class2do_string = 'Dinophysis';
% class2do_string = 'Lingulodinium'; ymax=12;
% class2do_string = 'Pennate'; ymax=70;
% class2do_string = 'Prorocentrum'; 
% class2do_string = 'Chaetoceros'; ymax=350;
% class2do_string = 'Det_Cer_Lau'; 
class2do_string = 'Eucampia'; 
% class2do_string = 'Umbilicosphaera'; chosen_threshold = 0.7; hi=50;
% class2do_string = 'Cochlodinium';

%class2do_string = 'Pseudo-nitzschia';
%class2do_string = 'NanoP_less10'; ymax=600;
%class2do_string = 'Cryptophyte'; ymax=50;
% class2do_string = 'Thalassiosira'; ymax=30;
% class2do_string = 'Skeletonema'; ymax=50;
% class2do_string = 'Centric'; 
% class2do_string = 'Guin_Dact'; ymax=35;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_2018'],'classcountTB','filelistTB','ml_analyzedTB','mdateTB','class2useTB'); 
load([filepath 'Data/IFCB_summary/manual/count_manual_05Feb2019']); 
load([filepath 'Data/SCW_master'],'SC');

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

%%%% Makes day bins for the matched automated counts.
[matdate_bin_match, classcount_bin_match, ml_analyzed_mat_bin_match] =...
    make_day_bins(mdateTB(it),classcountTB(it),ml_analyzedTB(it)); 

% Takes the series of day bins for automated counts and puts it into a year x day matrix.
[ mdate_mat_match, y_mat_match, yearlist, yd ] = timeseries2ydmat(matdate_bin_match,classcount_bin_match./ml_analyzed_mat_bin_match ); 

indA = strmatch(class2do_string, class2useTB); %classifier index

y_mat=classcountTB(:,indA)./ml_analyzedTB(:);
y_mat((y_mat<0)) = 0; % cannot have negative numbers 

%%%% Makes day bins for the matched manual counts.
ind2 = strmatch(class2do_string, class2use); %manual index

[matdate_bin_auto, classcount_bin_auto, ml_analyzed_mat_bin_auto] =...
    make_day_bins(matdate(im),classcount(im,ind2), ml_analyzed(im)); 

% Takes the series of day bins and puts it into a year x day matrix.
[mdate_mat_manual, y_mat_manual, yearlist, yd ] = timeseries2ydmat(matdate_bin_auto,classcount_bin_auto./ml_analyzed_mat_bin_auto); 

ind=(find(y_mat)); % find dates associated with nonzero elements
mdate_val=[mdateTB(ind),y_mat(ind)];

% Plot automated vs manual classification vs microscopy cell counts

figure('Units','inches','Position',[1 1 7.5 3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.12 -0.7], [0.1 0.05]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

xax1=datenum(['2018-01-01']); xax2=datenum(['2018-12-31']);     

subplot(2,1,1)
    sz=linspace(1,60,100); 
    A=SC.rai.EUC'./4;
    
%    A=SC.rai.PN'./4;
    A(A<=.01)=.01; %replace values <0 with 0.01  
    ii=~isnan(A); Aok=A(ii); 
    Asz=zeros(length(Aok),1); 
    for j=1:length(Asz)  
         Asz(j)=sz(round(Aok(j)*length(sz)));
    end
    h=scatter(SC.rai.dn(ii)',ones(size(Asz)),Asz,'m','filled');
    set(gca,'visible','off','xlim',[xax1 xax2],'ylim',[1 1.5],'xticklabel',{},...
        'yticklabel',{},'fontsize',14);  
    hold on  
    
subplot(2,1,2)    
    h1=stem(mdateTB, y_mat,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
    hold on
    for i=1:length(yearlist)
        ind_nan=find(~isnan(y_mat_manual(:,i)));
        h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
    end
    hold on
%    h3=plot(SC.dn,SC.Pn*.001,'b^','Linewidth',2,'Markersize',5);
    hold on

    set(gca,'xgrid','on','xlim',[xax1 xax2],'fontsize',14,'tickdir','out');  
    ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
        'fontsize',16, 'fontname', 'Arial','fontweight','bold');    
    hold on
    datetick('x','m','keeplimits');
     lh = legend([h1,h2,h],'Auto class','Manual class','RAI','location','Northeast');
    %     lh = legend([h1,h2,h3,h],'Auto class','Manual class','FISH','RAI','location','Northeast');
    set(lh,'fontsize',14,'box','off')
    
% set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Manual_automated_' num2str(class2do_string) '.tif']);
hold off

%% plot Automatic classification cell counts

figure('Units','inches','Position',[1 1 6 3.],'PaperPositionMode','auto');

xax1=datenum(['2018-01-01']); xax2=datenum(['2018-12-31']);     

h1=plot(mdateTB, y_mat,'k-','Linewidth',.5,'Marker','none'); %This adjusts the automated counts by the chosen slope. 
% hold on
% for i=1:length(yearlist)
%     ind_nan=find(~isnan(y_mat_manual(:,i)));
%     h2=plot(mdate_mat_manual(ind_nan,i), y_mat_manual(ind_nan,i),'r*','Markersize',6,'linewidth',.8);
% end

hold on
datetick('x','m','keeplimits');
set(gca,'xgrid','on',...
    'xlim',[xax1 xax2],'fontsize',14,'tickdir','out');  
ylabel(['\it' num2str(class2do_string) '\rm cells mL^{-1}\bf'],...
    'fontsize',16, 'fontname', 'Arial','fontweight','bold');    

hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/Manual_automated_line_' num2str(class2do_string) '.tif']);
hold off
