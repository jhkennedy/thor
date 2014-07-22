function [h, cax, cbax] = equalAreaContour(varargin)
% equalAreaContour creates an Equal Area Contour Plot (Schmidt Contour
% Plot) of data on the upper hemesphere of the unit circle. The data is
% projected onto a circle of radius sqrt(2) on the x-y plane.   
%   
%       equalAreaContour(N) makes a equal area contour plot of N. N is an
%       array of C-axis orientation unit vectors given in either Polar or
%       Cartesian form.
%           For Polar: N must be size Mx2 where M is the number of crystals
%           in the distrobution. Each row must be given as [THETA, PHI]
%           where THETA is the colatitude or zenith angle (in radians) and
%           PHI is the longitude or azumith angle (in radians) of the
%           orientation vector.    
%
%           For Cartesian: N must be size Mx3 where M is the number of
%           crystals in the distrobution. Each row must be given as [X, Y,
%           Z] where X, Y, Z are the catesian components of the orientation
%           vector.   
%
%       equalAreaContour(AX,N) plots into an axes with handle AX.
%
%       equalAreaContour(AX,N,...) can be passed the following
%       property/value pairs:
%           'Contours' is a 1xL vector of Sigma levels to contour. The
%           default value is [0,2,4,8,10,20,40,60,80,100] (1x10). For
%           example, equalAreaContour(AX,N,'Contours', [0,2,4,6,8,10]) will
%           contour the  0, 2, 4, 6, 8, and 10 Sigma level deviations from
%           isotropic. 
%
%           'Fcolor' is the background color of the plot. The default value
%           is 'none'.  For example, equalAreaContour(AX,N,'Fcolor','white')
%           sets the background color to white.   
%           
%           'Cmap' is the colormap of the contours. The default value is
%           greyInv (white for lowest Sigma variation to Black for
%           highest). For example, equalAreaContour(AX,N,'Cmap','jet') sets
%           the color map to MATLAB's default colormap: jet. 
%
%           'Cbar' turns on and off a colorbar. The default value is 'off'.
%           For example, equalAreaContour(AX,N,'Cbar','on') turns on a
%           colorbar. 
%
%           'CbarLocation' sets the location of the colorbar.  The default
%           value is 'EastOutside'. For example,
%           equalAreaContour(AX,N,'CbarLocation','SouthOutside') places a
%           colorbar below the contour plot. Positions follow MATLAB's
%           standard location values. 
%
%           'Npoints' sets the number of points along the X and Y axis of
%           the plot. The total number of points used to make the schmidt
%           plot will be Npoints*Npoints. The default value is 50. Using a
%           value of 200 is usually enough for high quality figures.
%
% see also Sims.Analyze.eualAreaPoint, Sims.Analyze.ternary and colorbar 


%% Organize inputs
    % sort arguments and axes
    [cax, args, ~] = axescheck(varargin{:});
    narginchk(1, 14);
    
    % get the data input
    N = args{1};

    % set all the plot options
    [Opt] = options(args);
    
    % check to see if there is a plot axis
    if isempty(cax)
        % make figure
        h = figure(1); clf(h);
        % set size of figure
        set(h, 'Units','centimeters','OuterPosition', [0 0 20 20]);
        % create axis
        cax = axes('Position', [.1,.1,.8,.8], 'parent',h,'layer','top');
                               %[left, bottom, width, height]
    end
  
    %% Check if N is polar or cartesian    
    if size(N,2) == 2
        % get cartesian form
        N   = [sin(N(:,1)).*cos(N(:,2)) sin(N(:,1)).*sin(N(:,2)) cos(N(:,1))];
        
     elseif size(N,2) ~= 3 
         
        error('Sims:Analyze:EqualAreaContour:sizeN', ['N is the array of C-axis',...
              'orientation vectors given in either Polar or Catesian form.\n',...
              '    For Polar: N must be size Mx2 where M is the number of ',...
              'crystal in the dirstobution.\n \n',...
              '    For Cartesian: N must be size Mx3 where M is the number of ',...
              'crystal in the dirstobution.\n \n',...
              'N was passed as size %g X %g'], size(N,1), size(N,2))
     end
   
    % number of crystals
    n = size(N,1);
    %% Make plotting Grid
    range = [-1.5,1.5];
    [X,Y] = meshgrid(linspace(range(1),range(2),Opt.Npoints));

    %% create plot mask (inside shmidt plot circle)
    PLT = X.^2 + Y.^2;
    mask = PLT < 2;
    %% initialize density matrix
    % set all points to zero density
    Z = X*0;
    
    %% get outside border points 
    BPHI = linspace(0,2*pi,100);
    BX = sqrt(2)*cos(BPHI);
    BY = sqrt(2)*sin(BPHI);
    
    %% get theta and phi for every point inside shmidt plot

    r = sqrt(X.^2 + Y.^2);

    t = 2*asin(r/2);
    t = t(mask);

    p = atan2(Y,X);
    p = p(mask);

    np = size(t,1);
    %% for every crystal get GT value at each point
    % T Thorsteinsson, E Waddington, L Wilen; A standardized approach to
    % extraction of fabric information from thin sections. Unpublished.
    % (likely to be in Journal of Glaciology) 
   
    % get unit vector for each point
    v = [sin(t).*cos(p) sin(t).*sin(p) cos(t)];
    
    % initialize density values
    G = zeros(np,1); %
        
    % get distribution width
    OmSq = 9/(18+2*n); % 
    % get distribution normalization
    x  = 0:.01:pi/2;
    gu = exp( -x.^2/(2*OmSq) );
    c = 2*pi*trapz(x,gu.*sin(x));
    
    % build total density values at each point from each crystal disro. 

%     % tried to vectorize... makes it twice as slow bc of large memory req.
%     v = permute(repmat(v,[1,1,n]),[1,3,2]);
%     N  = permute(repmat(N,[1,1,np]),[3,1,2]);
%     
%     b  = acos( sum(v.*N ,3) );
%     b2 = acos( sum(v.*-N,3) );
%     
%     G  = sum( (exp( -b.^2/(2*OmSq)) + exp( -b2.^2/(2*OmSq)) )/c ,2);
   
    for ii = 1:n
        % get great cirle distance at each point (just theta as unit vectors)
        b = acos(sum( v.*repmat(N(ii,:),np,1),2) );
        b2 = acos(sum( v.*repmat(-N(ii,:),np,1),2) );
        % get inividual crystal distros
        g = (exp( -b.^2/(2*OmSq)) + exp( -b2.^2/(2*OmSq)) )/c;
        % build total density
        G = G + g;
        
    end

% set values and normalize G
Z(mask) = G/n; 
% set all points outside plot to -1 so contours don't plot outside border
Z(~mask)= -1;
    
    %% Plot
  
    % contour invervals
    se = 1/(6*pi);
    lvl = se*Opt.lvl;
    
    % set the background color of the plot. 
    set(cax,'color',Opt.Fcolor);
    
    % contour the schmidt plot
    contourf(cax,X,Y,Z,lvl);
    
    % set the colormap
    colormap(cax,Opt.Cmap);
    
    % set axis scaling ratio to 1:1 and turn off drawing of axis
    axis(cax,'square');
    axis(cax,'off');
    
    hold(cax,'on');
    line = plot(cax,BX,BY,'k-');
    set(line,'LineWidth',3);
    hold(cax,'off');
    
    caxis(cax,[-.001,lvl(end)]);
    
    % set up color bar 
    switch Opt.Cbar
        case 'on'
            % make colorbar and set location
            cbax = colorbar('peer',cax,Opt.CbarLocation);
            
            % set the colorbar tick values
%             display(Opt.CbarTickAxis);
%             display(lvl);
            set(cbax, Opt.CbarTickAxis,lvl);
            
            % make the colorbar labels
            for ii = 1:length(lvl)
                Opt.CbarLabels{ii} = num2str(Opt.lvl(ii),'%4.2f');
            end
            
            % label the colorbar ticks
            set(cbax,Opt.CbarLabelAxis,Opt.CbarLabels);
            
            % Label the tick axis
            if strcmp(Opt.CbarTickAxis,'YTick')
                ylabel(cbax,'\sigma');
            else
                xlabel(cbax,'\sigma');
            end
            
        case 'off'
            % do nothing
    end   
end

function [Opt] = options(args) % remember to change nargs in error check
    %% figure options

    % figure background color
    if any(strcmp(args,'Fcolor'))
        Opt.Fcolor = args{find(strcmp(args,'Fcolor'))+1};
    else
        % set default
        Opt.Fcolor = 'default';
    end
    
    if any(strcmp(args,'Npoints'))
        Opt.Npoints = args{find(strcmp(args,'Npoints'))+1};
    else
        % set default
        Opt.Npoints = 50;
    end

    %% Contouring options
        
    % set the contouring levels
    if any(strcmp(args,'Contours'))
        Opt.lvl = args{find(strcmp(args,'Contours'))+1};
    else
        % set default
        Opt.lvl = [0,2,4,8,10,20,40,60,80,100];
    end
    
    
    % colormap
    if any(strcmp(args,'Cmap'))
        Opt.Cmap = args{find(strcmp(args,'Cmap'))+1};
    else
        % set default
        Opt.Cmap = greyInv;
    end
    
    % colorbar on or off
    if any(strcmp(args,'Cbar'))
        Opt.Cbar = args{find(strcmp(args,'Cbar'))+1};
    else
        % set default
        Opt.Cbar = 'off';
    end
    
    % colorbar Location
    if any(strcmp(args,'CbarLocation'))
        Opt.CbarLocation = args{find(strcmp(args,'CbarLocation'))+1};
        Opt.CbarLabels = cell(size(Opt.lvl));
        if any(strfind(lower(Opt.CbarLocation),'east'))
            Opt.CbarLabelAxis = 'YTickLabel';
            Opt.CbarTickAxis = 'YTick';
        elseif any(strfind(lower(Opt.CbarLocation),'west'))
            Opt.CbarLabelAxis = 'YTickLabel';
            Opt.CbarTickAxis = 'YTick';
        else
            Opt.CbarLabelAxis = 'XTickLabel';
            Opt.CbarTickAxis = 'XTick';
        end
    else
        % set default
        Opt.CbarLocation = 'EastOutside';
        Opt.CbarLabels = cell(size(Opt.lvl));
        Opt.CbarLabelAxis = 'YTickLabel';
        Opt.CbarTickAxis = 'YTick';
    end

end

% remember to add 2 to the total number of inputs

% if any(strcmp(args,''))
%         Opt. = args{find(strcmp(args,''))+1};
%     else
%         % set default
%         Opt. = ;
%     end

function map = greyInv(m)
% greyInv(M) returns an Mx3 colormap that is the oposite of Matlabs built in GREY
% colormap; colormap ranges from what at lowest to black at highest.
% greyInv, by itself, is the same lenth as the current figures colormap. If
% no figure exisits, MATLAB creates one.

    if nargin < 1, m = size(get(gcf,'colormap'),1); end
    h = sort((0:m-1)'/max(m,1),1,'descend');
    if isempty(h)
      map = [];
    else

      map = [h,h,h];
    end
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


