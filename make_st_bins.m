function [st_bin, classcount_bin, ml_analyzed_st_bin] = make_st_bins(filelist,classcount,ml_analyzed)

st_day = floor([filelist.st]);
st_bin = unique(floor(st_day));
classcount_bin = NaN(length(st_bin),size(classcount,2));
ml_analyzed_st_bin = classcount_bin;
for count = 1:length(st_bin)
    idx = find(st_day == st_bin(count));
    if ~isempty(idx)
        temp = classcount(idx,:);
        temp(isnan(ml_analyzed(idx,:))) = NaN;
        %classcount_bin(count,:) = nansum(classcount(idx,:),1);
        classcount_bin(count,:) = nansum(temp,1);
        ml_analyzed_st_bin(count,:) = nansum(ml_analyzed(idx,:),1);
    end
end
%no zeros mls should exist, zeros arise from nansum of all NaNs, set them
%back to NaN; do the same for cellcounts
%classcount_bin((ml_analyzed_mat_bin==0)) = NaN;
ml_analyzed_st_bin((ml_analyzed_st_bin==0)) = NaN;

end

