function [ Lc ] = velocity( stress, crysang, n )
% VELOCITY(STRESS, CRYSANG, N) returns the single crystal velocity gradient on a single 
% crystal with orientation CRYSANG, under a stress of STRESS. 
%   
%   STRESS is a 3x3 matrix containing the elements of the stress tensor.
%
%   CRYSANG is a 1x2 vector containing [theta phi] where theta and phi 
%   orientation angle of a crystal.
%
%   N is the exponent to be used in the flow law.
%
%   VELOCITY returns a 3x3 matrix containing the single crystal velocity
%   gradiant elements.

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
    
    % calculate the rate of shearing
    GAMMA1 = ALPHA*BETA*TAU1*abs(TAU1)^(n-1);
    GAMMA2 = ALPHA*BETA*TAU2*abs(TAU2)^(n-1);
    GAMMA3 = ALPHA*BETA*TAU3*abs(TAU3)^(n-1);
    
    % calculate the velocity gradiant. 
    Lc = S1.*GAMMA1 + S2.*GAMMA2 + S3.*GAMMA3;
end

