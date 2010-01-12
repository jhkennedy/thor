function [Lamdas] = posterEigen(THETA, PHI)
    
    A = zeros(3,3);
    for ii = 1:size(THETA,1)
        s = [sin(THETA(ii))*sin(PHI(ii)), cos(THETA(ii))*sin(PHI(ii)), cos(PHI(ii))];
        A = A+s'*s;
    end
    Lamdas = eig(A);
    Lamdas = Lamdas./size(THETA,1);

end