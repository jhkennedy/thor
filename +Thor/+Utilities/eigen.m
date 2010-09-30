function [ EIG ] = eigen( cdist, crange, N )
% [EIG]=eigen( cdist SET) calulates the orientation eigenvalues of the crystal
% distrobution cdist. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The
%   crystal distrubution structure is outlined in Thor.setup.
%   
%   crange is the range of crystals to sum over, given as crystals subscrits. A 2x3 matrix. 
%   [Imin, Imax; Jmin, Jmax; Kmin,Kmax]
%
%   N is the total number of crystals. 
%
% eigen returns EIG which is a 3x1 vector holding the orientation eigenvalues for the
% crystal distrobution. 
%
%   eigen fallows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168, 2004
%           Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup

    % initialize the orientation matrix and weight
    eigmat = zeros(3,3);
    Vt = 0;
    
    % loop through each crystal
    for I = crange(1,1):crange(1,2)
        for J = crange(2,1):crange(2,2)
            for K = crange(3,1):crange(3,2)
                ii = sub2ind(N,I,J,K);
                % get the orientation vector
                N = [sin(cdist{ii,2})*sin(cdist{ii,1}),... 
                     cos(cdist{ii,2})*sin(cdist{ii,1}),... 
                     cos(cdist{ii,1})];
                
                % calculate weights for average
                V = cell2mat(cdist(ii,7)).^3;
                Vt = Vt+V;
                % build the orientation matrix
                eigmat = eigmat + V*(N'*N);
            end
        end
    end

    EIG = eig(eigmat/Vt);

end