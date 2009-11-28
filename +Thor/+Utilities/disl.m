function [ cdist ] = disl( cdist, SET, elem )
%DISL Summary of this function goes here
%   Detailed explanation goes here
    
    for ii = 1:SET.numbcrys
        % time change of the dislocation density
        rhodot = Thor.Utilities.disldot(SET.T(elem), cdist{ii,7}, cdist{ii,5}, cdist{ii,8});
        % set new dislocation density
        cdist{ii, 8} = cdist{ii,8}+rhodot*SET.tsize;
    end
end

