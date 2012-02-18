elem = 1; run = 1;

for ii = 1:301
    cla
    cdist = load([Dir,'/Run',num2str(run),'/Step',num2str(SAVE(ii),'%05d'),'_EL',num2str(elem,'%09d'),'.mat']);
%     figure
    equalAreaPoint([cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))])
    pause(0.2)

    
end

%%
ii = 299;

cdist = load([Dir,'/Run',num2str(run),'/Step',num2str(SAVE(ii),'%05d'),'_EL',num2str(elem,'%09d'),'.mat']);
% figure
% [XY] = equalAreaPoint([cdist.theta(eigenMask(:,2)),cdist.phi(eigenMask(:,2))]);