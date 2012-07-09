% T   runs 1-4 then 5-8 ---> -30,-15
% st. runs 1,2,3,4 repeat 5-8 ---> 1D, 4D, 1R, 4R
% NNI elem 1-3 repeat to 12 ---> 10,61,11
% gs  elem 1-3,4-6,7-9,10-12  ---> 0015, 0030, 0150, 0300


%% max save
mx = 351;

%% eigenvalues compare layers -- STRAIN
figure
subplot(1,3,3), plot(strainStep(1:mx), squeeze(EIG(1,2, 1:mx,elem,run)), '-k',...
                     strainStep(1:mx), squeeze(EIG(1,1, 1:mx,elem,run)), '--k',...
                     'LineWidth',3)

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[.33,1])
                 
subplot(1,3,2), plot(strainStep(1:mx), squeeze(EIG(2,2, 1:mx,elem,run)), '-k',...
                     strainStep(1:mx), squeeze(EIG(2,1, 1:mx,elem,run)), '--k',...
                     'LineWidth',3)
             

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


subplot(1,3,1), plot(strainStep(1:mx), squeeze(EIG(3,2, 1:mx,elem,run)), '-k',...
                     strainStep(1:mx), squeeze(EIG(3,1, 1:mx,elem,run)), '--k',...
                     'LineWidth',3)
                 

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


%% eigenvalues compare layers -- TIME

figure
subplot(1,3,3), plot(ModelTime{run}(elem,1:mx), squeeze(EIG(1,2, 1:mx,elem,run)), '-k',...
                     ModelTime{run}(elem,1:mx), squeeze(EIG(1,1, 1:mx,elem,run)), '--k',...
                     'LineWidth',3)

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[.33,1])
                 
subplot(1,3,2), plot(ModelTime{run}(elem,1:mx), squeeze(EIG(2,2, 1:mx,elem,run)), '-k',...
                     ModelTime{run}(elem,1:mx), squeeze(EIG(2,1, 1:mx,elem,run)), '--k',...
                     'LineWidth',3)
             

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


subplot(1,3,1), plot(ModelTime{run}(elem,1:mx), squeeze(EIG(3,2, 1:mx,elem,run)), '-k',...
                     ModelTime{run}(elem,1:mx), squeeze(EIG(3,1, 1:mx,elem,run)), '--k',...
                     'LineWidth',3)
                 

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])

%% Strain vs Model Time

figure
stka = (60*60*24*365*1000);
plot(strainStep(1:mx), ModelTime{run}(elem,1:mx)/stka, '-k',...
     'LineWidth',3)
xlabel('Strain')
ylabel('ka')
title('Strain vs Model Time')
set(gca,'FontSize',24,'FontWeight','bold')

%% eigenvalues window

figure
plot(strainStep(1:mx), squeeze(EIG(1,2, 1:mx,elem,run)-EIG(1,1, 1:mx,elem,run)),...
     '-k','LineWidth',3)

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold'...
    )

%% compare poly events

figure
plot(strainStep(1:mx), [0,PolyEvents{run}(elem,1:mx-1)],'-k',...
     'LineWidth',3)
%       x, PolyEvents{2}(1,:),'--k',...
%      x, PolyEvents{3}(1,:),'-k+',...
%      x, PolyEvents{4}(1,:),'--kd',...
 
 xlabel('Strain')
ylabel('Events')
set(gca,'FontSize',24,'FontWeight','bold')
