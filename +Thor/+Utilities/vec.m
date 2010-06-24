function [ cdist] = vec( cdist, SET, elem, CONN)
% [cdist]=vec(cdist, SET, elem, CONN) calculates the velocity gradient and single crystal
% strain rate for every crystal in cdist. cdist is the crystal disrobution for element
% elem. Vec uses the settings in SET and the connectivity structure specified by CONN.
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%
%   SET is the setting structure outlined in Thor.setup.
%
%   elem is the element number that cdist is a part of.
%
%   CONN is the conectivity structure as outlined in Thor.setup.
%
% vec returns cdist with new values for the rss, vel, ecdot, odf and shmidt for each
% crystal within the distrobution calculated from the current theta and phi values
% specified for each crystal.
%
%   See also Thor.setup


%% Initialize variables
    
    ALPHA = interp1(SET.A(1,:), SET.A(2,:),SET.T(elem,1));% s^{-1} Pa^{-n}
    BETA = 630; % from Thors 2001 paper (pg 510, above eqn 16)
    
    % initialize rate of shearing
    GAMMA = zeros(1,3); % s^{-1}

    % glen exponent
    n = SET.glenexp(elem,1); % -
    
    for ii = 1:SET.numbcrys
        % calculate the orientation distrobution function component for crystal ii
        cdist{ii,6} = sin(cdist{ii,1}); % -

        % get shmidt tensors for the slip system
        cdist{ii, 10} = Thor.Utilities.shmidt(cdist{ii,1}, cdist{ii,2}); % -

        % calculate the RSS on each slip system
        cdist{ii,3} = Thor.Utilities.rss(cdist{ii,10}, SET.stress(:,:,elem)); % Pa
        
    end
    
%% loop through each crystal in the distrobution and calc its velocity gradient and 
    for ii = 1:SET.numbcrys

        % clalculate the softness parameter
        switch SET.ynsoft
            case 'yes'
               if cdist{ii,3} == 0
                   esoft = 1;
               else
                   [cdist esoft] = Thor.Utilities.soft(cdist, CONN(ii,:), ii, SET.soft); % -
                   if esoft > 10
                      esoft = 10; 
                   end
               end
            case 'no'
                esoft = 1; % -
        end

        % calculate the rate of shearing on each slip system
        GAMMA(1,1) = ALPHA*BETA*esoft*cdist{ii,3}(1)*abs(esoft*cdist{ii,3}(1))^(n-1); % s^{-1}
        GAMMA(1,2) = ALPHA*BETA*esoft*cdist{ii,3}(2)*abs(esoft*cdist{ii,3}(2))^(n-1); % s^{-1}
        GAMMA(1,3) = ALPHA*BETA*esoft*cdist{ii,3}(3)*abs(esoft*cdist{ii,3}(3))^(n-1); % s^{-1}

        % calculate the velocity gradient of crystal ii
        cdist{ii,4} = cdist{ii,10}(:,:,1).*GAMMA(1,1) + cdist{ii,10}(:,:,2).*GAMMA(1,2) +...
                      cdist{ii,10}(:,:,3).*GAMMA(1,3); % s^{-1}

        % add the shmidt tensor to its transpose and divide by 2 (thor 2001 papar, eqn 7)
        S123(:,:,1) = (cdist{ii,10}(:,:,1) + cdist{ii,10}(:,:,1)')/2; % s^{-1}
        S123(:,:,2) = (cdist{ii,10}(:,:,2) + cdist{ii,10}(:,:,2)')/2; % s^{-1}
        S123(:,:,3) = (cdist{ii,10}(:,:,3) + cdist{ii,10}(:,:,3)')/2; % s^{-1}

        % calculate the strain rate for crystal ii
        cdist{ii,5} = (S123(:,:,1).*GAMMA(1,1) + S123(:,:,2).*GAMMA(1,2) +...
                      S123(:,:,3).*GAMMA(1,3)); % s^{-1}
    end

end

