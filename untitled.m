ls +Taylor/Results/
load +Taylor/Results/TAYLOR.mat
plot(TAYLOR(:,1),TAYLOR(:,3),'o',TAYLOR(:,1),TAYLOR(:,4),'o',TAYLOR(:,1),TAYLOR(:,5),'o')
plot(TAYLOR(:,3),TAYLOR(:,1),'o',TAYLOR(:,4),TAYLOR(:,1),'o',TAYLOR(:,5),TAYLOR(:,1),'o')
set(axes,'XDir','default', 'YDir', 'reverse')
plot(TAYLOR(:,3),TAYLOR(:,1),'o',TAYLOR(:,4),TAYLOR(:,1),'o',TAYLOR(:,5),TAYLOR(:,1),'o')
set('YDir', 'reverse')
set(axis,'YDir', 'reverse')
set(axes,'YDir', 'reverse')
plot(TAYLOR(:,3),TAYLOR(:,1),'o',TAYLOR(:,4),TAYLOR(:,1),'o',TAYLOR(:,5),TAYLOR(:,1),'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(TAYLOR(:,3),TAYLOR(:,1),'o',TAYLOR(:,4),TAYLOR(:,1),'o',TAYLOR(:,5),TAYLOR(:,1),'o')
xlabel('Eigenvalue')
ylabel('Depth')
legend('S_z, S_y, S_z','Position','SouthOutside','Orientation','Horizontal')
legend('S_z', 'S_y', 'S_z','Position','SouthOutside','Orientation','Horizontal')
legend('S_z', 'S_y', 'S_x','Location','SouthOutside','Orientation','Horizontal')
legend('S_z', 'S_y', 'S_x','Location','NorthOutside','Orientation','Horizontal')
figure, plot([-43,-23], [0,600])
clf
set(axes,'YDir', 'reverse')
hold on
plot([-43,-23], [0,600],'LineWidth',2)
plot([-43,-23], [0,600],'LineWidth',3)
plot([-43,-23], [0,600],'LineWidth',5)
plot([-43,-23], [0,600],'LineWidth',4)
xlabel('Temperature, (^oC)')
ylabel('Deapth (m)')
xlabel('Temperature (^oC)')
close all, clear all
ls +Taylor/Results/
load +Taylor/Results/ds0p50.mat
edit +Taylor/getSoft.m
DEAPTH = Taylor.getDeapth(to, SAVE, IN(1).tsize, AGE);
DEAPTH
IN(1).stress
IN(1).stress(:,:,1)
SET{1}.stress(:,:,1)
stress11 = [IN(1).stress(1,1,1),SET{1}.stress(1,1,1)]
stress22 = [IN(1).stress(2,2,1),SET{1}.stress(2,2,1)]
stress33 = [IN(1).stress(3,3,1),SET{1}.stress(3,3,1)]
deapth = [DEAPTH(1), DEAPTH(end)]
plot(deapth, stress11, deapth, stress22, deapth, stress33,)
plot(deapth, stress11, deapth, stress22, deapth, stress33)
plot(deapth, stress11, 'b', deapth, stress22, 'b', deapth, stress33)
plot(deapth, stress11, 'b', deapth, stress22, 'b', deapth, stress33, 'r')
plot(deapth, stress11, 'b', deapth, stress22, 'b', deapth, stress33, 'r', 'LineWidth', 4)
plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
clf
set(axes,'YDir', 'reverse')
hold on
plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
clf
set(axes,'Xdir','reverse','YDir', 'reverse')
hold on
plot(stress11, deapth, 'b', stress22, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
xlabel('Stress (Pa)')
ylabel('Deapth (m)')
legend('\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
plot(stress11, deapth, 'b', stress11+0.1*stress11, deapth, 'b', stress11+0.1*stress11, deapth, 'r', 'LineWidth', 4)
plot(stress33-0.1*stress33, deapth, 'b', stress33-0.1*stress33, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
clf
hold on
plot(stress33-0.1*stress33, deapth, 'b', stress33-0.1*stress33, deapth, 'b', stress33, deapth, 'r', 'LineWidth', 4)
xlabel('Stress (Pa)')
ylabel('Deapth (m)')
legend('\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
clf
hold on
[e1,e2,e2] = reshapeEIG(EIG)
EIG
[e1,e2,e2] = Taylor.reshapeEIG(EIG)
e1 = cell2mat(e1)
e1 = reshape(e1,12,[])
e1 = e1'
e2 = cell2mat(e2)
e2 = reshape(e2,12,[])
e2 = e2'
e3 = cell2mat(e3)
e3 = reshape(e3,12,[])
e3 = e3'
[e1,e2,e3] = Taylor.reshapeEIG(EIG)
e3 = cell2mat(e3)
e3 = reshape(e3,12,[])
e3 = e3'
e1 = cell2mat(e1)
e1 = reshape(e1,12,[])
e1 = e1'
e2 = cell2mat(e2)
e2 = reshape(e2,12,[])
e2 = e2'
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH)
clf
set(axes,'YDir', 'reverse')
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH)
load +Taylor/Results/TAYLOR.mat
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH, TAYLOR(:,1)', TAYLOR(:,3:5))
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH, TAYLOR(:,3), TAYLOR(:,1), TAYLOR(:,4), TAYLOR(:,1), TAYLOR(:,5), TAYLOR(:,1))
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'o',TAYLOR(:,4),  TAYLOR(:,1), 'o', TAYLOR(:,5), TAYLOR(:,1),'o')
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
plot(e1(1,:), DEAPTH, e2(1,:), DEAPTH, e3(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,150])
axis([0,1,90,180])
clear all, close all
load +Taylor/Results/ds0p10.mat
e1
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
load +Taylor/Results/TAYLOR.mat
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
clf
set(axes,'YDir', 'reverse')
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or','LineWidth',4)
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
plot(e1, DEAPTH)
plot(e1, DEAPTH, e2, DEAPTH, e3, DEAPTH)
plot(e1, DEAPTH, e2, DEAPTH)
plot(e1, DEAPTH, e2, DEAPTH, 'o')
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
plot(e3, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3, DEAPTH, 'o')
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,0,600])
clear all
load +Taylor/Results/ds0p50.mat
[e1,e2,e3] = Taylor.reshapeEIG(EIG)
e3 = cell2mat(e3)
e3 = reshape(e3,12,[])
e3 = e3'
e1 = cell2mat(e1)
e1 = reshape(e1,12,[])
e1 = e1'
e2 = cell2mat(e2)
e2 = reshape(e2,12,[])
e2 = e2'
load +Taylor/Results/TAYLOR.mat
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
DEAPTH = Taylor.getDeapth(to, SAVE, IN(1).tsize, AGE);
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
clf
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,0,600])
plot(e3(1,:), DEAPTH, e2(1,:), DEAPTH, e1(1,:), DEAPTH, TAYLOR(:,3), TAYLOR(:,1), 'ob',TAYLOR(:,4),  TAYLOR(:,1), 'og', TAYLOR(:,5), TAYLOR(:,1),'or')
xlabel('Eigenvalue')
ylabel('Deapth (m)')
legend('\sigma_{11}^M', '\sigma_{22}^M', '\sigma_{33}^M','\sigma_{11}', '\sigma_{22}', '\sigma_{33}','Location','NorthOutside','Orientation','Horizontal')
axis([0,1,90,180])
plot(e3, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e3, DEAPTH, 'o')
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
clf
set(axes,'YDir', 'reverse')
hold on
plot(e1, DEAPTH, 'o', e2, DEAPTH, 'o')
ylabel('Depth (m)')
xlabel('Eigenvalue')

