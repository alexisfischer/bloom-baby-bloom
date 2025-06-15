%% plot Soundtoxins Dinophysis
% A.D. Fischer, May 2024

clear;
filepath = '~/Documents/MATLAB/bloom-baby-bloom/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));
addpath(genpath(filepath));

DSP=load([filepath 'Data/DSP_PugetSound'],'QH','BI','LB','SB','MB','DB');
load([filepath 'Data/SoundToxins_Dinophysis.mat'],'QH','BI','LB','SB','MB','DB','S');
Month=BI.Month;

%% sample size
figure('Units','inches','Position',[1 1 3.5 4.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.07 0.25], [0.2 0.03]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

cr=brewermap(1,'Reds'); cg=brewermap(6,'Greys');  c=[cr;cg(2:end,:)];

subplot(2,1,1)
b=bar(Month,[BI.n,SB.n,QH.n,DB.n,MB.n,LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:))
end
set(gca,'ylim',[0 220],'ytick',0:100:200,'fontsize',9,'xlim',[.5 12.5],...
    'xtick',1:1:12,'tickdir','out','xticklabel',{})
ylabel({'Soundtoxins';'total samples'},'fontsize',11)
lh=legend([b(6) b(5) b(4) b(3) b(2) b(1)],'LB (Liberty Bay)','MB (Mystery Bay)',...
    'DB (Discovery Bay)','QH (Quartermaster Harbor)','SB (Sequim Bay)','BI (Budd Inlet)',...
    'Location','North','fontsize',9); legend boxoff;
   lh.FontSize = 9; hp=get(lh,'pos');
   lh.Position=[hp(1) hp(2)+.25 hp(3) hp(4)]; hold on   

subplot(2,1,2)
b=bar(Month,[DSP.BI.n,DSP.SB.n,DSP.QH.n,DSP.DB.n,DSP.MB.n,DSP.LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:)); hold on
end
set(gca,'ylim',[0 400],'ytick',0:200:400,'fontsize',9,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
    'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); hold on;
ylabel({'WA DOH';'total samples'},'fontsize',11)

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_DSP_samplesize.png'],'Resolution',300)  

%% final fxs 2 panel plot
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.07 0.04], [0.1 0.28]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
%calculate fx Dinophysis at other sites
mo_total=sum([DB.n,LB.n,MB.n,QH.n,SB.n],2);
mo_P=sum([DB.n.*DB.Present,LB.n.*LB.Present,MB.n.*MB.Present,QH.n.*QH.Present,SB.n.*SB.Present],2);
mo_C=sum([DB.n.*DB.Common,LB.n.*LB.Common,MB.n.*MB.Common,QH.n.*QH.Common,SB.n.*SB.Common],2);
mo_B=sum([DB.n.*DB.Bloom,LB.n.*LB.Bloom,MB.n.*MB.Bloom,QH.n.*QH.Bloom,SB.n.*SB.Bloom],2);
mo_fxP=mo_P./mo_total;
mo_fxC=(mo_C+mo_B)./mo_total;

c=brewermap(4,'RdGy');
hb=bar([BI.Present,mo_fxP]); hold on
hl=plot(Month,(BI.Common+BI.Bloom),'-o',Month,mo_fxC,'-s','markersize',4,'linewidth',1.5); hold on
set(hb(1),'facecolor',c(2,:))
set(hb(2),'facecolor',c(3,:))
set(hl(1),'color',c(1,:),'markerfacecolor',c(1,:))
set(hl(2),'color','k','markerfacecolor','k')
set(gca,'ylim',[0 1],'ytick',0:.5:1,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{});
ylabel('fx of water samples','fontsize',11)

lh1=legend([hb(1) hl(1)],'Present','Common','location','east','fontsize',9); legend boxoff;
   lh1.FontSize = 9; hp=get(lh1,'pos');
   lh1.Position=[hp(1) hp(2)+.051 hp(3)+.5 hp(4)]; hold on 
   title(lh1,'Budd Inlet','fontsize',9)
ah = axes('position',get(gca,'position'),'visible','off');
lh2=legend(ah, [hb(2) hl(2)], {'Present','Common'}, 'Location','southeast','fontsize',9); legend boxoff;  
   lh2.FontSize = 9; hp=get(lh2,'pos');
   lh2.Position=[hp(1) hp(2)+.03 hp(3)+.5 hp(4)]; hold on 
   title(lh2,'Other sites','fontsize',9)
annotation('textbox', [0.73, 0.85, 0.1, 0.1], 'String', "{\itDinophysis} spp.",...
    'fontsize',11,'fontweight','bold','EdgeColor','none')

subplot(2,1,2)
%calculate fx DSTs at other sites
mo_total=sum([DSP.DB.n,DSP.LB.n,DSP.MB.n,DSP.QH.n,DSP.SB.n],2);
mo_w=sum([DSP.DB.n.*DSP.DB.with,DSP.LB.n.*DSP.LB.with,DSP.MB.n.*DSP.MB.with,DSP.QH.n.*DSP.QH.with,DSP.SB.n.*DSP.SB.with],2);
mo_16=sum([DSP.DB.n.*DSP.DB.above16,DSP.LB.n.*DSP.LB.above16,DSP.MB.n.*DSP.MB.above16,DSP.QH.n.*DSP.QH.above16,DSP.SB.n.*DSP.SB.above16],2);
mo_fxw=mo_w./mo_total;
mo_fx16=mo_16./mo_total;

hb=bar([DSP.BI.with,mo_fxw]); hold on
hl=plot(Month,DSP.BI.above16,'-o',Month,mo_fx16,'-s','markersize',4,'linewidth',1.5); hold on
set(hb(1),'facecolor',c(2,:))
set(hb(2),'facecolor',c(3,:))
set(hl(1),'color',c(1,:),'markerfacecolor',c(1,:))
set(hl(2),'color','k','markerfacecolor','k')
set(gca,'ylim',[0 1],'ytick',0:.5:1,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
    'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); hold on;
ylabel({'fx of mussel samples'},'fontsize',11)   

lh1=legend([hb(1) hl(1)],'Detected','\geq16\mug/100g','location','east','fontsize',9); legend boxoff;
   lh1.FontSize = 9; hp=get(lh1,'pos');
   lh1.Position=[hp(1) hp(2)+.051 hp(3)+.56 hp(4)]; hold on 
   title(lh1,'Budd Inlet','fontsize',9)
ah = axes('position',get(gca,'position'),'visible','off');
lh2=legend(ah, [hb(2) hl(2)], {'Detected','\geq16\mug/100g'}, 'Location','southeast','fontsize',9); legend boxoff;  
   lh2.FontSize = 9; hp=get(lh2,'pos');
   lh2.Position=[hp(1) hp(2)+.02 hp(3)+.56 hp(4)]; hold on 
   t=title(lh2,'Other sites','fontsize',9);
annotation('textbox', [0.8, 0.39, 0.1, 0.1], 'String', "DSTs",...
    'fontsize',11,'fontweight','bold','EdgeColor','none')

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_DSP_fxrevised.png'],'Resolution',300)  

%% fxs 2 panel plot
figure('Units','inches','Position',[1 1 5 3.5],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.07 0.04], [0.14 0.28]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(2,1,1)
mo_P=sum([DB.n.*DB.Present,LB.n.*LB.Present,MB.n.*MB.Present,QH.n.*QH.Present,SB.n.*SB.Present],2);
mo_C=sum([DB.n.*DB.Common,LB.n.*LB.Common,MB.n.*MB.Common,QH.n.*QH.Common,SB.n.*SB.Common],2);
mo_B=sum([DB.n.*DB.Bloom,LB.n.*LB.Bloom,MB.n.*MB.Bloom,QH.n.*QH.Bloom,SB.n.*SB.Bloom],2);

c=brewermap(4,'RdGy');
hb=bar([mo_P,BI.Present.*BI.n]); hold on
hl=plot(Month,(mo_C+mo_B),'-s',Month,(BI.Common.*BI.n+BI.Bloom.*BI.n),'-o','markersize',5,'linewidth',1.5); hold on
set(hb(2),'facecolor',c(2,:))
set(hb(1),'facecolor',c(3,:))
set(hl(2),'color',c(1,:),'markerfacecolor',c(1,:))
set(hl(1),'color','k','markerfacecolor','k')
set(gca,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{});
lh=legend([hb(1) hl(1)],'Present','Common','location','east','fontsize',10); legend boxoff;
   lh.FontSize = 10; hp=get(lh,'pos');
   lh.Position=[hp(1) hp(2) hp(3)+.52 hp(4)]; hold on   
ylabel({'total water samples';'with {\itDinophysis} spp.'},'fontsize',11)

subplot(2,1,2)
mo_w=sum([DSP.DB.n.*DSP.DB.with,DSP.LB.n.*DSP.LB.with,DSP.MB.n.*DSP.MB.with,DSP.QH.n.*DSP.QH.with,DSP.SB.n.*DSP.SB.with],2);
mo_16=sum([DSP.DB.n.*DSP.DB.above16,DSP.LB.n.*DSP.LB.above16,DSP.MB.n.*DSP.MB.above16,DSP.QH.n.*DSP.QH.above16,DSP.SB.n.*DSP.SB.above16],2);

hb=bar([mo_w,DSP.BI.with.*DSP.BI.n]); hold on
hl=plot(Month,mo_16,'-s',Month,DSP.BI.above16.*DSP.BI.n,'-o','markersize',5,'linewidth',1.5); hold on
set(hb(2),'facecolor',c(2,:))
set(hb(1),'facecolor',c(3,:))
set(hl(2),'color',c(1,:),'markerfacecolor',c(1,:))
set(hl(1),'color','k','markerfacecolor','k')
set(gca,'ylim',[0 330],'ytick',0:150:300,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
    'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); hold on;

lh=legend([hb(1) hl(1)],'Detected','\geq16\mug/100g','location','east outside','fontsize',10); legend boxoff;
   lh.FontSize = 10; hp=get(lh,'pos');
   lh.Position=[hp(1) hp(2) hp(3)+.56 hp(4)]; hold on   
ylabel({'total mussel samples';'with DSTs'},'fontsize',11)
   
% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_DSP_revised.png'],'Resolution',300)  


%% original 4 panel plot
figure('Units','inches','Position',[1 1 5 4.6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.23], [0.1 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=brewermap(length(S),'Spectral');

subplot(2,2,1)
plot(Month,(BI.Present+BI.Common+BI.Bloom),':',Month,(BI.Common+BI.Bloom),'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(Month,(SB.Present+SB.Common+SB.Bloom),':',Month,(SB.Common+SB.Bloom),'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(Month,(QH.Present+QH.Common+QH.Bloom),':',Month,(QH.Common+QH.Bloom),'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(Month,(DB.Present+DB.Common+DB.Bloom),':',Month,(DB.Common+DB.Bloom),'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(Month,(MB.Present+MB.Common+MB.Bloom),':',Month,(MB.Common+MB.Bloom),'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(Month,(LB.Present+LB.Common+LB.Bloom),':',Month,(LB.Common+LB.Bloom),'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on
set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',9,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{});
ylabel({'fraction of samples'},'fontsize',11)

subplot(2,2,3)
b=bar(Month,[BI.n,SB.n,QH.n,DB.n,MB.n,LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:))
end
set(gca,'ylim',[0 400],'ytick',0:200:400,'fontsize',9,'xlim',[.5 12.5],...
    'xtick',1:1:12,'tickdir','out','xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'})
ylabel('total samples','fontsize',11)
lh=legend('Budd Inlet','Sequim Bay','Quartermaster Harbor','Discovery Bay',...
    'Mystery Bay','Liberty Bay','Location','North','fontsize',9); legend boxoff;
    lh.FontSize = 9; hp=get(lh,'pos');
    lh.Position=[hp(1) hp(2)+.6 hp(3) hp(4)]; hold on   

subplot(2,2,2)
plot(Month,DSP.BI.with,':',Month,DSP.BI.above16,'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.SB.with,':',Month,DSP.SB.above16,'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.QH.with,':',Month,DSP.QH.above16,'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.DB.with,':',Month,DSP.DB.above16,'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.MB.with,':',Month,DSP.MB.above16,'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(Month,DSP.LB.with,':',Month,DSP.LB.above16,'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on
set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',9,'yticklabel',{},...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{}); hold on;

subplot(2,2,4)
b=bar(Month,[DSP.BI.n,DSP.SB.n,DSP.QH.n,DSP.DB.n,DSP.MB.n,DSP.LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:)); hold on
end
set(gca,'ylim',[0 400],'ytick',0:200:400,'fontsize',9,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','yticklabel',{},...
    'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'}); hold on;
xtickangle=90;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_DSP_lineplot.png'],'Resolution',300)  

%% Soundtoxins only
figure('Units','inches','Position',[1 1 3.5 4.6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.04 0.04], [0.08 0.23], [0.2 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.
c=brewermap(length(S),'Spectral');

subplot(2,1,1)
b=bar(Month,[BI.n,SB.n,QH.n,DB.n,MB.n,LB.n],'stacked','FaceColor','flat','BarWidth',1); hold on;
for i=1:length(b)
    set(b(i),'FaceColor',c(i,:))
end
set(gca,'ylim',[0 215],'ytick',0:100:200,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out','xticklabel',{})
ylabel('total samples','fontsize',11)
lh=legend('Budd Inlet','Sequim Bay','Quartermaster Harbor','Discovery Bay',...
    'Mystery Bay','Liberty Bay','Location','North','fontsize',10); legend boxoff;
    lh.FontSize = 9; hp=get(lh,'pos');
    lh.Position=[hp(1) hp(2)+.24 hp(3) hp(4)]; hold on   

subplot(2,1,2)
plot(Month,(BI.Present+BI.Common+BI.Bloom),':',Month,(BI.Common+BI.Bloom),'-','Color',c(1,:),'markersize',3,'linewidth',2); hold on
plot(Month,(SB.Present+SB.Common+SB.Bloom),':',Month,(SB.Common+SB.Bloom),'-','Color',c(2,:),'markersize',3,'linewidth',2); hold on
plot(Month,(QH.Present+QH.Common+QH.Bloom),':',Month,(QH.Common+QH.Bloom),'-','Color',c(3,:),'markersize',3,'linewidth',2); hold on
plot(Month,(DB.Present+DB.Common+DB.Bloom),':',Month,(DB.Common+DB.Bloom),'-','Color',c(4,:),'markersize',3,'linewidth',2); hold on
plot(Month,(MB.Present+MB.Common+MB.Bloom),':',Month,(MB.Common+MB.Bloom),'-','Color',c(5,:),'markersize',3,'linewidth',2); hold on
plot(Month,(LB.Present+LB.Common+LB.Bloom),':',Month,(LB.Common+LB.Bloom),'-','Color',c(6,:),'markersize',3,'linewidth',2); hold on

set(gca,'ylim',[-.02 1.02],'ytick',0:.5:1,'fontsize',10,...
    'xlim',[.5 12.5],'xtick',1:1:12,'tickdir','out',...
   'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D'});
ylabel({'fraction of samples';'with \itDinophysis \rmspp.'},'fontsize',11)


%% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Soundtoxins_lineplot.png'],'Resolution',100)    
hold off
