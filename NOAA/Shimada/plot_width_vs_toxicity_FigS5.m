%% plot PN cell width vs particulate DA
% Fig. SF in Fischer et al. 2024, L&O
% A.D. Fischer, May 2024
%
clear;

%%%%USER
fprint = 0; % 1 = print; 0 = don't
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/Shimada/';

%%%% load in and format data
addpath(genpath(filepath));
load([filepath 'Data/summary_19-21Hake_4nicheanalysis.mat'],'P');
P=sortrows(P,'pDA_pgmL','descend');
P(isnan(P.pDA_pgmL),:)=[]; %remove non detects from discrete dataset    
idx=(P.mean_PNwidth>0); X=P.mean_PNwidth(idx); Y=P.pDA_pgmL(idx); DT=P.DT(idx);
mdl = fitlm(X,Y); % linear regression for total dataset

% split data in 2019 and 2021
idx=(P.DT.Year==2019); 
X19=P.mean_PNwidth(idx); Y19=P.pDA_pgmL(idx);
X21=P.mean_PNwidth(~idx); Y21=P.pDA_pgmL(~idx);

%%%% import Pn width data from literature
s(1).width=[1.1 2]; s(1).name='delicatissima';
s(2).width=[1.5 3.4]; s(2).name='pseudodelicatissima';
s(3).width=[2.4 5.3]; s(3).name='pungens';
s(4).width=[3.4 6]; s(4).name='multiseries';
s(5).width=[4 6]; s(5).name='hemii';
s(6).width=[4.5 7.5]; s(6).name='fraudulenta';
s(7).width=[6.5 8]; s(7).name='australis';

% set colors
c=brewermap(7,'Set3'); col=[c(7,:);c(2,:);c(5,:);c(6,:);c(3,:);c(1,:);c(4,:)];
for i=1:length(col)
    s(i).color=col(i,:);
end

%%%% plot
fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 3.5 4.8]); 
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.1 0.1], [0.17 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, height, width} describes the inner and outer spacings.  

subplot(3,1,1)
    for i=1:length(s)
        line(s(i).width,[i./8 i./8],'color',s(i).color,'linewidth',10); hold on
    end
    set(gca,'ylim',[0.04 .95],'xlim',[-.1 8.1],'xtick',0:2:9,'fontsize',11,...
        'xaxislocation','top','tickdir','out','yticklabel',{}); box on
    xlabel('PN Width (\mum)','fontsize',12);

subplot(3,1,2:3)
col=brewermap(2,'RdBu');
a=scatter(X19(X19>0),Y19(X19>0),25,col(1,:),'o','linewidth',1); hold on
b=scatter(X21(X21>0),Y21(X21>0),25,col(2,:),'o','linewidth',1); hold on
c=scatter(X19(X19<=0),Y19(X19<=0),25,col(1,:),'x','linewidth',1); hold on
d=scatter(X21(X21<=0),Y21(X21<=0),25,col(2,:),'x','linewidth',1); hold on

h=legend([a,b,c],'2019','2021','no PN','Location','nw'); legend boxoff;
hp=get(h,'pos');     
hp=[0.7*hp(1) 1.02*hp(2) hp(3) hp(4)]; % [left, bottom, width, height].
set(h,'pos',hp,'fontsize',10);

%plot(X,mdl.Fitted,'r-')
%xlabel('mean PN width (um)','fontsize',12);
ylabel('pDA (pg/mL)','fontsize',12);
set(gca,'xlim',[-.1 8.1],'ylim',[0 400],'fontsize',11,'tickdir','out','box','on'); hold on;
    xlabel('PN Width (\mum)','fontsize',12);

if fprint
    exportgraphics(fig,[filepath 'Figs/width_vs_pDA.png'],'Resolution',300)    
end
hold off 