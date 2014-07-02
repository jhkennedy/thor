function [ cdist, esoft ] = soft( cdist, CONN, xc, ec )
% [ cdist, esoft ] = soft( cdist, CONN, xc, ec ) calculates the softness
% parameter for a crystal from the interaction between a crystal and its
% nearest neighbors.
%
%   cdist is the structure holding the crystal distribution outlined in
%   Thor.setup.
%
%   CONN is a 1xN array containing the crystal numbers for the N nearest
%   neighbors in the distribution.   
%
%   xc is the Nearest Neighbor Interaction, NNI, contribution from the
%   crystal. 
%
%   ec is the contribution from each neighboring crystal. 
%
% Soft returns the crystal distribution cdist and the scalar esoft which is
% the softness parameter for the crystal. 
%
%   See also Thor.setup

if ec == 0
    
    esoft = ones(size(cdist.MRSS)); % -
    
else
    
    load(['+Thor/+Build/Settings/CONN/' CONN])
    
    sumrss = @(x) sum(cdist.MRSS(x)); % Pa

    N  = cellfun('size', CONN,2); % -
    Ti = cellfun(sumrss, CONN); % Pa
    
    esoft = 1./(xc + N*ec).*(xc + ec.*Ti./cdist.MRSS); % -
    esoft(esoft > 10)= 10; % -


end

