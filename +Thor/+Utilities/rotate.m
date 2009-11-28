function [ cdist ] = rotate( cdist, SET )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    Od = 0; % bulk rotation rate boundry condition

    % modeled velocity gradient
    Lm = Thor.Utilities.bvel(cdist);
    % modeled rotation rate
    Om = (1/2)*(Lm - Lm');
    % bulk roation 
    Ob = Od + Om;
    
    for ii = 1:SET.numbcrys
        % single crystal plastic rotation rate
        Op = (1/2)*(cdist{ii,4} - cdist{ii,4}');
        % crystal lattice rotation
        Os = Ob - Op;
        % C-axis orientation
        N   = [sin(cdist{ii,1}).*cos(cdist{ii,2}) sin(cdist{ii,1}).*sin(cdist{ii,2}) cos(cdist{ii,1})];
        % rate of change in orientation
        ndot = Os*N;
        % new orientation vector
        N = N+ndot*SET.tsize;
        % new angles
        THETA = atan( (N(2)^2 + N(1)^2)^(1/2) / N(3) );
        PHI = atan( N(2)/N(1) );
        % check boundry conditions
        if THETA>pi/2
            THETA = pi - THETA;
        end
        % set new angles
        cdist{ii,1}= THETA;
        cdist{ii,2}= PHI;
    end
end

