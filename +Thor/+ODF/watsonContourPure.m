function [X,Y,Z] = watsonContourPure( k, PA )
% PA = principle axis
% k = concentration parameter

%% Make plotting Grid
    range = [-1.5,1.5];
    npoints = 200;
    [X,Y] = meshgrid(linspace(range(1),range(2),npoints));

    %% create plot mask (inside shmidt plot circle)
    PLT = X.^2 + Y.^2;
    mask = PLT < 2;
    
    %% get theta and phi and unit vector for every point inside shmidt plot

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

    
    %% get wastson density at each point
    
    THETA = acos(sum(v.*repmat(PA,np,1),2) );
    Z(mask) = 2*Thor.ODF.watson(k,THETA);
    
    
    %% get outside border points 
    BPHI = linspace(0,2*pi,100);
    BX = sqrt(2)*cos(BPHI);
    BY = sqrt(2)*sin(BPHI);


      %% Plot
    
    % contour invervals
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
