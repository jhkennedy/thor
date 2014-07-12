function seeMRSS(stress, Opt)

range = [-1.5, 1.5];
[X,Y] = meshgrid(linspace(range(1),range(2),500));
PLT = X.^2 + Y.^2;
mask = PLT < 2;
Z = X*0; ZR1 = X*0; ZR2 = X*0; ZR3 = X*0;
r = sqrt(X.^2 + Y.^2);
t = 2*asin(r/2);
t = t(mask);
p = atan2(Y,X);
p = p(mask);
np = size(t,1);
cdist.theta = t;
cdist.phi = p;
[ cdist, R1, R2, R3 ] = Thor.Utilities.shmidt( cdist, np, stress );
Z(mask) = cdist.MRSS;
ZR1(mask) = R1;
ZR2(mask) = R2;
ZR3(mask) = R3;

% get outside border points 
BPHI = linspace(0,2*pi,500);
BX = sqrt(2)*cos(BPHI);
BY = sqrt(2)*sin(BPHI);


% make figure
h = figure; clf(h);
% set size of figure
set(h, 'Units','centimeters','OuterPosition', [0 0 20 20]);
% create axis
cax = axes('Position', [.1,.1,.8,.8], 'parent',h,'layer','top');
                               %[left, bottom, width, height]
                               
% set the background color of the plot. 
set(cax,'color','default');

% set the relative contouring levels
lvl = 0:.1:1;

switch Opt
    case 'MRSS'
        caxMax = max(max(Z));
        contourf(cax,X,Y,Z,lvl*caxMax);
    case 'R1'
        caxMax = max(max(ZR1));
        contourf(cax,X,Y,ZR1,lvl*max(ZR1));
    case 'R2'
        caxMax = max(max(ZR2));
        contourf(cax,X,Y,ZR2,lvl*max(ZR2));
    case 'R3'
        caxMax = max(max(ZR3));
        contourf(cax,X,Y,ZR3,lvl*max(ZR3));
end

% set the colormap
colormap(cax, greyInv);

% set axis scaling ratio to 1:1 and turn off drawing of axis
axis(cax,'square');
axis(cax,'off');

% plot outside border line
hold(cax,'on');
line = plot(cax,BX,BY,'k-');
set(line,'LineWidth',3);
hold(cax,'off');

% colorbar
caxis(cax,[-.001,caxMax]);
cbax = colorbar('peer',cax,'SouthOutside');



end


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


