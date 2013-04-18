function [ cdist ] = rotate3( cdist, SET, elem )
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
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1} X

%     % crystal latice rotation
%     Os = repmat(Od,[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
    % rotate crystals without BCs
    for ii = 1:SET.numbcrys
        [~,Y] = ode45(@(t,y) Thor.Utilities.rotateODE(-Op(:,:,ii),y),[0,SET.tstep(elem)],N(ii,:)');
        N(ii,:) = Y(end,:);
    end

    % apply boundry condition with eigenvectors (rotate crystals such that
    % the distribution will have the desired priniple axis PAXO) 
        % set desired principle axis as verticle
        PAX0 = [0;0;1];
        % get eigenvectors and then principle axis from our no BCs rotated
        % crystal distribution
        [V1,D1] = eig(N'*N); [~,I1] = max(sum(D1));
        PAX1 = V1(:,I1); if (PAX1(3) < 0); PAX1 = -PAX1; end;
        % get rotation axis and angle 
        RAX = cross(PAX1,PAX0); RAX = RAX/norm(RAX);
        RAN = atan2(norm(cross(PAX1,PAX0)),dot(PAX1,PAX0));
        % make the rotation matrix
        RMA = (1-cos(RAN))*(RAX*RAX') + cos(RAN)*eye(3) + sin(RAN)*[      0,-RAX(3), RAX(2);...
                                                                     RAX(3),      0, RAX(1);...
                                                                    -RAX(2), RAX(1),      0];

    % bulk rotation of crystals (BC)
    j = 1:3;
    N = squeeze(sum(repmat(RMA,[1,1,SET.numbcrys]).*reshape(N(:,j(ones(3,1),:))',3,3,[]),2))';
    
    % make sure N is a unit vector
    N = N'./repmat(sqrt(N(:,1)'.^2+N(:,2)'.^2+N(:,3)'.^2),[3,1]); % -
    
    % get new angles
    HXY = sqrt(N(1,:).^2+N(2,:).^2);
    cdist.theta = atan2(HXY,N(3,:))';
    cdist.phi   = atan2(N(2,:),N(1,:))';
    
    % check bounds
    cdist = Thor.Utilities.bound(cdist);
    
end
