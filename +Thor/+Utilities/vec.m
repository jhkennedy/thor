function [ cdist] = vec( cdist, SET, elem)
% [cdist]=vec(cdist, SET, elem) calculates the velocity gradient and single
% crystal strain rate for every crystal in cdist. cdist is the crystal
% disrobution for element elem. Vec uses the settings in SET and the
% connectivity structure specified by CONN.   
%   
%   cdist is the structure holding the crystal distrobution outlined in
%   Thor.setup.   
%
%   SET is the setting structure outlined in Thor.setup.
%
%   elem is the element number that cdist is a part of.
%
% vec returns cdist with new fields for the shmidt tensors on each slip system
% (.S1, .S2, .S3 size 3x3xN) magnitude of the RSS (.MRSS size Nx1), velocity
% gradient on the crystals (.vel size 3x3xN) and the strain rate on the crystals
% (.ecdot size 3x3xN).    
%
%   See also Thor.setup


%% Initialize variables
    
    ALPHA = interp1(SET.A(1,:), SET.A(2,:),SET.T(elem,1));% s^{-1} Pa^{-n}
    BETA = 630; % from Thors 2001 paper (pg 510, above eqn 16)

    % glen exponent
    n = SET.glenexp(elem,1); % -
    
    % get the shmidt tensor and resolved shear stress, RSS, for each slip stystem
    [cdist, R1, R2, R3] = Thor.Utilities.shmidt(cdist, SET.numbcrys, SET.stress(:,:,elem));
    
    % get the softness parameter 
    [cdist, esoft] = Thor.Utilities.soft(cdist, SET.CONN, SET.xcec(1), SET.xcec(2)); 

    % calculate the rate of shearing on each slip system (size Nx1)
    G1 = ALPHA*BETA*esoft.*R1.*abs(esoft.*R1).^(n-1); % s^{-1}
    G2 = ALPHA*BETA*esoft.*R2.*abs(esoft.*R2).^(n-1); % s^{-1}
    G3 = ALPHA*BETA*esoft.*R3.*abs(esoft.*R3).^(n-1); % s^{-1}
    
    % calculate the velocity gradient (size 3x3xN)
    cdist.vel = cdist.S1.*reshape(repmat(G1',[9,1]),3,3,[])...
               +cdist.S2.*reshape(repmat(G2',[9,1]),3,3,[])... 
               +cdist.S3.*reshape(repmat(G3',[9,1]),3,3,[]); % s^{-1}
           
    % calculate the strain rate (size 3x3xN)
    cdist.ecdot = cdist.vel/2 + permute(cdist.vel,[2,1,3])/2; % s^{-1}

end

