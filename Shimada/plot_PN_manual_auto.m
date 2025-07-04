%% plots NCC Pseudo-nitzschia classifier results against manual data
% Shimada 2019, 2021, 2023
% A.D. Fischer, May 2024
%
clear;

%%%%USER
fprint = 0; % 1 = print; 0 = don't
filepath = '~/Documents/MATLAB/bloom-baby-bloom/'; % enter your path
ifcbpath = '~/Documents/MATLAB/ifcb-data-science/'; % enter your path

% load in data
addpath(genpath(filepath)); % add new data to search path
addpath(genpath(ifcbpath)); % add new data to search path
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/')); % add new data to search path
load([ifcbpath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],...
    'class2use','classcount','matdate','ml_analyzed','filelist'); % manual data summary
load([ifcbpath 'IFCB-Data/Shimada/class/summary_biovol_allTB'],'class2useTB',...
    'classcountTB','classcount_above_optthreshTB','classcount_above_adhocthreshTB',...
    'filelistTB','mdateTB','ml_analyzedTB'); %classified data summary

% totalI=sum(sum(classcount_above_optthreshTB))
% totalU=(sum(classcount_above_optthreshTB(:,end)))
% fxU=totalU./totalI

% %% format data
% %%%% eliminate manual files with high fx of unclassified data
% [badfilelist] = findmanualfiles_w_highUnclassified([filepath 'IFCB-Data/Shimada/manual/count_class_biovol_manual'],0.2,'Pseudo-nitzschia');
% [~,ia,~]=intersect({filelist.name}',badfilelist);
% filelist(ia)=[]; classcount(ia,:)=[]; matdate(ia)=[]; ml_analyzed(ia)=[];

%%%% find and select matching manual and class files using filenames
for i=1:length(filelist)
    filelist(i).newname=filelist(i).name(1:24); %format manual filenames like class filenames
end
[~,im,it] = intersect({filelist.newname}, filelistTB); 
mdateTB=datetime(mdateTB(it),'convertfrom','datenum');
ml_analyzedTB=ml_analyzedTB(it);
filelistTB=filelistTB(it);

%%%% sum up grouped PN classes for manual data
class2do_full='Pseudo-nitzschia_large_1cell,Pseudo-nitzschia_small_1cell';
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end
man1=sum(classcount(im,imclass),2)./ml_analyzedTB;
auto1=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB))./ml_analyzedTB;

class2do_full='Pseudo-nitzschia_large_2cell,Pseudo-nitzschia_small_2cell';
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end
man2=sum(classcount(im,imclass),2)./ml_analyzedTB;
auto2=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB))./ml_analyzedTB;

class2do_full='Pseudo-nitzschia_large_3cell,Pseudo-nitzschia_large_4cell,Pseudo-nitzschia_small_3cell,Pseudo-nitzschia_small_4cell';
ind = strfind(class2do_full, ',');
if ~isempty(ind)
    ind = [0 ind length(class2do_full)];
    for i = 1:length(ind)-2
        imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1)-1)),1);
    end
    i=length(ind)-1;
    imclass(i)=find(strcmp(class2use,class2do_full(ind(i)+1:ind(i+1))),1);
else
    imclass = find(strcmp(class2use,class2do_full));
end
man34=sum(classcount(im,imclass),2)./ml_analyzedTB;
auto34=classcount_above_optthreshTB(it,strcmp(class2do_full,class2useTB))./ml_analyzedTB;

%%%% match with latitude
[lat,~,ia,filelistTB]=match_IFCBdata_w_Shimada_lat_lon(filepath,filelistTB);

%%%% only select 25% (fx) of data for test set
fx=0.2; ia=sort(randsample(length(filelist),round(fx*(length(filelist)),0)));
auto1=auto1(ia); auto2=auto2(ia); auto34=auto34(ia);
man1=man1(ia); man2=man2(ia); man34=man34(ia);
lat=lat(ia);

clearvars im it i imclass ind badfilelist filelist filelistTB ml_analyzedTBtype ...
    matdate ml_analyzedTB ml_analyzed class2use classcount classcountTB ...
    classcount_above_optthreshTB classcountTB_above_adhocthresh class2do_full mdateTB opt fx;

%% Plot automated vs manual classification cell counts
figure('Units','inches','Position',[1 1 3.3 3.3],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.05 0.05], [0.15 0.08], [0.14 0.04]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.

subplot(3,1,1);
stem(lat,auto1,'k-','Linewidth',.5,'Marker','none'); hold on;
plot(lat,man1,'r*','Markersize',5,'linewidth',.8); hold on
    set(gca,'xgrid','on','tickdir','out','xaxislocation','top','xlim',[40 49],'ylim',[0 70],'fontsize',9); 
    ylabel('1 cell','fontsize',11); 
 legend('classifier','manual','location','nw');% legend boxoff;
    
subplot(3,1,2);
stem(lat,auto2,'k-','Linewidth',.5,'Marker','none'); hold on;
plot(lat,man2,'r*','Markersize',5,'linewidth',.8); hold on
    set(gca,'xgrid','on','tickdir','out','xlim',[40 49],'xticklabel',{},'ylim',[0 40],'fontsize',9); 
    ylabel('2 cells','fontsize',11); 

subplot(3,1,3);
stem(lat,auto34,'k-','Linewidth',.5,'Marker','none'); hold on; 
plot(lat,man34,'r*','Markersize',5,'linewidth',.8); hold on
    set(gca,'xgrid','on','tickdir','out','xaxislocation','bottom','xlim',[40 49],'ylim',[0 20],'fontsize',9); 
    ylabel('3-4 cells','fontsize',11); 
    xlabel('Latitude (ºN)','fontsize',11); 

if fprint
    exportgraphics(gcf,[filepath 'Shimada/Figs/Manual_automated_PN_byLatitude.png'],'Resolution',100)    
end
hold off
