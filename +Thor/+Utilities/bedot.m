function [ edot ] = bedot( cdist, SET )
% edot=BEDOT(cdist) claculates the bulk strain rate for the crystal distrobution
% specified by cdist
%   cdist is a crystal distrobution is aranged in an SET.NUMBCRYSx10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% BEDOT returns a 3x3 array holding the bulk strain rate of the crystal distrobution.
%
%   See also Thor.setup

    edot = zeros(3,3); % s^{-1}

    ODF = sum([cdist{1:SET.numbcrys,6}]); % -

    for ii = 1:SET.numbcrys
        edot = edot + cdist{ii,5}; % s^{-1}
    end

    edot = edot/ODF; % s^{-1}

end

