function [ cdist, esoft ] = soft( cdist, CONN, cnumb, soft )
% SOFT(cdist, CONN, stress, cnumb, TAUo) calculates the softness parameter from the
% interaction between a crystal and its nearest neighbors. 
%   cdist is a crystal distrobution is aranged in an 8000x5 cell array. The information
%   cells are: 
%      1) THETA holds the colatitudinal orientation angle for the crystal
%      2) PHI holds the longitudinal orientation angle for the crystal
%      3) VEL holds he velocity gradient tensor for the crystal
%      4) ECDOT holds the single crystal strain rate
%      5) ODF hold the crystals controbution to the orientation distrobution function, ODF
%
%   CONN is a 1x12 arry containing the crystal number for the nearest neighboors in the
%   distrobution.  
%
%   Soft retruns the crystal distrobution and the softness parameter, a scalar, for the
%   crysal



    xc = soft(1);
    ec = soft(2);

    % get number of neighbors
    N = sum(~isnan(CONN(1,:)));

    % Initialise variables
    Ti = 0;
    B = zeros(3,3);

    % get sum of RSS's for neighbors
    for ii = 1:12
        if ~isnan(CONN(1,ii))

            % Get neighbor crystal angles
            THETA = cdist{CONN(1,ii),1};
            PHI = cdist{CONN(1,ii),2};

            % basal plane vectors for neighbor crystal
            B(1,:)  =  1/3*[cos(THETA).*cos(PHI) cos(THETA).*sin(PHI) -sin(THETA)];  
            B(2,:)  = -1/6*[(cos(THETA).*cos(PHI) + 3^(.5)*sin(PHI))...
             (cos(THETA).*sin(PHI) - 3^(.5)*cos(PHI)) -sin(THETA)];
            B(3,:)  = -1/6*[(cos(THETA).*cos(PHI) - 3^(.5)*sin(PHI))...
             (cos(THETA).*sin(PHI) + 3^(.5)*cos(PHI)) -sin(THETA)]; 

            Ti = Ti+ norm(B(1,:)*cdist{CONN(1,ii),3}(1,1)+B(2,:)*cdist{CONN(1,ii),3}(1,2)+...
                  B(3,:)*cdist{CONN(1,ii),3}(1,3));
        end
    end

    % Get crystal angles
    THETA = cdist{cnumb,1};
    PHI = cdist{cnumb,2};

    % basal plane vectors
    B(1,:)  =  1/3*[cos(THETA).*cos(PHI) cos(THETA).*sin(PHI) -sin(THETA)];  
    B(2,:)  = -1/6*[(cos(THETA).*cos(PHI) + 3^(.5)*sin(PHI))...
     (cos(THETA).*sin(PHI) - 3^(.5)*cos(PHI)) -sin(THETA)];
    B(3,:)  = -1/6*[(cos(THETA).*cos(PHI) - 3^(.5)*sin(PHI))...
     (cos(THETA).*sin(PHI) + 3^(.5)*cos(PHI)) -sin(THETA)];

    % calculate the magnitude of the RSS on the crystal
    To = norm(B(1,:)*cdist{cnumb,3}(1,1)+B(2,:)*cdist{cnumb,3}(1,2)+B(3,:)*cdist{cnumb,3}(1,3));

    % calculate the softness parameter
    esoft = 1/(xc + N*ec)*(xc + ec*Ti/To);

end

