function struct_wrapper

% Perform all of the simulations using the unstructured version of the
% model
doloops = false;


% Set params:
parameters_structured
load params_structured.mat

% Competition scenarios:
G12s = [0.5,1,0.5];
G21s = [0.5,0.5,1];

% fishing rates
F1s = linspace(0,max_f1,4);
F2s = linspace(0,max_f2,20); % 20

% climate velocities
Vs = linspace(1,max_m2,20); % 20

if doloops

for g = 1:length(G12s)

    figure(g)
    set(gcf,'units','cent','position',[10,10,12,12])
    clf

    for f = 1:length(F1s)

        % set up results arrays
        P1 = nan(length(F2s),length(Vs),length(Rw));
        P2 = P1;
        dN = P1;

    for m = 1:length(Rw) % MPA scenarios

    for f2 = 1:length(F2s)
    for v = 1:length(Vs)
        [P1(f2,v,m),P2(f2,v,m),dN(f2,v,m)] = struct2sp(Vs(v),F2s(f2),Rw(m),Pr(m),G12s(g),G21s(g),F1s(f),0);

if f == 2 & f2 == 9 && v == 16 && m == 2
  %  keyboard
end

    end
    end % end F2s

    end % end loop over MPA scenarios

    % P1 

%keyboard
figure(g)
subplot(2,2,f)
hold on
makeplot_sp2(P1,P2,dN,F2s,Vs,F1s(f))

    end % end loop over F1s
end % end loop over gs
end % end if doloops

% Time series plots to show things...check why even very high F2 allows
% persistence for moderate climate velocities

% high fishing, slow climate - no persistence
%struct2sp(Vs(2),F2s(12),Rw(1),Pr(1),G12s(1),G21s(1),F1s(2),1);
% high fishing, habitat expanding - persistence
%struct2sp(Vs(4),F2s(12),Rw(1),Pr(1),G12s(1),G21s(1),F1s(2),1);

% high fishing, slow climate + small MPAs - persistence
%struct2sp(Vs(2),F2s(12),Rw(2),Pr(2),G12s(1),G21s(1),F1s(2),1);

% high fishing, slow climate + large MPAs - no persistence
%struct2sp(Vs(2),F2s(12),Rw(3),Pr(3),G12s(1),G21s(1),F1s(2),1);  

% high fishing, fast climate + large MPAs - persistence
%struct2sp(Vs(10),F2s(18),Rw(3),Pr(3),G12s(1),G21s(1),F1s(4),1); 

% high fishing, fast climate + large MPAs - no persistence
%struct2sp(3.5,0.15,Rw(2),Pr(2),G12s(1),G21s(1),F1s(2),1);  

struct2sp(3.5,0.15,Rw(2),Pr(2),G12s(1),G21s(1),F1s(2),1);  

struct2sp(3.5,0.15,Rw(3),Pr(3),G12s(1),G21s(1),F1s(2),1);  

struct2sp(5,0.1,Rw(2),Pr(2),G12s(1),G21s(1),F1s(2),1);  


% helper function
function makeplot_sp2(P1,P2,dN,F2s,Vs,F)

Col = {'k','r','b'};
for i = 1:size(P2,3)
contour(Vs,F2s,P2(:,:,i),1,'color',Col{i})
end

set(gca,'tickdir','out','ticklength',[0.015 0.015],...
    'xcolor','k','ycolor','k')
ylabel('Species 2 harvest rate')
xlabel('Climate velocity (km/y)')
title(strcat('Species 1 harvest rate: F = ',num2str(F)))


