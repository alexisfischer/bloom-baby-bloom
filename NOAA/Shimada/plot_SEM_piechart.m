%% plot SEM pie charts
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');

yr=2021;

if yr==2019
    idx=find(HA.dt<datetime('01-Jan-2020'));
    HA=HA(idx,:);
    val=3.9;
elseif yr==2021
    idx=find(HA.dt>datetime('01-Jan-2020'));
    HA=HA(idx,:);
    val=4.3;    
end

H=HA(~isnan(HA.fx_frau),:); %remove non SEM samples
H((H.lat<41),:)=[]; %remove CA stations
H=flipud(H); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom

labels={'delicatatisi.','pungens','pseudodeli.','heimii','fraudulenta','multiseries','australis'};
low=brewermap(2,'Blues'); 
mh=brewermap(6,'YlOrRd'); 
col(1,:)=low(1,:); col(2,:)=low(2,:); 
col(3,:)=mh(1,:); col(4,:)=mh(2,:); col(5,:)=mh(3,:); 
col(6,:)=mh(5,:); col(7,:)=mh(6,:);

% plot SEM piecharts on 1 figure
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1.4 val]); 
t = tiledlayout(length(H.fx_frau),1,'TileSpacing','compact');
for i=1:length(H.fx_pseu)
    ax(i) = nexttile;
    X=[H.fx_deli(i),H.fx_pung(i),H.fx_pseu(i),H.fx_heim(i),H.fx_frau(i),H.fx_mult(i),H.fx_aust(i)];
    idx=find(X==0);
    l=labels; l(idx)={''};
    p=pie(ax(i),X,l);
    ax(i).Colormap=col;
%    title(H.st2(i),'fontsize',9);
    delete(findobj(p,'Type','text'))%option 2    
    hold on
end

t.TileSpacing = 'none'; t.Padding = 'none';

% Create legend
lgd = legend(labels,'fontsize',9);
lgd.Layout.Tile = 'south';
legend boxoff;

% set figure parameters
exportgraphics(gcf,[filepath 'NOAA/Shimada/Figs/SEM_Shimada' num2str(yr) '.png'],'Resolution',300)    
hold off

