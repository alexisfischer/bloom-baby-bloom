%% plot Dinophysis vs TS plots
clear
filepath = '~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath(filepath));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom'));

load([filepath 'Data/BuddInlet_data_summary'],'T','Tc');

%%%% set data type
%type='daily';
type='continuous';

%%%% set year
yr='2021-2023';
%yr='2021';
%yr='2022';
%yr='2023';

if strcmp('daily',type), data=T; else data=Tc; end
if strcmp('2021-2023',yr), else idx=find(data.dt.Year==str2double(yr)); data=data(idx,:); end

%%%% set variable
%daily
    %label='Dinophysis'; var=data.dino_fl; cax=[0 3]; col=brewermap(256,'YlOrRd');
    %label='Mesodinium'; var=data.meso_fl; cax=[0 3]; col=brewermap(256,'BuGn');
%continuous
    label='Mesodinium'; var=data.meso; cax=[0 10]; col=brewermap(256,'BuGn');
    %label='Dinophysis'; var=data.dino; cax=[0 4]; col=brewermap(256,'YlOrRd');
    %label='D. fortii'; var=data.M_dfort; cax=[0 3]; col=brewermap(256,'YlOrRd');
    %label='D. acuminata'; var=data.M_dacum; cax=[0 3]; col=brewermap(256,'YlOrRd');
    %label='D. norvegica'; var=data.M_dnorv; cax=[0 3]; col=brewermap(256,'YlOrRd');

%%%% get isopycnals
s=data.s1; t=data.t1;
yax=[9 24]; xax=[20 32];
[SA_gridded,CT_gridded,isopycs_gridded]=get_isopycnals(s,t,1);

if strcmp('2021-2023',yr)
    %%%% pcolor plot
    % Create grid
    res=.5;
    s_grid = min(s):res:max(s);
    t_grid = min(t):res:max(t);
    nx = length(s_grid);
    ny = length(t_grid);    
    
    % Average data on grid
    data_grid = nan(nx,ny);
    for ii = 1:nx
        for jj = 1:ny
            data_grid(ii,jj) = mean(var(s>=s_grid(ii)-res/2 & s<s_grid(ii)+res/2 & t>=t_grid(jj)-res/2 & t<t_grid(jj)+res/2),'omitnan');
        end
    end    
    [t_plot,s_plot] = meshgrid(t_grid,s_grid);
    
    fig=figure; set(gcf,'color','w','Units','inches','Position',[1 1 4 4]);     
        h=pcolor(s_plot-res/2,t_plot-res/2,data_grid); % have to shift t/s for pcolor with flat shading     
        shading flat; hold on;
        clearvars t_plot s_plot ii jj nx ny s_grid t_grid data_grid res
    
        colormap(col); clim(cax);
        axis([xax(1) xax(2) yax(1) yax(2)]);
        h=colorbar('eastoutside','AxisLocation','out');
        h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = [label ' (cells/mL)'];
        h.Label.FontSize = 12; 
        xtickangle(0); hold on; 
        xlabel('Salinity (ppt)','fontsize',12)
        ylabel('Temperature (^oC)','fontsize',12)  
        title([yr ' ' type],'fontsize',12);
    [c1,h] = contour(SA_gridded,CT_gridded,isopycs_gridded,13:2:24,':','Color',[.5 .5 .5]); hold on;
    clabel(c1,h,'labelspacing',300,'fontsize',10,'color',[.5 .5 .5]); hold on

else
    %%%% scatter
    figure('Units','inches','Position',[1 1 4 4],'PaperPositionMode','auto');
    [c1,h] = contour(SA_gridded,CT_gridded,isopycs_gridded,13:2:24,':','Color',[.5 .5 .5]); hold on;
    clabel(c1,h,'labelspacing',360,'fontsize',10,'color',[.5 .5 .5]); hold on
    scatter(s,t,30,var,'filled'); 
    clim(cax); hold on;
    set(gca,'fontsize',10,'ylim',yax,'xlim',xax)
    box on;
        colormap(col);  
        h=colorbar('eastoutside','AxisLocation','out');
        h.TickDirection = 'out'; h.FontSize = 10; h.Label.String = [label ' (cells/mL)'];
        h.Label.FontSize = 12; %h.Ticks=linspace(cax(1),cax(2),3); hold on   
    xlabel('Salinity (ppt)','fontsize',12)
    ylabel('Temperature (^oC)','fontsize',12)
        title([yr ' ' type],'fontsize',12);    
end

% set figure parameters
exportgraphics(gcf,[filepath 'Figs/TS_diagram_' label '_' yr '.png'],'Resolution',100)    
hold off
