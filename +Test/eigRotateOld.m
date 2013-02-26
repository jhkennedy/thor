%% setup workspace
addpath /home/joseph/Documents/MATLAB/

clear all;

%% create distribution of crystals

% number of crystals
N = 100;
% concentation parameter for watson distribution
k = -1;
% generate watson distribution
W = Thor.ODF.watsonGenerate(N,k);
% make all in upper hemisphere
W(W(:,3) <=0,:) = W(W(:,3) <=0,:)*-1;
% get theta, phi
HXY = sqrt(W(:,1).^2+W(:,2).^2);
T = atan2(HXY,W(:,3));
P = atan2(W(:,2),N(:,1));


%% set stress
% stress = [0,0,1;0,0,0;1,0,0]*10000; % Pa
stress = [1/2,0,0;0,1/2,0;0,0,-1]*1000; % Pa
% stress = [1,0,0;0,0,0;0,0,-1]*1000; % Pa

% expand the stress for RSS
stress = repmat(stress,[1,1,N]);

% ehancement factor
E = 100;

%% calculate velocity gradients

% glen exponent
n = 3;
% beta
BETA = 630;
ALPHA = 5.1e-26; % s^{-1} Pa^{-1}

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

% apply enhancement factor
VEL2 = E*VEL;

 %% calcualte rotation rates for crystals
 
% calculate the rotation rate
ROR = (1/2)*(VEL -permute(VEL,[2,1,3])); % Op

ECDOT = (1/2)*(VEL +permute(VEL,[2,1,3]));

BEDOT = sum(ECDOT,3)/N; % edot

BVEL =  sum(VEL,3)/N; % Lm

BROR = (1/2)*(BVEL - BVEL'); % Om

% calculate the rotation rate
ROR2 = (1/2)*(VEL2 -permute(VEL2,[2,1,3])); % Op

ECDOT2 = (1/2)*(VEL2 +permute(VEL2,[2,1,3]));

BEDOT2 = sum(ECDOT2,3)/N; % edot

BVEL2 =  sum(VEL2,3)/N; % Lm

BROR2 = (1/2)*(BVEL2 - BVEL2'); % Om


%%

% bulk rotation rate boundry condition
BC = BEDOT.*[0,1,1;-1,0,1;-1,-1,0] - BROR; % s^{-1} 

% bulk roation 
BROT = BC + BROR; % s^{-1}

% crystal latice rotation
ROT = repmat(BROT,[1,1,N]) - ROR;

% bulk rotation rate boundry condition
BC2 = BEDOT2.*[0,1,1;-1,0,1;-1,-1,0] - BROR2; % s^{-1} 

% bulk roation 
BROT2 = BC2 + BROR2; % s^{-1}

% crystal latice rotation
ROT2 = repmat(BROT2,[1,1,N]) - ROR2;


%% rotate crystals without boundary condition
% time step
time = 1000*3.15569e12; % s

for ii = 1:N
    % rotate crystals through ROR only
    Wror(ii,:) = expm(time*ROT(:,:,ii))*W(ii,:)'; %#ok<SAGROW>
end

% make sure Wror is a unit vector
Wror = Wror./repmat(sqrt(Wror(:,1).^2+Wror(:,2).^2+Wror(:,3).^2),[1,3]); % -


for ii = 1:N
    % rotate crystals through ROR only
    Wror2(ii,:) = expm(time*ROT2(:,:,ii))*W(ii,:)'; %#ok<SAGROW>
end

% make sure Wror is a unit vector
Wror2 = Wror2./repmat(sqrt(Wror2(:,1).^2+Wror2(:,2).^2+Wror2(:,3).^2),[1,3]); % -

%% visualize results

MSize = 90;
LWidth = 3;

figure;
scatter3(W(:,1),W(:,2),W(:,3), MSize, 'xb','LineWidth',LWidth)
hold on

scatter3(Wror(:,1),Wror(:,2),Wror(:,3), MSize, 'or','LineWidth',LWidth)
hold on

scatter3(Wror2(:,1),Wror2(:,2),Wror2(:,3), MSize, 'og','LineWidth',LWidth)
hold off

axis([-1,1,-1,1,-1,1])
view([0,90])