class2do_string = 'NanoP_less10'; %USER 
bin=5;
slope = Coeffs(bin,2);

load 'F:\IFCB104\manual\summary\count_biovol_manual_21Jan2018' %load manual count result file that you made from running 'biovolume_summary_manual_user_training.m'
summary_path = 'F:\IFCB104\class\summary\'; %load automated count file with all thresholds you made from running 'countcells_allTB_class_by_thre_user.m'
load([summary_path 'summary_allTB_bythre_' class2do_string]);

for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24);
end

[~,im,it] = intersect({filelist.newname}, filelistTB); %finds the matched files between automated and manually classified files

%Automated
mdate_mat_match = mdateTB(it);
y_mat_match = classcountTB_above_thre(it,bin)./ml_analyzedTB(it);
%y_mat((y_mat<0)) = 0; % cannot have negative numbers 

ind2 = strmatch(class2do_string, class2use); %change this for whatever class you are analyzing

%Manual
mdate_mat_manual = matdate(im);
y_mat_manual =classcount(im,ind2)./ml_analyzed(im);

%%
figure('Units','inches','Position',[1 1 6 3],'PaperPositionMode','auto');

h1=stem(mdate_mat_match,y_mat_match./slope,'k-','Marker','none','linewidth',1.5); %This adjusts the automated counts by the chosen slope.     
hold on
h2=plot(mdate_mat_manual,y_mat_manual,'r*','Markersize',4,'linewidth',1.2);

hold all
datetick,set(gca, 'xgrid', 'on')
ylabel(['\it' num2str(class2do_string) '\rm (mL^{-1})\bf'],...
    'fontsize',12, 'fontname', 'Arial');

set(gca,'fontsize', 12, 'fontname', 'Arial')
lh = legend([h1,h2], ['Automated classification (' num2str(threlist(bin)) 'Thr)'],...
    'Manual classification','Location','NorthOutside');
hold on

set(lh,'fontsize',12)
%set(gcf,'PaperOrientation','landscape');
set(gcf,'units','inches')
set(gcf,'position',[5 6 8 3],'paperposition', [-0.5 3 12 4]);
set(gcf,'color','w')
    set(gca,'xlim',[datenum('2017-12-17') datenum('2017-12-23')],...   
        'xtick',datenum('2017-12-17'):1:datenum('2017-12-23'),...
        'XTickLabel',{'17-Dec','18-Dec','19-Dec','20-Dec','21-Dec','22-Dec','23-Dec'},...
        'tickdir','out');

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    ['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Figs\Manual_automated_ALL_' num2str(class2do_string) '.tif']);
hold off
