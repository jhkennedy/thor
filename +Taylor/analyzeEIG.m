

e1 = cell2mat(E1');
e2 = cell2mat(E2');
e3 = cell2mat(E3');

plot(DEAPTH,e1,DEAPTH,e2,DEAPTH,e3,TAYLOR(:,1),TAYLOR(:,3),'o',TAYLOR(:,1),TAYLOR(:,4),'o',TAYLOR(:,1),TAYLOR(:,5),'o');

