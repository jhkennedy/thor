function [ cdist ] = grow( cdist, SET, elem )
% [cdist]=grow( cdist, SET, elem, step) calculates the new crystal sizes of
% cidst for an element elem, using the settings in SET.   
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% grow returns a crystal distrobution with updated crystal sizes. 
%
%   See also Thor.setup

    % Physical constants
    Ko = 8.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    
    % claculate the grain growth factor
    K  = Ko*exp(-Q/(R*(273.13+SET.T(elem)) ) ); % m^2 s^{-1}
    
    % calculate new crystal diameter
    cdist.size = sqrt(K*(SET.ti(elem)-SET.to(:,elem)) + SET.Do(:,elem).^2);
    
end
