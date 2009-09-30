function [ cdist] = vec( cdist, stress, n, ynsoft )
% VEC( THETA, PHI, stress, n ) returns [ vel ecdot odf] for a crystal specifies by THETA,
% PHI, stress and n.
%   cdist is a 1x8000 cell aray holding a crystal distrobution
%
%   stess is a 3x3 array holding the stress tensor that the crystal distrobution experiences
%
%   n is the flow law power that the crystal distrubution experiences
%
%   ynsoft turns on and of the softness parameter
%
%   Vec returns returns the modified cdist


%% Initialize variables
    ALPHA = 1; % to make unitless
    BETA = 630; % from Thors 2001 paper (pg 510, above eqn 16)

    % initialize rate of shearing
    GAMMA = zeros(1,3);
  
%% loop through each crystal in the distrobution and calc its velocity gradient and 
    for ii = 1:20*20*20
        % calculate the orientation distrobution function component for crystal ii
        cdist{ii,5} = sin(cdist{ii,1});

        % get shmidt tensors for the slip system
        S123 = Thor.Utilities.shmidt(cdist{ii,1}, cdist{ii,2});

        % calculate the RSS on each slip system
        TAU = Thor.Utilities.rss(S123, stress);

        % clalculate the softness parameter
        switch ynsoft
            case 'yes'
               [cdist esoft] = Thor.Utilities.soft(cdist, cnumb, TAU);
            case 'no'
                esoft = 1;
        end

        % calculate the rate of shearing on each slip system
        GAMMA(1,1) = ALPHA*BETA*esoft*TAU(1,1)*abs(esoft*TAU(1,1))^(n-1);
        GAMMA(1,2) = ALPHA*BETA*esoft*TAU(1,2)*abs(esoft*TAU(1,2))^(n-1);
        GAMMA(1,3) = ALPHA*BETA*esoft*TAU(1,3)*abs(esoft*TAU(1,3))^(n-1);

        % calculate the velocity gradient of crystal ii
        cdist{ii,3} = S123(:,:,1).*GAMMA(1,1) + S123(:,:,2).*GAMMA(1,2) +...
                      S123(:,:,3).*GAMMA(1,3);

        % add the shmidt tensor to its transpose and divide by 2 (thor 2001 papar, eqn 7)
        S123(:,:,1) = (S123(:,:,1) + S123(:,:,1)')/2;
        S123(:,:,2) = (S123(:,:,2) + S123(:,:,2)')/2;
        S123(:,:,3) = (S123(:,:,3) + S123(:,:,3)')/2;

        % calculate the strain rate for crystal ii
        cdist{ii,4} = cdist{ii,5}*(S123(:,:,1).*GAMMA(1,1) + S123(:,:,2).*GAMMA(1,2) +...
                      S123(:,:,3).*GAMMA(1,3));
    end

end

