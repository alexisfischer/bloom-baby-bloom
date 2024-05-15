%% heatmap of discrete samples (2019 and 2021) along CCS
% data options: pDA, chlA, nitrate, phosphate, silicate, Si:N, P:N
% option to include or remove sites of interest
% Shimada 2019 and 2021
% Fig 2 in Fischer et al. 2024
% A.D. Fischer, May 2024
%
clear;

%%%%USER
fprint = 0; % 1 = print; 0 = don't
yr = 2019; % 2019; 2021
unit = 0.06; % amount to subtract from latitude so does not overlap with map
leftsubplot=0; % 1 = larger plot sites of interest; 0 = basic version
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/coast_CCS'],'coast'); %map
states=load([filepath 'Data/USwestcoast_pol']); %map
load([filepath 'Data/HAB_merged_Shimada19-21'],'HA');

HA((HA.lat<40),:)=[]; %remove CA stations
HA(~(HA.dt.Year==yr),:)=[]; %select year of data

%%%%USER enter data of interest
%data=HA.chlA_ugL; cax=[0 20]; ticks=[0,10,20]; label={'Chl a (ug/L)'}; name='CHL'; col=brewermap(256,'PuBu'); lim=.1; col(1:50,:)=[];
%data=HA.Nitrate_uM; cax=[0 48]; ticks=[0,24,48]; label={'NO_3^- + NO_2^- (μM)'}; name='NIT'; col=brewermap(256,'YlGn'); lim=0.6;
%data=HA.Phosphate_uM; cax=[0 3]; ticks=[0,1.5,3]; label={'PO_4^{3−} (μM)'}; name='PHS';col=brewermap(256,'YlGn'); lim=0.6;
%data=HA.Silicate_uM; cax=[0 48]; ticks=[0,24,48]; label={'Si[OH]_4 (μM)'}; name='SIL';col=brewermap(256,'YlGn'); lim=1.1;
%data=HA.Silicate_uM; cax=[0 300]; ticks=[0,300]; label={'Si[OH]_4 (μM)'}; name='SILHi'; c1=brewermap(256,'YlGn');c1=c1(1:6:end,:); c2=(brewermap(256,'Purples'));c2=c2(round(256*1/6):end,:); col=[c1;c2]; lim=1.1;  
%data=HA.pDA_pgmL; cax=[6.4 300]; ticks=[66,200,300]; lim=6.4; label={'pDA (pg/mL)'}; name='pDA'; c1=flipud(brewermap(100,'YlGn')); c1=c1(30:75,:); c2=(brewermap(220,'YlOrRd')); c2(1:30,:)=[]; c2(95:115,:)=[]; col=vertcat(c1,c2);
%data=HA.S2N; cax=[-1 1]; ticks=[-1 0 1]; label={'SiNi'}; name='SiNi';col=flipud(brewermap(256,'RdBu')); lim=-100;
%data=HA.P2N; cax=[-1 1]; ticks=[-1 0 1]; label={'PhNi'}; name='PhNi';col=flipud(brewermap(256,'RdBu')); lim=-10;

% remove Nans and add lon gap
lat = HA.lat; lon = HA.lon; 
idx=isnan(data); data(idx)=[]; lat(idx)=[]; lon(idx)=[];
lon=lon-unit;

%%%% plot
if leftsubplot == 1
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 3 4.7]); 
else
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 4.7]); 
end

ind=(data<=lim); 
scatter(lon(ind),lat(ind),2,[.3 .3 .3],'o','filled'); hold on
scatter(lon(~ind),lat(~ind),20,data(~ind),'filled','markeredgecolor','k','LineWidth',.5); hold on

colormap(col); clim(cax);
axis([min(lon) max(lon) min(lat) max(lat)]);
h=colorbar('northoutside','xtick',ticks); hp=get(h,'pos');    
set(h,'pos',hp,'xaxisloc','top','fontsize',9,'tickdir','out');
xtickangle(0); hold on;    
colorTitleHandle = get(h,'Title');
set(colorTitleHandle,'String',label,'fontsize',11);
    
sem=NaN*ones(size(HA.st));
HA=addvars(HA,sem,'after','dt');
HA((HA.lat<40),:)=[]; %remove CA stations
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples

% overlay SEM data for pDA plot
if strcmp(name,'pDA')
    H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom
    scatter([H.lon],[H.lat],20,'o','k','MarkerFaceColor','none'); hold on    
    if yr==2019
        text([H.lon]-0.4,[H.lat]-.1,num2str([H.st2]),'fontsize',8)    
    else
        text([H.lon]-0.6,[H.lat]-.15,num2str([H.st2]+9),'fontsize',8)   
    end
end

% Plot map
fillseg(coast); dasp(42); hold on;
plot(states.lon,states.lat,'k'); hold on;
set(gca,'ylim',[39.9 49],'xlim',[-126.6 -123.5],'xtick',-127:2:-124,...
    'xticklabel',{'127 W','125 W'},'yticklabel',...
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},...
    'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');

if leftsubplot == 1
    set(gca,'ylim',[39.9 49],'xlim',[-127.3 -122.3],'xtick',-127:2:-122,...
        'xticklabel',{'127 W','125 W','123 W'},'yticklabel',...    
    {'40 N','41 N','42 N','43 N','44 N','45 N','46 N','47 N','48 N','49 N'},'fontsize',9,'tickdir','out','box','on','xaxisloc','bottom');    
   text(-124.25,47.75,{'JF';'Eddy'},'fontsize',9); hold on
   text(-123.85,46.2,{'Colum.';'River'},'fontsize',9); hold on
   text(-124,44,{'Heceta';'Bank'},'fontsize',9); hold on
   text(-124,41.65,{'Trinidad';' Head'},'fontsize',9); hold on
end
xtickangle(0); hold on;    

if fprint==1
    exportgraphics(gca,[filepath 'NOAA/Shimada/Figs/' name '_discrete_Shimada' num2str(yr) '.png'],'Resolution',300)    
end
hold off 