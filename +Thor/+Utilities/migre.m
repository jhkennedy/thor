function [ cdist ] = migre( cdist, SET, elem )
%MIGRE Summary of this function goes here
%   Detailed explanation goes here

    % new crystal dislocation density
    rhoo = 1e10; % m^{-2} 
    % effectice stress
    s = SET.stress(:,:,elem);
    es = (s(1,1)^2+s(2,2)^2+s(3,3)^2+2*s(1,2)^2+2*s(1,3)^2+2*s(2,3)^2)^(1/2);
    % new crystal size
    D = es^(-4/3);
    % initialize RSS check vector
    RSS = zeros(100,1);
    
    % only active above 12 degrees celsius
    if SET.T(elem)>(-12)
       
        for ii = 1:SET.numbcrys
           
            % get grain boundry energy
            Egb = Thor.Utilities.gbEn(cdist(ii,7));
            % check to see if it energetically favorable to recrystalize
            if cdist{ii,9}>Egb
                % set new crystals dislocation density
                cdist{ii,8} = rhoo;
                % set new crystal size
                cdist{ii,7} = D;
                % get a set of new crystal angle
                THETA = (pi/2)*rand(100,1);
                PHI = (2*pi)*rand(100,1);
                % get magnitude of the rss for each new crystal
                for jj = 1:100
                   S123 = Thor.Utilities.shmidt(THETA(jj,1),PHI(jj,1));
                   rss = Thor.Utilities.shmidt(S123,s);
                   
                   % basal plane vectors for the crystal
                   B(1,:)  =  1/3*[cos(THETA(jj)).*cos(PHI(jj)) cos(THETA(jj)).*sin(PHI(jj)) -sin(THETA(jj))];  
                   B(2,:)  = -1/6*[(cos(THETA(jj)).*cos(PHI(jj)) + 3^(.5)*sin(PHI(jj)))...
                              (cos(THETA(jj)).*sin(PHI(jj)) - 3^(.5)*cos(PHI(jj))) -sin(THETA(jj))];
                   B(3,:)  = -1/6*[(cos(THETA(jj)).*cos(PHI(jj)) - 3^(.5)*sin(PHI(jj)))...
                              (cos(THETA(jj)).*sin(PHI(jj)) + 3^(.5)*cos(PHI(jj))) -sin(THETA(jj))];
                   
                   RSS(jj) = norm(B(1,:)*rss(1,1)+B(2,:)*rss(1,2)+B(3,:)*rss(1,3));
                end
                % set new crystal angles
                cdist{ii,1}= THETA(RSS==max(RSS));
                cdist{ii,2}= PHI(RSS==max(RSS));
            end
        end
    end
end

