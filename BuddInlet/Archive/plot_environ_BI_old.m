%% plot continuous Budd Inlet data
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

yr='2022'; % '2023'
load([filepath 'Data/BuddInlet_data_summary'],'T','fli');

% only select data from year of interest
T(~(T.dt.Year==str2double(yr)),:)=[];
%T((T.dt.Month<=5),:)=[];
%nanmean(T.Urea_avg)
%nanstd(T.Urea_avg)

%%%% remove IFCB sampling data gaps, but keep meso gaps
idx=find(isnan(T.mesoSmall_fl)); 
    T.mesoSmall_fl(idx)=999; T.mesoLarge_fl(idx)=999; T.mesoSmall_sc(idx)=999; T.mesoLarge_sc(idx)=999;
idx=find(isnan(T.dino_fl));
    T.mesoSmall_fl(idx)=NaN; T.mesoLarge_fl(idx)=NaN; T.mesoSmall_sc(idx)=NaN; T.mesoLarge_sc(idx)=NaN;
idx=~((T.mesoSmall_fl)==999); 
    small=T.mesoSmall_fl(idx); large=T.mesoLarge_fl(idx); smallA=T.mesoSmall_sc(idx); largeA=T.mesoLarge_sc(idx); dt=T.dt(idx);

idx=find(dt==datetime('09-Jul-2023')); large(idx)=large(idx)-17;

%2022
total=max(sum([smallA,large],2,'omitnan'));
T.t1=(smoothdata(T.t1,'movmean',3,'omitnan'));
T.s1=(smoothdata(T.s1,'movmean',3,'omitnan'));

figure('Units','inches','Position',[1 1 3.2 4.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.06 0.06], [0.19 0.23]);
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax=[datetime(['' yr '-04-01']) datetime(['' yr '-10-01'])];
c=(brewermap(7,'Paired'));

subplot(4,1,1);
yyaxis left
h=plot(fli.dt,fli.dino,'.','color',[.7 .7 .7],'markersize',4,'Linewidth',.5); hold on; %raw
%h=plot(T.dt,T.dino_fl,'k-','linewidth',1); hold on;
    set(gca,'xaxislocation','top','xlim',[xax(1) xax(2)],'ylim',[0 30],'ytick',0:15:30,...
        'fontsize', 8,'tickdir','out','ycolor','k');  
    ylabel({'\itDinophysis';'\rm(cells/mL)'},'fontsize',11); hold on;  
    title(yr,'fontsize', 10)   

yyaxis right
    if strcmp(yr,'2022')
        b=bar(dt,[large,smallA],'stacked','FaceColor','flat','barwidth',1.,'EdgeColor','none');hold on; 
        meso=sum([large,smallA],2);
    else
        b=bar(dt,[large,small],'stacked','FaceColor','flat','barwidth',1.5,'EdgeColor','none');hold on;
        meso=sum([large,small],2);        
    end  
    b(1).FaceColor = c(6,:);
    b(2).FaceColor = c(7,:);   

    %plot zeros w/ xs
%    idx=(meso==0);
 %   hz=plot(dt(idx),meso(idx),'r^','markerfacecolor','w','Linewidth',.5,'markersize',4); hold on;       

    set(gca,'tickdir','out','xticklabel',{},'xlim',xax,'ylim',[0 10],...
        'ytick',0:5:10,'fontsize',8,'ycolor',c(6,:));
    ylabel({'\itMesodinium';'\rm(cells/mL)'},'fontsize',10); hold on;           

%set(gca, 'SortMethod', 'depth'); %brings left axis to top

    % add grey lines to axis where no IFCB data 
    idx=find(isnan(T.dino_fl)); val=0.12*ones(size(idx));
    hn=plot(T.dt(idx),val,'s','markersize',3,'linewidth',.5,'color','k','markerfacecolor','k'); hold on;              
    if strcmp(yr,'2021')
        iend=find(~isnan(T.dino_fl),1); 
        dti=datetime(T.dt(1)):1:datetime(T.dt(iend-1)); 
        val=0.1*ones(size(dti));
        plot(dti,val,'-','linewidth',3.2,'color','k'); hold on;        
    end

subplot(4,1,2)
plot(T.dt,T.t1,'-k','linewidth',1); hold on;
hline(15,'k:'); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[9 23],...
        'fontsize', 8,'xticklabel',{},'tickdir','out','ycolor','k');   
    ylabel({'Temperature';'(^oC)'},'fontsize',10,'color','k'); hold on;

subplot(4,1,3)
%yyaxis left
plot(T.dt,T.s1,'-k','linewidth',1); hold on;
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[20 33],...
        'fontsize', 8,'tickdir','out','xticklabel',{},'ycolor','k');   
    ylabel({'Salinity';'(ppt)'},'fontsize',10,'color','k'); hold on;
% yyaxis right
% plot(T.dt,T.DeschutesCfs,'-.','Color',c(2,:),'linewidth',1.3); hold on;
%     datetick('x', 'm', 'keeplimits');       
%     set(gca,'xlim',[xax(1) xax(2)],'xticklabel',{},'ylim',[0 1400],...
%         'ytick',0:700:1400,'fontsize', 8,'tickdir','out','ycolor',c(2,:));   
%     ylabel({'Discharge';'(cfs)'},'fontsize',10,'color',c(2,:)); hold on;

%%% find max Deschutes R discharge    
%nansum(T.DeschutesCfs)*2.4465755808E-6*5*30 %convert to km^3 (5 months, 30 days/mo)    


subplot(4,1,4)
h1=plot(T.dt(~isnan(T.NH3_avg)),T.NH3_avg(~isnan(T.NH3_avg)),'o-k','Markersize',3,'linewidth',1); hold on;
h2=plot(T.dt(~isnan(T.NO3_avg)),T.NO3_avg(~isnan(T.NO3_avg)),'.:k','Markersize',10,'linewidth',1.3); hold on;
    datetick('x', 'm', 'keeplimits');       
    set(gca,'xlim',[xax(1) xax(2)],'ylim',[0 23],'fontsize',8,'tickdir','out','ycolor','k');   
    ylabel({'Nitrogen';'(uM)'},'fontsize',10,'color','k'); hold on;
    lh=legend([h1 h2],'NH_3','NO_3','Location','East');
    lh.FontSize = 8; hp=get(lh,'pos');
    lh.Position=[hp(1)+.26 hp(2) hp(3) hp(4)]; legend boxoff; hold on  
    datetick('x', 'm', 'keeplimits');           
    
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/BI_overview_' yr '.png'],'Resolution',300)    
hold off


