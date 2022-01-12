%% plot IFCB Space & Time Contours
%addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;
filepath = '/Users/afischer/MATLAB/bloom-baby-bloom/SFB/';
load([filepath 'Data/NetDeltaFlow'],'DN','X2','OUT');
load([filepath 'Data/SFB_eqdiam_biovol_2017-2019'],'Bi','B','note1','note2');

% back-of-the-envelope Suisun Bay daily residence time calculation
OUT=OUT*60*60*24; %convert from m^3/s to m^3/day
RT=(.001)*6.54e11./OUT; % days
    
%% monthly averages
clearvars X Y C;

%label="<10um carbon ug/mL"; str="carbon0-10"; cax=[0 .03];  F=[Bi.car0_10]';
%label="10-20um carbon ug/mL"; str="carbon10-20"; cax=[0 .04];  F=[Bi.car10_20]';
%label="20-60um carbon ug/mL"; str="carbon20-60"; cax=[0 .05];  F=[Bi.car20_60]';

label="<10um cells/mL"; str="cell0-10"; cax=[0 1000];  F=[Bi.cell0_10]';
label="10-20um cells/mL"; str="cell10-20"; cax=[0 300];  F=[Bi.cell10_20]';
label="20-60um cells/mL"; str="cell20-60"; cax=[0 60];  F=[Bi.cell20_60]';

D = [Bi.dn]'; Y=[Bi(1).d18]';

for i=1:size(F,2) %organize data into a week x location matrix   
        [ ~, y_ydmat, yearlist, ~ ] = timeseries2ydmat( D, F(:,i));
        [  y_wkmat, mdate_wkmat, yd_wk ] = ydmat2interval( y_ydmat, yearlist, 30 );
        C(i,:) = reshape(y_wkmat,[length(y_wkmat)*size(y_wkmat,2),1]);
        X = reshape(mdate_wkmat,[length(mdate_wkmat)*size(mdate_wkmat,2),1]);
end

figure('Units','inches','Position',[1 1 5 6.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.01], [0.16 0.04], [0.13 0.04]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  
xax=[datenum('2017-12-01') datenum('2019-12-31')];     
     
subplot(5,1,1);
    plot(DN,smooth(RT,4),'-k','linewidth',1);
    datetick('x', 'yyyy', 'keeplimits')
    set(gca,'tickdir','out','ylim',[0 3.3],'ytick',1:1:3,...
        'xlim',[xax(1) xax(2)],'fontsize', 14,'xticklabels',{},'ycolor','k');   
    ylabel('days', 'fontsize', 14, 'fontname', 'arial')
    hold on

subplot(5,1,[2 3 4 5]);
    pcolor(X,Y,C);        
    caxis(cax); shading flat; 
    set(gca,'xaxislocation','bottom','xlim',[xax(1) xax(2)],...
        'ylim',[0 max(Y)],'ytick',0:20:80,'fontsize', 14,'tickdir','out');
    datetick('x', 'yyyy', 'keeplimits')  
    ylabel('Distance (km) from Angel Island)', 'fontsize', 14)    
    hold on
    
    color=brewermap([],'YlGn');     
    colormap(color);    
      
    h=colorbar('south'); h.Label.String = label; h.Label.FontSize = 14;               
    hp=get(h,'pos'); 
    hp(1)=hp(1); hp(2)=.2*hp(2); hp(3)=.54*hp(3); hp(4)=.8*hp(4);
    set(h,'pos',hp,'xaxisloc','bottom','fontsize',10); 
    hold on
    
if str == "cell0-10"    
        h.Label.Position = [hp(1)+1400 hp(2)+1];
        h.Ticks=linspace(cax(1),cax(2),5);    
    elseif str == "cell10-20"    
        h.Label.Position = [hp(1)+400 hp(2)+1];
        h.Ticks=linspace(cax(1),cax(2),5);    
    elseif str == "cell20-60"    
        h.Label.Position = [hp(1)+90 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);            
    elseif str == "carbon0-10"    
        h.Label.Position = [hp(1)-.107 hp(2)+1];
        h.Ticks=linspace(cax(1),cax(2),4);         
    elseif str == "carbon10-20"    
        h.Label.Position = [hp(1)-.092 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5); 
    elseif str == "carbon20-60"    
        h.Label.Position = [hp(1)-.07 hp(2)+1];
        h.Ticks=linspace(cax(1),cax(2),6);                
    else
        h.Label.Position = [hp(1)+30 hp(2)+1]; 
        h.Ticks=linspace(cax(1),cax(2),5);         
 end
        
    h.Label.FontSize = 14;           
    hold on   
    plot([datenum('01-Jan-2018') datenum('01-Jan-2018')],[0 100],'k-','linewidth',1);    
    plot([datenum('01-Jan-2019') datenum('01-Jan-2019')],[0 100],'k-','linewidth',1);    
    plot(DN,(X2-6.43738),'k-','linewidth',2); %adjust X2 so distance from Angel island, not GG

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/' num2str(str) '_RT_space_time_2013-2019.tif'])
hold off