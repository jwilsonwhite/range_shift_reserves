function [persist1,persist2,dN1] = struct2sp(Mean2,Fpatch2,Rw,Pr,g12,g21,f1s,doplot) %(g12,g21,Fpatch1,Fpatch2)


%Set up reserves
load params_structured.mat T X Mean1 SD1 SD2 maxA


%make landscape 
MPAs = make_landscape(Rw, Pr, X);
P = length(MPAs);

% Fishing species 1 (No Fishing)
 Fpatch1= f1s; %Fishing mortality
 F_total1= Fpatch1*P; %Total Fishing 
 F_total2= Fpatch2*P; %Total Fishing

 
 %Mean2=10;
%make matricies
N1= zeros(maxA,P,T); 
N2= zeros(maxA,P,T); 

%Dispersal matrix

D1= Dispersal_matrix(P,Mean1,SD1);
D2= Dispersal_matrix(P,Mean1,SD2);

[N0,~,~,~,CPUEinit] = iterate_struct(g12,0,D1,D2,Fpatch1,Fpatch2,0,MPAs,P,200);
N1(:,:,1)  = N0(:,:,end);
N2(:,1,1) = N0(:,1,end);
CPUEinit = CPUEinit(:,end); % CPUE of species 1, to set initial conditions

% iterate the model:
[N1,N2,Fi1,Fi2,~,L2] = iterate_struct(g12,g21,D1,D2,Fpatch1,Fpatch2,Mean2,MPAs,P,T,N1(:,:,1),N2(:,:,1),CPUEinit);


if ~exist('doplot','var')
    doplot=false;
end


if doplot % plot some spatial distributions

    figure
    clf
    set(gcf,'units','cent','position',[10,10,8,20])

    s(1)=subplot(3,1,1);
    hold on

    plot(sum(N1(:,:,T/2)),'b--')
    plot(sum(N1(:,:,T)),'b-')
    ylabel('Abundance of resident species')

    s(2)=subplot(3,1,2);
    hold on

    plot(sum(N2(:,:,T/2)),'b--')
    plot(sum(N2(:,:,T)),'b-')
    x1 = min(T,Mean2*T/2);
    x2 = min(T,Mean2*T);
    y1 = sum(N2(:,round(x1),T/2))*0.5;
    y2 = sum(N2(:,round(x2),T))*0.5;
    plot([x1 x1],[0, y1],'k-')
    plot([x2 x2],[0, y2],'k-')
    ylabel('Abundance of shifting species')


    s(3)=subplot(3,1,3);
    hold on

plot(L2(:,T),'b-')
%plot(L2(:,15),'b.-')
plot(L2(:,10),'b--')

ylim([0 0.1])
    %plot(Fi1(:,T),'r-')
    %plot(Fi2(:,T),'r--')

    %ylabel('Harvest rates (y-1)')
    ylabel('Larval production')
    xlabel('Distance along coastline (km)')

      set(s,'tickdir','out','ticklength',[0.015 0.015],...
        'xcolor','k','ycolor','k')


figure
    clf
    set(gcf,'units','cent','position',[10,12,3.5,5])
    ss(1)= subplot(2,1,1);
    plot(sum(squeeze(N1(1,:,:))))
     ylabel('Abundance')
     xlabel('Time (y)')
   %  ylim([350 390])


    ss(2) = subplot(2,1,2);
    plot(sum(squeeze(N2(1,:,:))))
    ylabel('Abundance')
    xlabel('Time (y)')
    
    set(s,'tickdir','out','ticklength',[0.015 0.015],...
        'xcolor','k','ycolor','k')
    set(ss,'tickdir','out','ticklength',[0.015 0.015],...
        'xcolor','k','ycolor','k')

    persist2= (sum(sum(N2(1,:,end))))>=(sum(sum(N2(1,:,end-1))))


figure
set(gcf,'units','cent','position',[10,10,8,20])
hold on

for i = 2:10
subplot(9,1,i-1)
plot((L2(:,i)))
ylim([0,0.02])
set(ss,'tickdir','out','ticklength',[0.015 0.015],...
        'xcolor','k','ycolor','k')
end


    %keyboard
end % end if doplot

%sustainablity of N2
%  LPR= L2(:,end)'./R2(:,end-1)';
%  LPR(isnan(LPR))=0;
%  De=D2.*repmat(LPR,[length(L2),1]);
%  persist= max(eig(De))>=1;
%  persist=double(persist);

%keyboard
persist1= (sum(sum(N1(:,:,end))))/(sum(sum(N1(:,:,end-1))));
persist1=double(persist1);

if sum(sum(N2(1,:,end))) > 0
persist2= (sum(sum(N2(1,:,end))))>=(sum(sum(N2(1,:,end-1))));
persist2=double(persist2);
else
    persist2 = 0;
end

% Look at change in N1 as well:
dN1 = sum(sum(N1(:,:,end)))/sum(sum(N1(:,:,1)));

%%%%%%%
%% Notes 2/21/24
% Change the way the climate shift happens bc as of now it is possible to
% persist, Pringle & Byers style, but that's not realistic. Possibly just
% moving window of acceptability ... perhaps that's how Fuller et al did
% it? Window is 100 km wide, so the same total potential habitat...and
% sliding at some rate of # cells per year

