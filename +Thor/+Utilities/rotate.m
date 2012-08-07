function [ cdist ] = rotate( cdist, SET, elem )
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

    % get bulk rotation
        % get bulk strain rate for rotation boundry condition
        edot = Thor.Utilities.bedot( cdist ); % X
        
        % get bulk strain boundry condition mask (bulk same should only be in same places as deviatoric stress)
        MSK = (SET.stress(:,:,elem)~= 0).*[0,1,1;-1,0,1;-1,-1,0];
        
        % get the boundry condition enhancement 
        ENH = 1 + sum(sum(abs(edot(MSK+eye(3) == 0))))/sum(sum(abs(edot(MSK ~= 0))));
        if ENH < 1.001; ENH = 1; end
        if ENH > 5; ENH = 5; end
        
        % bulk rotation rate boundry condition
        Od = ENH*edot.*MSK; % s^{-1} 
        
    
    % single crystal plastic rotation rate
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1} X

    % crystal latice rotation
    Os = repmat(Od,[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
    % get new C-axis orientation
    for ii = 1:SET.numbcrys
        N(ii,:) = expm(SET.tstep(elem)*Os(:,:,ii))*N(ii,:)';
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
