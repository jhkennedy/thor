function [ cdist, SET, nMigRe ] = migre( cdist, SET, elem, eigMask )
% [cdist]=migre(cdist,SET,elem, eigMask) recrystalizes crystals that are
% favorable to do so.
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
    Egb = 3*Ggb./cdist.size;

    % calculate the dislocation energy
    kappa = 0.035; % adjustible parameter -- Thor2002 eqn. 19 -- value set [38] !wrong! should be 1/10 what is in paper
    G = 3.4e9; % Pa
    b = 4.5e-10; % m
    % find the average dislocation energy
    Edis = kappa.*G.*cdist.dislDens.*b.^2.*log(1./( sqrt(cdist.dislDens).*b) ); % J m^{-3}

    % check to see if it energetically favorable to recrystalize
    mask = Edis > Egb;
    
    % number of polygonization events in each layer
    nMigRe = zeros(1,size(eigMask,2));
    for ii = 1:size(eigMask,2)
        nMigRe(1,ii) = sum(mask & eigMask(:,ii));
    end
    
    if any(mask)
        % set new dislocation densities
        cdist.dislDens(mask) = rhoo; % m^{-2}
        % set new crystal size
        cdist.size(mask) = cdist.size(mask)*0+D;
        SET.Do(mask,elem) = cdist.size(mask);
        SET.to(mask,elem) = SET.ti(elem);

        % find a soft orientation
        theta = cdist.theta(cdist.MRSS == max(cdist.MRSS)); theta = theta(1);

        % set new theta randomly within +- 10 degrees of soft orientation
        cdist.theta(mask) = theta +(-1+2*rand( size(cdist.theta(mask)) ) )*0.02;
        % set random phi angle (assumes max MRSS symetric about vertical)
        cdist.phi(mask) = 2*pi*rand( size(cdist.phi(mask)) );
    else
        return
    end
end   