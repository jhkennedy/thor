%% script to test migration recrystalization condition for different temperatures
% close all; clear all; clc    
%% setup script

% set time steps, end after 210000 years
tf = 210000*(365*24*60*60); % s
to = 0;
steps = 10000;
ti = linspace(to,tf,steps); % s

% set constants for Egb and Edisl
    % Edisl
    rho0 = 4*1e10; % m^{-2}
    b = 4.5e-10; % m
    G = 3.4e9; % Pa
    kappa = 0.035; % -
    stress = [5000,    0,      0;...
                 0, 5000,      0;...
                 0,    0, -10000]; % Pa
    
    % glens flow law parameter
    A(1,:) = [      0,     -2,     -5,    -10,    -15,    -20,    -25,    -30,    -35,    -40,    -45,    -50]+273.13; % K
    A(2,:) = [ 0.6800, 0.2400, 0.1600, 0.0460, 0.0290, 0.0170, 0.0094, 0.0051, 0.0027, 0.0014, 0.0007, 0.0004]*1e-23; % s^{-1} Pa^{-3}
    
    % Egb
    gamma = 0.065; % J m^{-2}
    
    % crystal qrowth
    Ko = 8.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    Do = 0.003; % m
    
%% calculate crystal size for temperature

T = 273.13-30; % K
K = Ko*exp(-Q/(R*T)); % m^2 s^{-1}
D = sqrt(K*(ti-to) + Do^2); % m

%% calculate strain rates
% isotropic assumtion
edot = interp1(A(1,:),A(2,:),T)*stress.^3; % s^{-1}
% Magnitude (second invariant) of strain rate
Medot = sqrt( sum(sum(edot.*edot))/2 ); % s^{-1}

%% calculate Egb

Egb = 3*gamma./D; % J m^{-3} = Pa

%% Calculate Edisl

% % use matlabs ode solver: ode23
% [~, rho] = ode45(@(t,y) dislODE(t, y, Medot, b, K, ti, D),ti, rho0); 
% 
% rho = rho';

rho = rho0;
for ii = 2:size(ti,2)
    rho(ii) = rho(ii-1) + (Medot/(b*D(ii-1)) - rho(ii-1)*K/D(ii)^2)*(ti(2)-ti(1));
end



Edisl = kappa.*rho.*G.*b^2.*log(1./(sqrt(rho)*b)); % Pa

%% plot results

% figure,
% plot(ti,D)
% figure,
% plot(ti,rho)
figure, 
plot(ti,ones(size(ti)),ti,Edisl./Egb)


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


