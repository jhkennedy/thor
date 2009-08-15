% Code to find general form of the bulk strain rate, edot


% clc
clear all
close all

tic

ALPHA = 1; % to make unitless
BETA = 630; % from Thors paper (pg 510, above eqn 16)

% uniaxial compression stres tensor
SIGMA = [ 0 0 0
          0 0 0
          0 0 1];

def = 100; % integration steps -- 100 is good, smaller = less accurate.

Aodeg = 0; % girdle angle in degrees
Ao = Aodeg *pi/180; % girdle angle in radians

Adeg = 45; % cone angle in degrees
A = Adeg *pi/180; % cone angle in radians

EfacTEMP = zeros(3,6); % Bulk strain rate holder
Efac = zeros(3,3); % Enhancement factor

% do twice, once for given cone angle, once for isotropic ice so that the
% enhancement factor can be genorate
for ii = 1:2
    
    % set to isotropic ice
    if ii == 2
        Adeg = 90; % cone angle in degrees
        A = Adeg *pi/180; % cone angle in radians
    end
    
    % even distribution of crystals (one at each theta,phi point)
    THETA = linspace(Ao,A,def); 
    PHI = linspace(0,2*pi,def);

    % initialize Shmidt tensors for the the slip systems
    S1 = zeros(3,3);
    S2 = zeros(3,3);
    S3 = zeros(3,3);

    % initialize the single crystal strain rate
    ecdot = zeros(3*def*def,3);

    % initialize the bulk strain rate
    EdotTEMP = zeros(3*def,3);
    Edot = zeros(3,3);
    
    C = 0;
    for m = 1:def
        for n = 1:def
            C = C + 1; % counter to keep track of which crystal

            % basal plane vectors [ outputs as x,y,z as columns for each angle
            % as the rows.
            B1  = 1/3*[cos(THETA(m)).*cos(PHI(n)) cos(THETA(m)).*sin(PHI(n)) -sin(THETA(m))];  
            B2  = -1/6*[(cos(THETA(m)).*cos(PHI(n)) + 3^(.5)*sin(PHI(n)))...
                 (cos(THETA(m)).*sin(PHI(n)) - 3^(.5)*cos(PHI(n))) -sin(THETA(m))];
            B3  = -1/6*[(cos(THETA(m)).*cos(PHI(n)) - 3^(.5)*sin(PHI(n)))...
                 (cos(THETA(m)).*sin(PHI(n)) + 3^(.5)*cos(PHI(n))) -sin(THETA(m))]; 

            % C-axis orientation
            N   = [sin(THETA(m)).*cos(PHI(n)) sin(THETA(m)).*sin(PHI(n)) cos(THETA(m))];

            % c-axis orientation distributin funtion (ODF)
            F = sin(THETA(m))/(2*pi*(cos(Ao)-cos(A)));

            % populate the shmidt tensors
            S1 = B1'*N;
            S2 = B2'*N;
            S3 = B3'*N;

            % populate the traction
            TAU1 = sum(sum(S1.*SIGMA));
            TAU2 = sum(sum(S2.*SIGMA));
            TAU3 = sum(sum(S3.*SIGMA));

            % add the shmit tensor to its transpose and divide by 2 (thor paper, eqn 7)
            S1 = (S1+S1')/2;
            S2 = (S2+S2')/2;
            S3 = (S3+S3')/2;

            % calculate the single crystal strain rate
            ecdot((C*3-2):(C*3),:) = F*ALPHA*BETA*(S1*TAU1^3 + S3*TAU2^3 + S3*TAU3^3);
        end
    end

    %find the bulk strain rate
        % integrate of phi
        for m = 1:def
            for n = 1:3
                for p = 1:3
                    EdotTEMP(((m-1)*3+n),p) = trapz(ecdot(((m-1)*3*def+n):3:(3*def*m),p))*(2*pi/def);
                end
            end
        end

        % integrate over theta
        for m = 1:3
            for n = 1:3
                Edot(m,n) = trapz(EdotTEMP(m:3:3*def,n))*((A-Ao)/def);
            end
        end

    % hold the bulk strain rait
    EfacTEMP(1:3,ii*3-2:ii*3) = Edot;

end

% calculate the enhancement factor by compairing to Isotropic Ice
for m = 1:3
    for n = 1:3
        if abs(EfacTEMP(m,n)) > 0.00005
           Efac(m,n) = EfacTEMP(m,n)/EfacTEMP(m,n+3);
        end
    end
end

display(Efac);

toc