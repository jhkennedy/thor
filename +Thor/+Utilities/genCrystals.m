function Crystals = genCrystals(angles, method)
%% genCrystals -- generates a distrobution of crystals
%   
%   genCrystals(angles, method) generates crystal angles between the 
%   colatitudinal angles by the vector 'angles' according to the 
%   distribution specified in 'method'.
%   
%   'angles' should be a 1x2 vector with colatitudinal angles [ Ao A ]
%       where 'Ao' is the girdle angle and 'A' is the cone angle, or  
%       [0 2*pi] for logitudinal angles.
%   'method' should be a character array with values of either:
%       'iso'. (room to expand)
%
%   genCrystals returns an array of size 20x20x20 with each array spot
%   containing a angle between specified colaitudinal or logitudinal
%   angles.

    % initialize the crystal array
    Crystals = zeros(20,20,20);

    % find which method
    switch method
        case 'iso'
            % generate randomly spaced crystals over the range of 'angles'
            Crystals = angles(1) + (angles(2)-angles(1))*rand(20,20,20);
            return;

    end