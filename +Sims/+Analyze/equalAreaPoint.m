function [ varargout ] = equalAreaPoint( varargin )
% equalAreaPoint creates an Equal Area Point Plot (Schmidt Point Plot) of
% data on the upper hemesphere if the unit circle. The data is projected
% onto a circle of radius sqrt(2) on the x-y plane.  
%   
%       equalAreaPoint(N) makes a equal area point plot of N. N is an array
%       of C-axis orientation unit vectors given in either Polar or
%       Cartesian form.  
%           For Polar: N must be size Mx2 where M is the number of crystals
%           in the distrobution. Each row must be given as [THETA, PHI]
%           where THETA is the colatitude or zenith angle (in radians) and
%           PHI is the longitude or azumith angle (in radians) of the
%           orientation vector.    
%
%           For Cartesian: N must be size Mx3 where M is the number of
%           crystals in the distrobution. Each row must be given as [X, Y ,
%           Z] where X, Y, Z are the catesian components of the orientation
%           vector.   
%
%       equalAreaPoint(N,...) can also be passed many of the normal plot
%       function PropertyName/PropertyValue pairs (equalAreaPoint does not
%       handle linespec specifiers!). Valid PropertyNames are:
%               Marker
%               MarkerSize
%               MarkerEdgeColor
%               MarkerFaceColor
%               BorderLineColor
%               BorderLineWidth
%               BackgroundColor
%               
%           There are additional, non-standard properties that can be
%           customized: 
%               'Grid' turns on latitude and longitude grid lines.
%               PropertyValue is either True or False.
%                   equalAreaPoint(N,'Grid',True) 
%               'GridLongs' is the number of logitudinal lines. The default
%               property value is 10.
%               'GridLats' is the number of latitudinal lines. The defualt
%               property value is 10.
%               'GridLineStyle' is the style of the grid lines. The defualt
%               property value is ':k'
%               'GridLineWidth' is the width of the grid lines. The defualt
%               property value is 0.5
%               'GridMarkerSize' is the size of the grid markers. The
%               defualt property value is 6
%               'GridMarkerEdgeColor' is the color of the grid marker
%               edges. The defualt property value is 'k'
%               'GridMarkerFaceColor' is the color of the grid marker
%               edges. The defualt property value is 'k'
%
%       [P] = equalAreaPoint(N,...) returns an Mx2 array of the XY
%       coordinates of each crystal in the equal area point plot as well as
%       plotting them.  
%
% see also Sims.Analyze.equalAreaContour

    %% Parse input arguments
    [cax, args, ~] = axescheck(varargin{:});
    narginchk(1, 15);
    
    % get the data input
    N = args{1};
    
    %% set all options
    [Marker, MarkerSize, MarkerEdgeColor, MarkerFaceColor,...
     BorderLineColor, BorderLineWidth, BackgndColor,...
     Grid, GridLongs, GridLats, GridLineStyle, GridLineWidth,...
     GridMarkerSize, GridMarkerEdgeColor, GridMarkerFaceColor,...
    ] = options(args);

    
    %% Check if N is polar or cartesian
    if size(N,2) == 2
        cord = 'polar';
    elseif size(N,2) == 3
        cord = 'cartesian';
    else
        error('Sims:Analyze:EqualAreaPoint:sizeN', ['N is the array of C-axis',...
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
            HXY = sqrt(N(:,1).^2+N(:,2).^2);
            THETA = atan2(HXY,N(:,3));
            PHI   = atan2(N(:,2),N(:,1));
            
            % check angles are within allowed bounds 
            % (0 <= THETA <= pi/2, 0 <= PHI <= 2*pi)
                % THETA < 0 -- flip to positive theta and rotate PHI by pi
                PHI(THETA < 0) = PHI(THETA < 0) + pi;
                THETA(THETA < 0) = abs(THETA(THETA < 0));
            
                % THETA > pi/2 -- use `other end' of c-axis (symetric: can't
                % tell which side is which) 
                PHI(THETA > pi/2) = PHI(THETA > pi/2) + pi;
                THETA(THETA > pi/2) = pi - THETA(THETA > pi/2);

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
    
    
    %% Plot Background, boundary, and grid
    
    % prepare the plot axis
    cax = newplot(cax);
    hold(cax,'on');
    
    % create sines and cosines for lats and longs
    RPHI = linspace(0,2*pi,100);
    RX = cos(RPHI);
    RY = sin(RPHI);
    
    
    % fill plot background
    patch(sqrt(2)*RX,sqrt(2)*RY,BackgndColor, 'parent', cax)
    % draw boundry line
    line(sqrt(2)*RX,sqrt(2)*RY,'LineStyle','-','LineWidth',BorderLineWidth,'Color',BorderLineColor,'parent', cax)
    
    % draw grid
    if Grid
        % Latitude lines
        GT = linspace(0,pi/2,GridLats+2);
        GLatR = 2*sin(GT/2);
        for ii = 2:GridLats+1
            plot(GLatR(ii)*RX,GLatR(ii)*RY,GridLineStyle,'LineWidth',GridLineWidth,...
                 'MarkerSize',GridMarkerSize,'MarkerEdgeColor',GridMarkerEdgeColor,...
                 'MarkerFaceColor',GridMarkerFaceColor,'parent', cax)
        end
        
        % Longitude lines
        GP = linspace(0,2*pi,GridLongs+2);
        
        RTHETA1 = linspace(-pi/2,-GT(2),100);
        RTHETA2 = linspace(GT(2),pi/2,100);
        RR1 = 2*sin(RTHETA1/2);
        RR2 = 2*sin(RTHETA2/2);
        
        for ii = 1:GridLongs+1
            plot(RR1*cos(GP(ii)),RR1*sin(GP(ii)),GridLineStyle,'LineWidth',GridLineWidth,...
                 'MarkerSize',GridMarkerSize,'MarkerEdgeColor',GridMarkerEdgeColor,...
                 'MarkerFaceColor',GridMarkerFaceColor,'parent', cax)
             plot(RR2*cos(GP(ii)),RR2*sin(GP(ii)),GridLineStyle,'LineWidth',GridLineWidth,...
                 'MarkerSize',GridMarkerSize,'MarkerEdgeColor',GridMarkerEdgeColor,...
                 'MarkerFaceColor',GridMarkerFaceColor,'parent', cax)
        end
        
    end
    
    %% Plot the orientation points
    
    plot(X,Y,Marker, 'MarkerSize',MarkerSize,'MarkerEdgeColor',MarkerEdgeColor,'MarkerFaceColor',MarkerFaceColor,'parent', cax)
    
     
    %% clean up look of plot
    axis square
    axis off
    hold(cax, 'off')
    
    
    %% Output arguments
    
    if nargout >= 1
        varargout(1) = {[ X , Y ]};
    end
    
end


function [Marker, MarkerSize, MarkerEdgeColor, MarkerFaceColor,...
          BorderLineColor, BorderLineWidth, BackgndColor,...
          Grid, GridLongs, GridLats, GridLineStyle, GridLineWidth,...
          GridMarkerSize, GridMarkerEdgeColor, GridMarkerFaceColor...
         ] = options(args)

    %% Options for plotting the data
        if any(strcmp(args,'Marker'))
            Marker = args{find(strcmp(args,'Marker'))+1};
        else
            Marker = '.';
        end
        if any(strcmp(args,'MarkerSize'))
            MarkerSize = args{find(strcmp(args,'MarkerSize'))+1};
        else
            MarkerSize = 6;
        end
        if any(strcmp(args,'MarkerEdgeColor'))
            MarkerEdgeColor = args{find(strcmp(args,'MarkerEdgeColor'))+1};
        else
            MarkerEdgeColor = 'b';
        end
        if any(strcmp(args,'MarkerFaceColor'))
            MarkerFaceColor = args{find(strcmp(args,'MarkerFaceColor'))+1};
        else
            MarkerFaceColor = 'b';
        end

    %% Options for the border
        if any(strcmp(args,'BorderLineColor'))
            BorderLineColor = args{find(strcmp(args,'BorderLineColor'))+1};
        else
            BorderLineColor = 'k';
        end
        if any(strcmp(args,'BorderLineWidth'))
            BorderLineWidth = args{find(strcmp(args,'BorderLineWidth'))+1};
        else
            BorderLineWidth = 3;
        end

    %% Option for the Background color
        if any(strcmp(args,'BackgoundColor'))
            BackgndColor = args{find(strcmp(args,'BackgroundColor'))+1};
        else
            BackgndColor = 'w';
        end        

    %% Option for plotting the grid
        if any(strcmp(args,'Grid'))
            Grid = args{find(strcmp(args,'Grid'))+1};
        else
            Grid = false;
        end    

        % Number of Longs and Lats    
        if any(strcmp(args,'GridLongs'))
            GridLongs = args{find(strcmp(args,'GridLongs'))+1};
        else
            GridLongs = 10;
        end
        
        if any(strcmp(args,'GridLats'))
            GridLats = args{find(strcmp(args,'GridLats'))+1};
        else
            GridLats = 10;
        end

        if any(strcmp(args,'GridLineStyle'))
            GridLineStyle = args{find(strcmp(args,'GridLineStyle'))+1};
        else
            GridLineStyle = ':k';
        end
        
        if any(strcmp(args,'GridLineWidth'))
            GridLineWidth = args{find(strcmp(args,'GridLineWidth'))+1};
        else
            GridLineWidth = 0.5;
        end
        
        if any(strcmp(args,'GridMarkerSize'))
            GridMarkerSize = args{find(strcmp(args,'GridMarkerSize'))+1};
        else
            GridMarkerSize = 6;
        end
        
        if any(strcmp(args,'GridMarkerEdgeColor'))
            GridMarkerEdgeColor = args{find(strcmp(args,'GridMarkerEdgeColor'))+1};
        else
            GridMarkerEdgeColor = 'k';
        end
        
        if any(strcmp(args,'GridMarkerFaceColor'))
            GridMarkerFaceColor = args{find(strcmp(args,'GridMarkerFaceColor'))+1};
        else
            GridMarkerFaceColor = 'k';
        end

end

% remember to add 2 to the total number of inputs

% if any(strcmp(args,''))
%         Opt. = args{find(strcmp(args,''))+1};
%     else
%         % set default
%         Opt. = ;
%     end




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


