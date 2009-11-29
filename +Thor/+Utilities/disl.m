function [ cdist ] = disl( cdist, SET, elem )
% [cdist]=DISL(cdist, SET, elem) calculates the new dislocation density for each crystal in
% in the distrobution cdist of element elem, bassed on the settings specified in SET.
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% DISL returns the crystal distrobution, cdist, with new dislocation densities. 
%   
%   See also Thor.setup

    
    for ii = 1:SET.numbcrys
        
        % time change of the dislocation density
        rhodot = Thor.Utilities.disldot(SET.T(elem), cdist{ii,7}, cdist{ii,5}, cdist{ii,8});
        
        % set new dislocation density
        cdist{ii, 8} = cdist{ii,8}+rhodot*SET.tsize;
    end
end

