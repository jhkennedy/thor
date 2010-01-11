function [ cdist ] = migre( cdist, SET, elem )
% [cdist]=migre(cdist,SET,elem) recrystalizes crystals that are favorable to do so. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% migre returns a crystal distrobution, cdist, with recrystalized crystals that were
% favorable to do so. 
%
%   See also Thor.setup

    % only active above 12 degrees celsius
    if SET.T(elem)>(-12)

    % new crystal dislocation density
    rhoo = 1e10; % m^{-2} 
    % effectice stress
    s = SET.stress(:,:,elem); % Pa
    es = (s(1,1)^2+s(2,2)^2+s(3,3)^2+2*s(1,2)^2+2*s(1,3)^2+2*s(2,3)^2)^(1/2); % Pa
    % new crystal size
    pc = 1; % Pa^{4/3} m
    D = pc*es^(-4/3); % m
    % initialize RSS check vector
    RSS = zeros(100,1); % Pa
       
        for ii = 1:SET.numbcrys
           
            % get grain boundry energy
            Egb = Thor.Utilities.gbEn(cdist{ii,7}); % J  m^{-3}
            % check to see if it energetically favorable to recrystalize
            if cdist{ii,9}>Egb
                % set new crystals dislocation density
                cdist{ii,8} = rhoo; % m^{-2}
                % set new crystal size
                cdist{ii,7} = D; % m
                % get a set of new crystal angle
                THETA = (pi/2)*rand(100,1); % -
                PHI = (2*pi)*rand(100,1); % -
                % get magnitude of the rss for each new crystal
                for jj = 1:100
                   S123 = Thor.Utilities.shmidt(THETA(jj,1),PHI(jj,1)); % -
                   rss = Thor.Utilities.rss(S123,s); % Pa
                   
                   % basal plane vectors for the crystal
                   B(1,:)  =  1/3*[cos(THETA(jj)).*cos(PHI(jj)) cos(THETA(jj)).*sin(PHI(jj)) -sin(THETA(jj))]; % -
                   B(2,:)  = -1/6*[(cos(THETA(jj)).*cos(PHI(jj)) + 3^(.5)*sin(PHI(jj)))...
                              (cos(THETA(jj)).*sin(PHI(jj)) - 3^(.5)*cos(PHI(jj))) -sin(THETA(jj))]; % -
                   B(3,:)  = -1/6*[(cos(THETA(jj)).*cos(PHI(jj)) - 3^(.5)*sin(PHI(jj)))...
                              (cos(THETA(jj)).*sin(PHI(jj)) + 3^(.5)*cos(PHI(jj))) -sin(THETA(jj))]; % -
                   
                   RSS(jj) = norm(B(1,:)*rss(1,1)+B(2,:)*rss(1,2)+B(3,:)*rss(1,3)); % Pa
                end
                % set new crystal angles
                cdist{ii,1}= THETA(RSS==max(RSS)); % -
                cdist{ii,2}= PHI(RSS==max(RSS)); % -
            end
        end
    end
end