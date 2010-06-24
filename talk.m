

load +Taylor/Results/TAYLOR.mat
%% Temp
plot([-43,-23], [0,600],'LineWidth',4)
clf
set(axes,'YDir', 'reverse')
hold on
plot([-43,-23], [0,600],'LineWidth',4)
ylabel('Depth (m)')
xlabel('Temperature (^oC)')

%% Eig
plot(TAYLOR(:,3),TAYLOR(:,1),'o',TAYLOR(:,4),TAYLOR(:,1),'o',TAYLOR(:,5),TAYLOR(:,1),'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(TAYLOR(:,3),TAYLOR(:,1),'o',TAYLOR(:,4),TAYLOR(:,1),'o',TAYLOR(:,5),TAYLOR(:,1),'o')
xlabel('Eigenvalue')
ylabel('Depth (m)')
legend('S_z', 'S_y', 'S_x','Location','NorthOutside','Orientation','Horizontal')

%% Age
load +Taylor/Results/ds0p50.mat
plot(AGE(:,1),AGE(:,2),'LineWidth',4)
clf
set(axes,'YDir', 'reverse')
hold on
plot(AGE(:,1),AGE(:,2),'LineWidth',4)
ylabel('Depth (m)')
xlabel('Age (ka)')

%% Ds0p5
DEAPTH = Taylor.getDeapth(to, SAVE, IN(1).tsize, AGE);
[e1,e2,e3] = Taylor.reshapeEIG(EIG);
e3 = cell2mat(e3);
e3 = reshape(e3,12,[]);
e3 = e3';
e1 = cell2mat(e1);
e1 = reshape(e1,12,[]);
e1 = e1';
e2 = cell2mat(e2);
e2 = reshape(e2,12,[]);
e2 = e2';

stress11 = [IN(1).stress(1,1,1),SET{1}.stress(1,1,1)];
stress22 = [IN(1).stress(2,2,1),SET{1}.stress(2,2,1)];
stress33 = [IN(1).stress(3,3,1),SET{1}.stress(3,3,1)];
deapth = [DEAPTH(1), DEAPTH(end)];

plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
clf
set(axes,'Xdir','reverse','YDir', 'reverse')
hold on
plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
xlabel('Stress (Pa)')
ylabel('Depth (m)')
legend('\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')

%% Ds0p5EigWhole
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Depth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
%% Ds0p5Eig
axis([0,1,90,180])
%% Ds0p5e3
plot(e3, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3, DEAPTH, 'o')
ylabel('Depth (m)')
xlabel('Eigenvalue')
%% Ds0p5e1e2
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
ylabel('Depth (m)')
xlabel('Eigenvalue')

%% Ds0p1
clear all, close all
load +Taylor/Results/ds0p10.mat
load +Taylor/Results/TAYLOR.mat

stress11 = [IN(1).stress(1,1,1),SET{1}.stress(1,1,1)];
stress22 = [IN(1).stress(2,2,1),SET{1}.stress(2,2,1)];
stress33 = [IN(1).stress(3,3,1),SET{1}.stress(3,3,1)];
deapth = [DEAPTH(1), DEAPTH(end)];

plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
clf
set(axes,'Xdir','reverse','YDir', 'reverse')
hold on
plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
xlabel('Stress (Pa)')
ylabel('Depth (m)')
axis([-10e5,-2e5,90,150])
legend('\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')

%% Ds0p1EigWhole
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Depth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
%% Ds0p1Eig
axis([0,1,90,180])
%% Ds0p1e3
plot(e3, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3, DEAPTH, 'o')
ylabel('Depth (m)')
xlabel('Eigenvalue')
%% Ds0p1e1e2
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
ylabel('Depth (m)')
xlabel('Eigenvalue')

