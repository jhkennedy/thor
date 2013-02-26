function [cdist, SET, nMigRe] = migReRelax(cdist, SET, elem, eigMask, rhoDotStrain)
% [cdist]=migReRelax(cdist,SET,elem, eigMask) recrystalizes crystals that
% are favorable to do so and relaxes the strain on the surrounding crystals
% by reducing the number of dislocation within the neighbooring crystals. 
%
%   cdist is the structure holding the crystal distrobution of N crystals
%   as outlined in Thor.setup.  
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
%   eigenMask is a NxM logical array where eigenMask(:,m) is the mth layer
%   in of the crystal distrobution. 
%
% migre returns: a crystal distrobution, cdist, with recrystalized crystals
% that were favorable to do so; the setting structure, SET, and nMigRe, an
% 1xM array holding the number of recrystalization events in each layer
% specified by eigMask.
%
%   See also Thor.setup


% Dislocation Density Reduction for neighbooring crystals -- basically
% reduce crystals dislocation density by the amount gained from 

    % load connectivity matrix
    CONN = [];
    load(['+Thor/+Build/Settings/CONN/' SET.CONN]);

    % Effective stress
    S = SET.stress(:,:,elem); % Pa
    Estress = sqrt( sum(sum(S.*S))/2 ); % Pa
        % Thor2002 page 3-4 paragraph [29]

    % new crystal dislocation density
    rhoo = 1e10; % m^{-2} 
    % new crystal size
    pc = 1; % Pa^{4/3} m -- perportionality constant [Shimizu 2008]
    D = pc*Estress^(-4/3); % m

    % calculate the grain boundary energy
    Ggb = 0.065; % J m^{-2}
    Egb = 3*Ggb./cdist.size;  % J m^{-3}

    % calculate the dislocation energy
    kappa = 0.35; % adjustible parameter -- Thor2002 eqn. 19 -- value set [38] 
    % had this note: "wrong! should be 1/10 what is in paper"
    % not sure why now... doesn't appear to be so upon review... need to
    % check
    
    G = 3.4e9; % Pa
    b = 4.5e-10; % m
    % find the average dislocation energy
    Edis = kappa.*G.*cdist.dislDens.*b.^2.*log(1./( sqrt(cdist.dislDens).*b) ); % J m^{-3}
    
    % find a soft orientation
    theta = cdist.theta(cdist.MRSS == max(cdist.MRSS)); theta = theta(1);

     % store mask of which crystals have recrystalized
     mask = false(size(cidst.size));
    
    % randomly step through crystal distrobution and recrystalize all
    % favorable crystals
    for ii = randperm(SET.numbcrys);
        % check to see if favorable to recrystalize
        if Edis(ii) > Egb(ii)
            % set recrystalization in mask
            mask(ii) = true;
            
            % set new dislocation density of crystal
            cdist.dislDens(ii) = rhoo; % m^{-2}
            % set new crystal size
            cdist.size(ii) = D;
            SET.Do(ii) = D;
            % set time of last recrystalization
            SET.to(ii,elem) = SET.ti(elem);
            
            % reduce dislocation density for neighboring crystals
            cdist.dislDens(CONN{ii}) = cdist.dislDens(CONN{ii}) - rhoDotStrain;
            
            % set new theta randomly within +- 10 degrees of soft orientation
            cdist.theta(ii) = theta +(-1+2*rand )*0.02;
            % set random phi angle (assumes max MRSS symetric about vertical)
            cdist.phi(ii) = 2*pi*rand;
        
        end
        
    end
    
    % number of polygonization events in each layer
    nMigRe = zeros(1,size(eigMask,2));
    for ii = 1:size(eigMask,2)
        nMigRe(1,ii) = sum(mask & eigMask(:,ii));
    end

end