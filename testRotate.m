function [THETA, PHI, N] = testRotate( cdist, SET, cnumb) 

Od = 0; % s^{-1} bulk rotation rate boundry condition

    % modeled velocity gradient
    Lm = Thor.Utilities.bvel(cdist, SET); % s^{-1}
    % modeled rotation rate
    Om = (1/2)*(Lm - Lm'); % s^{-1}
    % bulk roation 
    Ob = Od + Om; % s^{-1}
    
    ii = cnumb;
    
        % single crystal plastic rotation rate
        Op = (1/2)*(cdist{ii,4} - cdist{ii,4}'); % s^{-1}
        % crystal lattice rotation
        Os = Ob - Op; % s^{-1}
        % C-axis orientation
        N   = [sin(cdist{ii,1}).*cos(cdist{ii,2}) sin(cdist{ii,1}).*sin(cdist{ii,2}) cos(cdist{ii,1})]; % -
        % new C-axis orientation
        N = expm(SET.tsize*Os)*N'; % -
        % make N a unit vector
        N = N/(N(1)^2+N(2)^2+N(3)^2)^(1/2); % -
        % new angles
        PHI = atan2( N(2),N(1) ); % -
        THETA = acos( N(3) ); % -
        % check boundry conditions
        if THETA>pi/2
            THETA = pi - THETA; % -
            PHI = PHI + pi; % -
        elseif THETA<0;
            THETA = abs(THETA); % -
            PHI = PHI + pi; % -
        end
        % make sure PHI isn't negitive
        PHI = rem(PHI+2*pi, 2*pi); % -

