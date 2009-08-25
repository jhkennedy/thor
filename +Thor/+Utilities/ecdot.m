function edot = ecdot( stress, crysang, angles, n)
% ECDOT(STRESS, CRYSANG, ANGLES, N) returns the strain rate on a single 
% crystal with orientation CRYSANG, under a stress of STRESS. 
%   
%   STRESS is a 3x3 matrix containing the elements of the stress tensor.
%
%   CRYSANG is a 1x2 vector containing [theta phi] where theta and phi 
%   orientation angle of a crystal.
%
%   ANGLES is a 1x2 vector containing [Ao A] where Ao is the girdle angle
%   of the fabric and A is the cone angle of the fabric.
%
%   N is the exponent to be used in the flow law.
%
%   ECDOT returns a 3x3 matrix containing the single crystal strain rate
%   elements.


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

    % calculate the shmidt tensors
    S1 = B1'*N;
    S2 = B2'*N;
    S3 = B3'*N;

    % calculate the traction
    TAU1 = sum(sum(S1.*stress));
    TAU2 = sum(sum(S2.*stress));
    TAU3 = sum(sum(S3.*stress));

    % add the shmit tensor to its transpose and divide by 2 (thor paper, eqn 7)
    S1 = (S1+S1')/2;
    S2 = (S2+S2')/2;
    S3 = (S3+S3')/2;
    
    % calculate the ODF component
    F = sin(crysang(1));

    % calculate the single crystal strain rate
    edot = F*ALPHA*BETA*(S1*TAU1*abs(TAU1)^(n-1) + S2*TAU2*abs(TAU2)^(n-1)...
        + S3*TAU3*abs(TAU3)^(n-1));

end

