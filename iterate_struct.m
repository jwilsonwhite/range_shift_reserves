function [N1,N2,Fi1,Fi2,cpue1,L2]= iterate_struct(g12,g21,D1,D2,Fpatch1,Fpatch2,Mean2,MPAs,P,T,N1init,N2init,CPUEinit)

%Iterate the structured
%competition model
load params_structured.mat maxA isFish a1 a2 b M1 M2 Fec  W1 Rw Fpenalty

% Fishing species 1 (No Fishing)
 %Fpatch1= 0; %Fishing mortality
 F_total1= Fpatch1*P; %Total Fishing 

 % Fishing species 2 (No Fishing)
 %Fpatch2= 0; %Fishing mortality
 F_total2= Fpatch2*P; %Total Fishing
 
%  g12= 0.0;
%  g21= 0.0;

%make matrices
N1= zeros(maxA,P,T); 
N2= zeros(maxA,P,T); 

if ~exist('N1init','var')
    N1(:,:,1)=repmat(W1,[1,P]);
else
    N1(:,:,1) = N1init;
end

if ~exist('N2init','var')
    N2(:,:,1)=0;
else
    N2(:,:,1) = N2init;
end


Fi1= zeros(P,T);
Fi1(:,1) = (1-MPAs)*(F_total1/sum(1-MPAs));

Fi2= zeros(P,T);
Fi2(:,1) = (1-MPAs)*(F_total2/sum(1-MPAs));

yield1= zeros(P,T);
yield1(:,1)= (1-MPAs)' ;

yield2= zeros(P,T);
yield2(:,1)= (1-MPAs)' ;

cpue1= zeros(P,T);
if ~exist('CPUEinit','var')
    cpue1(:,1)= (1-MPAs');
else
    cpue1(:,1) = CPUEinit;
end


cpue2= zeros(P,T);
cpue2(:,1)= (1-MPAs');


% landscape details
Shift_landscape = zeros(P,1);
Upper_limit = Rw(3);
Lower_limit = Rw(3)-P;
Shift_landscape(1:Upper_limit) = 1;

for t=2:T
    
% Shift the climate envelope
  Upper_limit = min(round(Upper_limit + Mean2),P);
  Lower_limit = min(round(Lower_limit + Mean2),P);
  Shift_landscape(1:Upper_limit) = 1;
  if Lower_limit>= 1
    Shift_landscape(1:Lower_limit) = 0; 
  end


    %Fishing intensity
    Fi1(:,t) = F_total1*(cpue1(:,t-1).^Fpenalty./sum(cpue1(:,t-1).^Fpenalty));
    Fi1(isnan(Fi1))=0;
    
    Fi2(:,t) = F_total2*(cpue2(:,t-1).^Fpenalty./sum(cpue2(:,t-1).^Fpenalty));
    Fi2(isnan(Fi2))=0;
 % Fi2(:,t) = Fi2(:,t-1);
  
    %Adult 
   for p=1:P
       %Survival 1
        Fvec1 = repmat(Fi1(p,t),[1,maxA]); % vector of Fishing rates
        Surv1 = exp(- (M1 + isFish.*Fvec1)); % vector of survival at each ag
        % Assemble the matrix 1
        Leslie1 = diag(Surv1(1:end-1),-1);
        Leslie1(1,:) = Fec;
        
         %Survival 2
        Fvec2 = repmat(Fi2(p,t),[1,maxA]); % vector of Fishing rates
        Surv2 = exp(- (M2 + isFish.*Fvec2)); % vector of survival at each age
        % Assemble the matrix
        Leslie2 = diag(Surv2(1:end-1),-1);
        Leslie2(1,:) = Fec;    
       
   
    N1(:,p,t)= Leslie1 * N1(:,p,t-1); %Adult population advancement 1 (initial pop, and mortality)
    N2(:,p,t)= Leslie2 * N2(:,p,t-1); %Adult population advancement 2 (initial pop, and mortality)
   end

    %reproduction
    L1(:,t) = a1 * N1(1,:,t); %Larvae Species 1 at all t, everywhere
    L2(:,t) = a2 * N2(1,:,t) .* Shift_landscape(:)'; %Larvae Species 2 at all t, everywhere, , with repro limited by climate window


    %Dispersal
    S1(:,t)= D1*L1(:,t);  %Settlers of 1
    S2(:,t)= D2*L2(:,t);  %Settlers of 2
    
    %Recruitment (Density Dep.) Beverton Holt
    R1(:,t)= S1(:,t)./(1+((S1(:,t)+(g21*S2(:,t)))/b)); %includes interspecific comp
    R2(:,t)= S2(:,t)./(1+((S2(:,t)+(g12*S1(:,t)))/b)); %includes interspecific comp
  
    %Recruits become the first age class
     N1(1,:,t)= R1(:,t); 
    N1(isnan(N1))=0;
    
    N2(1,:,t)= R2(:,t); 
    N2(isnan(N2))=0;
    
   %yield % WW fixed this to reflect the actual number of fish taken
    %(5/10/18)
    yield1(:,t)= (sum(N1(1:end-1,:,t-1)-N1(2:end,:,t)))'.*(Fi1(:,t)./(Fi1(:,t)+M1));
    yield1(yield1(:,t)<0,t) = realmin;
    yield1(isnan(yield1))=0;
    
    yield2(:,t)= (sum(N2(1:end-1,:,t-1)-N2(2:end,:,t)))'.*(Fi2(:,t)./(Fi2(:,t)+M2));
    yield2(yield2(:,t)<0,t) = realmin;
    if t == 2; yield2(:,t) = max(yield2(:,t),realmin); end % fix because N2 is expanding
    yield2(isnan(yield2))=0;
    
    %cpue
    cpue1(:,t)= yield1(:,t)./Fi1(:,t);
    cpue1(isnan(cpue1))=0;
    cpue1(isinf(cpue1))=0;
    
    cpue2(:,t)= yield2(:,t)./Fi2(:,t);
    cpue2(isnan(cpue2))=0;
    cpue2(isinf(cpue2))=0;

end


if Fpatch1>0 & Fpatch2>0 
 % keyboard; 
end

if g21>0
  % keyboard
end
