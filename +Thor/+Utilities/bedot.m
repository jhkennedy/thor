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


    ODF = sum([cdist{1:SET.numbcrys,6}]); % -
    
    temp = reshape([cdist{1:SET.numbcrys,5}],9,[]);
    todf = [cdist{1:SET.numbcrys,6}];
    todf = repmat(todf,9,1);
    temp = temp.*todf;
    temp = sum(temp,2);
    edot = reshape(temp,3,3); % s^{-1}
   
    edot = edot/ODF; % s^{-1}
end