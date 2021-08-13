close all
clear all
clc

xx=[-Inf      2.5527
    -Inf      1.3988
    -Inf      3.7984
    -Inf      4.0297
    -Inf      4.1687
    -Inf      4.6387
    -Inf      7.1782
    -Inf      4.1320
    -Inf      4.2782
    -Inf      2.4957
    3.6916    Inf
    2.6521    Inf
    6.7862    Inf
    2.8872    Inf
    3.9121    Inf
    4.3221    Inf
    4.2646    Inf
    1.2738    Inf
    3.3879    Inf
   -0.0056    Inf
    2.7480    3.3480
    4.0380    4.6380
    2.6833    3.2833
    2.8754    3.4754
    5.8209    6.4209
    2.5160    3.1160
    0.3888    0.9888
    3.0400    3.6400
   -0.9232   -0.3232
    0.3354    0.9354
    6.5216    7.1216
   -2.2916   -1.6916
    0.9786    1.5786
    4.0443    4.6443
    3.8893    4.4893
    4.6707    5.2707
    3.5162    4.1162
    1.6837    2.2837
    1.5772    2.1772
    1.3320    1.9320
    3.4626    4.0626
    3.7167    4.3167
    2.1168    2.7168
    3.1897    3.7897
    1.7531    2.3531
    4.6149    5.2149
    4.5249    5.1249
    1.9554    2.5554
    3.0747    3.6747
    3.5440    4.1440
   -3.0151   -2.4151
    3.2938    3.8938
    0.6433    1.2433
    2.7620    3.3620
    5.2770    5.8770
    2.3071    2.9071
    5.9049    6.5049
    2.3912    2.9912
    0.4567    1.0567
    0.3604    0.9604
    4.3547    4.9547
    0.1139    0.7139
    0.5420    1.1420
    2.6760    3.2760
    4.3641    4.9641
    2.5176    3.1176
    3.0438    3.6438
    5.2702    5.8702
    2.3343    2.9343
    3.9983    4.5983
    1.7357    2.3357
    1.6694    2.2694
    3.0495    3.6495
    0.3320    0.9320
    4.9494    5.5494
    6.1926    6.7926
   -0.1502    0.4498
    6.5352    7.1352
    2.5313    3.1313
    5.0977    5.6977
    0.1747    0.7747
    1.0336    1.6336
    0.7306    1.3306
    4.0575    4.6575
    0.9214    1.5214
    2.1299    2.7299
   -1.7742   -1.1742
    5.8691    6.4691
   -2.7750   -2.1750
    2.5718    3.1718
    5.2752    5.2752
    3.3392    3.3392
    1.9617    1.9617
    3.4075    3.4075
    2.8454    2.8454
    5.1404    5.1404
   -0.4164    -0.4164
    4.0137    4.0137
   -0.5626    -0.5626
    1.0920    1.0920];

%In the above data set:
%the first ten observations are left censored
%the following ten observations are right censored
%the last ten observations are exactly observed.
%all other observations refer to interval censored data.


[pars covars SE gval exitflag]=normfitc(xx)  %fit the normal distribution to the data
[pars covars SE gval exitflag]=normfitc(xx,2)%do the same using "fmincon" with LargeScale turned off and sqp active
[pars covars SE gval exitflag]=normfitc(xx,2,[2 2]) %do the same by providing initial values
options=optimset('MaxFunEvals',10000,'MaxIter',10000); %do the same by also providing some option to fminsearchbnd since minimizer=1
[pars covars SE gval exitflag]=normfitc(xx,1,[2 2],options)

%Other distribution you could try that have the real line as a support:
%[pars covars SE gval exitflag]=logistfitc(xx)      
%[pars covars SE gval exitflag]=evfitc(xx)       



%%

%Now let's see an example that deals with positive supported distributions
%and try to fit the weibull distribution:

clear all
close all
clc

xx=[0      2.5527
    0      1.3988
    0      3.7984
    0      4.0297
    0      4.1687
    0      4.6387
    0      7.1782
    0      4.1320
    0      4.2782
    0      2.4957
    3.6916    Inf
    2.6521    Inf
    6.7862    Inf
    2.8872    Inf
    3.9121    Inf
    4.3221    Inf
    4.2646    Inf
    1.2738    Inf
    3.3879    Inf
    0.0056    Inf
    2.7480    3.3480
    4.0380    4.6380
    2.6833    3.2833
    2.8754    3.4754
    5.8209    6.4209
    2.5160    3.1160
    0.3888    0.9888
    3.0400    3.6400
    0.9232    1.3232
    0.3354    0.9354
    6.5216    7.1216
    2.2916    3.6916
    0.9786    1.5786
    4.0443    4.6443
    3.8893    4.4893
    4.6707    5.2707
    3.5162    4.1162
    1.6837    2.2837
    1.5772    2.1772
    1.3320    1.9320
    3.4626    4.0626
    3.7167    4.3167
    2.1168    2.7168
    3.1897    3.7897
    1.7531    2.3531
    4.6149    5.2149
    4.5249    5.1249
    1.9554    2.5554
    3.0747    3.6747
    3.5440    4.1440
    1.0151    2.4151
    3.2938    3.8938
    0.6433    1.2433
    2.7620    3.3620
    5.2770    5.8770
    2.3071    2.9071
    5.9049    6.5049
    2.3912    2.9912
    0.4567    1.0567
    0.3604    0.9604
    4.3547    4.9547
    0.1139    0.7139
    0.5420    1.1420
    2.6760    3.2760
    4.3641    4.9641
    2.5176    3.1176
    3.0438    3.6438
    5.2702    5.8702
    2.3343    2.9343
    3.9983    4.5983
    1.7357    2.3357
    1.6694    2.2694
    3.0495    3.6495
    0.3320    0.9320
    4.9494    5.5494
    6.1926    6.7926
    0.1502    0.4498
    6.5352    7.1352
    2.5313    3.1313
    5.0977    5.6977
    0.1747    0.7747
    1.0336    1.6336
    0.7306    1.3306
    4.0575    4.6575
    0.9214    1.5214
    2.1299    2.7299
    1.7742    2.1742
    5.8691    6.4691
    2.7750    3.1750
    2.5718    3.1718
    5.2752    5.2752
    3.3392    3.3392
    1.9617    1.9617
    3.4075    3.4075
    2.8454    2.8454
    5.1404    5.1404
    0.4164    0.4164
    4.0137    4.0137
    0.5626    0.5626
    1.0920    1.0920];


%In the above data set:
%the first ten observations are left censored
%the following ten observations are right censored
%the last ten observations are exactly observed.
%all other observations refer to interval censored data.
clc
[pars covars SE gval exitflag]=wblfitc(xx)  %fit the normal distribution to the data
[pars covars SE gval exitflag]=wblfitc(xx,2)%do the same using "fmincon" with LargeScale turned off and sqp active
[pars covars SE gval exitflag]=wblfitc(xx,2,[2 2]) %do the same by providing initial values
options=optimset('MaxFunEvals',10000,'MaxIter',10000); %do the same by also providing some option to fminsearchbnd since minimizer=1
[pars covars SE gval exitflag]=wblfitc(xx,1,[2 2],options)
 


%Other positive supported distributions you could try:
%[pars covars SE gval exitflag]=expfitc(xx)         
%[pars covars SE gval exitflag]=loglogistfitc(xx)   
%[pars covars SE gval exitflag]=lognfitc(xx)       
%[pars covars SE gval exitflag]=gamfitc(xx)
%[pars covars SE gval exitflag]=raylfitc(xx)




