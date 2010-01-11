function [ cdist ] = rotate( cdist, SET )
% [cdist]=rotate(cdist, SET) rotates the crystals based on the information in the crystal
% distrobution cdist based on the setting in SET.
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% rotate returns a crystal distrobution, cdist, with rotated orientation angles.
%
%   See also Thor.setup


    Od = 0; % s^{-1} bulk rotation rate boundry condition

    % modeled velocity gradient
    Lm = Thor.Utilities.bvel(cdist); % s^{-1}
    % modeled rotation rate
    Om = (1/2)*(Lm - Lm'); % s^{-1}
    % bulk roation 
    Ob = Od + Om; % s^{-1}
    
    for ii = 1:SET.numbcrys
        % single crystal plastic rotation rate
        Op = (1/2)*(cdist{ii,4} - cdist{ii,4}'); % s^{-1}
        % crystal lattice rotation
        Os = Ob - Op; % s^{-1}
        % C-axis orientation
        N   = [sin(cdist{ii,1}).*cos(cdist{ii,2}) sin(cdist{ii,1}).*sin(cdist{ii,2}) cos(cdist{ii,1})]; % -
        % rate of change in orientation
        % ndot = Os*N'; % s^{-1}
        % new orientation vector
        % N = N'+(ndot*SET.tsize/(ndot(1)^2+ndot(2)^2+ndot(3)^2)^(1/2)); % - 
        N = expm(SET.tsize*Os)*N';
        % new angles
%         THETA = acos(N(3)/(N(1)^2+N(2)^2+N(3)^2)); % -
        N = N/(N(1)^2+N(2)^2+N(3)^2)^(1/2);
        PHI = atan2( N(2),N(1) ); % -
        THETA = atan( (N(2)^2 + N(1)^2)^(1/2) / N(3) ); % -
%         PHI = atan( N(2)/N(1) ); % -
        % check boundry conditions
        if THETA>pi/2
            THETA = pi - THETA; % -
            PHI = PHI + pi;
        elseif THETA<0;
            THETA = abs(THETA);
            PHI = PHI + pi;
        end
        PHI = rem(PHI+2*pi, 2*pi); 
        % set new angles
        cdist{ii,1}= THETA; % -
        cdist{ii,2}= PHI; % -
    end
end

