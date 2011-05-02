function [ varargout ] = cdistPlot( RUN, EL, STEPS, varargin )
% cdistPlot plots equal area point plots of the crystal distrobutions for a
% specified model run
%
%   cdistPlot(RUN, EL, STEPS) plots the top and bottom crystal distrobution for
%   run RUN and element EL at each saved step in STEPS. RUN and EL are numbers,
%   and STEPS is vector of saved steps.


    % load in the mask for the layers
    load +Param/Results/ExploreParam2011Jan7/exploreResults.mat eigenMask
    
    % cell array of possible plot colors
    clr = {'.k','.b','.g','.r','.c','.m','.y'};
    
    % in new figure window, plot the middle layers points for each step
    figure;
    for ii = 1:max(size(STEPS))
        % load in crystal distrobution
        cdist = load(['+Param/Results/ExploreParam2011Jan7/Run',num2str(RUN),...
                      '/Step',num2str(STEPS(ii),'%05.0f'),'_EL',...
                      num2str(EL,'%09.0f'),'.mat']);
        
        % plot middle layer
        equalAreaPoint([cdist.theta(eigenMask(:,2)), cdist.phi(eigenMask(:,2))],varargin{:},clr{rem(ii,size(clr,2))+1});
        title('Middle');
        hold on;
    end
    
    figure;
    for ii = 1:max(size(STEPS))
        % load in crystal distrobution
        cdist = load(['+Param/Results/ExploreParam2011Jan7/Run',num2str(RUN),...
                      '/Step',num2str(STEPS(ii),'%05.0f'),'_EL',...
                      num2str(EL,'%09.0f'),'.mat']);

        % plot top layer
        equalAreaPoint([cdist.theta(eigenMask(:,1)), cdist.phi(eigenMask(:,1))],varargin{:},clr{rem(ii,size(clr,2))+1});
        title('Top');
        hold on;
    end

end

