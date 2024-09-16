function [persist1,persist2,dN1]= unstruct2sp(Mean2,Fpatch2,Rw,Pr,g12,g21,f1s,doplot)%(g12,g21,Fpatch1,Fpatch2)


%Set up reserves
load params_unstructured.mat T X Mean1 SD1 SD2

%make landscape 
MPAs= make_landscape(Rw,Pr,X);
P = length(MPAs);

% Fishing species 1 (No Fishing)
 Fpatch1= f1s; %Fishing mortality
 F_total1= Fpatch1*P; %Total Fishing 

 % Fishing species 2 (No Fishing)
 %Fpatch2= 0; %Fishing mortality
 F_total2= Fpatch2*P; %Total Fishing
 
 
%create state variables
N1= zeros(P,T); 
 
N2= zeros(P,T); 
N2(1,1)=1;

Fi1= zeros(P,T);
Fi1(:,1) = (1-MPAs)*(F_total1/sum(1-MPAs));

Fi2= zeros(P,T);
Fi2(:,1) = (1-MPAs)*(F_total2/sum(1-MPAs));

yield1= zeros(P,T);
yield1(:,1)= (1-MPAs)' ;

yield2= zeros(P,T);
yield2(:,1)= (1-MPAs)' ;

cpue1= zeros(P,T);
cpue1(:,1)= (1-MPAs');

cpue2= zeros(P,T);
cpue2(:,1)= (1-MPAs');


%Dispersal matrix

D1= Dispersal_matrix(P,Mean1,SD1);
D2= Dispersal_matrix(P,Mean1,SD2);

% obtain equilibrium without sp 2 as initial conditions:
N0 = iterate_unstruct(g12,0,D1,D2,Fpatch1,Fpatch2,Mean2,MPAs,P,T);
N1(:,1) = N0(:,end);


% iterate the model:
[N1,N2,Fi1,Fi2] = iterate_unstruct(g12,g21,D1,D2,Fpatch1,Fpatch2,Mean2,MPAs,P,T,N1(:,1),N2(:,1));


if ~exist('doplot','var')
    doplot=false;
end

if doplot % plot some spatial distributions

    figure
    clf
    set(gcf,'units','cent','position',[10,10,8,20])

    s(1)=subplot(3,1,1);
    hold on

    %plot(N1(:,1),'k--')
    plot(N1(:,T/2),'b--')
    plot(N1(:,T),'b-')
    ylabel('Abundance of resident species')

    s(2)=subplot(3,1,2);
    hold on

   % plot(N2(:,1),'k--')
    plot(N2(:,T/2),'b--')
    plot(N2(:,T),'b-')
    x1 = Mean2*T/2;
    x2 = Mean2*T;
    y1 = N2(round(x1),T/2)*0.5;
    y2 = N2(round(x2),T)*0.5;
    plot([x1 x1],[0, y1],'k-')
    plot([x2 x2],[0, y2],'k-')
    ylabel('Abundance of shifting species')

    s(3)=subplot(3,1,3);
    hold on

    plot(Fi1(:,T),'r-')
    plot(Fi2(:,T),'r--')
    ylabel('Harvest rates (y-1)')
    xlabel('Distance along coastline (km)')

    set(s,'tickdir','out','ticklength',[0.015 0.015],...
        'xcolor','k','ycolor','k')


    figure
    clf
    set(gcf,'units','cent','position',[10,12,3.5,5])
    ss(1)= subplot(2,1,1);
    plot(sum(N1))
     ylabel('Abundance')
     xlabel('Time (y)')


    ss(2) = subplot(2,1,2);
    plot(sum(N2))
    ylabel('Abundance')
    xlabel('Time (y)')
    
    set(s,'tickdir','out','ticklength',[0.015 0.015],...
        'xcolor','k','ycolor','k')


   % keyboard

end % end if doplot

%sustainablity of N2
%  LPR= L2(:,end)'./R2(:,end-1)';
%  LPR(isnan(LPR))=0;
%  De=D2.*repmat(LPR,[length(L2),1]);
%  persist= max(eig(De))>=1;
%  persist=double(persist);

%keyboard
%persist1= (sum(N1(:,end)))>=(sum(N1(:,end-1)));
persist1 = sum(N1(:,end))/sum(N1(:,1));
persist1=double(persist1);
persist2= (sum(N2(:,end)))>=(sum(N2(:,end-1)));
persist2=double(persist2);

% Look at change in N1 as well:
dN1 = sum(N1(:,end))/sum(N1(:,1));

%keyboard
%Out=[N1(:,end) N2(:,end)];
%Out= persist;
%keyboard