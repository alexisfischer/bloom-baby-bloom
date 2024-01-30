%% Import BI temp, sal, chl profiles data from Excel
% uses GSW toolbox to calculatec the following variables:
% https://www.teos-10.org/pubs/gsw/html/gsw_contents.html#3
%
% SA =  Absolute Salinity               [ g/kg ]
% CT =  Conservative Temperature        [ deg C ]
% p =   sea pressure                    [ dbar ]
% rho = in-situ density                 [ kg m^-3 ]
% Zm =  upper pycnocline                [m]
% Zb =  lower pycnocline                [m]
% Zp =  actual pycnocline               [m]
% N =   Brunt-Vaisala Frequency at Zp   [cycles s-1 ]

clear;
lat=47.04571;
interval=0.25;
filepath='~/Documents/MATLAB/bloom-baby-bloom/NOAA/BuddInlet/Data/';
addpath(genpath('~/Documents/MATLAB/ifcb-analysis/'));
addpath(genpath('~/Documents/MATLAB/bloom-baby-bloom/'));

filename=[filepath 'TSDChl_Data_Graphs.xlsx'];
sheets = sheetnames(filename);
for i=1:length(sheets)
    opts = spreadsheetImportOptions("NumVariables", 4);
    opts.Sheet = sheets(i);
    opts.DataRange = 'A2:D300'; %300 is just a big value
    opts.VariableNames = ["C", "SALPSU", "ChlRFU", "VertPosM"];
    opts.VariableTypes = ["double", "double", "double", "double"];    
    T = readtable(filename, opts, "UseExcel", false);

    idx=isnan(T.C); T(idx,:)=[]; %remove all of the extra rows
    edges=(0:interval:8)'; 
    ind=discretize(T.VertPosM,edges);
    
    B(i).dn=datenum(datetime(sheets(i),'InputFormat','MMddyy'));    
    B(i).z=edges; %depth
    B(i).p=gsw_p_from_z(-edges,lat); %calculate pressure from height
    B(i).t = accumarray(ind,T.C,[length(edges) 1],@mean,NaN);
    B(i).s = accumarray(ind,T.SALPSU,[length(edges) 1],@mean,NaN);
    B(i).fl = accumarray(ind,T.ChlRFU,[length(edges) 1],@mean,NaN);
    
    clearvars opts T ind idx;    
end

dt=datetime([B.dn],'ConvertFrom','datenum');

%%%% calculate density and interpolate data gaps
% do not include bottom (bottom varies for each profile)
for i=1:length(B)
    iend=find(~isnan(B(i).t),1,'last');
    %interpolate data gaps and smooth for a 2m running mean
    B(i).fl(1:iend)=smooth(fillmissing(B(i).fl(1:iend),'linear'),2/interval); 
    B(i).t(1:iend)=smooth(fillmissing(B(i).t(1:iend),'linear'),1/interval); 
    B(i).s(1:iend)=smooth(fillmissing(B(i).s(1:iend),'linear'),1/interval);
    [B(i).SA,~]= gsw_SA_from_SP(B(i).s,B(i).p,-122.90702,lat);    
    B(i).CT=gsw_CT_from_t(B(i).SA,B(i).t,B(i).p);
    %B(i).rho=(gsw_rho(B(i).SA,B(i).CT,B(i).p)); %in-situ density  [ kg m^-3 ]
    B(i).rho=smooth(gsw_rho(B(i).SA,B(i).CT,B(i).p),1.5/interval); %in-situ density  [ kg m^-3 ]
    B(i).sigmat=B(i).rho-1000; %'Sigma-t' is rho minus 1000
    B(i).rho_m=[NaN;diff(B(i).rho)./diff(B(i).z)];   
end

clearvars i sheets range edges iend;

%% Stratification calculation
%i=1
sigma1=0.1;
sigma2=0.2;
for i=1:length(B)
    iend=find(~isnan(B(i).t),1,'last');    

    lp=find(B(i).rho_m>sigma2); %lower pycnocline
    if isempty(lp)
        B(i).Zb=NaN;             
    else
        B(i).Zb=B(i).z(lp(end));        
    end

    up=find(B(i).rho_m>sigma1); %upper pycnocline
    if isempty(up)
        B(i).Zm=NaN;
        B(i).Zp=NaN;
        B(i).N=NaN;      
    else
        B(i).Zm=B(i).z(up(1));
        %since a value exceeds 0.1, can find maximum        
       [m,im]=max(B(i).rho_m); %actual pycnocline    
       B(i).rho_max=m;
        B(i).Zp=B(i).z(im);
       [N2,~] = gsw_Nsquared(B(i).SA,B(i).CT,B(i).p,lat);
        N=sqrt(N2)/(2*pi); %buoyancy frequency (strength of pycnocline) cycles/s
        B(i).N=N(im);   
    end    

    figure('Units','inches','Position',[1 1 2 4],'PaperPositionMode','auto');
    plot(B(i).sigmat,B(i).z,'r-','linewidth',1); hold on
    set(gca,'ylim',[0 6],'xlim',[0 24],'Ydir','reverse','xaxislocation','top',...
        'fontsize',10,'Tickdir','out');
    title(datestr([B(i).dn]),'fontsize',12);
    xlabel('sigma-t','fontsize',12);    
    ylabel('depth (m)','fontsize',12);

    idx=find(B(i).z==B(i).Zp);
    if ~isempty(idx)
    text(B(i).sigmat(idx),B(i).Zp,'Zp \rightarrow','fontsize',10,'HorizontalAlignment','right');
    end

    idx=find(B(i).z==B(i).Zm);
    if ~isempty(idx)    
    text(B(i).sigmat(idx),B(i).Zm,'Zm \rightarrow','fontsize',10,'HorizontalAlignment','right')    
    end

    idx=find(B(i).z==B(i).Zb);
    if ~isempty(idx)        
    text(B(i).sigmat(idx),B(i).Zb,'Zb \rightarrow','fontsize',10,'HorizontalAlignment','right')    
    end

    text(0.5,5.7,[num2str(round(B(i).rho_max,1)) ' kg/m^4 @Zp'])
    pause;
    
end


save([filepath 'BuddInlet_TSChl_profiles'],'B','dt');