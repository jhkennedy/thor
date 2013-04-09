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
    % Thor2002 sets this at 0.35, which aligns with paper he cites 
    %(>0.1; Mohamed2000 -- a paper based on cold rolling copper to .35 strain),
    % however, this does not give the correct results -- it will cause an
    % undeform crystal with the minimum dislocation density to
    % recrystallize. From Thors paper, he initially starts the crystals
    % with:
        % dislDens: 4e10 % m^{-2}
        % size:     4 mm
    % which gives:
        % Egb  = 48.75 J m^{-3}
        % Edis = 89.79 J m^{-3}
    % then in paragraph [38] he states " initially..., so Edis is very
    % small relative to the grain boundary energy." Which is not at all the
    % case using his equations. 
    %
    % It looks like kappa should include the log term as well --
    % log(1./(sqrt(cdist.dislDens).*b)  is equal to about 10. Removing the
    % log term you would end up with 9.63 J m^{-3} which is actually much
    % less than 48.75 J m^{-3}. So, keeping the log term in the equation,
    % you should use kappa = 0.035. Or, drop the log term out of the Edis
    % equation (line 76) and keep kappa at 0.35. For computational
    % efficiency, I am going to drop the log term. It can be added in by
    % coppying it from above. Also, Mohamed2000 states that the log term
    % can be a constant. Note: LOG is natural log in MATLAB. 
    
    G = 3.4e9; % Pa
    b = 4.5e-10; % m
    % find the average dislocation energy
    Edis = kappa.*G.*cdist.dislDens.*b.^2; % J m^{-3}
    
    % find a soft orientation
    theta = cdist.theta(cdist.MRSS == max(cdist.MRSS)); theta = theta(1);

     % store mask of which crystals have recrystalized
     mask = false(size(cdist.size));
    
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
            cdist.dislDens(CONN{ii}) = cdist.dislDens(CONN{ii}) - rhoDotStrain(ii);
            
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