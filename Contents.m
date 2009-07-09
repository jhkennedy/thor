% Code to recreate the anisotrpy model in Throstur Thorsteinsson's paper
%   An analytic approach to deformation of anisotropic ice-crystal
%       aggregates
%   Journal of Glaciology, Vol.47, No. 158, 2001 pg 507-516
%
% To run the model type 'THOR'
%
% Directory Contents:
%
% thor.m -- main program
%
% numb.m -- numeric method for recreating the figures in Thorsteinsson's
% paper. This one is underestimating the integration. It maintains the
% shape of the integral, however, it's 'amplitude' is too small when
% comparing to the paper. 
%
% symb.m -- symolic method for recreating the figures in Thorsteinsson's
% paper. This one is 'correct'.