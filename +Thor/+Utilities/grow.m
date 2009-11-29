function [ cdist ] = grow( cdist, SET, elem )
% [cdist]=grow( cdist, SET, elem) calculates the new crystal size of each crystal in a
% distrobution cidst for an element elem, using the settings in SET. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% grow returns a crystal distrobution with updated crystal sizes. 
%
%   See also Thor.setup

    % initialize constants
    Ko = 9.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    
    % calculate grain growth factor
    K = Ko*exp(-Q/(R*SET.T(elem)));
    
    % find the average dislocaton energy
    for ii = 1:(SET.numbcrys)
        dislEnAv = dislEnAv + cdist{ii,9}/(SET.numbcrys);
    end
    
    % grow grain
    for ii = 1:(SET.numbcrys)
        % modify grain growth by dilocation energy
        Ki = (dislEnAv - cdist{ii,9})*K;
        % calculate new crystal diameter
        cdist{ii, 7} = (Ki*SET.tsize + SET.Do^2)^(1/2);
    end
end