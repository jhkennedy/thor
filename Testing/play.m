load ./+Thor/+Build/initial.mat

% cube length width hight array
cube = [in.width, in.width, in.width];
% initialize connectivity structure
CONN = nan(in.numbcrys,12);

% get cubic connectivity, 6 nearest neighbors
    % get indices for crystals
    [I,J,K] = ind2sub(cube,1:in.numbcrys);
    % get the top, bottom, left, right, back, front indices 1xNUMBCRYS*6
    cons = [I-1, I+1,   I,   I,   I,   I;...
              J,   J, J-1, J+1,   J,   J;...
              K,   K,   K,   K, K-1, K+1 ];
    % mask any unvalid indexes
    mask = [I-1, I+1, J-1, J+1,  K-1, K+1 ];
    mask = mask<1 | mask>in.width;
    % get valid index numbers on the conecting crystals
    ind = sub2ind(cube, cons(1,~mask)', cons(2,~mask)', cons(3,~mask)');
    % set connectivity matrix
    CONN(~mask) = ind;