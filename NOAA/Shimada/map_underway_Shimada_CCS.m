%% plot Shimada 2019 data 
addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

filepath = '~/MATLAB/NOAA/Shimada/';
load([filepath 'Data/Shimada_HAB_2019'],'HA19');
    
var=HA19.pDAngL; cax=[0 2000]; textsurv='2019';

latk = HA19.Lat_dd; lonk = HA19.Lon_dd;  ii=~isnan(var+latk+lonk);
lonk=lonk(ii); latk=latk(ii); vk=var(ii);   
[~,order]=sort(vk); lonok=lonk(order); latok=latk(order); vok=vk(order);    

d=(vok-cax(1))/(cax(2)-cax(1));%scale of 0:1, divide by upper limit
d(d>1)=1; d(d<=.01)=.01;

% define colors according to [var]    
color=parula; 
COL=zeros(length(d),3); %preallocate space   
for ii=1:length(COL)  
    COL(ii,:)=color(round(d(ii)*length(color)),:);
end    

% define sizes according to [var]    
sz=linspace(5,20,100); 
SIZE=zeros(length(d),1); %preallocate space   
for ii=1:length(SIZE)  % define SIZEs according to var abundance
    SIZE(ii)=sz(round(d(ii)*length(sz)));
end

%% m map plotting
figure('Units','inches','Position',[1 1 4 6],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[36.57 49],'long',[-128 -121]);
m_gshhs('hc','patch',[.7 .7 .7],'edgecolor','k','linewidth',.5);  hold on
m_gshhs('hb2','color','k','linewidth',.5);  %borders
m_grid('xtick',5,'linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','bottom','yaxisloc','left','fontsize',10,'backcolor','w'); hold on; 

%put zeros back  and plot as xs
ii=find(vok<.01); SIZE(ii)=.5; COL(ii,:)=0*COL(ii,:); 
m_line(lonok(ii),latok(ii),'marker','x','markersize',5,...
    'color','k','linewi',1,'linest','none'); hold on   

% plot each point with a special size and color representing [var]
for ii=1:length(lonok) 
    m_line(lonok(ii),latok(ii),'marker','o','markersize',SIZE(ii),'color','none',...
        'markerfacecolor',COL(ii,:),'linewi',.2,'linest','none'); hold on
end      
colormap(color); 
caxis(cax); hold on;    

%% regular matlab ploting
load([filepath 'Data/USwestcoast_shore']);
load([filepath 'Data/USwestcoast_pol']);

figure('Units','inches','Position',[1 1 4 6],'PaperPositionMode','auto');        
plot(USwestcoast_pol(:,1),USwestcoast_pol(:,2),'k'); MapAspect(40)
plot(USwestcoast_shore(:,1),USwestcoast_shore(:,2),'k'); hold on;
plot(USwestcoast_pol(:,1),USwestcoast_pol(:,2),'k'); MapAspect(40)
axis([-128 -120 34 49]);
hold on;

%put zeros back  and plot as xs
ii=find(vok<.01); SIZE(ii)=.5; COL(ii,:)=0*COL(ii,:); 
plot(lonok(ii),latok(ii),'marker','x','markersize',5,...
    'color','k','linewi',1,'linest','none'); hold on   

for ii=1:length(lonok) % plot each point separately with a special color
    scatter(lonok(ii),latok(ii),8*SIZE(ii),COL(ii,:),'filled');
end
makescale('ne')

colormap(color); 
caxis(cax);    
h=colorbar('west'); 
h.TickDirection = 'out';    
%h.Label.String = {str; label};
h.Ticks=linspace(cax(1),cax(2),3);   
hp=get(h,'pos'); hp(1)=hp(1); hp(3)=.8*hp(3); hp(4)=.3*hp(4);
set(h,'pos',hp,'xaxisloc','top','fontsize',10); 
title(textsurv,'fontsize',12);    
hold on;

%% legend
text={'10^3','10^2','10^1','10^0'};
leg=[3,2,1,.01];
    d=leg./maxx; d(d<=.01)=.01;
    color=parula;    
    dcol=zeros(length(leg),3); %preallocate space   
    scol=zeros(length(d),1); %preallocate space   
    for ii=1:length(dcol)  
        dcol(ii,:)=color(round(d(ii)*length(color)),:);
        scol(ii)=sz(round(d(ii)*length(sz)));        
    end    

lon=[-52,-52,-52,-52]; lat=74.5:-.6:72.5;
for ii=1:length(lon)    
    m_line(lon(ii),(lat(ii)-.1),'marker','o','markersize',scol(ii),'color','k',...
        'markerfacecolor',dcol(ii,:),'linewi',.2,'linest','none');   
    m_text(-50.5,lat(ii),text(ii),'color','k');
end
m_line(lon(1),lat(end)-.6,'marker','x','markersize',4,'linewi',.8,'color','k');
m_text(-50.5,lat(end)-.6,'0','color','k');
m_text(-55,lat(1)+.7,'cysts cc^{-1}','color','k','fontweight','bold');

% cb=colorbar('East'); a=cb.Position;
% set(cb,'Position',[1.05*a(1) 3*a(2) 1.5*a(3) .6*a(4)],'tickdir','out',...
%     'fontsize',11,'YAxisLocation','right','Ticks',0:1:3,...
%     'TickLabels',{'10^0','10^1','10^2'}); hold on    
% set(get(cb,'Title'),'String',{'log';'cysts';'cc^{-1}'}); 

clearvars cb i ii dcol scol lonk lonok latk latok a d s order minn maxx color subplot sz TL cyst cystk cystok


%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[filepath 'Figs/CCS_map.tif']);
hold off 