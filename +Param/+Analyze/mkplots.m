%% eigenvalues compare layers -- STRAIN


subplot(1,3,3), plot(strainStep, squeeze(EIG(1,2, :,1,1)), '-k',...
                     strainStep, squeeze(EIG(1,1, :,1,1)), '--k',...
                     'LineWidth',3)

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[.33,1])
                 
subplot(1,3,2), plot(strainStep, squeeze(EIG(2,2, :,1,1)), '-k',...
                     strainStep, squeeze(EIG(2,1, :,1,1)), '--k',...
                     'LineWidth',3)
             

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


subplot(1,3,1), plot(strainStep, squeeze(EIG(3,2, :,1,1)), '-k',...
                     strainStep, squeeze(EIG(3,1, :,1,1)), '--k',...
                     'LineWidth',3)
                 

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])

%% eigenvalues compare layers -- TIME



subplot(1,3,3), plot(ModelTime{1}(1,:), squeeze(EIG(1,2, :,1,1)), '-dk',...
                     ModelTime{1}(1,:), squeeze(EIG(1,1, :,1,1)), '--dk',...
                     'LineWidth',3)

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[.33,1])
                 
subplot(1,3,2), plot(ModelTime{1}(1,:), squeeze(EIG(2,2, :,1,1)), '-dk',...
                     ModelTime{1}(1,:), squeeze(EIG(2,1, :,1,1)), '--dk',...
                     'LineWidth',3)
             

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])


subplot(1,3,1), plot(ModelTime{1}(1,:), squeeze(EIG(3,2, :,1,1)), '-dk',...
                     ModelTime{1}(1,:), squeeze(EIG(3,1, :,1,1)), '--dk',...
                     'LineWidth',3)
                 

xlabel('Model Time')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold',...
    'YLim',[0,.33])

%% Strain vs Model Time
mx = 52; % 52
stka = (60*60*24*365*1000);
plot(strainStep(1:mx), ModelTime{1}(1,1:mx)/stka, '-dk',...
     'LineWidth',3)
xlabel('Strain')
ylabel('ka')
title('Strain vs Model Time')
set(gca,'FontSize',24,'FontWeight','bold')

%% eigenvalues window


plot(strainStep, squeeze(EIG(1,2, :,2,1)-EIG(1,1, :,2,1)), '-k',...
                     'LineWidth',3)

xlabel('Strain')
ylabel('e_1')
set(gca,'FontSize',24,'FontWeight','bold'...
    )

%% compare poly events

x = (1:TimeSteps).*StrainStep;
plot(x, PolyEvents{1}(1,:),'--k',...
     x, PolyEvents{2}(1,:),'-k',...
     x, PolyEvents{3}(1,:),'-k+',...
     x, PolyEvents{4}(1,:),'--kd',...
     'LineWidth',3)
 
 xlabel('Strain')
ylabel('Events')
set(gca,'FontSize',24,'FontWeight','bold')
