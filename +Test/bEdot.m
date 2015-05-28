%% setup workspace
addpath /home/joseph/Documents/MATLAB/


%% create distribution of crystals

% number of crystals
N = 1000;
% concentation parameter for watson distribution
k = 0;
% generate watson distribution
W = Thor.ODF.watsonGenerate(N,k);
% % make all in upper hemisphere
% W(W(:,3) <=0,:) = W(W(:,3) <=0,:)*-1;
% % get theta, phi
HXY = sqrt(W(:,1).^2+W(:,2).^2);
T = atan2(HXY,W(:,3));
P = atan2(W(:,2),N(:,1));

%% set stress
% stress = [0,0,1;0,0,0;1,0,0]*10000; % Pa
% stress = [1/2,0,0;0,1/2,0;0,0,-1]*10000; % Pa
stress = [1,0,0;0,0,0;0,0,-1]*10000; % Pa

% expand the stress for RSS
stress = repmat(stress,[1,1,N]);

%% calculate velocity gradients

R = 0.008314472; % kJ K^{-1} mol^{-1}
Q = 60;  % kJ mol^{-1}

% glen exponent
n = 3;
% beta
BETA = 630;
% ALPHA = 5.1e-26; % s^{-1} Pa^{-1}
temperature = -30; % celcius
ALPHA = 3.5e-25*BETA*exp(-(Q/R)*(1.0/(273.15+temperature)-1.0/263.15)); % s^{-1} Pa^{-n}

% burgers vectors
B1 = (1/3)*[cos(T).*cos(P), cos(T).*sin(P), -sin(T)];
B2 = (1/6)*[(-cos(T).*cos(P)-sqrt(3).*sin(P)), (-cos(T).*sin(P)+sqrt(3).*cos(P)), sin(T)];
B3 = (1/6)*[(-cos(T).*cos(P)+sqrt(3).*sin(P)), (-cos(T).*sin(P)-sqrt(3).*cos(P)), sin(T)];

% schmidt tensor
j = 1:3;
S1 = reshape(repmat(B1',3,1).* W(:,j(ones(3,1),:)).',[3,3,N]);
S2 = reshape(repmat(B2',3,1).* W(:,j(ones(3,1),:)).',[3,3,N]);
S3 = reshape(repmat(B3',3,1).* W(:,j(ones(3,1),:)).',[3,3,N]); 
clear j;

% calculate the RSS on each slip system (Nx1 vector)
R1 = reshape(sum(sum(S1.*stress)),1,[])'; % Pa
R2 = reshape(sum(sum(S2.*stress)),1,[])'; % Pa
R3 = reshape(sum(sum(S3.*stress)),1,[])'; % Pa

% calculate the magitude of the RSS on each crystal
MRSS = sqrt( sum( ( B1.*repmat(R1,[1,3])...
                         +B2.*repmat(R2,[1,3])...
                         +B3.*repmat(R3,[1,3]) ).^2,2) );  % Pa


% calculate the rate of shearing on each slip system (size Nx1)
G1 = ALPHA*BETA*R1.*abs(R1).^(n-1); % s^{-1}
G2 = ALPHA*BETA*R2.*abs(R2).^(n-1); % s^{-1}
G3 = ALPHA*BETA*R3.*abs(R3).^(n-1); % s^{-1}

% calculate the velocity gradient (size 3x3xN)
VEL = S1.*reshape(repmat(G1',[9,1]),3,3,[])...
      +S2.*reshape(repmat(G2',[9,1]),3,3,[])... 
      +S3.*reshape(repmat(G3',[9,1]),3,3,[]); % s^{-1}

  
EDOT = VEL/2 + permute(VEL,[2,1,3])/2; % s^{-1}

BVEL  = (1/N)*sum(VEL,3);
BEDOT = (1/N)*sum(EDOT,3);
bedot = BVEL/2 + BVEL'/2;
  
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEvoR: Fabric Evolution with Recrystallization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2009-2014  Joseph H Kennedy
%
% This file is part of FEvoR.
%
% FEvoR is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later 
% version.
%
% FEvoR is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
% details.
%
% You should have received a copy of the GNU General Public License along 
% with FEvoR.  If not, see <http://www.gnu.org/licenses/>.
%
% Additional permission under GNU GPL version 3 section 7
%
% If you modify FEvoR, or any covered work, to interface with
% other modules (such as MATLAB code and MEX-files) available in a
% MATLAB(R) or comparable environment containing parts covered
% under other licensing terms, the licensors of FEvoR grant
% you additional permission to convey the resulting work.


