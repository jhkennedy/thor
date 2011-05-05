function [ cdist ] = poly( cdist, SET, elem, step )
% [cdist]=poly(cdist, SET, elem, step) polygonizes crystals favorable do so.
% 
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup.    
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
%   step is the current time step.
%
% poly returns the crystal distrobution with polygonized crystals. 
%
%   See also Thor.setup

    % physical constants
    del = 0.065; % ratio threshold -- Thor 2002 [26]
    rhop = 5.4e10; % m^{-2} dislocation density needed to form a wall -- Thor 2002 [26]
    
    % magnitude of the stress
    S = SET.stress(:,:,elem); % Pa
    Mstress = sqrt( S(1,1)*S(2,2)+S(2,2)*S(3,3)+S(3,3)*S(1,1)...
                    -(S(1,2)^2+S(2,3)^2+S(3,1)^2) ); % Pa
    
    % see if polygonize is favorable
    mask = (cdist.MRSS/Mstress < del) & (cdist.dislDens > rhop);
    
    if any(mask)
        % reduce dislocation density
        cdist.dislDens(mask) = cdist.dislDens(mask) -rhop; % m^{-2}
        % halve the crystal size
        cdist.size(mask) = cdist.size(mask)/2;
        SET.Do(mask,elem) = cdist.size(mask);
        SET.to(mask,elem) = step;
        % rotate the crystal
        task = cdist.theta < pi/6;
        % if withing 30 degrees of vertical move crystal away by 5 degrees
        cdist.theta(mask & task) = cdist.theta(mask & task) + pi/36; % -
        % else choose sign at random and then move crystal +/- 5 degrees
        rask = rand(SET.numbcrys,1) <= 0.5;
        cdist.theta(mask & ~task & rask) = cdist.theta(mask & ~task & rask) + pi/36;
        cdist.theta(mask & ~task & ~rask) = cdist.theta(mask & ~task & ~rask) - pi/36;
    else
        return
    end
end

