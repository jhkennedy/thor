 nn = 20;
 ncube = [nn,nn,nn];
 numbcrys = prod(ncube);
 
 CONN1 = nan*ones(numbcrys,6);

[I,J,K] = ind2sub(ncube,1:numbcrys);
% I is (1 x numbcrys)
cons = cat(3,cat(1,I-1,J,K), cat(1,I+1,J,K), cat(1,I,J-1,K),cat(1,I,J+1,K),cat(1,I,J,K-1),cat(1,I,J,K+1));
% cons is (3 x numbcrys x 6)
cons1 = reshape(cons,3,6*numbcrys);
msk1 = any(cons1<1, 1);
msk2 = any(cons1>nn, 1);
msk = ~(msk1 | msk2);
cons2 = cons1(:,msk);
ind = sub2ind(ncube,cons2(1,:),cons2(2,:),cons2(3,:));

ii = repmat(1:numbcrys,[1,6]);
jj = repmat(1:6,[numbcrys,1]);
ii = ii(msk);
jj = jj(msk);
ij = sub2ind(size(CONN1),ii,jj);
CONN1(ij) = ind;