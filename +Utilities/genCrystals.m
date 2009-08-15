function Crystals = genCrystals(number, angles, method)
% genCrystals -- generates a distrobution of crystals
%   
%   genCrystals(number, angles, method) generates the amount of crstals
%   specified by the scalar 'number' between the colatitudinal angles
%   by the vector 'angles' according to the distribution specified in
%   'method'.
%   
%   'number' should be a scalar value and defines how many values to assign 
%       to each THETA and PHI resulting in a 'number'by'number amount of 
%       crystals.
%   'angles' should be a 1x2 vector with colatitudinal angles [ Ao A ]
%       where 'Ao' is the girdle angle and 'A' is the cone angle.
%   'method' should be a character array with values of either:
%       'even' or 'iso'. 
%
%   genCrystals returns an array of size 'number'x2 with values:
%       [ theta1 phi1
%           :     :   ]

% initialize the crystal array
Crystals = zeros(number*number,2);

% find which method
switch method
    case 'even'
        % generate evenly spaced crystals over the range of [0 2*pi] for 
        % PHI and the range of 'angles' for THETA (will look like a wagon
        % wheel)
        THETA = linspace(angles(1),angles(2), number);
        PHI = linspace(0,2*pi,number);
        for ii = 1:number
            Crystals(number*(ii-1)+1:number*ii,1) = THETA(ii);
            Crystals(number*(ii-1)+1:number*ii,2) = PHI';
        end
        return;
        
    case 'iso'
        % generate randomly spaced crystals over the range of [0 2*pi] for 
        % PHI and the range of 'angles' for THETA 
        THETA = angles(1) + (angles(2)-angles(1))*rand(1,number*number);
        PHI = rand(1,number*number)*2*pi;
        Crystals = [THETA', PHI'];
        return;
        
end