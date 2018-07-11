%% import discharge data
% Discharge (cubic feet per second)
% Date,  dn=datenum(TimeUTC,'yyyy-mm-dd HH:MM');

filename = '/Users/afischer/Documents/MATLAB/bloom-baby-bloom/SCW/Data/PajaroRiver_2012-2018.txt';
delimiter = {'\t',' ',':'};
startRow = 31;
formatSpec = '%*q%*q%{yyyy-MM-dd HH:mm}D%*q%f%*s%[^\n\r]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);

dt = dataArray{:, 1};
discharge = dataArray{:, 2};


%% plot Pajaro River discharge
figure('Units','inches','Position',[1 1 7 2.5],'PaperPositionMode','auto');

plot(datenum(dt),discharge,'b-','Linewidth',1);
datetick('x','yyyy');
set(gca,'yscale','log','ylim',[1 10^4],...
    'xlim',[datenum('2012-01-01') datenum('2019-01-01')],...     
	'fontsize',10,'XAxisLocation','bottom','TickDir','out'); 
ylabel('Discharge (ft^3 sec^-^1)','fontsize',11,'fontweight','bold');        
hold on

% set figure parameters
set(gcf,'color','w');
print(gcf,'-dtiff','-r600','~/Documents/MATLAB/bloom-baby-bloom/SCW/Figs/PajaroDischarge_2012-2018.tif')
hold off 