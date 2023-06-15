%% plot SEM pie charts
clear; %close all;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath(filepath)); % add new data to search path

load([filepath 'NOAA/Shimada/Data/HAB_merged_Shimada19-21'],'HA');

H=HA(~isnan(HA.fx_frau),:); %remove non SEM samples
H((H.st<185),:)=[]; %remove CA stations
H=flipud(H); H.st2(:)=(1:1:length(H.st)); %order them so 1:6, top to bottom

H.fx_frau=[];
labels={'pungens','pseudodeli.','heimii','multiseries','australis'};
low=brewermap(2,'Blues'); %
mh=brewermap(6,'YlOrRd'); 
col(1,:)=low(2,:); 
col(2,:)=mh(1,:); col(3,:)=mh(2,:); 
col(4,:)=mh(5,:); col(5,:)=mh(6,:);

% plot SEM piecharts on 1 figure
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 1.4 3.7]); 
t = tiledlayout(6,1,'TileSpacing','compact');
for i=1:length(H.fx_pseu)
    ax(i) = nexttile;
    X=[H.fx_pung(i),H.fx_pseu(i),H.fx_heim(i),H.fx_mult(i),H.fx_aust(i)];
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
exportgraphics(gcf,[filepath 'NOAA/Shimada/Figs/SEM_Shimada2019.png'],'Resolution',300)    
hold off


%% not using
for i=1:length(H.fx_pseu)
    i=1
    figure; set(gcf,'color','w','Units','inches','Position',[1 1 2 2]); 
    X=[H.fx_pseu(i),H.fx_heim(i),H.fx_pung(i),H.fx_mult(i),H.fx_frau(i),H.fx_aust(i)];    
    idx=find(X>0);
    h=pie(X(idx),labels(idx)); hold on
    hp = findobj(h, 'Type', 'patch');
    
    set(hp(1),'Color','g');
    set(hp(2),'Color','r');
    set(hp(3),'Color','b');
    set(hp(4),'Color','m');
end
