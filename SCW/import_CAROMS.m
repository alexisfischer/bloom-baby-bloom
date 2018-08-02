
year= 2017;

load(['MB_ROMs_filenames_Jan-Jul' num2str(year) ''],'filename');
filename=flipud(char(filename));
in_dir='http://west.rssoffice.com:8080/thredds/dodsC/roms/CA3km-nowcast/MB/';
out_dir=['~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/ROMS/MB_temp_sal_' num2str(year) '']; %change for whatever year
in_dir_base='ca_subMB_das_';

for i=1:length(filename)
    disp(filename(i,1:26));
    indir_name = [in_dir filename(i,1:26)];
    lat=ncread(indir_name,'lat'); %degrees_north
    lon_E=ncread(indir_name,'lon'); %degrees_east
    lon=lon_E-360; %convert to negative degrees_west    
    depth=ncread(indir_name,'depth'); 
    temp=ncread(indir_name,'temp'); 
    temp(find(temp==-9999))=NaN; %convert -9999 to NaNs
    salt=ncread(indir_name,'salt'); 
    salt(find(salt==-9999))=NaN; %convert -9999 to NaNs
    time=ncread(indir_name,'time'); 
    dn=datenum(datetime({num2str(filename(i,14:23))},'InputFormat','yyyyMMddHH'));

ROMS(i).dn=dn;    
ROMS(i).lat=lat(49); % 36.9573°N,    
ROMS(i).lon=lon(54); % -122.0173°W
ROMS(i).Z=depth;
ROMS(i).T=squeeze(temp(54,49,:));
ROMS(i).S=squeeze(salt(54,49,:));

end

%%
% remove bad data on '11-Apr-2018 09:00:00'
%ROMS(392) = [];

% find dT/dz
for i=1:length(ROMS)
    ROMS(i).Ti = spline(ROMS(1).Z,ROMS(i).T,0:1:40)'; %cubic spline interpolation
    ROMS(i).Si = spline(ROMS(1).Z,ROMS(i).S,0:1:40)';
    ROMS(i).Zi = (0:1:40)';
    ROMS(i).dTdz=(-diff(ROMS(i).Ti))./(diff(ROMS(i).Zi));
    [ROMS(i).maxdTdz,idx]=max(ROMS(i).dTdz);
    ROMS(i).Tmax=ROMS(i).Ti(idx);
    ROMS(i).Zmax=ROMS(i).Zi(idx);
    
end

%find where dT from the surface exceeds 0.5ºC, aka the MLD
for i=1:length(ROMS)
    for j=1:length(ROMS(i).Ti)
       ROMS(i).diff(j)=abs(diff([ROMS(i).Ti(1) ROMS(i).Ti(j)]));
    end
    ROMS(i).mld2=ROMS(i).Zi(find(ROMS(i).diff > 0.2,1));
    ROMS(i).mld2(isempty(ROMS(i).mld2))=40; %replace with deepest depth if empty
    ROMS(i).mld5=ROMS(i).Zi(find(ROMS(i).diff > 0.5,1));
    ROMS(i).mld5(isempty(ROMS(i).mld5))=40; %replace with deepest depth if empty    
    ROMS(i).diff=ROMS(i).diff';
end

out_dir=['~/Documents/MATLAB/bloom-baby-bloom/SCW/Data/ROMS/MB_temp_sal_' num2str(year) '']; %change for whatever year
save(out_dir,'ROMS');


%% plot pcolor temperature and dTdz profile

year=2017;
resultpath='~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load(['Data/ROMS/MB_temp_sal_' num2str(year) ''],'ROMS');
figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
 subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.2]);
% %subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
% %where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

subplot(2,1,1);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];
    pcolor(X,Y,C); shading interp;
    caxis([10 16]); datetick('x',4);  grid on; 
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))
    set(gca,'xticklabel',{},'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,...
        'fontsize',10,'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.FontSize = 10;
    h.Label.String = 'T (^oC)'; 
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    
subplot(2,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.diff];
    pcolor(X,Y,C); shading interp;
    caxis([0 0.5]); datetick('x',4);  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.mld5],20),'k-','linewidth',3);
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))    
    set(gca,'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,'fontsize',10,'tickdir','out');
    datetick('x','mmm','keeplimits','keepticks');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = '\DeltaT from 0m (^oC)';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    legend([hh(1)],'\DeltaT = 0.5^oC','Location','SE');
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs/ROMS_MB_Temp_MLD_' num2str(year) '.tif']);
hold off

%% plot pcolor temperature and dTdz profile

year=2018;
resultpath='~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load(['Data/ROMS/MB_temp_sal_' num2str(year) ''],'ROMS');
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

subplot(3,1,1);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.Ti];

    pcolor(X,Y,C); shading interp;
    caxis([10 16]); datetick('x',4);  grid on; 
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))
    set(gca,'xticklabel',{},'Ydir','reverse','ylim',[0 40],'ytick',0:20:40,'fontsize',10,'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.FontSize = 10;
    h.Label.String = 'T (^oC)'; 
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

subplot(3,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi(1:40)]';
    C=[ROMS.dTdz];
    pcolor(X,Y,C); shading interp;
    caxis([0 0.2]); datetick('x',4);  grid on; 
    hold on
    plot(X,smooth([ROMS.Zmax],20),'w-','linewidth',3);
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))    
    set(gca,'Ydir','reverse','ylim',[0 40],'ytick',0:20:40,'fontsize',10,...
        'xticklabel',{},'tickdir','out');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = 'dTdz (^oC m^{-1})';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

subplot(3,1,3);
    X=[ROMS.dn]';
    Y=[ROMS(1).Zi]';
    C=[ROMS.diff];
    pcolor(X,Y,C); shading interp;
    caxis([0 0.5]); datetick('x',4);  grid on; 
    hold on
    hh=plot(X,smooth([ROMS.mld2],20),'r-',X,smooth([ROMS.mld5],20),'k-','linewidth',3);
    hold on
    xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))    
    set(gca,'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,'fontsize',10,'tickdir','out');
    datetick('x','mmm','keeplimits','keepticks');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = '\DeltaT from 0m (^oC)';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on
    legend([hh(1),hh(2)],'\DeltaT = 0.2^oC','\DeltaT = 0.5^oC','Location','SE');
    
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs/ROMS_MB_Temp_dTdz_' num2str(year) '.tif']);
hold off


%%
surface=zeros(length(ROMS),1);
for i=1:length(ROMS)
    surface(i)=ROMS(i).temp(1,1);
end

%%


imagesc(temp(:,:,1)) %surface, kinda like pcolor
imagesc(salt(:,:,1)) %below, kinda like pcolor


% daydir_0 = datetime({'2018010103'},'InputFormat','yyyyMMddHH'); % 01 January
% daydir_end = datetime({'2018070103'},'InputFormat','yyyyMMddHH'); % 01 July
% daydir_dt = [daydir_0: hours(6): daydir_end]'; % 6hr intervals of ROMS output
% daydir = datestr(daydir_dt,'yyyymmddHH');
% indir_name = [in_dir in_dir_base num2str(daydir(i,1:10)) '.nc'];
    dn=datenum(datetime({num2str(daydir(i,1:10))},'InputFormat','yyyyMMddHH'));
