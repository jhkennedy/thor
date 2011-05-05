function [ cdist, esoft ] = soft( cdist, CONN, xc, ec )
% SOFT(cdist, CONN, cnumb, soft) calculates the softness parameter from the
% interaction between a crystal and its nearest neighbors. 
%
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell
%   array. The crystal distrubution structure is outlined in Thor.setup.
%
%   CONN is a 1x12 array containing the crystal number for the nearest neighboors
%   in the distrobution.   
%
%   xc is the Nearest Neighbor Interaction, NNI, controbution from the crystal.
%
%   ec is the controbution from each neighboring crystal. This is usually set in
%   SETTINGS.soft as outlined in Thor.setup.  
%
% Soft returns the crystal distrobution and the softness parameter, a scalar,
% for the crysal. 
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

