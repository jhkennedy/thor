function [Ebedotz, Eeig] = eigRotate(N,k,E)

%% setup workspace
addpath /joe/Documents/MATLAB/

%% create distribution of crystals

% number of crystals
% N = 100;
% concentation parameter for watson distribution
% k = -1;
% generate watson distribution
W = Thor.ODF.watsonGenerate(N,k);
% make all in upper hemisphere
W(W(:,3) <=0,:) = W(W(:,3) <=0,:)*-1;
% get theta, phi
HXY = sqrt(W(:,1).^2+W(:,2).^2);
T = atan2(HXY,W(:,3));
P = atan2(W(:,2),N(:,1));

%% make sure distrobution is vertical
% get principle axis
[~,~,V] = svd(diag(ones(1,N)/N)*W);
PAX = V(:,1); if (PAX(3) < 0); PAX = -PAX; end; % check in upper hemisphere

if (PAX(3) < .95)
    % get rotation axis and angle 
    ZAX = [0;0;1];
    RAX = cross(PAX,ZAX); RAX = RAX/norm(RAX);
    RAN = atan2(norm(cross(PAX,ZAX)),dot(PAX,ZAX));


    for ii = 1:N
        W(ii,:) = (1-cos(RAN))*dot(W(ii,:)',RAX)*RAX+cos(RAN)*W(ii,:)'+sin(RAN)*cross(RAX,W(ii,:)'); 
    end

    % make sure Wnew is a unit vector
    W = W./repmat(sqrt(W(:,1).^2+W(:,2).^2+W(:,3).^2),[1,3]); % -
end

%% set stress
% stress = [0,0,1;0,0,0;1,0,0]*10000; % Pa
stress = [1/2,0,0;0,1/2,0;0,0,-1]*1000; % Pa
% stress = [1,0,0;0,0,0;0,0,-1]*1000; % Pa

% expand the stress for RSS
stress = repmat(stress,[1,1,N]);

% ehancement factor
% E = 10;

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
                         +B3.*repmat(R3,[1,3]) ).^2,2) );  %#ok<NASGU> % Pa


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
ROR = (1/2)*(VEL -permute(VEL,[2,1,3]));

% calculate the rotation rate
ROR2 = (1/2)*(VEL2 -permute(VEL2,[2,1,3]));

%% rotate crystals without boundary condition
% time step
time = 1000*3.15569e12; % s


Wror = W*0;
for ii = 1:N
    % rotate crystals through ROR only
    Wror(ii,:) = expm(time*-ROR(:,:,ii))*W(ii,:)';
end

if any(isnan(Wror) | isinf(Wror))
    Ebedotz = NaN;
    Eeig = NaN;
    display('Wror!')
    display(W)
    return
end

% make sure Wror is a unit vector
Wror = Wror./repmat(sqrt(Wror(:,1).^2+Wror(:,2).^2+Wror(:,3).^2),[1,3]); % -

Wror2 = W*0;
for ii = 1:N
    % rotate crystals through ROR only
    Wror2(ii,:) = expm(time*-ROR2(:,:,ii))*W(ii,:)'; 
end

% make sure Wror is a unit vector
Wror2 = Wror2./repmat(sqrt(Wror2(:,1).^2+Wror2(:,2).^2+Wror2(:,3).^2),[1,3]); % -

if any(isnan(Wror2) | isinf(Wror2))
    Ebedotz = NaN;
    Eeig = NaN;
    display('Wror2!')
    display(Wror2)
    return
end

%% apply boundry condition with eigenvectors
% get principle axis
[~,~,V] = svd(diag(ones(1,N)/N)*Wror);
PAX = V(:,1); if (PAX(3) < 0); PAX = -PAX; end; % check in upper hemisphere


    % get rotation axis and angle 
    ZAX = [0;0;1];
    RAX = cross(PAX,ZAX); RAX = RAX/norm(RAX);
    RAN = atan2(norm(cross(PAX,ZAX)),dot(PAX,ZAX));

    Wnew = W*0;
    for ii = 1:N
        Wnew(ii,:) = (1-cos(RAN))*dot(Wror(ii,:)',RAX)*RAX+cos(RAN)*Wror(ii,:)'+sin(RAN)*cross(RAX,Wror(ii,:)');
    end

    % make sure Wnew is a unit vector
    Wnew = Wnew./repmat(sqrt(Wnew(:,1).^2+Wnew(:,2).^2+Wnew(:,3).^2),[1,3]); % -
    
    if any(isnan(Wnew) | isinf(Wnew))
        Ebedotz = NaN;
        Eeig = NaN;
            display('Wnew!')
        display(Wnew)
        return
    end


% get principle axis
[~,~,V2] = svd(diag(ones(1,N)/N)*Wror2);
PAX = V2(:,1); if (PAX(3) < 0); PAX = -PAX; end; % check in upper hemisphere


    % get rotation axis and angle 
    ZAX = [0;0;1];
    RAX = cross(PAX,ZAX); RAX = RAX/norm(RAX);
    RAN = atan2(norm(cross(PAX,ZAX)),dot(PAX,ZAX));

    Wnew2 = W*0;
    for ii = 1:N
        Wnew2(ii,:) = (1-cos(RAN))*dot(Wror2(ii,:)',RAX)*RAX+cos(RAN)*Wror2(ii,:)'+sin(RAN)*cross(RAX,Wror2(ii,:)');
    end

    % make sure Wnew is a unit vector
    Wnew2 = Wnew2./repmat(sqrt(Wnew2(:,1).^2+Wnew2(:,2).^2+Wnew2(:,3).^2),[1,3]); % -

    if any(isnan(Wnew2) | isinf(Wnew2))
        Ebedotz = NaN;
        Eeig = NaN;
            display('Wnew2!')
        display(Wnew2)
        return
    end

    
%% calc  bulk strains and eigenvalues

ECDOT = (1/2)*(VEL +permute(VEL,[2,1,3]));

BEDOT = sum(ECDOT,3)/N; % edot

ECDOT2 = (1/2)*(VEL2 +permute(VEL2,[2,1,3]));

BEDOT2 = sum(ECDOT2,3)/N; % edot

eig = svd(sqrt(diag(ones(1,N)/N))*W).^2;
eigNew = svd(sqrt(diag(ones(1,N)/N))*Wnew).^2;
eigNew2 = svd(sqrt(diag(ones(1,N)/N))*Wnew2).^2;

Ebedotz = BEDOT2(3,3)/BEDOT(3,3);

Eeig = (eig(1)-eigNew2(1))/(eig(1)-eigNew(1));

%% visualize results

% MSize = 90;
% LWidth = 3;
% 
% figure;
% scatter3(W(:,1),W(:,2),W(:,3), MSize, 'xb','LineWidth',LWidth)
% hold on
% 
% % scatter3(Wror(:,1),Wror(:,2),Wror(:,3), MSize, 'og','LineWidth',LWidth)
% % hold on
% 
% scatter3(Wnew2(:,1),Wnew2(:,2),Wnew2(:,3), MSize, 'og','LineWidth',LWidth)
% hold on
% 
% scatter3(Wnew(:,1),Wnew(:,2),Wnew(:,3), MSize, 'or','LineWidth',LWidth)
% hold off
% 
% axis([-1,1,-1,1,-1,1])
% view([0,90])
% 
% title(['Old eig: ', num2str(eig(1)),' New eig: ', num2str(eigNew(1)),' Enh. eig: ', num2str(eigNew2(1)), ' Enh. factor: ', num2str(E)])


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


