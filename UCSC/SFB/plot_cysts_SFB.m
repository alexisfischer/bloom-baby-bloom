resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SFB/';

load([resultpath 'Data/SFB_cyst_data.mat']);

%% plot overall SFB map w stations

figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');        
m_proj('albers equal-area','lat',[37.4 38.25],'long',[-123.1 -122],'rect','on');
m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');    
m_grid('linestyle','none','linewidth',1,'tickdir','out',...
     'xaxisloc','top','yaxisloc','left','fontsize',10);
h1=m_line(lon,lat,'marker','o','color','b','linewi',1,...
          'linest','none','markersize',4,'markerfacecolor','w');        

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\SFB_map.tif']);
hold off 

%% plot overall SFB map with A. cat only

figure('Units','inches','Position',[1 1 6 4],'PaperPositionMode','auto');        

    cyst=A_cat;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);

    color=flipud(autumn); % define colors according to cyst abundance
    colormap(color);    
   d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    hold on
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.4 38.3],'long',[-123.1 -122],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10);
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.1,'linest','none');
    end
    hold on

% Create colorbar
    caxis([2 40]); 
    h=colorbar('Location','EastOutside',...        
    'Ticks',[2 10 20 30 40],...
    'FontSize',10);
    h.Ticks=[2,10,20,30,40];
    h.Label.String={'\bf Cysts cc^-^1'};    
    set(h,'tickdir','out','fontsize',10) 
    
    % set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r600',[resultpath 'Figs\SFB_map_Acat.tif']);
    hold off 

%% Part 1: plot close up of Richardson bay SFB map w stations
% plot cyst map with dot size proportional to cyst concentration

figure('Units','inches','Position',[1 1 10 4],'PaperPositionMode','auto');        
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.04], [0.07 0.12]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(1,4,1)
    cyst=A_cat;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);

    color=flipud(autumn); % define colors according to cyst abundance
    colormap(color);    
   d=cystok./41;  
   % d=cystok./max(cystok);  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    hold on
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
%    s=cystok./max(cystok);      
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10);
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.1,'linest','none');
    end
    hold on

subplot(1,4,2)
    cyst=A_ost;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);
    
    d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10,'yticklabel',{});
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.2,'linest','none');
    end
    hold on
     
subplot(1,4,3)
    cyst=P_heart;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);
    
    d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10,'yticklabel',{});
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.2,'linest','none');
    end
    hold on    
 
subplot(1,4,4)
    cyst=P_spin;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);
    
    d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10,'yticklabel',{});
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.2,'linest','none');
    end
    hold on
    
% Create colorbar
    caxis([2 40]); 
    h=colorbar('Position',...
    [0.90800305460099 0.184027777777778 0.0294969453990094 0.641465100489733],...        
    'Ticks',[2 10 20 30 40],...
    'FontSize',10);
    h.Ticks=[2,10,20,30,40];
    h.Label.String={'\bf Cysts cc^-^1'};    
    set(h,'tickdir','out','fontsize',10) 
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\SFB_cyst_distribution_part1.tif']);
hold off 

%% Part 2: plot close up of Richardson bay SFB map w stations
% plot cyst map with dot size proportional to cyst concentration

figure('Units','inches','Position',[1 1 10 4],'PaperPositionMode','auto');        
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.04 0.04], [0.07 0.12]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(1,4,1)
    cyst=P_rndbr;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);

    color=flipud(autumn); % define colors according to cyst abundance
    colormap(color);    
   d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    hold on
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10);
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.1,'linest','none');
    end
    hold on

subplot(1,4,2)
    cyst=Polykrk;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);
    
    d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10,'yticklabel',{});
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.2,'linest','none');
    end
    hold on
     
subplot(1,4,3)
    cyst=Spinif;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);
    
    d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10,'yticklabel',{});
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.2,'linest','none');
    end
    hold on    
 
subplot(1,4,4)
    cyst=Scrip;     
    ii=~isnan(cyst);
    lonk=lon(ii); latk=lat(ii); cystk=cyst(ii);   
    [Xo,order]=sort(cystk); 
    cystok=cystk(order);
    latok=latk(order);
    lonok=lonk(order);
    
    d=cystok./41;  
    d(d<=.01)=.01; %replace values <0 with 0.01   
    dcol=zeros(length(d),3); %preallocate space   
    for i=1:length(dcol)  
        dcol(i,:)=color(round(d(i)*length(color)),:);
    end    
    
    j=find(cystok>1,1);
    dcol(1:j,:)=zeros(size((dcol(1:j,:))));
    
    sz=linspace(4,10,100); % define sizes according to cyst abundance
    s=cystok./41;  
    s(s<=.01)=.01; %replace values <0 with 0.01   
    scol=zeros(length(s),1); %preallocate space   
    for i=1:length(scol)  % define sizes according to cyst abundance
        scol(i)=sz(round(d(i)*length(sz)));
    end
    
    hold on
    m_proj('albers equal-area','lat',[37.5 37.95],'long',[-122.55 -122.15],'rect','on');
    m_gshhs_h('patch',[.8 .8 .8],'edgecolor','none');  
    m_grid('linestyle','none','linewidth',1,'tickdir','out',...
         'xaxisloc','top','yaxisloc','left','fontsize',10,'yticklabel',{});
    hold on    
    for i=1:length(lonok) % plot each point separately with a special color representing cyst abundance
        m_line(lonok(i),latok(i),'marker','o','markersize',scol(i),'color','k',...
            'markerfacecolor',dcol(i,:),'linewi',.2,'linest','none');
    end
    hold on
    
% Create colorbar
    caxis([2 40]); 
    h=colorbar('Position',...
    [0.90800305460099 0.184027777777778 0.0294969453990094 0.641465100489733],...        
    'Ticks',[2 10 20 30 40],...
    'FontSize',10);
    h.Ticks=[2,10,20,30,40];
    h.Label.String={'\bf Cysts cc^-^1'};    
    set(h,'tickdir','out','fontsize',10) 
        
% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\SFB_cyst_distribution_part2.tif']);
hold off 