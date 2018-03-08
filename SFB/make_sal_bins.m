function [sal_bin, classcount_bin, ml_analyzed_sal_bin] = ...
    make_sal_bins(filelist, classcount, ml_analyzed)

sal = floor([filelist.sal]');
sal_bin = unique(floor(sal));
classcount_bin = NaN(length(sal_bin),size(classcount,2));
ml_analyzed_sal_bin = classcount_bin;
for count = 1:length(sal_bin)
    idx = find(sal == sal_bin(count));
    if ~isempty(idx)
        temp = classcount(idx,:);
        temp(isnan(ml_analyzed(idx,:))) = NaN;
        classcount_bin(count,:) = nansum(temp,1);
        ml_analyzed_sal_bin(count,:) = nansum(ml_analyzed(idx,:),1);
    end
end
%no zeros mls should exist, zeros arise from nansum of all NaNs, set them
%back to NaN; do the same for cellcounts
%classcount_bin((ml_analyzed_sal_bin==0)) = NaN;
ml_analyzed_sal_bin((ml_analyzed_sal_bin==0)) = NaN;
sal_bin((sal_bin==0)) = 1; % cannot have zeros as a bin

end

