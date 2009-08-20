close all
clear all

%% Plot crystals

% % Get crystal orientations
% crystals = Thor.Utilities.genCrystals(20,[pi/4 pi/2],'iso');
% crystwos = Thor.Utilities.genCrystals(20,[pi/4 pi/2],'even');
% 
% polar(crystals(:,2),crystals(:,1),'.');
% title('isotropic');
% 
% figure, polar(crystwos(:,2),crystwos(:,1),'.');
% title('even');

%% Get single crystal strain rate

% % uniaxial compression stres tensor
% SIGMA = [ 0 0 0
%           0 0 0
%           0 0 1];
% 
% for ii = 0:.1:pi/2
%     edot = Thor.Utilities.ecdot(SIGMA, [ii ii], 3);
%     display(edot);
% end

%% Integrate over single crystal strain rate

% SIGMA = [ 0 0 0
%           0 0 0
%           0 0 1];
% 
% Efac   = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],3), 0 ,pi/4 ,0 ,pi*2);
% Efac90 = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],3), 0 ,pi/2 ,0 ,pi*2);
% 
% display(Efac/Efac90);

%% integrate to make fig 3 in thor's paper
% 
% SIGMA = [ 0 0 0
%           0 0 0
%           0 0 1];
% 
% T = 20;
% Range = (pi/2)/(T-1):(pi/2)/(T-1):pi/2;
% fig = zeros(1,T-1);
% for ii = 1:T-1;
%     Efac   = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],3), 0 , Range(ii) ,0 ,pi*2);
%     Efac90 = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],3), 0 ,pi/2 ,0 ,pi*2);
%     fig(ii) = Efac/Efac90;
% end 
% plot(Range,fig);

%% Test thor

SIGMA = [ 0 0 0
          0 0 0
          0 0 1];
tic
Efac = Thor.efac(SIGMA, [0 pi/4],'iso', 3);
toc
display(Efac);

%% sum to Make figures in thor paper. 

% tic
% SIGMA = [ 0 0 1
%           0 0 0
%           1 0 2];
% 
% T = 1000;
% A = linspace(pi/(2*T), pi/2, T);
% Efac = zeros(T*3,3);
%       
% for ii = 1:T
%     Efac(ii*3-2:ii*3,:) = Thor.efac(SIGMA, [0 A(ii)],'iso', 3);
% end
% 
% 
% 
% figure, plot(A,Efac(3:3:end,3));
% title('efac33');
% toc
