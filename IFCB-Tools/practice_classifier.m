close all; clear;
load fisheriris
xx = meas(:, 1:1); % more features -> higher AUC
yy = species;

% dividing data to test and train sets
r = randperm(150); trn = r(1:100); tst = r(101:150);

% train classifier
model = fitcdiscr(xx(trn, :),yy(trn));

% predict labels
% score store likelihood of each sample 
% being of each class: nSample by nClass
[Y2, scores] = predict(model, xx(tst, :));

% plot ROCs
hold on
for i=1:length(model.ClassNames)
    [X,Y,T,AUC,OPTROCPT] = perfcurve(yy(tst),scores(:, i), model.ClassNames(i));
    maxT(i)=T((X==OPTROCPT(1))&(Y==OPTROCPT(2)));
    plot(X,Y,'linewidth', 1); hold on
    plot(OPTROCPT(1),OPTROCPT(2),'ro'); hold on;
    %legends{i} = sprintf('AUC for %s class: %.3f', model.ClassNames{i}, AUC);
end
%%
% for i=1:length(model.ClassNames)
%     [fpr,accu,thr] = perfcurve(yy(tst),scores(:, i), model.ClassNames(i),'ycrit','accu');
%     [maxaccu(i),iaccu] = max(accu);
%     maxthre(i) = thr(iaccu); 
%     plot(fpr,accu,'linewidth', 1); hold on
%     plot(fpr(iaccu),maxaccu,'ro'); hold on
% end
%legend(legends, 'location', 'southeast')
line([0 1], [0 1], 'linestyle', ':', 'color', 'k');
xlabel('FPR'), ylabel('TPR')
title('ROC for Iris Classification (1 vs Others)')
axis square

%%
%    [fpr,yr,thr] = perfcurve(b.Y,Sfit(:,count), class2use{old_ind},'ycrit','accu');
