cdist.t1 = cdist1.(NAMES.files{pltcrys});
cdist.t2 = cdist2.(NAMES.files{pltcrys});
%%
PLT = [cell2mat(cdist.t1(:,2)),cell2mat(cdist.t1(:,1)),cell2mat(cdist.t2(:,2)),cell2mat(cdist.t2(:,1))];


polar(PLT(:,1),PLT(:,2),'.b')
    xlabel('Initial Crystal Orientations')
    title('Uniaxial Compression')

figure, polar(PLT(:,3),PLT(:,4),'.r')
    xlabel('Crystal Orientations After applied Stress')
    title('Uniaxial Compression')
%%
figure, h = polar([cell2mat(cdist.t1(1,2)), 0],[cell2mat(cdist.t1(1,1)), pi/2],'.b');
hold on
polar(gca,cell2mat(cdist.t2(1,2)),cell2mat(cdist.t2(1,1)),'.r')

FID = fopen('uniaxial.dat','w+');
fprintf(FID, '%d %d %d %d\n', PLT');
fclose(FID);