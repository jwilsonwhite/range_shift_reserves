function parameters_unstructured


b= 1; % Beverton-Holt maximum density
M1= 0.2; %natural mortality species 1 (most species have 0.1-0.2, most fisheries use 0.2 for estimations)
M2= 0.2; %natural mortality species 2 


a1=4; %growth factor 1
a2= 4; %growth factor 2

%Competition
max_g12= 2; % max number of iterations (divide by 20=max competition coefficient 1 on 2)
max_g21= 2;  % max number of iterations (divide by 20=max competition coefficient 2 on 1)

%Fishing (maximum range of fishing rates)
% Persistence requires M <= a + s - 1
max_f1= a1 + exp(-M1) - 1; 
max_f2= a2 + exp(-M2) - 1; 

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


%Reserve set up
% Given the choice of M and a, we need to have p(retained) > (1-exp(-M))/a for
% persistence. Having a reserve that is 1x dispersal distance should be
% self-persistent
Rw = [0, 1, 20]; %Size of reserve
Pr = [0 0.2 0.2]; %Proportion of area that is reserved
X = 100; %target size of landscape

save params_unstructured.mat

