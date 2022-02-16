function [ ] = determine_classifier_performance( classifiername )
%[ ] = classifier_oob_analysis( classifername )
%For example:
% determine_classifier_performance('D:\Shimada\classifier\summary\Trees_12Oct2021')
% input classifier file name with full path
% expects output from make_TreeBaggerClassifier*.m
%   Alexis D. Fischer, NOAA NWFSC, September 2021
%
% Example Inputs
%classifiername='D:\Shimada\classifier\summary\Trees_15Feb2022';
%outpath='C:\Users\ifcbuser\Documents\GitHub\bloom-baby-bloom\IFCB-Data\Shimada\class\';
load(classifiername,'b','classes','featitles','maxthre','targets');

%%%% confusion matrix for winner takes all interpretation of scores
[Yfit,Sfit,Sstdfit] = oobPredict(b);
[mSfit, ii] = max(Sfit');
for count = 1:length(mSfit), mSstdfit(count) = Sstdfit(count,ii(count)); t(count)= Sfit(count,ii(count)); end
if isempty(find(mSfit(:)-t(:), 1)), clear t, else disp('check for error...'); end

[c_all, class] = confusionmat(b.Y,Yfit); 
total = sum(c_all')'; maxn = max(total);
[TP TN FP FN] = conf_mat_props(c_all); % true positive (TP), true negative (TN), false positive (FP), false negative (FN)

Se = TP./(TP+FN); %sensitivity (or probability of detection)
Pr = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c_all)./sum(c_all)'
all=table(class,total,Se,Pr);

disp('overall error rate:')
disp(1-sum(TP)./sum(total))

%%
%%%% apply the optimal threshold
t = repmat(maxthre,length(Yfit),1);
win = (Sfit > t);
[i,j] = find(win);
Yfit_max = NaN(size(Yfit));
Yfit_max(i) = j;
ind = find(sum(win')>1);
for count = 1:length(ind)
    [~,Yfit_max(ind(count))] = max(Sfit(ind(count),:));
end
ind = find(isnan(Yfit_max));
Yfit_max(ind) = length(classes)+1; %unclassified set to last class
ind = find(Yfit_max);
classes2 = [classes(:); 'unclassified'];
[c_opt, class] = confusionmat(b.Y,classes2(Yfit_max));
total = sum(c_opt')';
[TP TN FP FN] = conf_mat_props(c_opt);

Se = TP./(TP+FN); %sensitivity
Pr = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
disp('error rate for all classifications (optimal score threshold):')
disp(1-sum(TP)./sum(total))
Pm = c_opt(:,end)./total;
opt=table(class,total,Se,Pr,Pm);
%opt(end,:)=[]; %delete unclassified row

disp('fraction unclassified:')
disp(length(find(Yfit_max==length(classes2)))./length(Yfit_max))
c_optb = c_opt(1:end-1,1:end-1); %ignore the instances in 'unknown'
total = sum(c_optb')';
[TP TN FP FN] = conf_mat_props(c_optb);
disp('error rate for accepted classifications (optimal score threshold):')
disp(1-sum(TP)./sum(total))

clearvars TP TN FP FN total ind count i ii t j classes2 class Pm Pr Se

%% how did regional classifier do on Shimada dataset
idx = contains(targets,{'IFCB777' 'IFCB117'});
MC=b.Y;
[C, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);C=C(idx,idx);
total = sum(C')'; 
[TP TN FP FN] = conf_mat_props(C);
Se= TP./(TP+FN); %sensitivity (or probability of detection)
Pr = TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
Pr(Pr==0)=NaN;

%find gaps, if they exist
PNW=all;
[~,ib]=ismember(classes,class);
for i=1:length(ib)
    if ib(i)>0
        PNW.total(i)= total(ib(i));
        PNW.Se(i)= Se(ib(i));
        PNW.Pr(i)= Pr(ib(i));        
    else
        PNW.total(i)=0;
        PNW.Se(i)=NaN;
        PNW.Pr(i)=NaN;        
    end
end

PNW=table(class,total,Se,Pr);

%% how did regional classifier do on SCW dataset
idx = contains(targets,'IFCB104');
MC=b.Y;
[C, class] = confusionmat(MC(idx),Yfit(idx)); 
[~,idx]=sort(class);class=class(idx);C=C(idx,idx);
total = sum(C')';
[TP TN FP FN] = conf_mat_props(C);

Se= TP./(TP+FN); %sensitivity (or probability of detection)
Pr= TP./(TP+FP); %precision = TP/(TP+FP) = diag(c1)./sum(c1)'
Pr(Pr==0)=NaN;

%find gaps, if they exist
SCW=all;
[~,ib]=ismember(classes,class);
for i=1:length(ib)
    if ib(i)>0
        SCW.total(i)= total(ib(i));
        SCW.Se(i)= Se(ib(i));
        SCW.Pr(i)= Pr(ib(i));        
    else
        SCW.total(i)=0;
        SCW.Se(i)=NaN;
        SCW.Pr(i)=NaN;        
    end
end

clearvars TP TN FP FN Se Pr MC idx total classi

%% sorting features according to the best ones
figure('Units','inches','Position',[1 1 3.5 3],'PaperPositionMode','auto');
[~,ind]=sort(b.OOBPermutedVarDeltaError,2,'descend');
bar(sort(b.OOBPermutedVarDeltaError,2,'descend'))
ylabel('Feature importance')
xlabel('Feature ranked index')
set(gcf,'color','w');
print(gcf,'-dtiff','-r200',[outpath 'Figs\Feature_importance.png']);
hold off

disp(['Most important features: ' ])
topfeat=featitles(ind(1:20))';

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

save([outpath 'performance_classifier_' classifiername(37:end) ''],'topfeat','PNW','SCW','all','opt','c_all','c_opt');

end