load('MB_ROMs_filenames_Jan-Jul2018','filename'); filename=flipud(char(filename));
in_dir='http://west.rssoffice.com:8080/thredds/dodsC/roms/CA3km-nowcast/MB/';
out_dir='~/Documents/MATLAB/bloom-baby-bloom/SCW/ROMS/MB_temp_sal_2018';
in_dir_base='ca_subMB_das_';

ROMS.dn=zeros(length(filename),1);
ROMS.lat=zeros(length(filename),1);
ROMS.lon=zeros(length(filename),1);
ROMS.depth=zeros(length(filename),1);
ROMS.temp=zeros(length(filename),1);
ROMS.salt=zeros(length(filename),1);

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
ROMS(i).depth=depth;
ROMS(i).temp=squeeze(temp(54,49,:));
ROMS(i).salt=squeeze(salt(54,49,:));
    
end

% remove bad data on '11-Apr-2018 09:00:00'
ROMS(392) = [];

save(out_dir,'ROMS');

%% find dT/dz
load('MB_temp_sal_2018','ROMS');

for i=1:length(ROMS)
    ROMS(i).dTdz=abs((diff(ROMS(i).temp)))./(diff(ROMS(i).depth));
    [ROMS(i).maxdTdz,idx]=max(ROMS(i).dTdz);
    ROMS(i).maxT=ROMS(i).temp(idx);
    ROMS(i).maxZ=ROMS(i).depth(idx);
end

save('~/Documents/MATLAB/bloom-baby-bloom/SCW/ROMS/MB_temp_sal_2018','ROMS');


%% plot pcolor temperatyre and dTdz profile
resultpath='~/Documents/MATLAB/bloom-baby-bloom/SCW/';

figure('Units','inches','Position',[1 1 8 4],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.06 0.06], [0.08 0.04], [0.09 0.2]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings. 

subplot(2,1,1);
    X=[ROMS.dn]';
    Y=[ROMS(1).depth]';
    C=[ROMS.temp];

    pcolor(X,Y,C); shading interp;
    caxis([10 16]); datetick('x',4);  grid on; 
    hold on

    set(gca,'XLim',[datenum('01-Jan-2018') datenum('01-Jul-2018')],'xticklabel',{},...
        'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,'fontsize',10,'tickdir','out');

    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
  %  colormap(jet);
    h=colorbar; 
    h.FontSize = 10;
    h.Label.String = 'T (^oC)'; 
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

subplot(2,1,2);
    X=[ROMS.dn]';
    Y=[ROMS(1).depth(1:23)]';
    C=[ROMS.dTdz];
    
%    colormap(jet);
    pcolor(X,Y,C); shading interp;
    caxis([0 0.2]); datetick('x',4);  grid on; 
    hold on
    plot(X,smooth([ROMS.maxZ],20),'w-','linewidth',2);
    hold on

    set(gca,'XLim',[datenum('01-Jan-2018') datenum('01-Jul-2018')],...
        'Ydir','reverse','ylim',[0 40],'ytick',0:10:40,'fontsize',10,'tickdir','out');
    datetick('x','mmm','keeplimits','keepticks');
    ylabel('Depth (m)','fontsize',12,'fontweight','bold');
    h=colorbar; 
    h.Label.String = 'dTdz (^oC m^{-1})';
    h.FontSize = 10;
    h.Label.FontSize = 12;
    h.Label.FontWeight = 'bold';
    h.TickDirection = 'out';
    hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs/ROMS_MB_Temp_dTdz_2018.tif']);
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
