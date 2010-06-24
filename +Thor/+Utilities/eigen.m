function [ EIG ] = eigen( cdist, SET )
% [EIG]=eigen( cdist SET) calulates the orientation eigenvalues of the crystal
% distrobution cdist. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The
%   crystal distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% eigen returns EIG which is a 3x1 vector holding the orientation eigenvalues for the
% crystal distrobution. 
%
%   eigen fallows the method as outlined in 
%       Gagliardini, Durand, and Wang. Journal of Glaciology, Vol. 50, No. 168, 2004
%           Grain Area as a statistical weight for polycrystal constituents
%
% see also Thor.setup

    % initialize the orientation matrix
    eigmat = zeros(3,3);

    % calculate weights for average
    V = cell2mat(cdist(:,7)).^3;
    V = V/sum(V);
    
    % loop through each crystal
    for ii = 1:SET.numbcrys
        % get the orientation vector
        N = [sin(cdist{ii,2})*sin(cdist{ii,1}),... 
             cos(cdist{ii,2})*sin(cdist{ii,1}),... 
             cos(cdist{ii,1})];
        % build the orientation matrix
        eigmat = eigmat + V(ii)*(N'*N);
    end

    EIG = eig(eigmat);

end