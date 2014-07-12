% script to make Thor. 2001 figures for Erin

%% Setup

% number of points
npts = 100;
% number of tirals
trials = 10;

% load setup strucure
load erinFiguresData.mat

%make eigenvalues
eigs = linspace(1/3,1,npts); % e1
eigs(2:3,:) = repmat((1-eigs)/2,2,1); % e2, e3 where e2 = e3

% initialize concentation parameter array
K = zeros(1,npts);
% initialize bulk strain rate array
epsDot = zeros(3,3,npts,SET.nelem);
% initialize normalized bulk strain rate array
normEpsDot = zeros(SET.nelem,npts,trials);

    %% Calculate strain rates for each stress for each eigenvalue
for kk = 1:trials
    % loop through stresses
    for ii = 1:SET.nelem
        % loop through eigenvalues
        for jj = 1:npts
            % create distribution of crystals
                % get concentation parameter for watson distribution
                K(jj) = Thor.ODF.watsonK(eigs(:,jj));
                % generate crystals
                N = Thor.ODF.watsonGenerate(SET.numbcrys,K(jj))';
                % get theta and phi values
                HXY = sqrt(N(1,:).^2+N(2,:).^2);
                cdist.theta = atan2(HXY,N(3,:))';
                cdist.phi   = atan2(N(2,:),N(1,:))';
                % set size of crystals
                cdist.size = ones(SET.numbcrys,1);

            % calculate velocity gradients and strain rates for each crystal
            cdist = Thor.Utilities.vec( cdist, SET, ii);

            % calculate bulk strain rate
            epsDot(:,:,jj,ii) = Thor.Utilities.bedot(cdist);

        end
    end

    %% calculate the normalized strain rate for each stress
        % Uniaxial Compression
        normEpsDot(1,:,kk) = squeeze(epsDot(3,3,:,1))/epsDot(3,3,1,1)';
        % Pure Shear
        normEpsDot(2,:,kk) = squeeze(epsDot(3,3,:,2))/epsDot(3,3,1,2)';
        % Simple Shear
        normEpsDot(3,:,kk) = squeeze(epsDot(1,3,:,3))/epsDot(1,3,1,3)';        

end        
%% average normalized strain rates to get a smooth line

avNormEpsDot = mean(normEpsDot,3);

%% Plot

plot(eigs(1,:),avNormEpsDot)


%% pot NNI -- Uni comp and pure shear

figure; clf;
% set size of figure
%                                             left, bottom, width, height
set(gcf, 'Units','centimeters','OuterPosition', [5 5 17 16]);

% figure properties
FName = 'Optima';
FWeight = 'normal';
FSize = 14;
LWidth = 3;
MSize = 7;
LineColor = [0.5 0.5 0.5];


% make figure axis
ax = axes('Position', [.15,.15,.8,.8], 'parent',gcf,'layer','top');
                          %[left, bottom, width, height]

% plot
h = plot(ax,eigs(1,:), NNI.none(1,:),'-k',...
            eigs(1,:), NNI.full(1,:),'-k',...
            eigs(1,:), NNI.none(2,:),'--k',...
            eigs(1,:), NNI.full(2,:),'--k',...
            'LineWidth',LWidth);

set(h([2,4]), 'Color', LineColor)

 set(ax, 'FontSize',FSize,'FontWeight',FWeight,'FontName',FName)
 xlabel(ax,'Largest eigenvalue','FontSize',FSize,'FontWeight',FWeight)
 ylabel(ax,'Normalized strain rate','FontSize',FSize,'FontWeight',FWeight)
 
%% plot NNI - simple shear

 figure; clf;
% set size of figure
%                                             left, bottom, width, height
set(gcf, 'Units','centimeters','OuterPosition', [5 5 17 16]);

% figure properties
FName = 'Optima';
FWeight = 'normal';
FSize = 14;
LWidth = 3;
MSize = 7;
LineColor = [0.5 0.5 0.5];


% make figure axis
ax = axes('Position', [.15,.15,.8,.8], 'parent',gcf,'layer','top');
                          %[left, bottom, width, height]

% plot
h = plot(ax,eigs(1,:), NNI.none(3,:),'-k',...
            eigs(1,:), NNI.full(3,:),'-k',...
            'LineWidth',LWidth);

set(h(2), 'Color', LineColor)

 set(ax, 'FontSize',FSize,'FontWeight',FWeight,'FontName',FName)
 xlabel(ax,'Largest eigenvalue','FontSize',FSize,'FontWeight',FWeight)
 ylabel(ax,'Normalized strain rate','FontSize',FSize,'FontWeight',FWeight)


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


