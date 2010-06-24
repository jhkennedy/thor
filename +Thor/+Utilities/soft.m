function [ cdist, esoft ] = soft( cdist, CONN, cnumb, xcec )
% SOFT(cdist, CONN, cnumb, soft) calculates the softness parameter from the
% interaction between a crystal and its nearest neighbors. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The
%   crystal distrubution structure is outlined in Thor.setup.
%
%   CONN is a 1x12 arry containing the crystal number for the nearest neighboors in the
%   distrobution.  
%
%   cnumb is the crystal number within cdist the softness parameter is getting calculated
%   for.
%
%   xcec is a 1x2 vector holding [xc, ec]. xc is the Nearest Neighbor Interaction, NNI,
%   controbution from the crystal and ec is the controbution from each neighboring
%   crystal. This is usually set in SETTINGS.soft as outlined in Thor.setup.
%
% Soft returns the crystal distrobution and the softness parameter, a scalar, for the
% crysal
%
%   See also Thor.setup


    % controbution from the crystal
    xc = xcec(1);
    % controbution from each neighboring crystal
    ec = xcec(2);

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

            % sum of the magnitudes of the RSS on the neigboring crystals
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

