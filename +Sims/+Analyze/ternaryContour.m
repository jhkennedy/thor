function [ varargout ] = ternaryContour(varargin)
% ternaryContour creates contour plot of eigenvalue data in the valid region of
% a ternary plot.
%   
%       ternaryContour(E) creates ternary contour plot of E.
%           E can be either Mx2 or Mx3 where M is the total number of
%           eigenvalues to plot. E(m,1) and E(m,2) will be the first and second
%           largest eigenvalues respectively. Since E(m,3) = 1-E(m,1)-E(m,2),
%           E(m,3) is optional. The eigenvalue axis are located on the ternary
%           plot as such:
%                   E(:,1)
%                     /\
%                    /  \
%             E(:,3)/____\E(:,2)
%
%           Note: because E(:,1) >= E(:,2) >= E(:,3) and 1==E(:,1)+E(:,2)+E(:,3)
%           only 1/6 of the full equillarteral triangle is used and plotted.
%
%       ternaryContour(AX,E) plots into an axes with handle AX.
%
%       ternaryContour(AX,E,...) can be passed the following
%       property/value pairs:
%           'GCLine' turns on the line that makes the switch from girdle to
%           cluster type distributions. The default value is set to 'off'.
%           
%           'GCLineSpec' is the LineSpec for the girdle-cluster transition line.
%           The default value is '-k'.
%           
%           'GCLineWidth' is the line width for the girdle-cluster transition
%           line. The default value is 2.
%
%           'Contours' is a 1xL vector of density levels to contour. The
%           default value is [0,5,10,20,40,60,80,100] (1x10) where the 100 level
%           corresponds to 100% the maximum point density within the plot. For 
%           example, ternaryContour(AX,E,'Contours', [0,2,4,6,8,10]) will
%           contour the  0, 2, 4, 6, 8, and 10 percent max density levels. 
%
%           'Fcolor' is the background color of the plot. The default value
%           is 'none'.  For example, ternaryContour(AX,E,'Fcolor','white')
%           sets the background color to white.   
%           
%           'Cmap' is the colormap of the contours. The default value is
%           greyInv (white for lowest point density to Black for
%           highest). For example, ternaryContour(AX,E,'Cmap','jet') sets
%           the color map to MATLAB's default colormap: jet. 
%
%           'Cbar' turns on and off a colorbar. The default value is 'off'.
%           For example, ternaryContour(AX,E,'Cbar','on') turns on a colorbar. 
%
%           'CbarLocation' sets the location of the colorbar.  The default
%           value is 'EastOutside'. For example,
%           ternaryContour(AX,E,'CbarLocation','SouthOutside') places a
%           colorbar below the contour plot. Positions follow MATLAB's
%           standard location values. 
%
%           'Npoints' sets the number of points along the X and Y axis of
%           the plot. The total number of points used to make the ternary
%           plot will be Npoints*Npoints. The default value is 200. Using a
%           value of 200 is usually enough for high quality figures.
%
% see also Sims.Analyze.ternaryPoint, colorbar and
%
%   Woodcock, N. H. (1977). 
%   Specification of fabric shapes using an eigenvalue method. 
%   Geological Society Of America Bulletin, 88, 1231–1236.

%% Organize inputs
    % sort arguments and axes
    [cax, args, ~] = axescheck(varargin{:});
    narginchk(1, 20);
    
    % get the data input
    E = args{1};

    % set all the plot options
    [Opt] = options(args);
    varargout{1} = Opt;
    
    % check to see if there is a plot axis
    if isempty(cax)
        % make figure
        h = figure(1); clf(h);
        % set size of figure
        set(h, 'Units','centimeters','OuterPosition', [0 0 10 20]);
        % create axis
        cax = axes('Position', [.1,.1,.8,.8], 'parent',h,'layer','top');
                               %[left, bottom, width, height]
    end
  
    %% Check if E is sized correctly   
    if size(E,2) == 2
        % get E3
        E = [E, 1-sum(E,2)];
        
    elseif size(E,2) == 3 
        % check that E sums to 1
        if any(sum(E,2) < -1e-10)
            error('Sims:Analyze:ternaryPoint:sumE', 'sum(E,2) must equal 1!')
        end
        
        
    else
        error('Sims:Analyze:ternary:sizeE', ['E is an array of eigenvalues! \n',...
              '    E must by either Mx2 or Mx3 where M is the number of \n',...
              '    eigenvalues. E(:,1) is the largest eigenvalue,  \n',...
              '    E(:,2) is the second largest eigenvalue and E(:,3) \n',...
              '    is the smallest eigenvalue. E(:,3) is optional as \n',...
              '    E(:,3) = 1 - E(:,1) - E(:,2). \n',...
              'E was passed as size %g X %g'], size(E,1), size(E,2))
    end
    
    % check E1 > E2 > E3
    if any(E(:,1) < E(:,2)) || any(E(:,2)-E(:,3) < -0.0001)
        error('Sims:Analyze:ternaryPoint:orderE', 'E in wrong order! Order must be: E(:,1) >= E(:,2) >= E(:,3)!')
    end

    %% calculate cartesian points
    X = (1/2)*E(:,1) + E(:,2); % use geometry to convince yourself of these
    Y = sqrt(3)/2*E(:,1);
    
    %% calculate points for girdle-cluster line
    
    switch Opt.GCLine
        case 'on'
            e1all = 1/3:.01:1;
            e2all = e1all*0;
            e2fun = @(e2,e1) e1 -e1^2 -e1*e2 -e2^2;
            for ii = 1:length(e1all)
               e1 = e1all(ii);
               e2f = @(e2) e2fun(e2, e1);
               e2all(ii) = fzero(e2f,(1-e1)/2);
            end

            GCX = (1/2)*e1all + e2all;
            GCY = sqrt(3)/2*e1all;
        case 'off'
            % do nothing
    end
    
    %% Make plotting grid
    xrange = linspace(1/2, (1/2)*(1/2)+(1/2), Opt.Npoints);
    yrange = linspace(sqrt(3)/2*(1/3), sqrt(3)/2, Opt.Npoints);
    [MX, MY] = meshgrid(xrange, yrange);
    
%     [DENS, ~] = hist3([Y,X], {yrange xrange}); %DENS = DENS'; % FIXME: I don't know why.
    
    % make width of probability distributions
    total = length(X);
    if total > 500
        total = 500;
    end
    sx = (xrange(end)-xrange(1))/12;
    sy = (yrange(end)-yrange(1))/12;
    sigmaSquared = 1/total*[sx,0;0,sy];
    
    MZ = MX*0;
    norm = 0;
    maxF = X*0;
    for ii=1:length(X)
        F = mvnpdf([MX(:),MY(:)],[X(ii),Y(ii)],sigmaSquared)*(xrange(2)-xrange(1))*(yrange(2)-yrange(1));
        F = reshape(F,length(xrange),length(yrange));
        norm = norm + trapz(trapz(F));
        maxF(ii) = max(max(F));
        MZ = MZ+F;
    end
    
    % border polygon
    B = [1/2,sqrt(3)/2;...
         1/2,sqrt(3)/2*(1/3);...
         (1/2)*(1/2)+(1/2),sqrt(3)/2*(1/2);...
         1/2,sqrt(3)/2];
    
    % see which points are in border polygon
    [m1, m2] = inpolygon(MX,MY,B(:,1),B(:,2));
    mask = m1 | m2;
    
    % normalize
    MZ(mask) = MZ(mask)/max(maxF);
    
    % remove points outside polygon
    MZ(~mask) = -1;
       
    %% Plot
    
    % contour intervals
     lvl = max(MZ(mask))*Opt.lvl/max(Opt.lvl);
        
    % set the background color of the plot. 
    set(cax,'color',Opt.Fcolor);
        
    % contour the ternary plot
    contourf(cax,MX,MY,MZ,lvl);
%     contourf(cax,MX,MY,MZ);
    
    % set the colormap
    colormap(cax,Opt.Cmap);
    
    % turn off drawing of axis
    axis(cax,'off');
    
    hold(cax,'on');
    
    line = plot(cax,B(:,1),B(:,2),'k-');
    set(line,'LineWidth',3);
    
    % plot the girdle-cluster line
    if Opt.GCLine
        
     GCline = plot(cax, GCX, GCY, Opt.GCLineSpec);
     set(GCline, 'LineWidth',Opt.GCLineWidth);
        
    end
    
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
            lbl = ceil(max(MZ(mask)))*Opt.lvl/max(Opt.lvl);
            for ii = 1:length(lvl)
                Opt.CbarLabels{ii} = num2str(lbl(ii),'%4.1f');
            end
            
            % label the colorbar ticks
            set(cbax,Opt.CbarLabelAxis,Opt.CbarLabels);
            
            % Label the tick axis
            if strcmp(Opt.CbarTickAxis,'YTick')
                ylabel(cbax,'%');
            else
                xlabel(cbax,'%');
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
    
    % options for girdle-cluster transition line
    if any(strcmp(args,'GCLine'))
        Opt.GCLine = args{find(strcmp(args,'GCLine'))+1};
    else
        % set default
        Opt.GCLine = 'off';
    end
    if any(strcmp(args,'GCLineSpec'))
        Opt.GCLineSpec = args{find(strcmp(args,'GCLineSpec'))+1};
    else
        % set default
        Opt.GCLineSpec = '-k';
    end
    if any(strcmp(args,'GCLineWidth'))
        Opt.GCLineWidth = args{find(strcmp(args,'GCLineWidth'))+1};
    else
        % set default
        Opt.GCLineWidth = 2;
    end
    
        %% Contouring options
    if any(strcmp(args,'Npoints'))
        Opt.Npoints = args{find(strcmp(args,'Npoints'))+1};
    else
        % set default
        Opt.Npoints = 200;
    end
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


