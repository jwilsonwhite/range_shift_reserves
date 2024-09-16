function Out = Dispersal_matrix(P,Mean1,SD1)

%Dispersal matrix

X = 1:P;
X = repmat(X,[P,1]);
Y = X';
Dist = X-Y;
Out= normcdf(Dist+0.5,Mean1,SD1) - normcdf(Dist-0.5,Mean1,SD1);
% can add multiple coastlines 
%Out= normcdf(Dist+0.5+P,Mean1,SD1) - normcdf(Dist-0.5-P,Mean1,SD1);
%Out= normcdf(Dist+0.5+(2*P),Mean1,SD1) - normcdf(Dist-0.5-(2*P),Mean1,SD1);
%normcdf(X,Mean,sd) size MPas set scale of sd (long vs short relative to
%mpa). 