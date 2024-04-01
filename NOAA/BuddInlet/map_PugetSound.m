%% plot Puget Sound map
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

m_proj('albers equal-area','lat',[48.5 46.8],'long',[-125 -122],'rect','on');
m_gshhs_f('save',[filepath 'Figs/PugetSound_map']);

load([filepath 'Figs/PugetSound_map'],'ncst');

%% BuddInlet Map
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[47.13 47.04],'long',[-122.94 -122.88],'rect','on');

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none');  
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',12);  

m_ruler(.05,[.02 .35],'ticklen',.01);

%m_line(-122.905,47.0465,'marker','.','markersize',12,'color','k');
m_line(-122.906843,47.047,'marker','.','markersize',12,'color','k');


%% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Map_BuddInlet.png'],'Resolution',300)    
hold off

%% Puget Sound Map
figure('Units','inches','Position',[1 1 3.5 4],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[48.2 47],'long',[-123.3 -122.2],'rect','on');

m_gshhs_f('patch',[.8 .8 .8],'edgecolor','none');  
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',12);  

m_ruler(.05,[.02 .35],3,'ticklen',.02,'fontsize',10);

m_line(-122.90702,47.04571,'marker','.','markersize',12,'color','k');
m_text(-122.86,47.04571,{'Budd Inlet'},'fontsize',10,'fontweight','bold');

m_line(-123.04609,48.08195,'marker','.','markersize',12,'color','k');
m_text(-123.04609-.05,48.08195-.05,{'SB'},'fontsize',10);

m_line(-122.62655,47.70521,'marker','.','markersize',12,'color','k');
m_text(-122.62655-.05,47.70521-.05,{'LB'},'fontsize',10);

m_line(-122.43893,47.39728,'marker','.','markersize',12,'color','k');
m_text(-122.43893-.05,47.39728-.05,{'QH'},'fontsize',10);

m_line(-122.86722,48.03791,'marker','.','markersize',12,'color','k');
m_text(-122.86722-.05,48.03791-.05,{'DB'},'fontsize',10);

m_line(-122.69488,48.0569,'marker','.','markersize',12,'color','k');
m_text(-122.69488-.05,48.0569-.05,{'MB'},'fontsize',10);

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/Map_PugetSound.png'],'Resolution',300)    
hold off
