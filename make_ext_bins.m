function [ext_bin, classcount_bin, ml_analyzed_ext_bin] = ...
    make_ext_bins(filelist, classcount, ml_analyzed)

ext = floor([filelist.ext]');
ext_bin = unique(floor(ext));
classcount_bin = NaN(length(ext_bin),size(classcount,2));
ml_analyzed_ext_bin = classcount_bin;
for count = 1:length(ext_bin)
    idx = find(ext == ext_bin(count));
    if ~isempty(idx)
        temp = classcount(idx,:);
        temp(isnan(ml_analyzed(idx,:))) = NaN;
        classcount_bin(count,:) = nansum(temp,1);
        ml_analyzed_ext_bin(count,:) = nansum(ml_analyzed(idx,:),1);
    end
end
%no zeros mls should exist, zeros arise from nansum of all NaNs, set them
%back to NaN; do the same for cellcounts
%classcount_bin((ml_analyzed_sal_bin==0)) = NaN;
ml_analyzed_ext_bin((ml_analyzed_ext_bin==0)) = NaN;
ext_bin((ext_bin==0)) = 1; % cannot have zeros as a bin


end

