function [dn_acc,y_acc,subs] = ts_aggregation(dn,y,n,target_fmt,fct_handle)

% dn is time in datenum format (i.e. days)
% y is whatever variable you want to aggregate
% n is the number of minutes, hours, days
% target_fmt is 'minute', 'hour' or 'day'
% fct_handle can be an arbitrary function (e.g. @sum or @mean)

    dn = dn(:);
    y = y(:);
    switch target_fmt
        case 'day'
            dn_factor = 1;        
        case 'hour'
            dn_factor = 1 / 24;            
        case 'minute'
            dn_factor = 1 / ( 24 * 60 );
    end
    dn_acc = ( dn(1) : n * dn_factor : dn(end) )';
    subs = ones(length(dn), 1);
    for i = 2:length(dn_acc)
       subs(dn > dn_acc(i-1) & dn <= dn_acc(i)) = i; 
    end
    y_acc = accumarray( subs, y, [], fct_handle , NaN); %put in NaNs if datagap
        
end