function [spm_bin, classcount_bin, ml_analyzed_spm_bin] = ...
    make_spm_bins(filelist, classcount, ml_analyzed)

spm = floor([filelist.spm]');
spm_bin = unique(floor(spm));
classcount_bin = NaN(length(spm_bin),size(classcount,2));
ml_analyzed_spm_bin = classcount_bin;
for count = 1:length(spm_bin)
    idx = find(spm == spm_bin(count));
    if ~isempty(idx)
        temp = classcount(idx,:);
        temp(isnan(ml_analyzed(idx,:))) = NaN;
        classcount_bin(count,:) = nansum(temp,1);
        ml_analyzed_spm_bin(count,:) = nansum(ml_analyzed(idx,:),1);
    end
end
%no zeros mls should exist, zeros arise from nansum of all NaNs, set them
%back to NaN; do the same for cellcounts
%classcount_bin((ml_analyzed_sal_bin==0)) = NaN;
ml_analyzed_spm_bin((ml_analyzed_spm_bin==0)) = NaN;

end

