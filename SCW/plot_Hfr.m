clear;

filepath = '~/MATLAB/bloom-baby-bloom/SCW/'; 
%load([filepath 'Data/Hfr_daily_SCW_March2018'],'dn','u','v','lat','lon','iilat','iilon')
load([filepath 'Data/Hfr_daily_SCW_Feb2018'],'dn','u','v','lat','lon','iilat','iilon');
load([filepath 'Figs/coast_montereybay'],'ncst');

%% test figure for a specific date
date='25-Feb-2018'; 
factor=.002;
iilat=[36.5 37.05]; iilon=[-122.29 -121.77];
itime=find(dn==datenum(date));

figure('Units','inches','Position',[1 1 5 6],'PaperPositionMode','auto');   
plot(ncst(:,1),ncst(:,2),'k-'); dasp(42); xlim(iilon); ylim(iilat);
hold on
q=quiver(lon,lat,factor*squeeze(u(:,:,itime)),factor*squeeze(v(:,:,itime)),'k');
q.AutoScale='off';

hold on
plot(-122.02,36.96,'.','Markersize',20,'Color','r');
text(-122.1,36.97, {'SCMW'},'fontsize',12);
title(date,'fontsize',14)
hold on
    
% Set figure parameters
ch=char(date);
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/Hfr_MB_' ch(1:2) ch(4:6) ch(8:11) '.tif'])
hold off


%% quivermc plot multiple figs to be made into a movie
loops=length(dn); F(loops) = struct('cdata',[],'colormap',[]);

for j = 1:loops
    ui=squeeze(u(:,:,j)); vi=squeeze(v(:,:,j));
    figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');   
    ax=worldmap(iilat,iilon);
    geoshow(ncst(:,2),ncst(:,1),'Color','k');
    hold on
    geoshow(36.96,-122.02,'Marker','.','Markersize',35,'MarkerEdgeColor','k','linewidth',2);
    textm(36.96+.02,-122.02-.038, {'Santa Cruz';'    Wharf'},'fontsize',14);
    hold on
    colormap(ax,jet); caxis([0 40])    
    [~,cb] = quivermc(lat,lon,ui,vi,'density',70,'colormap',jet,'linewidth',1.5,'colorbar','eastoutside','reference','median');
    xlabel(cb,'Surface Velocity (cm/s)')
    cb.TickDirection = 'out';         
    cb.FontSize = 14;
    set(cb, 'xlim', [0 40],'xtick',0:10:40);
    title(['' num2str(datestr(dn(j))) ''],'fontsize',16)
    xlabel(cb,'Surface Velocity (cm/s)','fontsize',16)
    drawnow
    F(j) = getframe(gcf);
end

%%
v = VideoWriter([filepath 'SCW/Figs/SCW_currents.avi']);
v.FrameRate=1;
v.Quality=100;

open(v)
writeVideo(v,F)
close(v)

%% not using


%% Test figure of timepoint: divergence
itime=find(dn==datenum('23-Feb-2018')); C=brewermap(4,'RdBu');
U=squeeze(u(:,:,itime))'; V=squeeze(v(:,:,itime))'; LON=lon'; LAT=lat';
div=divergence(LON,LAT,U,V);

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
plot(ncst(:,1),ncst(:,2),'k-'); dasp(42); xlim(iilon); ylim(iilat);
hold on
pcolor(LON,LAT,div); shading interp
hold on
quiver(LON,LAT,U,V,'k');
hold on
colormap('parula');
plot(-122.02,36.96,'.','Markersize',20,'Color',C(1,:));
text(-122.058,36.98, {'Santa Cruz';'    Wharf'},'fontsize',12);
title(['' num2str(datestr(dn(itime))) ''],'fontsize',14)

%% Test figure of timepoint: curl angular velocity in one plane
itime=find(dn==datenum('27-Feb-2018')); C=brewermap(4,'RdBu');
U=squeeze(u(:,:,itime))'; V=squeeze(v(:,:,itime))'; LON=lon'; LAT=lat';
cav=curl(LON,LAT,U,V);

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
plot(ncst(:,1),ncst(:,2),'k-'); dasp(42); xlim(iilon); ylim(iilat);
hold on
pcolor(LON,LAT,cav); shading interp
hold on
quiver(LON,LAT,U,V,'y');
hold on
colormap('copper');

plot(-122.02,36.96,'.','Markersize',20,'Color',C(1,:));
text(-122.058,36.98, {'Santa Cruz';'    Wharf'},'fontsize',12);
title(['' num2str(datestr(dn(itime))) ''],'fontsize',14)

%% Test figure of timepoint: no color quiver and streamline
date='27-Feb-2018';
ch=char(date);
itime=find(dn==datenum(date));
U=squeeze(u(:,:,itime))'; V=squeeze(v(:,:,itime))'; LON=lon'; LAT=lat';

iilat=[36.55 37]; iilon=[-122.21 -121.77];

C=brewermap(4,'RdBu');
figure('Units','inches','Position',[1 1 4.5 6],'PaperPositionMode','auto');
plot(ncst(:,1),ncst(:,2),'k-'); dasp(42); xlim(iilon); ylim(iilat);
hold on
quiver(LON,LAT,U,V,'k','LineWidth',1)
hold on
[sx,sy]=meshgrid(iilon(1):.05:iilon(2),36.75);
hline=streamline(LON,LAT,U,V,sx,sy); set(hline,'LineWidth',2,'Color',C(4,:))
hold on
plot(-122.02,36.96,'.','Markersize',20,'Color',C(1,:));
text(-122.1,36.97, {'SCMW'},'fontsize',12);

title(date,'fontsize',14)

% Set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r100',[filepath 'Figs/Hfr_streamline_MB_' ch(1:2) ch(4:6) ch(8:11) '.tif'])
hold off

%% Test figure of timepoint: quivermc
itime=find(dn==datenum('23-Feb-2018'));
ui=squeeze(u(:,:,itime)); vi=squeeze(v(:,:,itime));

iilat=[36.73 37]; iilon=[-122.15 -121.77];

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
worldmap(iilat,iilon); 
geoshow(ncst(:,2),ncst(:,1),'Color','k'); hold on
geoshow(36.96,-122.02,'Marker','.','Markersize',35,'MarkerEdgeColor','k','linewidth',2);
textm(36.96+.02,-122.02-.038, {'Santa Cruz';'    Wharf'},'fontsize',12);
test=fillseg(ncst,'r','b');

hold on
colormap(jet); caxis([0 40])
[~,cb] = quivermc(lat(6:8,11:13),lon(6:8,11:13),ui(6:8,11:13),vi(6:8,11:13),'density',75,'fontsize',12,'colormap',jet,'linewidth',1.5,'colorbar','eastoutside','reference','median');
cb.TickDirection = 'out'; cb.FontSize = 12;
set(cb, 'xlim', [0 40],'xtick',0:10:40);
title(['' num2str(datestr(dn(itime))) ''],'fontsize',14)
xlabel(cb,'Surface Velocity (cm/s)','fontsize',14)