%% Test recode

close all, clear all, clc
load in

[NAMES, SET] = Thor.setup(in, 1337);
cdist = load('./+Thor/CrysDists/Run1337/EL000000001');

Thor.step(NAMES, SET, 1337, 1, 0 );

% check point: vec
cp1 = Thor.Utilities.vec(cdist, SET, 1);

% check point: disl
cp2 = Thor.Utilities.disl(cp1, SET, 1); 

% check point: grow
cp3 = Thor.Utilities.grow(cp2, SET, 1, 1);

% check point: poly
cp4 = Thor.Utilities.poly(cp3, SET, 1);

% check for migration recrystallization
cp5 = Thor.Utilities.migre(cp4, SET, 1);

% check crystal orientation bounds
cp6 = Thor.Utilities.bound(cp5);

% calculate new velocity gradients and crystal strain rates -- from poly and migre
cp7 = Thor.Utilities.vec( cp6, SET, 1);

% rotate the crstals from last time steps calculations
cp8 = Thor.Utilities.rotate(cp7, SET );

cstep = load('./+Thor/CrysDists/Run1337/EL000000001');


%% Test Thor 2001 results

% % figure 3
%
% matlabpool
% 
% try
% 
% load +Thor/+Build/initial.mat
% 
% 
% A = linspace(pi/200, pi/2);
% Ao = zeros(1,100);
% in.disangles = [Ao', A'];
% stress = [0, 0, 0; 0, 0, 0; 0, 0, 1];
% in.stress = repmat(stress, [1 1 in.nelem]);
% in.glenexp = ones(in.nelem,1)*3;
%     
% 
%     tic; [CONN, NAMES, SETTINGS] = Thor.setup(in); toc
%     
%     
%     edot = zeros(3,3,in.nelem);
%     for ii = 1:in.nelem
%         tmp = load(['./+Thor/CrysDists/' NAMES.files{ii}]);
%         edot(:,:,ii) = Thor.Utilities.bedot(tmp.(NAMES.files{ii}), SETTINGS);
%     end
%     
%     toc
%     
%     edot = edot./(edot(3,3,in.nelem));
%     edot(isnan(edot)) = 0;
% %     edot(abs(edot)<=.000025) = 0;
%     
%     plot(A*180/pi,edot(9:9:end))
%     title('Bulk strain rate enhancement for uniaxial compression');
%     xlabel('Cone Angle (degrees)')
%     ylabel('Enhancement Factor')
% 
%     matlabpool close
%     toc
%     
% catch ME
%     matlabpool close
%     toc
%     rethrow(ME);
% 
% end

%% Test Thor 2002 results
% 
% % see if a time step works
% 
% try
%    
%     close all; clear all;
% 
%     h = waitbar(0, 'Initializing . . .');
%     timesteps = 10;
%     
%     tic;
%     matlabpool;
%     
%     pltcrys = 1;%randi(100,1,1);
%     
%      load +Thor/+Build/initial.mat
%     
%     in.T = in.T - 15;
%     in.soft = [1,1];
%     
%     [CONN, NAMES, SET] = Thor.setup(in); toc
%     
%     cdist1 = load(['./+Thor/CrysDists/Run' num2str(0) '/' NAMES.files{pltcrys}]);
%     
%     waitbar(0, h, 'Calculating...');
%     
%     for ii=1:timesteps
%     [ CONN, NAMES, SET ] = Thor.step(CONN, NAMES, SET, 0 ); toc
%     waitbar(ii/timesteps, h);
%     end
%     
%     cdist2 = load(['./+Thor/CrysDists/Run' num2str(0) '/' NAMES.files{pltcrys}]);
%         
%     matlabpool close;
%     
%     close(h);
%     
%     plottest
%     
% catch ME
%     matlabpool close;
%     toc;
%     rethrow(ME);
%     
% end
