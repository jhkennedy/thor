%% eigenvalues compare layers


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
set(gca,'FontSize',24,'FontWeight','bold',...
    'Ylim',[-50,850])
