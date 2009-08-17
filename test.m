close all
clear all


%% Get crystal orientations
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
%     edot = Thor.Utilities.ecdot(SIGMA, [ii ii],[0 pi/2]);
%     display(edot);
% end

%% Integrate over single crystal strain rate

% SIGMA = [ 0 0 0
%           0 0 0
%           0 0 1];
% 
% Efac   = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],[0 pi/4]), 0 ,pi/4 ,0 ,pi*2);
% Efac90 = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],[0 pi/2]), 0 ,pi/2 ,0 ,pi*2);
% 
% display(Efac/Efac90);

%% make fig 3 in thor's paper

SIGMA = [ 0 0 0
          0 0 0
          0 0 1];

T = 100;
Range = 0:(pi/2)/(T-1):pi/2;
fig = zeros(1,T);
      
for ii = 1:T;
    Efac   = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],[0 Range(ii)]), 0 , Range(ii) ,0 ,pi*2);
    Efac90 = dblquad(@(x,y) Thor.Utilities.ecdot(SIGMA, [x y],[0 pi/2]), 0 ,pi/2 ,0 ,pi*2);
    fig(ii) = Efac/Efac90;
end 
%plot(Range,fig);