%% ACIDD2017 - Extract blobs and features and apply classifier

start_blob_batch_user_training(...
    'F:\IFCB113\ACIDD2017\data\2017\',...
    'F:\IFCB113\ACIDD2017\blobs\2017\',true);

start_feature_batch_user_training(...
    'F:\IFCB113\ACIDD2017\data\2017\',...
    'F:\IFCB113\ACIDD2017\blobs\2017\',...
    'F:\IFCB113\ACIDD2017\features\2017\',true)

start_classify_batch_user_training(...
    'F:\IFCB104\manual\summary\UserExample_Trees_08Jan2018',...
    'F:\IFCB113\ACIDD2017\features\2017\',...
    'F:\IFCB113\ACIDD2017\class\class2017_v1\')

%%
countcells_allTBnew_user_training(...
    'F:\IFCB113\ACIDD2017\class\classxxxx_v1\',...
    'F:\IFCB113\ACIDD2017\data\',2017);

%%
load 'F:\IFCB113\ACIDD2017\class\summary\summary_allTB';

for i=1:(length(class2useTB)-1)
    figure(i)
    classind = i;
    plot(mdateTB, classcountTB(:,classind)./ml_analyzedTB, '.-')
    hold on
    plot(mdateTB, classcountTB_above_optthresh(:,classind)./ml_analyzedTB, 'g.-')
    plot(mdateTB, classcountTB_above_adhocthresh(:,classind)./ml_analyzedTB, 'r.-')
    legend('All wins', 'Wins above optimal threshold', 'Wins above adhoc threshold')
    ylabel([class2useTB{classind} ', mL^{ -1}'])
    datetick('x')

    set(gcf,'color','w');
    print(gcf,'-dtiff','-r600',...
        ['C:\Users\kudelalab\Documents\GitHub\bloom-baby-bloom\ACIDD2017\Figs\WinThrSummary_' class2useTB{classind} '.tif'])
    hold off
end