%% plot fx PN species composition as pie charts using SEM data
% Shimada 2019 and 2021
% did not end up using this, but is a nice plot
% A.D. Fischer, May 2024
%
clear; 

%%%%USER
yr=2019; % 2019; 2021
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/'; %enter filepath

% load in data
addpath(genpath(filepath)); % add new data to search path
load([filepath 'Data/HAB_merged_Shimada19-21'],'HA');
HA=HA(~isnan(HA.fx_frau),:); %remove non SEM samples
HA((HA.lat<41),:)=[]; %remove CA stations
HA(~(HA.dt.Year==yr),:)=[]; % select year of data

if yr==2019
    val=4.3;
elseif yr==2021
    val=4.0;    
end

H=flipud(HA); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom

labels={'delicatatisi.','pungens','pseudodeli.','heimii','fraudulenta','multiseries','australis'};
low=brewermap(2,'Blues'); mh=brewermap(7,'YlOrRd'); 
col(1,:)=low(2,:); 
col(2,:)=mh(1,:); col(3,:)=mh(2,:); col(4,:)=mh(3,:); 
col(5,:)=mh(4,:); col(6,:)=mh(6,:); col(7,:)=mh(7,:);

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
lgd = legend(labels,'fontsize',9);
lgd.Layout.Tile = 'south';
legend boxoff;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/SEM_Shimada' num2str(yr) '.png'],'Resolution',300)    
hold off

