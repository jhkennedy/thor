function [ cdist ] = rotate( cdist, SET )
% [cdist]=rotate(cdist, SET) rotates the crystals based on the information in the crystal
% distrobution cdist based on the setting in SET.
%   cdist is the structure holding the crystal distrobution outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
% rotate returns a crystal distrobution, cdist, with rotated orientation angles.
%
%   See also Thor.setup

    Od = 0; % s^{-1} bulk rotation rate boundry condition

    % modeled velocity gradient
    Lm = Thor.Utilities.bvel(cdist, SET); % s^{-1}

    % modeled rotation rate
    Om = (1/2)*(Lm - Lm'); % s^{-1}

    % bulk roation 
    Ob = Od + Om; % s^{-1}
    
    % single crystal plastic rotation rate
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1}

    % crystal latice rotation
    Os = repmat(Ob,[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
    % get new C-axis orientation
    for ii = 1:SET.numbcrys
        N(ii,:) = expm(SET.tstep*Os(:,:,ii))*N(ii,:)';
            % can't vectorize this. expm is generator of finite rotations from
            % infintesimal rotation Os
    end
    
    % make sure N is a unit vector
    N = N'./repmat(sqrt(N(:,1)'.^2+N(:,2)'.^2+N(:,3)'.^2),[3,1]); % -
    
    % get new angles
    HXY = sqrt(N(1,:).^2+N(2,:).^2);
    cdist.theta = atan2(HXY,N(3,:))';
    cdist.phi   = atan2(N(2,:),N(1,:))';
    
    % check bounds
    cdist = Thor.Utilities.bound(cdist);
    
end
