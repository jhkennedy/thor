function [ F ] = odf( crystals )
% ODF(CRYSTALS) returns the single crystal orientation distribution
% function values so that the normalizing constant can be found within a
% parfor loop, otherwise, CRYSTALS is not a sliced variable and results in
% too much overhead for matlab to deal with. 
%
%   CRYSTALS is a 1x2 vector containing [theta phi] where theta and phi 
%   orientation angle of a crystal.

F = sin(crystals(1));

end

