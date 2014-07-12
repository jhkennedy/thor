function [X,Y,Z] = watsonContourPure( k, PA )
% [X,Y,Z] = watsonContourPure( k, PA ) generates a contoured plot of a
% continuous Watson distribution for the concentration parameter k and
% principle axis PA.
%   PA is the principle axis of the distribution -- a vector in Cartesian
%   space.
% 
%   k is the scalar concentration parameter of the distribution. Positive
%   values specify girdle type distributions, negative values specify
%   single maximum type distributions, and K=0 specifies a uniform
%   distribution. All these distributions are  specified around a primary
%   axis. K must be a scalar value.
%
% watsonCountourPure returns X, Y, and Z which are the grids used to
% contour the plots where X and Y are the xy values of the Cartesian
% projection onto the xy plane and Z is the distribution density at each X
% Y point.  
%
%   see also Thor.ODF.watson, Thor.ODF.watsonGenerate, and
%   Thor.ODF.watsonK.

%% Make plotting Grid
    range = [-1.5,1.5];
    npoints = 200;
    [X,Y] = meshgrid(linspace(range(1),range(2),npoints));

    %% create plot mask (inside shmidt plot circle)
    PLT = X.^2 + Y.^2;
    mask = PLT < 2;
    
    %% get theta and phi and unit vector for every point inside Shmidt plot

    r = sqrt(X.^2 + Y.^2);

    t = 2*asin(r/2);
    t = t(mask);

    p = atan2(Y,X);
    p = p(mask);

    np = size(t,1);
    
    % get unit vector for each point
    v = [sin(t).*cos(p) sin(t).*sin(p) cos(t)];

    %% initialize density matrix
    % set all points to zero density
    Z = X*0;

    
    %% get Watson density at each point
    
    THETA = acos(sum(v.*repmat(PA,np,1),2) );
    Z(mask) = 2*Thor.ODF.watson(k,THETA);
    
    
    %% get outside border points 
    BPHI = linspace(0,2*pi,100);
    BX = sqrt(2)*cos(BPHI);
    BY = sqrt(2)*sin(BPHI);


      %% Plot
    
    % contour intervals
    se = 1/(6*pi);
    lvl = se*(2:2:10);
    
    contourf(X,Y,Z,lvl);
    colormap(greyInv);
%     colorbar('EastOutside')
    axis square;
    axis off;
    line(BX,BY,'LineStyle','-','LineWidth',3,'Color','k');
    caxis([0,lvl(end)]);
    
    
    
function map = greyInv(m)
% greyInv(M) returns an Mx3 colormap that is the opposite of Matlabs built
% in GREY colormap; colormap ranges from what at lowest to black at
% highest. greyInv, by itself, is the same length as the current figures
% colormap. If no figure exists, MATLAB creates one.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
h = sort((0:m-1)'/max(m,1),1,'descend');
if isempty(h)
  map = [];
else
  
  map = [h,h,h];
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


