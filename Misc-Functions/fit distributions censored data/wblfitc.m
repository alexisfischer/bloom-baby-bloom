function [pars covars SE gval exitflag]=wblfitc(x,minimizer,init,options)

%Fits the weibull distribution to the data x based on maximum likelihood.
%The data can be left and/or right and/or interval censored.

%INPUT ARGUMENTS:
%x: a two column matrix of the data. For example

%     0   5.0000  --> left censored observation
%7.0000      Inf  --> right censored observation
%5.0000   9.0000  --> interval censored observation
%8.0000   8.0000  --> exactly observed

% that is, if all data are exactly observed then the two columns must be identical.
% See also the "examples" file for an illustration.
%--------------------------------------------------------------------------
%OPTIONAL INPUT ARGUMENTS: (These can be either not be reached at all, 
%or set as [] to proceed to the next optional input argument)
%--------------------------------------------------------------------------
% minimizer:   Can be set equal to 1 or 2 or 3. That is 1: the fminsearchbnd routine is
%              used for minimization, 2: the fmincon with Largescale set to off and 
%              the ‘spq’ algorithm is employed. 3. the fmincon with Largescale set to 
%              off and the ‘interior-point’ algorithm is employed. If set
%              to [] or not reached at all then minimizer 1 is chosen by default (for no particular reason).
%              If convergence problems occur be sure to explore all three
%              minimizers first. Then you can explore with other initial values
%              in the next input argument.
% init:        A row vector of initial values defined by the user. If you do not want 
%              to define this and move on to the next optional input arguments set it as []. 
%              If initial values are not provided by the user then they are derived based on exactly 
%              observed data or right censored based on built in MATLAB
%              functions. If only interval data are available then the
%              midpoints are considered as exactly observed and built in
%              funtions are used to obtain initial values.
% options:     The options that will be used in the optimset of fminsearchbnd or fmincon 
%              depending which minimizer is selected by the previous input argument. That is,
%              if the minimizer is set to 1, then the options will refer to the fminsearchbnd.
%              If the minimizer is set to 2 or 3, then the options will refer to fmincon. The 
%              options set in this argument will replace the default options mentioned in the 
%              minimizer input argument. The default will take place if this input argument is 
%              set to [] or not reached at all. See also MATLAB
%              documentation for the "options" of fmincon or fminsearch. 
%
%-------OUTPUT ARGUMENTS:
%
%pars:     estimated parameters
%covars:   variance covariance matrix of the estimated parameters
%SE:       standard error of the estimated parameters
%gval:     value of the loglikelihood
%exitflag: depends on the minimizer selected. In the case where only
%          exactly observed data and/or right censored data are available then
%          exitflag is set to NaN since the estimation is done based on the built in
%          fitting routines.
%--------------------------------------------------------------------------
%
% The purpose of this routine is to provide a useful tool to MATLAB users to 
% fit some distributions (most of which are primarily used in Survival Analysis)
% when left and/or right and/or interval censored are available. 
%
% This routine uses John D'Erricos fminsearchbnd or built in "fmincon" for minimization.
% The covariance matrix is calculated 
% numerically using also John D'Erricos “Adaptive Robust Numerical
% Differentiation” tools. These can be found here:
%
% http://www.mathworks.com/matlabcentral/fileexchange/8277
% http://www.mathworks.com/matlabcentral/fileexchange/13490-adaptive-robust-numerical-differentiation
%
%--------------------------------------------------------------------------
%See also the "examples" file for an illustration
%--------------------------------------------------------------------------
% Author:
% Leonidas E. Bantis
% Dept. of Statistics and Actuarial-Financial Mathematics
% University of the Aegean
% Samos Island, Greece.
% e-mail: lbantis@aegean.gr, leobantis@gmail.com
% Release: 1
% Last Updated: September 17th 2012
%--------------------------------------------------------------------------



%-----Some error checking-------------------------
if nargin==0;error('Not enough imput arguments');end
if nargin==1; minimizer=1; init=[];  options=[]; end
if nargin==2; init=[];  options=[]; end
if nargin==3; options=[]; end
if nargin>4;error('Too  many imput arguments');end

if min(size(x))~=2;error('The data must be a two column matrix');end

pars=[NaN NaN];exitflag=NaN;
xlow=x(:,1);xupp=x(:,2);
%if min(xlow)<0;error('The data must be non-negative for the Weibull distribution');end
%if min(xupp)<0;error('The data must be non-negative for the Weibull distribution');end


if length(find(xlow==-Inf |xlow==0 ))==length(xlow);error('Analysis cannot be performed when all data are left censored');end
if length(find(xupp==Inf))==length(xupp);error('Analysis cannot be performed when all data are right censored');end
if length(find(xlow==-Inf | xlow==0 | xupp==Inf))==length(x(:,1));error('Analysis cannot be performed when all data are either left or right censored');end
if sum(xlow<=xupp)~=length(xlow);error('The first column of the data must be elementwise less or equal to the second column');end
if sum(isnan(xlow))>=1;error('No NaNs are allowed in the data');end
if sum(isnan(xupp))>=1;error('No NaNs are allowed in the data');end
%-----End of error checking-------------------------

xlow=x(:,1);xupp=x(:,2);

%----Now derive the appropriate likelihood depending on the form of the
%data. If all data are fully observed or contain only right censoring then
%use the built in functions of MATLAB for estimation.
lastwarn('')
if sum(xlow==xupp)==length(xlow)  %if all data are exactly observed
    pars=wblfit(xlow);
    logL=@(g) -sum(log(wblpdf(x,g(1),g(2))));
    %if isempty(lastwarn)==1;exitflag=1;end
    gval=-logL(pars);
    
elseif  max(xupp)==Inf && min(xlow)>0 && isequal(xupp(xupp<Inf),xlow(xupp<Inf))==1 %and if there is ONLY right censoring 
       statusupp=(xupp==Inf);
       pars=wblfit(xupp,0.05,statusupp);
       logL=@(g) -sum((statusupp==0).*log(wblpdf(xupp,g(1),g(2)))+...
                (statusupp==1).*log(1-wblcdf(xupp,g(1),g(2))));
       %if isempty(lastwarn)==1;exitflag=1;end%
       gval=-logL(pars);
else %in any other censoring scheme:
       if isempty(init)==1
            %first derive initial values based on
            %interval censored data and fully observed data:
            datanew=x;
            at= xlow==-Inf | xupp==Inf | xlow==0;
            datanew(at,:)=[];
            datanew=(datanew(:,1)+datanew(:,2))./2;
            init=wblfit(datanew);
            
       end
       
              %this is the general likeelihood:
              logL=@(g) -  ((sum(-1.*(xlow==xupp)+log(wblcdf(xupp,g(1),g(2)) - wblcdf(xlow,g(1),g(2))).^(xlow<xupp)))+...
                     sum(-1.*(xlow<xupp)+(log(wblpdf(xupp,g(1),g(2)))).^(xlow==xupp)));

end
        
%End of building the corresponding likelihood. Now depending on the
%minimizer chosen, minimize the negative loglikelihood:

 
if minimizer==1
    if isempty(options)==1;options = optimset('MaxFunEvals',8000,'MaxIter',8000);end
    if sum(isnan(pars))==2;[pars , gval, exitflag]=fminsearchbnd(logL,init,[0 0],[Inf Inf],options);end
    gval=-gval;
elseif minimizer==2
    if isempty(options)==1;options = optimset('LargeScale','off','Algorithm','sqp','MaxFunEvals',8000,'MaxIter',8000);end
    if sum(isnan(pars))==2;[pars , gval, exitflag , ~ , ~, ~, HESSIANN]=fmincon(logL,init,[],[],[],[],[0 0],[Inf Inf],[],options);end
    gval=-gval;
elseif minimizer==3
    if isempty(options)==1;options = optimset('LargeScale','off','Algorithm','interior-point','MaxFunEvals',8000,'MaxIter',8000);end
    if sum(isnan(pars))==2;[pars , gval, exitflag , ~ , ~, ~, HESSIANN]=fmincon(logL,init,[],[],[],[],[0 0],[Inf Inf],[],options);end
    gval=-gval;
end

%Provide the hessian based on John D'errico's function:
hess = hessian(logL,pars);

%If there are any computational problems and minimizer is set to 2 or 3 
%then use the hessian as provided by fmincon:
if sum(sum(isnan(hess)))~=0 || sum(sum(imag(hess)))~=0
    hess=HESSIANN;
end

%obtain the covariance matrix along with the standard errors:
covars=inv(hess);
SE=sqrt(diag(covars));



    

end