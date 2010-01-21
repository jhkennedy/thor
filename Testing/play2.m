 nn = 20;
 ncube = [nn,nn,nn];
 numbcrys = prod(ncube);

CONN = nan*ones(numbcrys,6);
for ii = 1:numbcrys
    % get index for current crystal
    [I J K] = ind2sub(ncube,ii);
    % get the top-bottom-left-right-back-front indexes
    cons = [I-1, J, K; I+1, J, K; I, J-1, K; I, J+1, K; I, J, K-1; I, J, K+1];
    % try to get linear indecies
    for jj = 1:6
        cjj = cons(jj,:);
        try
            CONN(ii,jj) = sub2ind(ncube,cjj(1),cjj(2),cjj(3));
        catch % ME %#ok<NASGU>
            % subscrypt was outside of array. This will hapen at all
            % corners and walls. Will leave value as NaN.
        end
    end
 end