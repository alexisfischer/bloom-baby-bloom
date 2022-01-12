%% plot classifier performance
clear;
addpath(genpath('~/MATLAB/ifcb-analysis/')); 
addpath(genpath('~/MATLAB/bloom-baby-bloom/')); 
filepath='/Users/afischer/GoogleDriveWHOI/Shimada/'; addpath(genpath(filepath));
outpath = '~/MATLAB/NWFSC/Shimada/'; addpath(genpath(outpath));

load([filepath 'summary/summary_allTB_2019'],...
    'filelistTB','class2useTB','ml_analyzedTB','mdateTB','classcountTB_above_optthresh'); % ADF note: be sure to use classcountTB_above_optthresh for classifier output
load([filepath 'summary/manual/count_class_manual_25Mar2021.mat'],...
    'matdate','ml_analyzed','classcount','filelist','class2use');

% only select classified files that have been manual classified
[~,~,ib]=intersect(extractBefore({filelist.name}','.'),cellstr(filelistTB));
classcountTB_above_optthresh=classcountTB_above_optthresh(ib,:);
ml_analyzedTB=ml_analyzedTB(ib);
mdateTB=mdateTB(ib);
filelistTB=filelistTB(ib);

% convert Brian's classlist to MB classifier
class2use=class2use';
[class2use,classcount]=match_PNW_w_SCW_classes(class2use,class2useTB,classcount);

% get labels for plotting
[~,class_label]=get_phyto_ind_CA(class2useTB,class2useTB); 

%% use this checkerboard as a template
figure('Units','inches','Position',[1 1 7 6],'PaperPositionMode','auto');
    cplot = zeros(size(c1)+1);
    cplot(1:length(classes),1:length(classes)) = c1;
    %pcolor(log10(cplot))
    pcolor(cplot)
    set(gca, 'ytick', 1:length(classes), 'yticklabel', [])
    text( -text_offset+ones(size(classes)),(1:length(classes))+.5, classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
    set(gca, 'xtick', 1:length(classes), 'xticklabel', [],'fontsize',12)
    text((1:length(classes))+.5, -text_offset+ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
    axis square, colorbar, caxis([0 maxn])
    title('manual vs. classifier; score threshold = 0')
    % set figure parameters
    set(gcf,'color','w');
    print(gcf,'-dtiff','-r200',[out_dir 'Figs\Classifier_vs_Manual.tif']);
    hold off

%% plot
figure('Units','inches','Position',[1 1 8 8],'PaperPositionMode','auto');
subplot = @(m,n,p) subtightplot (m, n, p, [0.07 0.05], [0.07 0.03], [0.06 0.02]);
%subplot = @(m,n,p) subtightplot(m,n,p,opt{:}); 
%where opt = {gap, width_h, width_w} describes the inner and outer spacings

for i=1:length(class2useTB)
    disp(class2useTB(i))
    id = strcmp(class2useTB(i), class2use); %change this for whatever class you are analyzing

    subplot(5,5,i)
    scatter(classcount(:,id),classcountTB_above_optthresh(:,i),6,'o'); hold on;
    axis square   
    lin_fit{i} = fitlm(classcount(:,id),classcountTB_above_optthresh(:,i));
    Rsq(i) = lin_fit{i}.Rsquared.ordinary;
    Coeffs(i,:) = lin_fit{i}.Coefficients.Estimate;
    coefPs(i,:) = lin_fit{i}.Coefficients.pValue;
    RMSE(i) = lin_fit{i}.RMSE;
    eval(['fplot(@(x)x*' num2str(Coeffs(i,2)) '+' num2str(Coeffs(i,1)) ''' , xlim, ''color'', ''r'')'])
    
    m=max(classcount(:,id)); mTB=max(classcountTB_above_optthresh(:,i));   
    if m>mTB
        plot(linspace(0,m),linspace(0,m),'k-','Linewidth',.3); hold on
        set(gca,'xlim',[0 round(m,1,'significant')],'ylim',[0 round(m,1,'significant')],...
            'xtick',0:round(m,1,'significant'):round(m,1,'significant'),...
            'ytick',0:round(m,1,'significant'):round(m,1,'significant'));
    else
        plot(linspace(0,mTB),linspace(0,mTB),'k-','Linewidth',.3); hold on        
        set(gca,'xlim',[0 round(mTB,1,'significant')],'ylim',[0 round(mTB,1,'significant')],...
            'xtick',0:round(mTB,1,'significant'):round(mTB,1,'significant'),...
            'ytick',0:round(mTB,1,'significant'):round(mTB,1,'significant'));
    end
    title(class_label(i));       
    box on; hold on;
end

ax=subplot(5,5,11); ax.YLabel.String='Automated SCW Classifier Counts'; ax.YLabel.FontSize=16;
ax=subplot(5,5,23); ax.XLabel.String='Manual Counts'; ax.XLabel.FontSize=16;

%% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r300',[outpath 'Figs/SCWclassifiercompare.tif']);
hold off
