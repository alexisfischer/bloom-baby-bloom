function[sfb,s]=import_SFB_data(filename)

load('stations_sfb.mat');

delimiter = ',';
startRow = 3;
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]'; % Read columns of data as text:
fileID = fopen(filename,'r'); % Open the text file.

% Read columns of data according to the format.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType',...
    'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID); % Close the text file.

%% Convert the contents of columns containing numeric text to numbers.
% Replace non-numeric text with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,7,8,9]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

%%
R = cellfun(@(x) isempty(x) || (ischar(x) && all(x==' ')),raw);
raw(R) = {NaN}; % Replace blank cells w NaN

sfb = cell2mat(raw); % Create output variable


sfb(:,1)=sfb(:,1)+693960;  % Convert excel dates to matlab dates

%% add Lat Long coordinates wrt station #
sfb = [sfb zeros(size(sfb(:,2))) zeros(size(sfb(:,2)))]; %add zeros to c10 and c11
for i=1:length(sfb(:,2))
        
   if sfb(i,2) == st(1)
       sfb(i,10) = lat(1);
       sfb(i,11) = long(1);
       
   elseif sfb(i,2) == st(2)
       sfb(i,10) = lat(2);
       sfb(i,11) = long(2);
       
   elseif sfb(i,2) == st(3)
       sfb(i,10) = lat(3);
       sfb(i,11) = long(3); 
       
   elseif sfb(i,2) == st(4)
       sfb(i,10) = lat(4);
       sfb(i,11) = long(4);
       
   elseif sfb(i,2) == st(5)
       sfb(i,10) = lat(5);
       sfb(i,11) = long(5);         
       
   elseif sfb(i,2) == st(6)
       sfb(i,10) = lat(6);
       sfb(i,11) = long(6);
       
   elseif sfb(i,2) == st(7)
       sfb(i,10) = lat(7);
       sfb(i,11) = long(7); 
       
   elseif sfb(i,2) == st(8)
       sfb(i,10) = lat(8);
       sfb(i,11) = long(8);
       
   elseif sfb(i,2) == st(9)
       sfb(i,10) = lat(9);
       sfb(i,11) = long(9);  
       
   elseif sfb(i,2) == st(10)
       sfb(i,10) = lat(10);
       sfb(i,11) = long(10);
       
   elseif sfb(i,2) == st(11)
       sfb(i,10) = lat(11);
       sfb(i,11) = long(11); 
       
   elseif sfb(i,2) == st(12)
       sfb(i,10) = lat(12);
       sfb(i,11) = long(12);
       
   elseif sfb(i,2) == st(13)
       sfb(i,10) = lat(13);
       sfb(i,11) = long(13);         
       
   elseif sfb(i,2) == st(14)
       sfb(i,10) = lat(14);
       sfb(i,11) = long(14);
       
   elseif sfb(i,2) == st(15)
       sfb(i,10) = lat(15);
       sfb(i,11) = long(15); 
       
   elseif sfb(i,2) == st(16)
       sfb(i,10) = lat(16);
       sfb(i,11) = long(16);
       
   elseif sfb(i,2) == st(17)
       sfb(i,10) = lat(17);
       sfb(i,11) = long(17);         
       
   elseif sfb(i,2) == st(18)
       sfb(i,10) = lat(18);
       sfb(i,11) = long(18);
       
   elseif sfb(i,2) == st(19)
       sfb(i,10) = lat(19);
       sfb(i,11) = long(19); 
       
   elseif sfb(i,2) == st(20)
       sfb(i,10) = lat(20);
       sfb(i,11) = long(20);
       
   elseif sfb(i,2) == st(21)
       sfb(i,10) = lat(21);
       sfb(i,11) = long(21);  
       
   elseif sfb(i,2) == st(22)
       sfb(i,10) = lat(22);
       sfb(i,11) = long(22);
       
   elseif sfb(i,2) == st(23)
       sfb(i,10) = lat(23);
       sfb(i,11) = long(23); 
       
   elseif sfb(i,2) == st(24)
       sfb(i,10) = lat(24);
       sfb(i,11) = long(24);
       
   elseif sfb(i,2) == st(25)
       sfb(i,10) = lat(25);
       sfb(i,11) = long(25);          

   elseif sfb(i,2) == st(26)
       sfb(i,10) = lat(26);
       sfb(i,11) = long(26); 
       
   elseif sfb(i,2) == st(27)
       sfb(i,10) = lat(27);
       sfb(i,11) = long(27);
       
   elseif sfb(i,2) == st(28)
       sfb(i,10) = lat(28);
       sfb(i,11) = long(28);
       
   elseif sfb(i,2) == st(29)
       sfb(i,10) = lat(29);
       sfb(i,11) = long(29); 
       
   elseif sfb(i,2) == st(30)
       sfb(i,10) = lat(30);
       sfb(i,11) = long(30);
       
   elseif sfb(i,2) == st(31)
       sfb(i,10) = lat(31);
       sfb(i,11) = long(31);   
       
   elseif sfb(i,2) == st(32)
       sfb(i,10) = lat(32);
       sfb(i,11) = long(32); 
       
   elseif sfb(i,2) == st(33)
       sfb(i,10) = lat(33);
       sfb(i,11) = long(33);
       
   elseif sfb(i,2) == st(34)
       sfb(i,10) = lat(34);
       sfb(i,11) = long(34);   
       
   elseif sfb(i,2) == st(35)
       sfb(i,10) = lat(35);
       sfb(i,11) = long(35);   
       
   elseif sfb(i,2) == st(36)
       sfb(i,10) = lat(36);
       sfb(i,11) = long(36); 
       
   elseif sfb(i,2) == st(37)
       sfb(i,10) = lat(37);
       sfb(i,11) = long(37);        
       
   elseif sfb(i,2) == st(38)
       sfb(i,10) = lat(38);
       sfb(i,11) = long(38);
       
   elseif sfb(i,2) == st(39)
       sfb(i,10) = lat(39);
       sfb(i,11) = long(39); 
       
   elseif sfb(i,2) == st(40)
       sfb(i,10) = lat(40);
       sfb(i,11) = long(40);
       
   elseif sfb(i,2) == st(41)
       sfb(i,10) = lat(41);
       sfb(i,11) = long(41);   
       
   elseif sfb(i,2) == st(42)
       sfb(i,10) = lat(42);
       sfb(i,11) = long(42); 
       
   elseif sfb(i,2) == st(43)
       sfb(i,10) = lat(43);
       sfb(i,11) = long(43);
       
   elseif sfb(i,2) == st(44)
       sfb(i,10) = lat(44);
       sfb(i,11) = long(44);   
       
   elseif sfb(i,2) == st(45)
       sfb(i,10) = lat(45);
       sfb(i,11) = long(45);   
       
   elseif sfb(i,2) == st(46)
       sfb(i,10) = lat(46);
       sfb(i,11) = long(46); 
       
   elseif sfb(i,2) == st(47)
       sfb(i,10) = lat(47);
       sfb(i,11) = long(47);  
       
   elseif sfb(i,2) == st(48)
       sfb(i,10) = lat(48);
       sfb(i,11) = long(48);
       
   elseif sfb(i,2) == st(49)
       sfb(i,10) = lat(49);
       sfb(i,11) = long(49); 
       
   elseif sfb(i,2) == st(50)
       sfb(i,10) = lat(50);
       sfb(i,11) = long(50);
       
   elseif sfb(i,2) == st(51)
       sfb(i,10) = lat(51);
       sfb(i,11) = long(51);  
       
   end
end

%% Sort by date
%Find indices to elements in first column of sfb that satisfy the equality
%Use the logical indices to index into sfb to return required sub-matrices

sfb = sortrows(sfb,1); %sort by dates

s(1).a = sfb((sfb(:,1) == datenum('25-Jul-2017')),:);
s(2).a = sfb((sfb(:,1) == datenum('31-Jul-2017')),:);
s(3).a = sfb((sfb(:,1) == datenum('22-Aug-2017')),:);
s(4).a = sfb((sfb(:,1) == datenum('30-Aug-2017')),:);
s(5).a = sfb((sfb(:,1) == datenum('19-Sep-2017')),:);
s(6).a = sfb((sfb(:,1) == datenum('28-Sep-2017')),:);
s(7).a = sfb((sfb(:,1) == datenum('18-Oct-2017')),:);
s(8).a = sfb((sfb(:,1) == datenum('27-Oct-2017')),:);

% organize station data into structures
for i=1:length(s)
    s(i).dn=s(i).a(:,1);    
    s(i).st=s(i).a(:,2);
    s(i).lat=s(i).a(:,10);
    s(i).long=s(i).a(:,11);
    s(i).chlD=s(i).a(:,3);
    s(i).chlC=s(i).a(:,4);
    s(i).sal=s(i).a(:,5);
    s(i).temp=s(i).a(:,6);
    s(i).ni=s(i).a(:,7);
    s(i).nina=s(i).a(:,8);
    s(i).amm=s(i).a(:,9); 
end

s=rmfield(s,'a');

% %% Sort by station
% %Find indices to elements in first column of sfb that satisfy the equality
% %Use the logical indices to index into sfb to return required sub-matrices
% 
% sfb = sortrows(sfb,2); %sort by station #, now have matrix
% 
% s(1).a = sfb((sfb(:,2) == 657),:);
% s(2).a = sfb((sfb(:,2) == 649),:);
% s(3).a = sfb((sfb(:,2) == 2),:);
% s(4).a = sfb((sfb(:,2) == 3),:);
% s(5).a = sfb((sfb(:,2) == 4),:);
% s(6).a = sfb((sfb(:,2) == 5),:);
% s(7).a = sfb((sfb(:,2) == 6),:);
% s(8).a = sfb((sfb(:,2) == 7),:);
% s(9).a = sfb((sfb(:,2) == 8),:);
% s(10).a = sfb((sfb(:,2) == 9),:);
% s(11).a = sfb((sfb(:,2) == 10),:);
% s(12).a = sfb((sfb(:,2) == 11),:);
% s(13).a = sfb((sfb(:,2) == 12),:);
% s(14).a = sfb((sfb(:,2) == 13),:);
% s(15).a = sfb((sfb(:,2) == 14),:);
% s(16).a = sfb((sfb(:,2) == 15),:);
% s(17).a = sfb((sfb(:,2) == 16),:);
% s(18).a = sfb((sfb(:,2) == 17),:);
% s(19).a = sfb((sfb(:,2) == 18),:);
% s(20).a = sfb((sfb(:,2) == 20),:);
% s(21).a = sfb((sfb(:,2) == 21),:);
% s(22).a = sfb((sfb(:,2) == 22),:);
% s(23).a = sfb((sfb(:,2) == 23),:);
% s(24).a = sfb((sfb(:,2) == 24),:);
% s(25).a = sfb((sfb(:,2) == 25),:);
% s(26).a = sfb((sfb(:,2) == 26),:);
% s(27).a = sfb((sfb(:,2) == 27),:);
% s(28).a = sfb((sfb(:,2) == 28),:);
% s(29).a = sfb((sfb(:,2) == 29),:);
% s(30).a = sfb((sfb(:,2) == 29.5),:);
% s(31).a = sfb((sfb(:,2) == 30),:);
% s(32).a = sfb((sfb(:,2) == 31),:);
% s(33).a = sfb((sfb(:,2) == 31),:);
% s(34).a = sfb((sfb(:,2) == 33),:);
% s(35).a = sfb((sfb(:,2) == 34),:);
% s(36).a = sfb((sfb(:,2) == 35),:);
% s(37).a = sfb((sfb(:,2) == 36),:);
% 
% % organize station data into structures
% for i=1:length(s);
%     s(i).st=s(i).a(1,2);
%     s(i).lat=lat(i);
%     s(i).long=long(i);
%     s(i).dn=s(i).a(:,1);
%     s(i).chlD=s(i).a(:,3);
%     s(i).chlC=s(i).a(:,4);
%     s(i).sal=s(i).a(:,5);
%     s(i).temp=s(i).a(:,6);
%     s(i).ni=s(i).a(:,7);
%     s(i).nina=s(i).a(:,8);
%     s(i).amm=s(i).a(:,9); 
% end
% 
% s=rmfield(s,'a');

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp R;

save('~/Documents/MATLAB/SantaCruz/Data/sfb','sfb','s');

end