function [ edot ] = bedot( cdist )
% edot=BEDOT(cdist) claculates the bulk strain rate for the crystal distrobution
% specified by cdist
%   cdist is a crystal distrobution is aranged in an 8000x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%
% BEDOT returns a 3x3 array holding the bulk strain rate of the crystal distrobution.
%
%   See also Thor.setup

    edot = zeros(3,3); % s^{-1}

    ODF = sum([cdist{1:8000,6}]); % -

    for ii = 1:8000
        edot = edot + cdist{ii,5}; % s^{-1}
    end

    edot = edot/ODF; % s^{-1}

end

