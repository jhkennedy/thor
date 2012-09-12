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
    
    % single crystal plastic rotation rate
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1} X

%     % crystal latice rotation
%     Os = repmat(Od,[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
    % initialize temp. crystal arrays
    Ntmp = N*0;
    
    % rotate crystals without BCs
    for ii = 1:SET.numbcrys
        Ntmp(ii,:) = expm(SET.tstep(elem)*-Op(:,:,ii))*N(ii,:)';
            % can't vectorize this. expm is generator of finite rotations from
            % infintesimal rotation Os
    end

    % apply boundry condition with eigenvectors
        % get eigenvectors of the distribuions
%         [~,~,V0] = svd(N);
        [~,~,V1] = svd(Ntmp);
        % get principle axes in upper hemisphere
%         PAX0 = V0(:,1); if (PAX0(3) < 0); PAX0 = -PAX0; end;
        PAX0 = [0;0;1];
        PAX1 = V1(:,1); if (PAX1(3) < 0); PAX1 = -PAX1; end;
        % get rotation axis and angle 
        RAX = cross(PAX1,PAX0); RAX = RAX/norm(RAX);
        RAN = atan2(norm(cross(PAX1,PAX0)),dot(PAX1,PAX0));

    % bulk rotation of crystals (BC)
    for ii = 1:SET.numbcrys
        N(ii,:) = (1-cos(RAN))*dot(Ntmp(ii,:)',RAX)*RAX+cos(RAN)*Ntmp(ii,:)'+sin(RAN)*cross(RAX,Ntmp(ii,:)');
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
