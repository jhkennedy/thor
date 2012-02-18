%% max save
mx = 301;

%% eigenvalues compare layers -- STRAIN

subplot(1,3,3), plot(strainStep(1:mx), squeeze(EIG(1,2, 1:mx,1,1)), '-k',...
                     strainStep(1:mx), squeeze(EIG(1,1, 1:mx,1,1)), '--k',...
                     'LineWidth',3)

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[.33,1])
                 
subplot(1,3,2), plot(strainStep(1:mx), squeeze(EIG(2,2, 1:mx,1,1)), '-k',...
                     strainStep(1:mx), squeeze(EIG(2,1, 1:mx,1,1)), '--k',...
                     'LineWidth',3)
             

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


subplot(1,3,1), plot(strainStep(1:mx), squeeze(EIG(3,2, 1:mx,1,1)), '-k',...
                     strainStep(1:mx), squeeze(EIG(3,1, 1:mx,1,1)), '--k',...
                     'LineWidth',3)
                 

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


%% eigenvalues compare layers -- TIME



subplot(1,3,3), plot(ModelTime{1}(1,1:mx), squeeze(EIG(1,2, 1:mx,1,1)), '-k',...
                     ModelTime{1}(1,1:mx), squeeze(EIG(1,1, 1:mx,1,1)), '--k',...
                     'LineWidth',3)

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[.33,1])
                 
subplot(1,3,2), plot(ModelTime{1}(1,1:mx), squeeze(EIG(2,2, 1:mx,1,1)), '-k',...
                     ModelTime{1}(1,1:mx), squeeze(EIG(2,1, 1:mx,1,1)), '--k',...
                     'LineWidth',3)
             

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


subplot(1,3,1), plot(ModelTime{1}(1,1:mx), squeeze(EIG(3,2, 1:mx,1,1)), '-k',...
                     ModelTime{1}(1,1:mx), squeeze(EIG(3,1, 1:mx,1,1)), '--k',...
                     'LineWidth',3)
                 

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])

%% Strain vs Model Time

stka = (60*60*24*365*1000);
plot(strainStep(1:mx), ModelTime{1}(1,1:mx)/stka, '-k',...
     'LineWidth',3)
xlabel('Strain')
ylabel('ka')
title('Strain vs Model Time')
set(gca,'FontSize',24,'FontWeight','bold')

%% eigenvalues window


plot(strainStep(1:mx), squeeze(EIG(1,2, 1:mx,2,1)-EIG(1,1, 1:mx,2,1)), '-k',...
                     'LineWidth',3)

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold'...
    )

%% compare poly events

x = (0:mx-1).*StrainStep;
plot(x, PolyEvents{1}(1,1:mx),'--k',...
     'LineWidth',3)
%       x, PolyEvents{2}(1,:),'-k',...
%      x, PolyEvents{3}(1,:),'-k+',...
%      x, PolyEvents{4}(1,:),'--kd',...
 
 xlabel('Strain')
ylabel('Events')
set(gca,'FontSize',24,'FontWeight','bold')
