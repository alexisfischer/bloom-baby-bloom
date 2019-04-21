function enzkin(varargin)
% ENZyme KINetics is the study of the chemical reactions that are catalysed by
% enzymes. In enzyme kinetics the reaction rate is measured and the effects of
% varying the conditions of the reaction investigated. Studying an enzyme's
% kinetics in this way can reveal the catalytic mechanism of this enzyme, its
% role in metabolism, how its activity is controlled, and how a drug or a poison
% might inhibit the enzyme.
% Michaelis–Menten kinetics approximately describes the kinetics of many
% enzymes. It is named after Leonor Michaelis and Maud Menten. This kinetic
% model is relevant to situations where very simple kinetics can be assumed,
% (i.e. there is no intermediate or product inhibition, and there is no
% allostericity or cooperativity).
% The Michaelis–Menten equation relates the initial reaction rate v0  to the
% substrate concentration [S]. The corresponding graph is a rectangular
% hyperbolic function; the maximum rate is described as Vmax (asymptote); the
% concentration of substrate where the v0 is the half of Vmax is the
% Michaelis-Menten costant (Km).
% To determine the maximum rate of an enzyme mediated reaction, a series of
% experiments is carried out with varying substrate concentration ([S]) and the
% initial rate of product formation is measured. 'Initial' here is taken to mean
% that the reaction rate is measured after a relatively short time period,
% during which complex builds up but the substrate concentration remains
% approximately constant and the quasi-steady-state assumption will hold.
% Accurate values for Km and Vmax can only be determined by non-linear
% regression of Michaelis-Menten data.
% The Michaelis-Menten equation can be linearized using several techniques.
% ENZKIN uses 6 regression models (2 non-linear and 4 linear) to obtain the
% kinetic parameters.
%
% Syntax: 	enzkin(S,v)
%      
%     Inputs:
%           S - data array of substrate concentrations
%           v - data array of measured initial velocity
%     Outputs:
%           - Vmax and Km estimation by:
%                ° Michaelis-Menten non linear regression
%                ° loglog non linear regression
%                ° Lineweaver-Burk linear regression
%                ° Hanes-Woolf linear regression
%                ° Eadie-Hofstee linear regression
%                ° Scatchard linear regression
%           - for the linear regressions, all regression data are summarized
%           - Plots
% By itself (without data), enzkin runs a demo
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2010). Enzkin: a tool to estimate Michaelis-Menten kinetic
% parameters
% http://www.mathworks.com/matlabcentral/fileexchange/26653



global tr n S v LBVmax LBKm HWVmax HWKm EHVmax EHKm SVmax SKm txtlbl

%Input Error handling
args=cell(varargin);
nu=numel(args);
default.values = {[],[]};
if nu~=2
    if nu==0 %If there aren't inputs, load the demo data
        load enzkindata xData yData
        default.values = {xData,yData};
        clear xData yData
    else
        error('Warning: Two data vectors are required')
    end
end
default.values(1:nu) = args;
[S v] = deal(default.values{:});
clear args default nu 

clc
%set the costants
n=length(S); %number of data
vc=tinv(0.95,n-2); %critical value for confidence intervals
tr=repmat('-',1,100); %divisor
txtlbl={'Michaelis & Menten non linear fit' '[S]' 'v'; 
    'Lineweaver-Burk (x=1/S; y=1/v)' '1/[S]' '1/V'; ...
    'Hanes-Woolf (x=s; y=s/v)' '[S]' '[S]/v'; ...
    'Logarithmic non linear fit' 'log(S)' 'log(v)'; ...
    'Eadie-Hofstee (x=v/s; y=v)' 'v/[S]' 'v'; ...
    'Scatchard (x=v; y=v/s)' 'v' 'v/[S]'}; %labels

%Michaelis and Menten non linear fit
xfit = S(:); yfit = v(:); %x and y
%fitting option: Km€[0,Inf) the same for Vmax
fo_ = fitoptions('method','NonlinearLeastSquares','Robust','On','Lower',[0 0]);
%check if x and y are ok
ok_ = isfinite(xfit) & isfinite(yfit);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
%set the start point: 
%the best rate for Vmax is the max(y);
%the best rate for Km is the x value of the couple (xk,yk) wher yk is closest to
%max(y)/2
st_ = [max(yfit) xfit(find(yfit(yfit<=max(yfit)/2),1,'last'))];
set(fo_,'Startpoint',st_);
%Set the Michaelis & Menten equation
ft_ = fittype('(Vmax*x)/(Km+x)',...
    'dependent',{'y'},'independent',{'x'},...
    'coefficients',{'Km', 'Vmax'});
% Fit this model using the data
[cf_, goodness] = fit(xfit(ok_),yfit(ok_),ft_,fo_);
%Display the results
disp(tr)
fprintf('Michaelis & Menten nonlinear fit...\n')
disp(tr)
disp(cf_)
fprintf('\tR = \t%0.4f\n',realsqrt(goodness.rsquare))
disp(tr)
disp(' ')

%log-log non linear fit
yfit = log(v(:));
%check if x and y are ok
ok_ = isfinite(log(xfit)) & isfinite(yfit);
if ~all( ok_ )
    warning( 'GenerateMFile:IgnoringNansAndInfs', ...
        'Ignoring NaNs and Infs in data' );
end
%set the start point: 
%The same of Michaelis & Menten fit but using logs
st_ = [max(yfit) xfit(find(yfit(yfit<=max(yfit-log(2))),1,'last'))];
set(fo_,'Startpoint',st_);
%Set the log(Michaelis & Menten) equation
ft_ = fittype('log(Vmax)+log(x)-log(Km+x)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'Km', 'Vmax'});
% Fit this model using data
[cfl_, goodness] = fit(xfit(ok_),yfit(ok_),ft_,fo_);
%Display the results
disp(tr)
fprintf('Logarithm nonlinear fit...\n')
disp(tr)
disp(cfl_)
fprintf('\tR = \t%0.4f\n',realsqrt(goodness.rsquare))
disp(tr)
disp(' ')

%Now use 4 linear forms of Michaelis and Menten equation:
%1) use x and y specific trasformations;
%2) use myregr function to compute slope (m), intercept (q), standard errors and R;
%3) derive Km and Vmax and the standard errors using the propagation of errors theory;
%4) compute the confidence intervals;
%5) display the results.
disp(tr)
fprintf('Lineweaver-Burk linearization (x=1/S; y=1/v => Vmax=1/q; Km=m/q)...\n')
disp(tr)
[LBslope, LBinter, LBStat]=myregr(1./S,1./v,0);
LBVmax=zeros(1,4); LBKm=zeros(1,4);
LBVmax(1:2)=[1/LBinter.value LBinter.se/LBinter.value^2]; LBVmax(3:4)=LBVmax(1)+[-1 1].*vc*LBVmax(2);
LBKm(1:2)=[LBslope.value/LBinter.value realsqrt((LBinter.value*LBslope.se)^2+(LBslope.value*LBinter.se)^2)/LBinter.value^2]; LBKm(3:4)=LBKm(1)+[-1 1].*vc*LBKm(2);
disppar(LBslope,LBinter,LBStat,LBVmax,LBKm)
disp(' ')

disp(tr)
fprintf('Hanes-Woolf linearization (x=S; y=S/v => Vmax=1/m; Km=q/m)...\n')
disp(tr)
[HWslope, HWinter, HWStat]=myregr(S,S./v,0);
HWVmax=zeros(1,4); HWKm=zeros(1,4);
HWVmax(1:2)=[1/HWslope.value HWslope.se/HWslope.value^2]; HWVmax(3:4)=HWVmax(1)+[-1 1].*vc*HWVmax(2);
HWKm(1:2)=[HWinter.value/HWslope.value realsqrt((HWslope.value*HWinter.se)^2+(HWinter.value*HWslope.se)^2)/HWslope.value^2]; HWKm(3:4)=HWKm(1)+[-1 1].*vc*HWKm(2);
disppar(HWslope,HWinter,HWStat,HWVmax,HWKm)
disp(' ')

disp(tr)
fprintf('Eadie-Hofstee linearization (x=v/S; y=v => Vmax=q; Km=-m)...\n')
disp(tr)
[EHslope, EHinter, EHStat]=myregr(v,v./S,0);
EHKm=zeros(1,4);
EHVmax=[EHinter.value EHinter.se EHinter.lv EHinter.uv]; 
EHKm(1:2)=[-EHslope.value EHslope.se]; EHKm(3:4)=EHKm(1)+[-1 1].*vc*EHKm(2);
disppar(EHslope,EHinter,EHStat,EHVmax,EHKm)
disp(' ')

disp(tr)
fprintf('Scatchard linearization (x=v; y=v/s => Vmax=-q/m; Km=-1/m)...\n')
disp(tr)
[Sslope, Sinter, SStat]=myregr(v./S,v,0);
SVmax=zeros(1,4); SKm=zeros(1,4);
SKm(1:2)=[-1/Sslope.value Sslope.se/Sslope.value^2]; SKm(3:4)=SKm(1)+[-1 1].*vc*SKm(2);
SVmax(1:2)=[-Sinter.value/Sslope.value realsqrt((-Sinter.se/Sslope.value)^2+(-Sinter.value/Sslope.value^2*Sslope.se)^2)]; SVmax(3:4)=SVmax(1)+[-1 1].*vc*SVmax(2);
disppar(Sslope,Sinter,SStat,SVmax,SKm)

%Display the plots
micmen(S,v,cf_.Vmax,cf_.Km)
mmlog(S,v,cfl_.Vmax,cfl_.Km)
linburk(1./S,1./v,LBslope.value,LBinter.value)
hanwoo(S,S./v,HWslope.value,HWinter.value)
eadhof(v,v./S,EHslope.value,EHinter.value)
scat(v./S,v,Sslope.value,Sinter.value)
end

function disppar(a,b,c,d,e) %display parameters
global tr n
fprintf('Parameter\t\tValue\t\tS.E.\t\t95%% Confidence Interval\t\tp-value\n')
fprintf('Slope\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',a.value,a.se,a.lv,a.uv,(1-tcdf(abs(a.value/a.se),n-2))*2)
fprintf('Intercept\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',b.value,b.se,b.lv,b.uv,(1-tcdf(abs(b.value/b.se),n-2))*2)
fprintf('R\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',c.r(1),c.r(2),c.r(3),c.r(4),(1-tcdf(abs(c.r(1)/c.r(2)),n-2))*2)
fprintf('Km\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',e,(1-tcdf(abs(e(1)/e(2)),n-2))*2)
fprintf('VMax\t\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\t\t%0.4f\n',d,(1-tcdf(abs(d(1)/d(2)),n-2))*2)
disp(tr)
end

function micmen(MMx,MMy,Vmax,Km) %Michaelis & Menten plot function
global x y xtick ytick
x=MMx; y=MMy;
kingraph(1,Vmax,Km)
H=text(5*xtick,Vmax+2*ytick,['Vmax = ' num2str(Vmax)]); set(H,'Color','m')
H=text(Km+5*xtick,Vmax/2,['Km = ' num2str(Km)]); set(H,'Color','m')
end

function mmlog(MLx,MLy,Vmax,Km) %log(Michaelis & Menten) plot function
global x y xtick ytick as
x=MLx; y=MLy;
kingraph(4,Vmax,Km)
H=text(as(1)+5*xtick,log(Vmax)+5*ytick,'log(v)=log(Vmax)+log(S)-log(Km+S)'); set(H,'Color','m')
H=text(as(1)+5*xtick,log(Vmax)+2*ytick,['log(Vmax) = ' num2str(log(Vmax))]); set(H,'Color','m')
H=text(log(Km)+5*xtick,log(Vmax/2),['log(Km) = ' num2str(log(Km))]); set(H,'Color','m')
end

function linburk(LBx,LBy,m,q) %Lineweaver-Burk plot function
global LBKm LBVmax x y stringa
%grafico
x=[-1/LBKm(1) 0 LBx];
y=[0 q LBy];
stringa={['Vmax = ' num2str(LBVmax(1)) '    Km = ' num2str(LBKm(1))];  ...
    'y = (Km/Vmax) * x + (1/Vmax)'; ...
    ['x=0; y=1/Vmax= ' num2str(y(2))]; ...
    ['y=0; x=-1/Km= ' num2str(x(1))]}; %labels
kingraph(2,m,q)
end

function hanwoo(HWx,HWy,m,q) %Hanes-Woolf plot function
global HWKm HWVmax x y stringa
%grafico
x=[-HWKm(1) 0 HWx];
y=[0 q HWy];
stringa={['Vmax = ' num2str(HWVmax(1)) '    Km = ' num2str(HWKm(1))];  ...
    'y = (1/Vmax) * x + (Km/Vmax)'; ...
    ['x=0; y=Km/Vmax=' num2str(y(2))]; ...
    ['y=0; x=-Km=' num2str(x(1))]}; %labels
kingraph(3,m,q)
end

function eadhof(EHx,EHy,m,q) %Eadie-Hofstee plot function
global EHKm EHVmax x y stringa
%grafico
x=[EHVmax(1)/EHKm(1) 0 EHx];
y=[0 EHVmax(1) EHy];
stringa={['Vmax = ' num2str(EHVmax(1)) '    Km = ' num2str(EHKm(1))];  ...
    'y = -Km * x + Vmax'; ...
    ['x=0; y=Vmax=' num2str(y(2))]; ...
    ['y=0; x=Vmax/Km=' num2str(x(1))]}; %labels
kingraph(5,m,q)
end

function scat(Sx,Sy,m,q) % Scatchard plot function
global SKm SVmax x y stringa
%grafico
x=[SVmax(1) 0 Sx];
y=[0 SVmax(1)/SKm(1) Sy];
stringa={['Vmax = ' num2str(SVmax(1)) '    Km = ' num2str(SKm(1))]; ...
    'y = -1/Km * x + Vmax/Km'; ...
    ['x=0; y=Vmax/Km=' num2str(y(2))]; ...
    ['y=0; x=Vmax=' num2str(x(1))]}; %labels
kingraph(6,m,q)
end

function kingraph(I,m,q) % main plot function
global x y as xtick ytick txtlbl stringa
if I==4
    xtick=range(log(x))/50; ytick=range(log(y))/50;
else
    xtick=range(x)/50; ytick=range(y)/50; 
end
subplot(2,3,I)
hold on
if I==1 || I==4
    start=1;
else
    start=3;
end
%plot the data points (blue circles)
if I==4
    plot(log(x(start:end)),log(y(start:end)),'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',4,'LineStyle','none')
else
    plot(x(start:end),y(start:end),'Marker','o','MarkerEdgeColor','b','MarkerFaceColor','b','MarkerSize',4,'LineStyle','none')
end
if I~=1 && I~=4
   %plot the x and y intersections (red circles)
   plot(x(1:2),y(1:2),'Marker','o','MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',4,'LineStyle','none')
end

%plot the regression line (orange line)
if I==1
    xs=linspace(0,max(x),500); ys=(m.*xs)./(q+xs);
    plot(xs,ys,'LineStyle','-','Color',[0.87 0.49 0])
elseif I==4
    xs=linspace(min(x),max(x),500); ys=log(m)+log(xs)-log(q+xs);
    plot(log(xs),ys,'LineStyle','-','Color',[0.87 0.49 0])
else
    xs=linspace(min(x),max(x),500);
    plot(xs,polyval([m q],xs),'LineStyle','-','Color',[0.87 0.49 0])
end

as=axis;
if I==1
    plot(as(1:2),[m m],'k--') %plot the Vmax asymptote
    plot([0 q],[m m]./2,'k--',[q q],[0 m/2],'k--') %plot the Km coordinates
elseif I==4
    as(4)=as(4)+10*ytick;
    axis(as)
    plot(as(1:2),log([m m]),'k--') %plot the Vmax asymptote
    plot([as(1) log(q)],log([m m]./2),'k--',log([q q]),[0 log(m/2)],'k--') %plot the Km coordinates
else    
    %Mark the axis (black line')
    axis([as(1)-10*xtick as(2)+10*xtick as(3)-10*ytick as(4)+10*ytick])
    xk1=[0 0]; yk1=as(3:4)+[-10 10].*ytick;
    xk2=as(1:2)+[-10 10].*xtick; yk2=[0 0];
    plot(xk1,yk1,'k',xk2,yk2,'k')
end
hold off
axis square
%set the labels
title(txtlbl(I,1))
xlabel(txtlbl(I,2))
ylabel(txtlbl(I,3))
if  I~=1 && I~=4
    H=text(as(1)-5*xtick,as(4)+2*ytick,stringa(1)); set(H,'Color','m')
    H=text(as(1)-5*xtick,as(4)-ytick,stringa(2)); set(H,'Color','m')
    H=text(5*xtick,y(2),stringa(3)); set(H,'Color','m')
    if I==2 || I==3
        H=text(x(1)+0.5*xtick,-5*ytick,stringa(4)); 
    elseif I==5 || I==6
        H=text(x(1)-12*xtick,-5*ytick,stringa(4));
    end
    set(H,'Color','m')
end
end
