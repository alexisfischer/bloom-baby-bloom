function [ ] = determine_classifier_performance( classifiername )
%[ ] = classifier_oob_analysis( classifername )
%For example:
% determine_classifier_performance('D:\Shimada\classifier\summary\Trees_12Oct2021')
% input classifier file name with full path
% expects output from make_TreeBaggerClassifier*.m
%   Alexis D. Fischer, NOAA NWFSC, September 2021
%
% Example Inputs

classifiername='D:\Shimada\classifier\summary\Trees_12Oct2021';

text_offset = 0.1;
outpath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';
load(classifiername,'b','classes','featitles','maxthre','targets');

%% confusion matrix for winner takes all interpretation of scores
[Yfit,Sfit,Sstdfit] = oobPredict(b);
[mSfit, ii] = max(Sfit');
for count = 1:length(mSfit), mSstdfit(count) = Sstdfit(count,ii(count)); t(count)= Sfit(count,ii(count)); end
if isempty(find(mSfit(:)-t(:), 1)), clear t, else disp('check for error...'); end

[c1, class] = confusionmat(b.Y,Yfit); 
total = sum(c1')'; maxn = max(total);
[TP TN FP FN] = conf_mat_props(c1); % true positive (TP), true negative (TN), false positive (FP), false negative (FN)

Se = TP./(TP+FN); %sensitivity (or probability of detection)
%Pr = 1-(sum(c1)-diag(c1)')./total'; %precision 1-FP/(TP+FP)
Pr = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
all=table(class,total,Se,Pr);

disp('overall error rate:')
disp(1-sum(TP)./sum(total))

%% apply the optimal threshold
t = repmat(maxthre,length(Yfit),1);
win = (Sfit > t);
[i,j] = find(win);
Yfit_max = NaN(size(Yfit));
Yfit_max(i) = j;
ind = find(sum(win')>1);
for count = 1:length(ind),
    %    ii = find(win(ind(count),:));
    [~,Yfit_max(ind(count))] = max(Sfit(ind(count),:));
end
ind = find(isnan(Yfit_max));
Yfit_max(ind) = length(classes)+1; %unclassified set to last class
ind = find(Yfit_max);
classes2 = [classes(:); 'unclassified'];
[c3, class] = confusionmat(b.Y,classes2(Yfit_max));
total = sum(c3')';
[TP TN FP FN] = conf_mat_props(c3);

Se3 = TP./(TP+FN); %sensitivity
Pr3 = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
disp('error rate for all classifications (optimal score threshold):')
disp(1-sum(TP)./sum(total))
Pm3 = c3(:,end)./total;
optimal=table(class,total,Se3,Pr3);

disp('fraction unclassified:')
disp(length(find(Yfit_max==length(classes2)))./length(Yfit_max))
c3b = c3(1:end-1,1:end-1); %ignore the instances in 'unknown'
total = sum(c3b')';
[TP TN FP FN] = conf_mat_props(c3b);
disp('error rate for accepted classifications (optimal score threshold):')
disp(1-sum(TP)./sum(total))

clearvars TP TN FP FN total ind count i ii t

%% how did regional classifier do on Shimada dataset
idx = contains(targets,{'IFCB777' 'IFCB117'});
MC=b.Y;
[c1, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);c1=c1(idx,idx);
total = sum(c1')'; maxn = max(total);
[TP TN FP FN] = conf_mat_props(c1);
Se= TP./(TP+FN); %sensitivity (or probability of detection)
Pr = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
Pr(Pr==0)=NaN;
PNW=table(class,total,Se,Pr);

% plot bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([PNW.Se PNW.Pr])
set(gca, 'xtick', 1:length(PNW.class), 'xticklabel', [])
text(1:length(PNW.class), -text_offset.*ones(size(PNW.class)), PNW.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Sensitivity', 'Precision','Location','SE')
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\Fx_sensitivity_precision_PNW.png']);
hold off

%% how did regional classifier do on SCW dataset
idx = contains(targets,'IFCB104');
MC=b.Y;
[c1, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);c1=c1(idx,idx);
total = sum(c1')'; maxn = max(total);
[TP TN FP FN] = conf_mat_props(c1);

Se= TP./(TP+FN); %sensitivity (or probability of detection)
Pr = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
Pr(Pr==0)=NaN;
SCW=table(class,total,Se,Pr);

save([outpath 'Sensitivity_Precision_SCW_PNW'],'PNW','SCW','all','optimal');

% plot bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([SCW.Se SCW.Pr])
set(gca, 'xtick', 1:length(SCW.class), 'xticklabel', [])
text(1:length(SCW.class), -text_offset.*ones(size(SCW.class)), SCW.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Sensitivity', 'Precision','Location','SE')
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\Fx_sensitivity_precision_SCW.png']);
hold off

%% plot bar True Positives and False Positives

figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([total TP FP])
legend('total in set', 'true pos', 'false pos','Location','NE');
set(gca, 'xtick', 1:length(classes), 'xticklabel', []);
ylabel('total in set');
text(1:length(classes), -text_offset.*ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\total_TP_FP.png']);
hold off

%% plot total in set
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([all.total SCW.total PNW.total])
legend('overall', 'SCW', 'N CCS','Location','NE');
set(gca, 'xtick', 1:length(classes), 'xticklabel', []);
ylabel('total images in set');
text(1:length(all.class), -text_offset.*ones(size(all.class)), all.class, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\total_SCW_PNW.png']);
hold off
    
%% plot bar Sensitivity and Precision
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([Se Pr])
set(gca, 'xtick', 1:length(classes), 'xticklabel', [])
text(1:length(classes), -text_offset.*ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Sensitivity', 'Precision','Location','SE')
title('score threshold = 0')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\Fx_sensitivity_precision.png']);
hold off
    
%% plot threshold scores
figure('Units','inches','Position',[1 1 6 4.5],'PaperPositionMode','auto');
boxplot(max(Sfit'),b.Y)
ylabel('Out-of-bag winning scores')
set(gca, 'xtick', 1:length(classes), 'xticklabel', [], 'ylim', [0 1])
text(1:length(classes), -.1*ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
hold on, plot(1:length(classes), maxthre, '*g')
title('score threshold = 0')
lh = legend('optimal threshold score','Location','NE'); set(lh, 'fontsize', 10)

set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\class_vs_thresholdscores.png']);
hold off

%% plot manual vs classifier checkerboard
figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
cplot = zeros(size(c1)+1);
cplot(1:length(classes),1:length(classes)) = c1;
%pcolor(log10(cplot))
pcolor(cplot)
set(gca, 'ytick', 1:length(classes), 'yticklabel', [])
text( -text_offset+ones(size(classes)),(1:length(classes))+.5, classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
set(gca, 'xtick', 1:length(classes), 'xticklabel', [])
text((1:length(classes))+.5, -text_offset+ones(size(classes)), classes, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
axis square, colorbar, caxis([0 maxn])
title('manual vs. classifier; score threshold = 0')
%
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\checkerboard_manual_vs_classifier.png']);
hold off

%% plot bar Sensitivity and Precision (optimal)
figure('Units','inches','Position',[1 1 6 5],'PaperPositionMode','auto');
bar([Se3 Pr3 Pm3])
title('optimal score threshold')
set(gca, 'xtick', 1:length(classes2), 'xticklabel', [])
text(1:length(classes2), -text_offset.*ones(size(classes2)), classes2, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45)
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
legend('Se', 'Pr', 'Pmissed')
set(gca, 'position', [ 0.13 0.35 0.8 0.6])
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\Fx_sensitivity_precision_optimal.png']);
hold off
    
%% plot manual vs classifier checkerboard (optimal)
figure('Units','inches','Position',[1 1 7 5],'PaperPositionMode','auto');
cplot = zeros(size(c3)+1);
cplot(1:length(classes2),1:length(classes2)) = c3;
%pcolor(log10(cplot))
pcolor(cplot)
set(gca, 'ytick', 1:length(classes2), 'yticklabel', [])
text( -text_offset+ones(size(classes2)),(1:length(classes2))+.5, classes2, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 0)
set(gca, 'xtick', 1:length(classes), 'xticklabel', [])
text((1:length(classes2))+.5, -text_offset+ones(size(classes2)), classes2, 'interpreter', 'none', 'horizontalalignment', 'right', 'rotation', 45) 
axis square, colorbar, caxis([0 maxn])
title('manual vs. classifier; optimal score threshold')
%
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\checkerboard_manual_vs_classifier_optimal.png']);
hold off

end