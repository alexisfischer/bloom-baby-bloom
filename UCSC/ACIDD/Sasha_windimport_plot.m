%% import and plot wind data

%% import raw Wind data from buoy 46042
filepath='/Users/afischer/MATLAB/bloom-baby-bloom/SCW/';

yr=(2002:2018)';
for i=1:length(yr)
    filename = [filepath '46042/46042_' num2str(yr(i)) '.txt'];
    
    if yr(i) <=2006
        startRow = 2;
    else
        startRow = 3;
    end

    formatSpec = '%4f%3f%3f%3f%3f%7f%7f%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    YYYY = dataArray{:, 1};
    MM = dataArray{:, 2};
    DD = dataArray{:, 3};
    hh = dataArray{:, 4};
    mm = dataArray{:, 5};
    dir = dataArray{:, 6};
    spd = dataArray{:, 7};

    dn=datenum(YYYY,MM,DD,hh,mm,zeros(size(YYYY)));

    for j=1:length(dn)
        if dir(j) == 999
            dir(j) = NaN;        
        end
        if spd(j) == 999
            spd(j) = NaN;        
        end    
    end

    [u,v] = UVfromDM(dir,spd);

    W(i).yr=YYYY(end);
    W(i).dn=dn;
    W(i).dir=dir;
    W(i).spd=spd;
    W(i).u=u;
    W(i).v=v;

    clearvars ans dataArray DD dir DIR dn DN fileID filename formatSpec hh j mm MM spd SPD startRow u v YY;
end

%%%%(step 2) Combine data into single column
w.s42.dn=W(1).dn;
w.s42.dir=W(1).dir;
w.s42.spd=W(1).spd;
w.s42.u=W(1).u;
w.s42.v=W(1).v;

for i=2:length(W)    
    w.s42.dn=[w.s42.dn;W(i).dn];
    w.s42.dir=[w.s42.dir;W(i).dir];
    w.s42.spd=[w.s42.spd;W(i).spd];
    w.s42.u=[w.s42.u;W(i).u];
    w.s42.v=[w.s42.v;W(i).v];
end

clearvars W i

%% plot regional upwelling

xax1=datenum('2017-04-21'); xax2=datenum('2017-04-23'); %enter your time period of interest

figure;
    itime=find(w.s42.dn>=xax1 & w.s42.dn<=xax2);
    [time,v,~] = ts_aggregation(w.s42.dn(itime),w.s42.v(itime),1,'hour',@mean); %take hourly mean
    [~,u,~] = ts_aggregation(w.s42.dn(itime),w.s42.u(itime),1,'hour',@mean);
    [vfilt,~]=plfilt(v,time); [ufilt,df]=plfilt(u,time);    
    
    [up,~]=rotate_current(ufilt,vfilt,44); %rotate based off geography of the coast, 44º in the Monterey Bay region
    [DF,UP,~] = ts_aggregation(df,up,1,'day',@mean); 
    plot(DF,UP,'-','Color','k','linewidth',2); 
    hold on
    xL = get(gca, 'XLim'); plot(xL, [0 0], 'k--')      
    
    datetick('x', 'm', 'keeplimits')
    set(gca,'xlim',[xax1 xax2],'ylim',[-11 10],'ytick',-7:7:7,'xticklabel',{},'fontsize',14,'tickdir','out');    
    ylabel('m s^{-1}','fontsize',15);
    hold on    
