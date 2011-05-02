function [ varargout ] = equalAreaPoint( N, varargin )
% equalAreaPoint creates an Equal Area Point Plot (Schmidt Point Plot) 
%   
%       equalAreaPoint(N) makes a equal area point plot of N. N is an array of
%       C-axis orientation unit vectors given in either Polar or Cartesian form. 
%           For Polar: N must be size Mx2 where M is the number of crystals in
%           the distrobution. Each row must be given as [THETA, PHI] where THETA
%           is the colatitude or zenith angle (in radians) and PHI is the
%           longitude or azumith angle (in radians) of the orientation vector.
%
%           For Cartesian: N must be size Mx3 where M is the number of crystals
%           in the distrobution. Each row must be given as [X, Y , Z] where X,
%           Y, Z are the catesian components of the orientation vector.
%
%       equalAreaPoint(N,...) can also be passed all the normal plot function
%       LineSpec and PropertyName/PropertyValue pairs. 
%           For example, equalAreaPoint(N,'.r') plots red dots for each point. 
%
%       [P] = equalAreaPoint(N,...) returns an Mx2 array of the XY coordinates
%       of each crystal in the equal area point plot as well as plotting them.
%
% see also plot, Thor.Utilities.equalAreaContour, Thor.Utilities.equalAnglePoint, Thor.Utilities.equalAngleContour
%          

    %% Check if N is polar or cartesian
    if size(N,2) == 2
        cord = 'polar';
    elseif size(N,2) == 3
        cord = 'cartesian';
    else
        error('Utilities:EqualAreaPlot:sizeN', ['N is the array of C-axis',...
              'orientation vectors given in either Polar or Catesian form.\n',...
              '    For Polar: N must be size Mx2 where M is the number of ',...
              'crystal in the dirstobution.\n \n',...
              '    For Cartesian: N must be size Mx3 where M is the number of ',...
              'crystal in the dirstobution.\n \n',...
              'N was passed as size %g X %g'], size(N,1), size(N,2))
    end

    %% Get THETA and PHI
    switch cord
        case 'polar'
            THETA = N(:,1);
            PHI   = N(:,2);
        case 'cartesian'
            
            % calculate polar angles
            THETA = atan2(N(:,2),N(:,1));
            PHI   = acos(N(:,3));
            
            % check angles are within allowed bounds 
            % (0 <= THETA <= pi/2, 0 <= PHI <= 2*pi)
                % THETA > pi/2 -- use `other end' of c-axis (symetric: can't
                % tell which side is which) 
                PHI(THETA > pi/2) = PHI(THETA > pi/2) + pi;
                THETA(THETA > pi/2) = pi - THETA(THETA > pi/2);

                % THETA < 0 -- flip to positive theta and rotate PHI by pi
                PHI(THETA < 0) = PHI(THETA < 0) + pi;
                THETA(THETA < 0) = abs(THETA(THETA < 0));

                % make sure PHI is within bounds
                PHI = rem(PHI +2*pi, 2*pi);
    end
    
    %% Transform to eqaul area coordinates
    RHO = 2*sin(THETA/2);
    
    X = RHO.*cos(PHI);
    Y = RHO.*sin(PHI);
    
    % See: 
    % ﻿Durand, G., Gagliardini, O., Thorsteinsson, T., Svensson, A., Kipfstuhl,
    % J., & Dahl-jensen, D. (2006). Ice microstructure and fabric: an up to date
    % approach to measure textures. Journal of Glaciology, 52(179), 619-630.  
    
    %% Make  Schmidt Plot
    
    % plot cirucular outside boundry
    rectangle('position',[-sqrt(2),-sqrt(2),2*sqrt(2),2*sqrt(2)],...
              'curvature',[1,1],'linestyle','-','edgecolor','k','LineWidth',3,...
              'FaceColor','w');
    hold on;
    
    % plot the orientation points - varargin passes plot optional arguments
    if nargin == 1
        plot(X,Y, '.');
    else
        plot(X,Y,varargin{:});
    end
    
          
    % make plot look pretty
    axis square;
    axis off;
    
    %% Output arguments
    if nargout >= 1
        varargout(1) = {[ X , Y ]};
    end
    
    
end

