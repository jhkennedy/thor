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
    kappa = 0.1; 
      % adjustible parameter -- Thor2002 eqn. 19 -- value set [38] 
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
      % log(1./(sqrt(cdist.dislDens).*b)) is equal to about 10. Removing the
      % log term you would end up with 9.63 J m^{-3} which is actually much
      % less than 48.75 J m^{-3}. So, keeping the log term in the equation,
      % you should use kappa = 0.035. Or, drop the log term out of the Edis
      % equation (line 76) and keep kappa at 0.35. For computational
      % efficiency, I am going to drop the log term. It can be added in by
      % coppying it from above. Also, Mohamed2000 states that the log term
      % can be a constant. Note: LOG is natural log in MATLAB. 
      %
      % Update 12/2/13 -- seems to be having too much MigRe so adujusting
      % Kappa to 0.1!
    
    G = 3.4e9; % Pa
    b = 4.5e-10; % m
    % find the average dislocation energy
    Edis = kappa.*G.*cdist.dislDens.*b.^2; % J m^{-3}

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