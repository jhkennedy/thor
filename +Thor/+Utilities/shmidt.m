function [ S123 ] = shmidt( THETA, PHI )
% SHMIDT( CRYSANG ) returns the 
%   Detailed explanation goes here

   S123 = zeros(3,3,3);

    % basal plane vectors
    B1  =  1/3*[cos(THETA).*cos(PHI) cos(THETA).*sin(PHI) -sin(THETA)];  
    B2  = -1/6*[(cos(THETA).*cos(PHI) + 3^(.5)*sin(PHI))...
         (cos(THETA).*sin(PHI) - 3^(.5)*cos(PHI)) -sin(THETA)];
    B3  = -1/6*[(cos(THETA).*cos(PHI) - 3^(.5)*sin(PHI))...
         (cos(THETA).*sin(PHI) + 3^(.5)*cos(PHI)) -sin(THETA)]; 

    % C-axis orientation
    N   = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)];

    % calculate the shmidt tensors
    S123(:,:,1) = B1'*N;
    S123(:,:,2) = B2'*N;
    S123(:,:,3) = B3'*N;


end

