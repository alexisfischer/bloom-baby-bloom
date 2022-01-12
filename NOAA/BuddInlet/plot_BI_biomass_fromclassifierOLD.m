%% Plot Budd Inlet biomass composition from classifier

addpath(genpath('~/MATLAB/ifcb-analysis/')); % add new data to search path
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); % add new data to search path
clear;

filepath = '/Users/afischer/MATLAB/';
load([filepath 'bloom-baby-bloom/IFCB-Data/BuddInlet/class/summary_biovol_allTB2021'],...
    'class2useTB','classbiovolTB','ml_analyzedTB','mdateTB','classcountTB');

% %%%% Step 1: take daily average
% [mdateTB, ml_analyzedTB ] = timeseries2ydmat(mdateTB, ml_analyzedTB);
% classbiovolTB=NaN*ones(366,length(class2useTB));
% for i=1:length(class2useTB)
%     [mdateTB, classbiovolTB(:,i) ] = timeseries2ydmat(mdateTB, classbiovolTB(:,i));
% end

%%%% Step 2: Convert Biovolume (cubic microns/cell) to ug carbon/ml
ind_diatom = get_diatom_ind_PNW(class2useTB);
[pgCcell] = biovol2carbon(classbiovolTB,ind_diatom); 
ugCml=NaN*pgCcell;
for i=1:length(pgCcell)
    ugCml(i,:)=.001*(pgCcell(i,:)./ml_analyzedTB(i)); %convert from pg/cell to pg/mL to ug/L 
end  

% find classes contributing to bulk of biomass
sampletotal=repmat(nansum(ugCml,2),1,size(ugCml,2));
fxC_all=ugCml./sampletotal;
classtotal=nansum(ugCml,1);
[~,idx]=maxk(classtotal,20); %find top carbon highest classes
idx=(sort(idx))';
fxC=fxC_all(:,idx);
class=class2useTB(idx);
clearvars fxC_all sampletotal classtotal i ind_diatom

ido=setdiff((1:1:length(class2useTB))',idx);
ugCmli=ugCml(:,idx);
other=nanmean(ugCml(:,ido),2);

%%%% Step 3: Find daily fraction of each group 
[ind_dino,label_dino] = get_dino_ind_PNW(class); 
[ind_diatom,label_diatom] = get_diatom_ind_PNW(class); 
[ind_nano,label_nano] = get_nano_ind_PNW(class);
[ind_otherphyto,label_otherphyto] = get_otherphyto_ind_PNW(class);
[ind_phyto,~] = get_phyto_ind_PNW(class); 

dino = (ugCmli(:,ind_dino));
diat = (ugCmli(:,ind_diatom));
nano = (ugCmli(:,ind_nano));
otherphyto = (ugCmli(:,ind_otherphyto));
phytoTotal = sum(ugCmli(:,ind_phyto),2);

clearvars sampletotal i ind_diatom pgCcell ind_dino ind_diatom ind_nano ind_otherphyto ind_phyto  

%%
figure('Units','inches','Position',[1 1 8 6],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.04], [0.08 0.25]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2021-08-03'); xax2=datenum('2021-11-10');     

subplot(2,1,1);
h = bar(mdateTB,[dino./phytoTotal diat./phytoTotal otherphyto./phytoTotal...
    nano./phytoTotal],'stack','Barwidth',4);
c=brewermap(length(class),'Spectral');
%    col=[c(1:9,:);c(12:23,:);[.8 .8 .8];[.1 .1 .1]];
    for i=1:length(h)
        set(h(i),'FaceColor',c(i,:));
    end  
    
    ylabel('Fx total C','fontsize',12);
    datetick('x', 'mm/dd', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    
    lh=legend([label_dino;label_diatom;label_otherphyto;label_nano]);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.25 hp(2)+.04 hp(3) hp(4)]; hold on    
    
subplot(2,1,2); 
idx=(strcmp('Dinophysis', class2useTB));
Dp=classcountTB(:,idx);
plot(mdateTB,smooth(Dp./ml_analyzedTB,5),'r-');
set(gca,'ylim',[0 25],'xlim',[xax1 xax2])
datetick('x', 'mm/dd', 'keeplimits');    
ylabel('Dinophysis (cells/mL)','fontsize',12);

%%
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/BuddInlet/Figs/FxCarbonBiomass_BuddInlet_class.tif']);
hold off
