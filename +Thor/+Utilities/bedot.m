function [ edot ] = bedot( cdist )
% BEDOT(CDIST) claculates the bulk strain rate for the crystal distrobution
% specified by CDIST
%   CDIST is a 8000x5 cell aray holding the modeled crystal distrobution
%
%   BEDOT returns a 3x3 array holding the bulk strain rate of the crystal distrobution.
    edot = zeros(3,3);

    ODF = sum([cdist{1:8000,5}]);

    for ii = 1:8000
        edot = edot + cdist{ii,4};
    end

    edot = edot/ODF;

end

