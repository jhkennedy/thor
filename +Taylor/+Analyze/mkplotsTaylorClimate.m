%% Climate Signal

plot( squeeze(-e1(1,:,1)+e1(2,:,1)), DEAPTH,'-db',...
      squeeze(-e1(1,:,2)+e1(2,:,2)), DEAPTH,'-dg',...
      squeeze(-e1(1,:,5)+e1(2,:,5)), DEAPTH,'-dr',...
      'LineWidth',3,'MarkerSize',9)
set(gca,'YDir','reverse','FontSize',24, 'FontWeight','bold')

xlabel('Climate Signal')
ylabel('Depth (m)')
legend('No NNI','mild','full')

%% Eigenvalues Layers 

nniLayer = 1; % 1 = no, 2 = mild, 5 = full; 

plot( squeeze(e1(1,:,nniLayer)), DEAPTH,'-db',...
      squeeze(e1(2,:,nniLayer)), DEAPTH,'-dg',...
      squeeze(e1(3,:,nniLayer)), DEAPTH,'-dr',...
      squeeze(e2(1,:,nniLayer)), DEAPTH,'-db',...
      squeeze(e2(2,:,nniLayer)), DEAPTH,'-dg',...
      squeeze(e2(3,:,nniLayer)), DEAPTH,'-dr',...
      squeeze(e3(1,:,nniLayer)), DEAPTH,'-db',...
      squeeze(e3(2,:,nniLayer)), DEAPTH,'-dg',...
      squeeze(e3(3,:,nniLayer)), DEAPTH,'-dr',...
      TAYLOR(:,3),TAYLOR(:,1),'ok',...
      TAYLOR(:,4),TAYLOR(:,1),'<k',...
      TAYLOR(:,5),TAYLOR(:,1),'xk',...
      'LineWidth',3,'MarkerSize',9)
set(gca,'YDir','reverse','FontSize',24, 'FontWeight','bold')

xlabel('Eigenvalue')
ylabel('Depth (m)')
legend('Top Layer','Middle','Bottom')

%% Compare NNI Eigenvalues

plot( squeeze(e1(1,:,1)), DEAPTH,'-db',...
      squeeze(e1(1,:,2)), DEAPTH,'-dg',...
      squeeze(e1(1,:,5)), DEAPTH,'-dr',...
      'LineWidth',3,'MarkerSize',9)
set(gca,'YDir','reverse','FontSize',24, 'FontWeight','bold')

xlabel('Climate Signal')
ylabel('Depth (m)')
legend('No NNI','mild','full')

%% grain size

plot( squeeze(GS(3,2,:,1)), DEAPTH,'-db',...
      squeeze(GS(3,2,:,2)), DEAPTH,'-dg',...
      squeeze(GS(3,2,:,5)), DEAPTH,'-dr',...
      'LineWidth',3,'MarkerSize',9)
set(gca,'YDir','reverse','FontSize',24, 'FontWeight','bold')

xlabel('Grain Size (mm)')
ylabel('Depth (m)')
legend('No NNI','mild','full')

