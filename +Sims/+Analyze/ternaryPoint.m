function [ varargout ] = ternaryPoint(varargin)
% ternaryPoint creates point plot of eigenvalue data in the valid region of a
% ternary plot. 
%   
%       ternaryPoint(E) creates ternary point plot of E.
%           E can be either Mx2 or Mx3 where M is the total number of
%           eigenvalues to plot. E(m,1) and E(m,2) will be the first and second
%           largest eigenvalues respectively. Since E(m,3) = 1-E(m,1)-E(m,2),
%           E(m,3) is optional.   
%
%       ternaryPoint(AX,E) plots into an axes with handle AX.
%
%       ternaryPoint(AX,E,...) can be passed the following
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
%           'Fcolor' is the background color of the plot. The default value
%           is 'none'.  For example, ternaryPoint(AX,E,'Fcolor','white')
%           sets the background color to white.   
%           
%           'Marker' is the marker specifier for the eigenvalue points. The
%           defualt value is '.'.
%
%           'MarkerSize' is the size of the point marker. The default value is
%           6. 
%
%           'MarkerEdgeColor' is the edge color of the point marker. The default
%           value is 'b'.
%
%           'MarkerFaceColor' is the face color of the point marker. The default
%           value is 'b'.
%
% see also Sims.Analyze.ternaryContour and colorbar 

%% Organize inputs
    % sort arguments and axes
    [cax, args, ~] = axescheck(varargin{:});
    narginchk(1, 14);
    
    % get the data input
    E = args{1};

    % set all the plot options
    [Opt] = options(args);
    
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
    if any(E(:,1) - E(:,2) < -0.0001) || any(E(:,2)-E(:,3) < -0.0001)
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
       
    %% Plot
    
    % set the background color of the plot. 
    set(cax,'color',Opt.Fcolor);
        
    % turn off drawing of axis
    axis(cax,'off');
    
    hold(cax,'on');
    
    % plot border
    B = [1/2,sqrt(3)/2;...
         1/2,sqrt(3)/2*(1/3);...
         (1/2)*(1/2)+(1/2),sqrt(3)/2*(1/2);...
         1/2,sqrt(3)/2];
    line = plot(cax,B(:,1),B(:,2),'k-');
    set(line,'LineWidth',3);
    
    % plot the girdle-cluster line
    switch Opt.GCLine
        case 'on'

             GCline = plot(cax, GCX, GCY, Opt.GCLineSpec);
             set(GCline, 'LineWidth',Opt.GCLineWidth)
        case 'off'
        % do nothing
    end
    
    % plot points
    plot(cax, X, Y, Opt.Marker, 'MarkerSize', Opt.MarkerSize,'MarkerEdgeColor', Opt.MarkerEdgeColor,'MarkerFaceColor', Opt.MarkerFaceColor)
    set(cax, 'XLim',[1/2,(1/2)*(1/2)+(1/2)],'YLim',[sqrt(3)/2*(1/3),sqrt(3)/2])
    
    hold(cax,'off');
       
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
    if any(strcmp(args,'Marker'))
        Opt.Marker = args{find(strcmp(args,'Marker'))+1};
    else
        % set default
        Opt.Marker = '.';
    end
    if any(strcmp(args,'MarkerSize'))
        Opt.MarkerSize = args{find(strcmp(args,'MarkerSize'))+1};
    else
        % set default
        Opt.MarkerSize = 6;
    end
    if any(strcmp(args,'MarkerEdgeColor'))
        Opt.MarkerEdgeColor = args{find(strcmp(args,'MarkerEdgeColor'))+1};
    else
        % set default
        Opt.MarkerEdgeColor = 'b';
    end
    if any(strcmp(args,'MarkerFaceColor'))
        Opt.MarkerFaceColor = args{find(strcmp(args,'MarkerFaceColor'))+1};
    else
        % set default
        Opt.MarkerFaceColor = 'b';
    end
    
    % options for girdle-cluster transition line
    if any(strcmp(args,'GCLine'))
        Opt.GCLine = args{find(strcmp(args,'GCLine'))+1};
    else
        % set default
        Opt.GCLine = false;
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
        Opt.GCLineWidth = 3;
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


