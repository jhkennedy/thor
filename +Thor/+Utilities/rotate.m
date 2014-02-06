function [ cdist, a ] = rotate( cdist, SET, elem )
% [cdist]=rotate(cdist, SET, elem) rotates the crystals based on the information in
% the crystal distrobution cdist based on the setting in SET. 
%
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup. 
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% rotate returns a crystal distrobution, cdist, with rotated orientation angles.
%
%   See also Thor.setup
    
    % single crystal plastic rotation rate
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1}
    
    % modeled bulk velocity gradient
    Lm = Thor.Utilities.bvel(cdist);
    
    % modeled bulk strain rate (also is bulk roation rate boundary condition)
    Em = 1/2*(Lm + Lm');
        
    % rotation rate of crystals
    Os = repmat(Em.*[0,1,1;-1,0,1;-1,-1,0],[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
    % check if any strain elements in stress
    
%     % modeled bulk rotation rate
%     Om = 1/2*(Lm + Lm');
%    
%     if( any( sum(abs(SET.stress(:,:,elem)) & [0,1,1; 1,0,1;1,1,0])) )
%         % get principle axis of crystal distrobution
%         [V,D] = eig( 1/SET.numbcrys*(N'*N) ); 
%         
%         % get eigenvalues associated with principle axis
%         EIG = sort(sum(D));
%         if (EIG(2) > (1/3) && EIG(3) < (1/3)) % girdle
%             [~,I] = min(sum(D));
%         else % single max or isotropic
%             [~,I] = max(sum(D));
%         end
%             
%         PAX = V(:,I); if (PAX(3) < 0); PAX = -PAX; end;
% 
%         % calculate rotation rate of principle axis
%         POs = Em.*[0,1,1;-1,0,1;-1,-1,0] - Om;
% 
%         % solve for isotropic enhancement factor needed to keep the principle
%         % axis vertical (BETA). This is a 1st order taylor series aproximation
%         % of [0;0;1] = expm(a*t*Pos)*PAX, solving for a.
%         B = [0;0;1] - PAX;
%         AinvB = SET.tstep(elem)*POs*B;    
%         a = PAX'*AinvB; % consided an isotropic enhancement factor
%     else
        a = 1;
%     end
    
    % rotate crystals
    for ii = 1:SET.numbcrys
        N(ii,:) = expm(a*SET.tstep(elem)*Os(:,:,ii))*N(ii,:)';
            % can't vectorize this!!! Expm is generator of finite rotations
            % from infintesimal rotation Os -- tried using taylor series
            % aprox. to 100 terms, but this still resulted in significant
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
