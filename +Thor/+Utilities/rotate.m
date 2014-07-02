function [ cdist ] = rotate( cdist, SET, elem )
% [cdist]=rotate(cdist, SET, elem) rotates the crystals based on the
% information in the crystal distribution cdist based on the setting in
% SET.
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distribution, cdist.
%
% rotate returns a crystal distribution, cdist, with rotated orientation
% angles. 
%
%   See also Thor.setup
    
    % single crystal plastic rotation rate
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1}
    
    % modeled bulk velocity gradient
    Lm = Thor.Utilities.bvel(cdist);
    
    % modeled bulk strain rate (also is bulk rotation rate boundary condition)
    Em = 1/2*(Lm + Lm');
        
    % rotation rate of crystals
    Os = repmat(Em.*[0,1,1;-1,0,1;-1,-1,0],[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
        
    % rotate crystals
    for ii = 1:SET.numbcrys
        N(ii,:) = expm(SET.tstep(elem)*Os(:,:,ii))*N(ii,:)';
            % FIXME: can't vectorize this!?! Expm is generator of finite rotations
            % from infinitesimal rotation Os -- tried using Taylor series
            % approx. to 100 terms, but this still resulted in significant
            % errors. Can't use expmdemo3 (an eigenvalue method of calc.
            % expm) as (SET.tstep(elem)*-Op(:,:,ii)) is really poorly
            % conditioned. 
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
