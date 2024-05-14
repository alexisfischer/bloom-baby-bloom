%% plot Puget Sound map
%https://www.mathworks.com/help/map/converting-coastline-data-gshhs-to-shapefile-format.html
%https://www.ngdc.noaa.gov/mgg/shorelines/data/gshhg/latest/
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

%world map
figure('Units','inches','Position',[1 1 1.8 1.8],'PaperPositionMode','auto');        

m_proj('ortho','lat',48','long',-123');
m_coast('patch',[.8 .8 .8],'edgecolor','none');
m_grid('linest','--','linewidth',.2,'xtick',-360:40:360,'xticklabels',[],'yticklabels',[]);

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/World_map.png'],'Resolution',300)    
hold off

%%
%%%% Puget Sound Map
figure('Units','inches','Position',[1 1 3.5 5],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[48.55 46.9],'long',[-123.8 -122.15],'rect','on'); hold on;

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none');  hold on;
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',10); hold on;  

%m_usercoast([filepath 'Data/PNW_watershed'],'color','w','linewidth',.5)

m_ruler(.05,[.02 .2],3,'ticklen',.02,'fontsize',8);

m_line(-122.90702,47.04571,'marker','o','linewidth',1,'markersize',8,'color','k');
m_line(-122.90702,47.04571,'marker','.','linewidth',1,'markersize',12,'color','k');
m_text(-122.90702-.04,47.04571-.07,{'BI'},'fontsize',9);

m_line(-123.04609,48.08195,'marker','.','markersize',10,'color','k');
m_text(-123.04609-.13,48.08195-.03,{'SB'},'fontsize',9);

m_line(-122.62655,47.70521,'marker','.','markersize',10,'color','k');
m_text(-122.62655-.13,47.70521-.03,{'LB'},'fontsize',9);

m_line(-122.43893,47.39728,'marker','.','markersize',10,'color','k');
m_text(-122.43893-.13,47.39728-.03,{'QH'},'fontsize',9);

m_line(-122.86722,48.03791,'marker','.','markersize',10,'color','k');
m_text(-122.86722-.13,48.03791-.03,{'DB'},'fontsize',9);

m_line(-122.69488,48.0569,'marker','.','markersize',10,'color','k');
m_text(-122.69488-.13,48.0569-.03,{'MB'},'fontsize',9);

%m_line(-122.902,47.01,'marker','^','markersize',4,'color','k');
%m_text(-122.73,46.98,{'Deschutes';'River'},'fontsize',8);

hold on;

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Map_PugetSound.png'],'Resolution',300)    
hold off


%% BuddInlet Map
figure('Units','inches','Position',[1 1 2.5 3],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[47.2 46.99],'long',[-122.98 -122.8],'rect','on');

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none'); hold on
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',12);  

m_ruler(.05,[.02 .35],'ticklen',.01);

m_usercoast([filepath 'Data/PNW_watershed'],'color','w','linewidth',1.5)

%m_line(-122.906843,47.047,'marker','.','markersize',12,'color','k');
m_line(-122.90702,47.04571,'marker','o','linewidth',1,'markersize',8,'color','k');
m_line(-122.90702,47.04571,'marker','.','linewidth',1,'markersize',12,'color','k');
m_text(-122.90702-.11,47.04571-.03,{'BI'},'fontsize',9);


%% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Map_BuddInlet.png'],'Resolution',300)    
hold off