function edot = ecdot( stress, crysang, angles )
% ECDOT(STRESS, CRYSANG, ANGLES) returns the strain rate on a single 
% crystal with orientation CRYSANG, under a stress of STRESS, within a 
% fabric specified by ANGLES. 
%   
%   STRESS is a 3x3 matrix containing the elements of the stress tensor.
%
%   CRYSANG is a 1x2 vector containing [theta phi] where theta and phi 
%   orientation angle of a crystal.
%
%   ANGLES is a 1x2 vector containg [Ao A] where Ao is the girdle angle and
%   A is the cone angle of the fabric. 


    ALPHA = 1; % to make unitless
    BETA = 630; % from Thors paper (pg 510, above eqn 16)

    % basal plane vectors
    B1  =  1/3*[cos(crysang(1)).*cos(crysang(2)) cos(crysang(1)).*sin(crysang(2)) -sin(crysang(1))];  
    B2  = -1/6*[(cos(crysang(1)).*cos(crysang(2)) + 3^(.5)*sin(crysang(2)))...
         (cos(crysang(1)).*sin(crysang(2)) - 3^(.5)*cos(crysang(2))) -sin(crysang(1))];
    B3  = -1/6*[(cos(crysang(1)).*cos(crysang(2)) - 3^(.5)*sin(crysang(2)))...
         (cos(crysang(1)).*sin(crysang(2)) + 3^(.5)*cos(crysang(2))) -sin(crysang(1))]; 

    % C-axis orientation
    N   = [sin(crysang(1)).*cos(crysang(2)) sin(crysang(1)).*sin(crysang(2)) cos(crysang(1))];

    % c-axis orientation distributin funtion (ODF)
    F = sin(crysang(1))/(2*pi*(cos(angles(1))-cos(angles(2))));

    % populate the shmidt tensors
    S1 = B1'*N;
    S2 = B2'*N;
    S3 = B3'*N;

    % populate the traction
    TAU1 = sum(sum(S1.*stress));
    TAU2 = sum(sum(S2.*stress));
    TAU3 = sum(sum(S3.*stress));

    % add the shmit tensor to its transpose and divide by 2 (thor paper, eqn 7)
    S1 = (S1+S1')/2;
    S2 = (S2+S2')/2;
    S3 = (S3+S3')/2;

    % calculate the single crystal strain rate
    edot = F*ALPHA*BETA*(S1*TAU1^3 + S2*TAU2^3 + S3*TAU3^3);

end

