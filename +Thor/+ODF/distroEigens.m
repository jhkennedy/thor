function [ eval, evec ] = distroEigens(N, varargin)
% returns eigenvalues eval [e1; e2; e3] and eigenvectors [v1x, v1y,v1z;...]
% inputs Nx2 or Nx3 array of C-Axes and optional vector w or weights
% weights could be size^2/3

if size(N,2) == 2
    % get cartesian form
    N   = [sin(N(:,1)).*cos(N(:,2)) sin(N(:,1)).*sin(N(:,2)) cos(N(:,1))];

elseif size(N,2) ~= 3 

    error('Thor:ODF:distoEigens:sizeN', ['N is the array of C-axis',...
          'orientation vectors given in either Polar or Catesian form.\n',...
          '    For Polar: N must be size Mx2 where M is the number of ',...
          'crystal in the dirstobution.\n \n',...
          '    For Cartesian: N must be size Mx3 where M is the number of ',...
          'crystal in the dirstobution.\n \n',...
          'N was passed as size %g X %g'], size(N,1), size(N,2))
end

if (nargin > 1)    
    w = varargin{1};
    w = w(:);

else
    w = 1/size(N,1);
end


if (length(w) ~= size(N,1) && length(w) ~= 1)
    error('Thor:ODF:distroEigens:weights', ['w must either be a scalar weight ',...
          'or a vector of weights with a length equal to size(N,1) \n',...
          'N was passed as size %g X %g'], size(N,1), size(N,2))
end

 [~, S, V] = svd(diag(w.^(1/2),0)*N);
 
 eval = sum(S).^2;
 eval = eval(:);
 evec = V';
