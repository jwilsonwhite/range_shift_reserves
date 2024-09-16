function parameters_structured

% parameters are based on Blue Rockfish (see White et al. 2022)

b= 1; %competition constant
M1= 0.14; %natural mortality species 1 (most species have 0.1-0.2, most fisheries use 0.2 for estimations)
M2= 0.14; %natural mortality species 2 

%Maturity
maxA = 30; % maximum age
Amat = 6; % age at maturity
Age = 1:maxA; % age vector
isMat = Age>=Amat; % maturity vector
Afish = 4; % age of entry
isFish = Age>=Afish;

%Fecunditity
  Linf = 38;
  k = 0.17;
  a0 = -1;
  L = Linf*(1 - exp(-k*(Age + a0)));
  B = L.^3;
  Fec = isMat.*B; % fecundity, accounting for maturity
  

%Unfished leslie matrix


% Survival part
%Surv = exp(- (M1));
Surv = exp(-(M1 + isFish*0));


Leslie = diag(Surv(1:end-1),-1);
Leslie(1,:) = Fec;

[W,L] = eig(Leslie); % W is eigenvectors, L is eigenvalues
L = diag(L); % vector of eigenvalues
maxL = max(L); % dominant eigenvalue
W1 = W(:,L==maxL); 

%Survivability
%sur= exp(-1*(M1.*(Age-1)))';

sur = [1; cumprod(Surv(1:end-1))'];

LEP = Fec*sur;

a1=1/(0.15*LEP); %0.05; %growth factor 1

a2= 1/(0.15*LEP); %0.05; %growth factor 2

%Competition
max_g12= 2; % max number of iterations (divide by 20=max competition coefficient 1 on 2)
max_g21= 2;  % max number of iterations (divide by 20=max competition coefficient 2 on 1)

%Fishing maximum rates
max_f1= 0.3; % based on other parameters, 0.26 is the largest value that allows persistence
max_f2= 0.3; 

T= 20; %timesteps
 
%Dispersal 1
Mean1= 0;
SD1= 20; %high= 10ish
%Run: Set F high, and vary SD

%Dispersal 2
max_m2= 10; %5 is slow movement (50km/decade), 10 is medium rate, and 20 is fast (200km/year, Fuller et al.)
SD2= 20;

% Fishing CPUE penalty for gravity model
Fpenalty = 0.25;

% Some of these may not be used....need to check

%Reserve set up
% Given the choice of M and a, we need to have p(retained) > (1-exp(-M))/a for
% persistence. Having a reserve that is 1x dispersal distance should be
% self-persistent
Rw = [0, 1, 20]; %Size of reserve
Pr = [0 0.2 0.2]; %Proportion of area that is reserved
X = 100; %target size of landscape

save params_structured.mat

