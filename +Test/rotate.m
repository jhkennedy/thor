%% setup workspace
addpath /home/joseph/Documents/MATLAB/


%% create distribution of crystals

% number of crystals
N = 10;
% concentation parameter for watson distribution
k = -100;
% generate watson distribution
W = Thor.ODF.watsonGenerate(N,k);
% make all in upper hemisphere
W(W(:,3) <=0,:) = W(W(:,3) <=0,:)*-1;
% get theta, phi
HXY = sqrt(W(:,1).^2+W(:,2).^2);
T = atan2(HXY,W(:,3));
P = atan2(W(:,2),N(:,1));

%% set stress
stress = [0,0,1;0,0,0;1,0,0]*-10000; % Pa
% stress = [1/2,0,0;0,1/2,0;0,0,1];
% stress = [1,0,0;0,0,0;0,0,1];

% expand the stress for RSS
stress = repmat(stress,[1,1,N]);

%% calculate velocity gradients

% glen exponent
n = 3;
% beta
BETA = 650;
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

  
 %% calcualte rotation rates for crystals crystals
 
% calculate the rotation rate
ROR = (1/2)*(VEL -permute(VEL,[2,1,3]));

% calculate the strain rate
SRN = (1/2)*(VEL +permute(VEL,[2,1,3]));

% calculate the bulk strain rate
BSRN = sum(SRN,3)/N;

% get bulk strain boundry condition mask
MSK = (stress(:,:,1) ~= 0).*[0,1,1;-1,0,1;-1,-1,0];

% % bluk rotation rate boundry condition
%     % find out how much flow is not in correct bulk direction
%     a = sum(sum(abs(BSRN+diag(diag(BSRN)))/2));
%     tmp = diag(diag(BSRN));
%     b = sum(abs(BSRN(MSK ~= 0)+tmp(MSK ~= 0)))/2;
%     E2 = 2 - b/a;
%     E3 = 1.5 - b/(2*a);
%     E1 = 1;
BC = repmat(BSRN.*MSK,[1,1,N]);

% cystal lattice rotation
ROT = BC - ROR;

%% rotate crystals

% time step
time = 3.15569e12; % s



for ii = 1:N
    % rotate crystals through whole step
    Wnew(ii,:) = expm(time*ROT(:,:,ii))*W(ii,:)'; %#ok<SAGROW>
    % rotate crystals through BC only
    Wbc(ii,:) = expm(time*BC(:,:,ii))*W(ii,:)'; %#ok<SAGROW>
    % rotate crystals through ROR only
    Wror(ii,:) = expm(time*-ROR(:,:,ii))*W(ii,:)'; %#ok<SAGROW>
    Wnew2(ii,:) = expm(time*BC(:,:,ii))*Wror(ii,:)';
    Wnew3(ii,:) = expm(time*-ROR(:,:,ii))*Wbc(ii,:)';
end

%% visualize results


figure;
scatter3(W(:,1),W(:,2),W(:,3),'xk')
hold on

scatter3(Wnew(:,1),Wnew(:,2),Wnew(:,3),'.b')
hold on

scatter3(Wbc(:,1),Wbc(:,2),Wbc(:,3),'.r')
hold on

scatter3(Wror(:,1),Wror(:,2),Wror(:,3),'.g')
hold on

scatter3(Wnew2(:,1),Wnew2(:,2),Wnew2(:,3),'.c')
hold on

scatter3(Wnew3(:,1),Wnew3(:,2),Wnew3(:,3),'.m')

axis([-1,1,-1,1,-1,1])
view([0,90])