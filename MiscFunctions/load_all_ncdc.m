% this requires import_ncdc.m

monthstoload=['2012_08';'2012_09';'2012_10';...
       '2012_11';'2012_12'];
pressureout=NaN(0);
dateout=NaN(0);
airtempout=NaN(0);
precipout=NaN(0);

   for ii=1:size(monthstoload,1)
       thefilename=['NCDC_' monthstoload(ii,:) '.txt'];
       %thefilename
       [WBAN1,Date1,Time1,StationType1,SkyCondition1,SkyConditionFlag1,...
           Visibility1,VisibilityFlag1,WeatherType1,WeatherTypeFlag1,...
           DryBulbFarenheit1,DryBulbFarenheitFlag1,DryBulbCelsius1,...
           DryBulbCelsiusFlag1,WetBulbFarenheit1,WetBulbFarenheitFlag1,...
           WetBulbCelsius1,WetBulbCelsiusFlag1,DewPointFarenheit1,...
           DewPointFarenheitFlag1,DewPointCelsius1,DewPointCelsiusFlag1,...
           RelativeHumidity1,RelativeHumidityFlag1,WindSpeed1,...
           WindSpeedFlag1,WindDirection1,WindDirectionFlag1,...
           ValueForWindCharacter1,ValueForWindCharacterFlag1,...
           StationPressure1,StationPressureFlag1,PressureTendency1,...
           PressureTendencyFlag1,PressureChange1,PressureChangeFlag1,...
           SeaLevelPressure1,SeaLevelPressureFlag1,RecordType1,...
           RecordTypeFlag1,HourlyPrecip1,HourlyPrecipFlag1,...
           Altimeter1,AltimeterFlag1] = import_ncdc(thefilename);
       tempdate=datenum([num2str(Date1) num2str(Time1,'%04.4d')],'yyyymmddHHMM');
       temppress=(StationPressure1+0.09).*33.86;
       pressureout=[pressureout; temppress];
       dateout=[dateout; tempdate];
       airtempout=[airtempout; DryBulbCelsius1];
       tempprecip=NaN(length(HourlyPrecip1),1);
       for prechr=1:length(HourlyPrecip1)
           %prechr
           if ~isempty(str2num(HourlyPrecip1{prechr}));
           tempprecip(prechr)=str2num(HourlyPrecip1{prechr});
           end
       end
       precipout=[precipout; tempprecip*25.4/24];      
       
   end
   

    