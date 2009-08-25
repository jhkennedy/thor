% Code to find general for of the bulk strain rate, edot
%
% still need to: get stress, 

clc
clear all
close all

tic

syms THETA PHI ALPHA BETA S11 S12 S13 S21 S22 S23 S31 S32 S33 Ao A real

plotdef = 100;

% % general Cauchy stress tensor
% SIGMA = [ S11 S12 S13
%           S21 S22 S23
%           S31 S32 S33];

% uniaxial Compression
SIGMA = [ 0 0 0
          0 0 0
          0 0 S33]; 
      
% % Pure Shear
% SIGMA = [ -S33 0 0
%           0    0 0
%           0    0 S33];

% % simple shear
% SIGMA = [ 0 0 S33
%           0 0 0
%           S33 0 0]; 

% basal plane vectors
b1  = 1/3*[cos(THETA)*cos(PHI) cos(THETA)*sin(PHI) -sin(THETA)];  
b2  = -1/6*[(cos(THETA)*cos(PHI) + 3^(.5)*sin(PHI))...
    (cos(THETA)*sin(PHI) - 3^(.5)*cos(PHI)) -sin(THETA)];
b3  = -1/6*[(cos(THETA)*cos(PHI) - 3^(.5)*sin(PHI))...
    (cos(THETA)*sin(PHI) + 3^(.5)*cos(PHI)) -sin(THETA)]; 

% C-axis orientation
n   = [sin(THETA).*cos(PHI) sin(THETA).*sin(PHI) cos(THETA)];  

% Schmidt tensor for the slip system
S1 = b1' * n;
S2 = b2' * n;
S3 = b3' * n;

% Traction in the basal plane along the 3 slip systems
TAU1 = sum(sum(S1.*SIGMA));
TAU2 = sum(sum(S2.*SIGMA));
TAU3 = sum(sum(S3.*SIGMA));

% reference shmidt tensor
R1 =(S1+S1')/2;
R2 =(S2+S2')/2;
R3 =(S3+S3')/2;

% single crystal strin rate
ecdot = ALPHA*BETA*(R1*TAU1^3+R2*TAU2^3+R3*TAU3^3);

% Orientation distribution function (ODF)
%F = sin(THETA)/(2*pi); % Isotropic Ice ODF
F = sin(THETA)/(2*pi*(1-cos(A))); % Cone Fabric ODF
%F = sin(THETA)/(2*pi*(cos(Ao)-cos(A))); % Girdle Fabric ODF

%%
% Bulk Strain Rate
Edottemp = int(F*ecdot(3,3),PHI,0,2*pi);
Edot = int(Edottemp,THETA,0,A);

PLT33 = Edot;
PLT33 = subs(PLT33, {ALPHA,BETA,S33,A}, {1,630,1,0:pi/(2*(plotdef-1)):(pi/2)});

plot(0:pi/(2*(plotdef-1)):pi/2,PLT33./PLT33(plotdef));
xlabel('Cone Angle (rad)');
ylabel('Normalized Strain Rate');
title('uniaxial compression');

toc