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

ugCml(:,get_nonliving_ind_PNW(class2useTB))=NaN; %exclude nonliving

% find classes contributing to bulk of biomass
sampletotal=repmat(nansum(ugCml,2),1,size(ugCml,2));
fxC_all=ugCml./sampletotal;
classtotal=nansum(ugCml,1);
[~,idx]=maxk(classtotal,18); %find top carbon highest classes
idx=(sort(idx))';
fxC=fxC_all(:,idx);
class=class2useTB(idx);

ido=setdiff((1:1:length(class2useTB))',idx);
ugCmli=ugCml(:,idx);
other=nansum(ugCml(:,ido),2);

%%%% Step 3: Find daily fraction of each group 
Total = nansum(ugCml,2);

clearvars fxC_all sampletotal classtotal i ind_diatom ugCml

%%
figure('Units','inches','Position',[1 1 7 5.],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.03 0.03], [0.06 0.04], [0.08 0.3]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings.  

xax1=datenum('2021-07-01'); xax2=datenum('2021-12-01');     

subplot(2,1,1);
h = bar(mdateTB,[ugCmli./Total other./Total],'stack','Barwidth',4);
c=brewermap(length(class),'Spectral'); col=[c;[.5 .5 .5]];
    for i=1:length(h)
        set(h(i),'FaceColor',col(i,:));
    end  
    ylabel('Fx total C','fontsize',12);
    datetick('x', 'mmm', 'keeplimits');    
    set(gca,'xlim',[xax1 xax2],'ylim',[0 1],'ytick',.2:.2:1,...
        'fontsize', 12,'fontname', 'arial','tickdir','out',...
        'yticklabel',{'.2','.4','.6','.8','1'},'xticklabel',{});    
    
[~,label] = get_all_ind_PNW(class); label(end+1)={'other'};
    lh=legend(label);
    legend boxoff; lh.FontSize = 10; hp=get(lh,'pos');
    lh.Position=[hp(1)+.3 hp(2)+.04 hp(3) hp(4)]; hold on    
    
subplot(2,1,2); 
idx=(strcmp('Dinophysis', class2useTB));
load([filepath 'NOAA/BuddInlet/Data/DinophysisMicroscopy'],'T');

h=plot(mdateTB,smooth(classcountTB(:,idx)./ml_analyzedTB,5),'k-',...
    datenum(T.SampleDate),0.001*T.DinophysisConcentrationcellsL,'r*');
set(gca,'ylim',[0 25],'xlim',[xax1 xax2])
datetick('x', 'mmm', 'keeplimits');    
ylabel('Dinophysis (cells/mL)','fontsize',12);
legend(h,'Classifier','Manual Microscopy');

set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[filepath 'NOAA/BuddInlet/Figs/FxCarbonBiomass_BuddInlet_class.tif']);
hold off
