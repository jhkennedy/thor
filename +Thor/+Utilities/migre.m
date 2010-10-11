function [ cdist ] = migre( cdist, SET, elem )
% [cdist]=migre(cdist,SET,elem) recrystalizes crystals that are favorable to do so. 
%   cdist is the structure holding the crystal distrobution outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% migre returns a crystal distrobution, cdist, with recrystalized crystals that were
% favorable to do so. 
%
%   See also Thor.setup

    % only active above -12 degrees C
    if SET.T(elem) <= -12
        return
    else

        % Effective stress
        S = SET.stress(:,:,elem); % Pa
        Estress = sqrt( (S(1,1) -S(2,2))^2/2 + (S(2,2) -S(3,3))^2/2 + (S(3,3) -S(1,1))^2/2 ...
                        +3*( S(1,2)^2 + S(2,3)^2 +S(3,1)^2 ) ); % Pa

        % new crystal dislocation density
        rhoo = 1e10; % m^{-2} 
        % new crystal size
        pc = 1; % Pa^{4/3} m -- perportionality constant [Shimizu 2008]
        D = pc*Estress^(-4/3); % m

        % calculate the grain boundary energy
        Ggb = 0.0065; % J m^{-2}
        Egb = 3*Ggb./cdist.size;

        % calculate the dislocation energy
        kappa = 0.35; % adjustible parameter -- Thor2002 eqn. 19 -- value set [38]
        G = 3.4e9; % Pa
        b = 4.5e-10; % m
        % find the average dislocation energy
        Edis = kappa.*G.*cdist.dislDens.*b.^2.*log(1./( sqrt(cdist.dislDens).*b) ); % J m^{-3}

        % check to see if it energetically favorable to recrystalize
        mask = Edis > Egb;
        if any(mask)
            % set new dislocation densities
            cdist.dislDens(mask) = rhoo; % m^{-2}
            % set new crystal size
            cdist.size(mask) = cdist.size(mask)*0+D;

            % find a soft orientation
            theta = cdist.theta(cdist.MRSS == max(cdist.MRSS)); theta = theta(1);
            phi = cdist.phi(cdist.MRSS == max(cdist.MRSS)); phi = phi(1);


            % set new angles randomly within +- 10 degrees of soft orientation
            cdist.theta(mask) = theta +(-1+2*rand( size(cdist.theta(mask)) ) )*0.02;
            cdist.phi(mask) = phi +(-1+2*rand( size(cdist.phi(mask)) ) )*0.02;
        else
            return
        end
    end
end   