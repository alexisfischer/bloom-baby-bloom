
class2do_string = 'Akashiwo'; ymax=1000; 
%class2do_string = 'Ceratium'; ymax=100; 
% class2do_string = 'Dinophysis'; ymax=12;
% class2do_string = 'Lingulodinium'; ymax=12;
% class2do_string = 'Pennate'; ymax=70;
% class2do_string = 'Prorocentrum'; ymax=240;
% class2do_string = 'Chaetoceros'; ymax=350;
% class2do_string = 'Det_Cer_Lau'; ymax=50; 
% class2do_string = 'Eucampia'; ymax=120;
% class2do_string = 'Pseudo-nitzschia'; ymax=30;
%class2do_string = 'NanoP_less10'; ymax=600;
%class2do_string = 'Cryptophyte'; ymax=50;
% class2do_string = 'Thalassiosira'; ymax=30;
% class2do_string = 'Skeletonema'; ymax=50;
% class2do_string = 'Centric'; ymax=150;
% class2do_string = 'Guin_Dact'; ymax=35;

filepath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([filepath 'Data/IFCB_summary/class/summary_allTB_bythre_' class2do_string]);


mdate = mdateTB;
y = classcountTB_above_thre(:,6)./ml_analyzedTB; % use column with whatever threshold you select
x = mdateTB;

[ mdate_mat, y_mat, yearlist, yd ] = timeseries2ydmat( x, y ); %takes a timeseries and makes it into a year x day matrix

figure;
[ y_wkmat, mdate_wkmat, yd_wk ] = ydmat2weeklymat( y_mat, yearlist ); %takes a year x day matrix and makes it a year x 2 week matrix
pcolor([yd_wk ;yd_wk(end)+7],[yearlist(1:3) yearlist(3)+1],[[y_wkmat(:,1:3)';zeros(1,52)], zeros(4,1)]) %for just 2015:2017
%caxis([0 100])
ylabel('Year', 'fontsize',14, 'fontname', 'arial');
xlabel('Month', 'fontsize',14, 'fontname', 'arial');
set(gca,'ytick',[2015 2016 2017 2018],'tickdir','out');
h=colorbar;
set(get(h,'ylabel'),'string',['\it' num2str(class2do_string) '\rm concentration (ml^{-1})\bf'],...
    'fontsize',14,'fontname','arial');
 h.TickDirection = 'out';
datetick('x',4)
axis square
shading flat

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',...
    ['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\Figs\SCW_seasonality_' num2str(class2do_string) '.tif']);
hold off
