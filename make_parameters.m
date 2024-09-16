function make_parameters


%Reserve set up
%Rw =0; %Size of reserve
%Pr = 0.0; %Proportion of area that is reserved
X = 100; %number of times unit is repeated


b= 1; %competition constant
M1= 0.2; %natural mortality species 1 (most species have 0.1-0.2, most fisheries use 0.2 for estimations)
M2= 0.2; %natural mortality species 2 

%Maturity
maxA = 30; % maximum age
Amat = 4; % age at maturity
Age = 1:maxA; % age vector
isMat = Age>=Amat; % maturity vector

%Fecunditity
  Linf = 100;
  k = 0.2;
  a0 = -1;
  L = Linf*(1 - exp(-k*(Age + a0)));
  B = L.^3;
  Fec = isMat.*B; % fecundity, accounting for maturity
  

%N2 unfished leslie matrix
M = 0.2; % maturity rate
F = 0.2; % fishing rate

% Survival part
Fvec = repmat(F,[1,maxA]); % vector of Fishing rates
Surv = exp(- (M + isMat.*Fvec));

Leslie = diag(Surv(1:end-1),-1);
Leslie(1,:) = Fec;

[W,L] = eig(Leslie); % W is eigenvectors, L is eigenvalues
L = diag(L); % vector of eigenvalues
maxL = max(L); % dominant eigenvalue
W1 = W(:,L==maxL); 

%Survivability
sur= exp(-1*(M.*(Age-1)))';
LEP = Fec*sur;

a1=1/(0.2*LEP); %0.05; %growth factor 1

a2= 1/(0.2*LEP); %0.05; %growth factor 2

%Competition
max_g12= 2; % max number of iterations (divide by 20=max competition coefficient 1 on 2)
max_g21= 2;  % max number of iterations (divide by 20=max competition coefficient 2 on 1)

%Fishing 
max_f1= 3; %maximum iterations of Fpatch1 (divide by 20 = fpactch1 in runs)
max_f2= 2; %maximum iterations of Fpatch2 (divide by 20 = fpactch2 in runs)

T= 100; %timesteps
 
%Dispersal 1
Mean1= 0;
SD1= 20; %high= 10ish
%Run: Set F high, and vary SD

%Dispersal 2
max_m2= 40; %5 is slow movement (50km/decade), 10 is medium rate, and 20 is fast (200km/year, Fuller et al.)
SD2= 20;

% Fishing CPUE penalty for gravity model
Fpenalty = 0.25;

%save params.mat

