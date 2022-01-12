resultpath = '~/Documents/MATLAB/bloom-baby-bloom/SCW/';
load([resultpath 'Data/RAI_SCW.mat'],'r');
load([resultpath 'Data/SCW_SCOOS.mat'],'a');

%% Chl threshold, color proportional to RAI score, and organize data in matrix

dnchl=a.dn(find(a.chl>=3)); %find the dates with chlorophyll exceeding a threshold
for h=1:length(r)
    r(h).xChl=zeros(size(dnchl));
    r(h).yChl=zeros(size(dnchl));
    r(h).color=zeros(size(dnchl));    
    for i=1:length(dnchl) %find corresponding dates in rai dataset
        for j=1:length(r(h).dn)
            if dnchl(i) == r(h).dn(j)
                r(h).xChl(i) = r(h).dn(j); %only use data with Chl > a threshold
                r(h).yChl(i) = r(h).count(j); %only use data with Chl > a threshold
            else
            end
        end
    end
end

%organize data into a year x week matrix
for i=1:length(r) 
    for j=1:length(r(i).yChl)
        r(i).color(j) = r(i).yChl(j)./4; %Assign colors proporational to RAI score  
    end
    [~,r(i).y_mat,r(i).yearlist,~]=timeseries2ydmat(r(i).xChl,r(i).color); %takes a timeseries and makes it into a year x day matrix
    [r(i).y_wkmat,~,r(i).yd_wk]=ydmat2weeklymat(r(i).y_mat,r(i).yearlist); %takes a year x day matrix and makes it a year x 1 week matrix
end

%% Pcolor RAI in a year x week matrix for each species
ind=1; %USER enter your species
%species=[55;50;36;34;32;28;19;17;7;5;1];

figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto'); 
X=[r(ind).yd_wk ;r(ind).yd_wk(end)+7]; %365 days in a year
Y=[r(ind).yearlist(1:8) r(ind).yearlist(8)+1];
C=[[r(ind).y_wkmat(:,1:8)'; zeros(1,52)] zeros(9,1)];

pcolor(X,Y,C); caxis([0 1]); colormap(flipud(hot));
datetick('x',4); axis square; shading flat;

set(gca,'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D',''},...
    'ylim',[2012 2019],'ytick',2012:2019,'yticklabel',{'','2012','2013','2014',...
    '2015','2016','2017','2018'},'fontsize',12,'tickdir','out');

ylabel('Year', 'fontsize',14, 'fontweight','bold');
xlabel('Month', 'fontsize',14, 'fontweight','bold');
title(num2str(r(ind).name), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

h=colorbar('Ticks',[0,.25,.5,.75,1],'TickLabels',...
    {'0 Absent','1 Rare','2 Present','3 Common','4 Abundant'});
h.Label.String = 'RAI (fraction)';
h.FontSize = 12;
h.Label.FontSize = 14;
h.Label.FontWeight = 'bold';
h.TickDirection = 'out';

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_ChlThr_' num2str(r(ind).name) '_2012-2018.tif']);
hold off
   
%% Pcolor Dino vs Diatoms in a year x week matrix
clearvars class2do_string dnok dnchl dnk h i ii j rk rok y_mat y_wkmat yd_wk yearlist;

%ind=61; %diatoms
ind=60; %dinoflagellates

dnchl=a.dn(find(a.chl>=3)); %find the dates with chlorophyll exceeding a threshold
for i=1:length(dnchl) %find corresponding dates in rai dataset
    for j=1:length(r(ind).dn)
        if dnchl(i) == r(ind).dn(j)
            dnk(i) = r(ind).dn(j);
            rk(i) = r(ind).rai(j);           
        else
        end
    end
end

ii=find(rk); rok=rk(ii)'; dnok=dnk(ii)'; %remove NaNs
[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok); %takes a timeseries and makes it into a year x day matrix
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist); %takes a year x day matrix and makes it a year x 2 week matrix

figure('Units','inches','Position',[1 1 6.5 5.5],'PaperPositionMode','auto'); 
X=[yd_wk]; 
Y=[yearlist(1:8) yearlist(8)+1];
C=[[y_wkmat(:,1:8)';zeros(1,52)]];

pcolor(X,Y,C); caxis([0 0.7]); colormap(flipud(hot));
datetick('x',4); axis square; shading flat;

set(gca,'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D',''},...
    'ylim',[2012 2019],'ytick',2012:2019,'yticklabel',{'','2012','2013','2014',...
    '2015','2016','2017','2018'},'fontsize',12,'tickdir','out');

ylabel('Year', 'fontsize',14, 'fontweight','bold');
xlabel('Month', 'fontsize',14, 'fontweight','bold');
title(num2str(r(ind).name), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

h=colorbar;
h.Label.String = 'Fraction of RAI biomass';
h.FontSize = 12;
h.Label.FontSize = 14;
h.Label.FontWeight = 'bold';
h.TickDirection = 'out';

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_ChlThr_' num2str(r(ind).name) '_2012-2018.tif']);
hold off

%% Pcolor RAI of select species in a year x week matrix 
year='2018';
species=[55;50;36;34;32;28;19;17;7;5;1];
for i=1:length(species)
    M(i,:)=r(species(i)).y_wkmat(:,8)';
end
name={r(species).name}

figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto'); 
X=[r(1).yd_wk ;r(1).yd_wk(end)+7]; %365 days in a year
Y=1:12;
C=[[M; zeros(1,52)] zeros(12,1)];

pcolor(X,Y,C); caxis([0 1]); colormap(flipud(hot));
datetick('x',4); axis square; shading flat;

set(gca,'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D',''},...
    'ytick',1:12,'yticklabel',{'',r(species).name},'fontsize',12,'tickdir','out');

xlabel('Month', 'fontsize',14, 'fontweight','bold');
title(num2str(year), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

h=colorbar('Ticks',[0,.25,.5,.75,1],'TickLabels',...
    {'0 Absent','1 Rare','2 Present','3 Common','4 Abundant'});
h.Label.String = 'RAI (fraction)';
h.FontSize = 12;
h.Label.FontSize = 14;
h.Label.FontWeight = 'bold';
h.TickDirection = 'out';

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_speces_ChlThr_' num2str(year) '.tif']);
hold off

 %%
xmat=xmat';
ydino=ydino';
ydiat=ydiat';

fx_dino=[ydino-[yAKA+yCER+yDINO+yLING+yPRO]]./ymat; %fraction other dinos
fx_diat=[ydiat-[yCHAET+yC+yDETO+yPN+yEUC+yGUIN]]./ymat; %fraction other diatoms
fx_other=[ymat-[ydino+ydiat]]./ymat; %fraction not dinos or diatoms

figure;

bar(xmat,[yAKA./ymat yCER./ymat yDINO./ymat yLING./ymat yPRO./ymat...
    yCHAET./ymat yDETO./ymat yEUC./ymat yGUIN./ymat yPN./ymat yC./ymat...
    fx_dino fx_diat fx_other], 0.5, 'stack');
ax = get(gca);
cat = ax.Children;

cstr = [[220 220 220]/255; [110 110 110]/255; [0 0 0]/255;...
    [255,255,153]/255; [166,206,227]/255; [31,120,180]/255;...
    [178,223,138]/255; [51,160,44]/255; [251,154,153]/255; [227,26,28]/255;...
    [253,191,111]/255; [255,127,0]/255; [202,178,214]/255;...
    [106,61,154]/255;[220 220 220]/255];

for ii = 1:length(cat)
    set(cat(ii), 'FaceColor', cstr(ii,:),'BarWidth',1)
end

datetick('x', 3, 'keeplimits')
xlim(datenum([['01-Jan-' num2str(year) '']; ['01-Jul-' num2str(year) '']]))
ylim([0;1])
set(gca,'xticklabel',{}, 'fontsize', 10, 'fontname', 'arial','tickdir','out')
ylabel('Fraction of total biovolume', 'fontsize', 12, 'fontname', 'arial','fontweight','bold')
h=legend('Akashiwo','Ceratium','Dinophysis','Lingulodinium','Prorocentrum',...
    'Chaetoceros','Detonula','Eucampia','Guinardia','Pseudo-nitzschia','Centric diatoms',...
    'other dinos','other diatoms','other cell-derived');
set(h,'Position',[0.808159725831097 0.399956604207141 0.187499996391125 0.246744784681747]);
hold on
  
%% Seasonality 2012-2019 Chlorophyll, Temperature, Nitrate, Silicate

% param_string = 'Silicate';
% ii=find(a.SilicateuM); rok=a.SilicateuM(ii); dnok=a.dn(ii); %remove NaNs

% param_string = 'Nitrate';
% ii=find(a.NitrateuM); rok=a.NitrateuM(ii); dnok=a.dn(ii); %remove NaNs

param_string = 'Temperature';
ii=find(a.temp); rok=a.temp(ii); dnok=a.dn(ii); %remove NaNs

% param_string = 'Chlorophyll';
% ii=find(a.chl); rok=a.chl(ii); dnok=a.dn(ii); %remove NaNs

[~,y_mat,yearlist,~]=timeseries2ydmat(dnok,rok); %takes a timeseries and makes it into a year x day matrix
[y_wkmat,~,yd_wk]=ydmat2weeklymat(y_mat,yearlist); %takes a year x day matrix and makes it a year x 2 week matrix

figure('Units','inches','Position',[1 1 6.5 5.5],'PaperPositionMode','auto'); 
X=[yd_wk]; 
Y=[yearlist(1:8) yearlist(8)+1];
C=[y_wkmat(:,1:8)';zeros(1,52)];

pcolor(X,Y,C); caxis([0 0.7]); colormap(flipud(hot));
%caxis([0 50]) %Silicate
%caxis([0 20]) %Nitrate
caxis([11 18]) %Temperature
%caxis([0 20]) %Chlorophyll

colormap(flipud(hot));
datetick('x',4); axis square; shading flat;

set(gca,'xticklabel',{'J','F','M','A','M','J','J','A','S','O','N','D',''},...
    'ylim',[2012 2019],'ytick',2012:2019,'yticklabel',{'','2012','2013','2014',...
    '2015','2016','2017','2018'},'fontsize',12,'tickdir','out');

ylabel('Year', 'fontsize',14, 'fontweight','bold');
xlabel('Month', 'fontsize',14, 'fontweight','bold');
title(num2str(param_string), 'fontsize',16, 'fontname', 'arial','fontweight','bold');

h=colorbar;
h.Label.String = 'mg m^{-3}';
% h.Label.String = 'uM';
% h.Label.String = '^oC';
h.FontSize = 12;
h.Label.FontSize = 14;
h.Label.FontWeight = 'bold';
h.TickDirection = 'out';

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\Seasonality_' num2str(param_string) '_2012-2019.tif']);
hold off


%% RAI for select species by circle size

figure('Units','inches','Position',[1 1 8 3],'PaperPositionMode','auto');        

for i=1:13
    sz=linspace(0,100,50); 
    A=r(i).rai';
    ii=~isnan(A); %which values are not NaNs
    Aok=A(ii);
    iii=find(Aok);
    Aook=Aok(iii);
    Asz=zeros(length(Aook),1); %preallocate space   
    for j=1:length(Asz)  % define sizes according to cyst abundance
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(i).dn(iii)',i*ones(size(Asz)),Asz,'m','filled');
    hold on    
end  

datetick('x','yyyy')
set(gca,'xgrid', 'on','ylim',[0 13],'ytick',0:1:13,...
    'xlim',[datenum('2007-09-01') datenum('2018-03-01')],...
        'YTickLabel',['0', {r.name}],'tickdir','out');   
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_2007-2018.tif']);
hold off

%% diatoms vs. dinos dot RAI plot
figure('Units','inches','Position',[1 1 8 1],'PaperPositionMode','auto');        

%dinoflagellate
    sz=linspace(1,70,100); 
    A=r(15).rai';
    ii=~isnan(A); Aok=A(ii);
    iii=find(Aok); Aook=Aok(iii);
    Aook(Aook>1)=1;
    Asz=zeros(length(Aook),1); 
    for j=1:length(Asz)  
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(15).dn(iii)',15*ones(size(Asz)),Asz,'r','filled');
    hold on    
%diatoms
    sz=linspace(1,50,100); 
    A=r(16).rai';
    ii=~isnan(A); Aok=A(ii);
    iii=find(Aok); Aook=Aok(iii);
    Aook(Aook>1)=1;
    Asz=zeros(length(Aook),1); 
    for j=1:length(Asz)  
         Asz(j)=sz(round(Aook(j)*length(sz)));
    end
    scatter(r(15).dn(iii)',16*ones(size(Asz)),Asz,'b','filled');
    hold on        

datetick('x','yyyy')
set(gca,'xgrid', 'on','ylim',[14 16],'ytick',14:1:16,...
    'xlim',[datenum('2008-01-01') datenum('2018-03-01')],...
        'YTickLabel',['0',{'Dinoflagellates','Diatoms'}],'tickdir','out');   
    
    % set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600',[resultpath 'Figs\RAI_Dino_Diat_2007-2018.tif']);
hold off


%% Script to assign colors based off of specific values
% color=flipud(autumn); 
% colormap(color);    
% d=[0;1;2;3;4]/4;
% dcol=zeros(length(d),3); %preallocate space   
% for i=1:length(dcol)  
%     dcol(i,:)=color(round(d(i)*length(color)),:);
% end       

% %set colors for all classes    
% for i=1:length(r) 
%     r(i).color=ones(length(r(i).count),3); %default white for 0
%     for j=1:length(r(i).count)
%         if r(i).count(j) == 1
%             r(i).color(j,:) = dcol(1,:);           
%         elseif r(i).count(j) == 2
%             r(i).color(j,:) = dcol(2,:);   
%         elseif r(i).count(j) == 3
%             r(i).color(j,:) = dcol(3,:);    
%         elseif r(i).count(j) == 4
%             r(i).color(j,:) = dcol(4,:);            
%         end
%     end
% end
