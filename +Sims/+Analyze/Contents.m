% Package Thor contains all the functions necessary to run the Thor model.
%
%  =========
%  Functions
%  =========
%
%   contourMovie
%       contourMovie(results) 
%       This function creates a time laps .avi video of Shmidt (equal area)
%       plots of a layer of all the saved crystal distrobutions in a model
%       simulation.  
%
%   distroDetails
%       [ EIG, DISLINFO, SIZEINFO ]=analyzeDistro( cdist, eigenMask ) 
%       This function calculates the orientation eigenvalues, mean
%       dislocation density, and mean grain size of a crystal
%       distrobution. 
%
%   equalAreaContour
%       [h, cax, cbax] = equalAreaContour(varargin)
%       This function makes an Equal Area Contour Plot (Schmidt Contour
%       Plot) of data on the upper hemesphere of the unit circle. The data
%       is projected onto a circle of radius sqrt(2) on the x-y plane. 
%
%   equalAreaPoint
%       [ varargout ] = equalAreaPoint( varargin )
%       The function makes an Equal Area Point Plot (Schmidt Point Plot) of
%       data on the upper hemesphere of the unit circle. The data is
%       projected onto a circle of radius sqrt(2) on the x-y plane.
%
%   savedResultsPar
%       [EIG, DISLDENS, GRAINSIZE] = 
%           savedResultsPar( Dir, in, runs, eigenMask, SAVE, NAMES)
%       This function calls analyzeDistro on every saved crystal
%       distribution from a model simulation. 
%
%  =======
%  Scripts
%  =======
%
%   postProcess
%       This script selects a results file, and then runs the
%       savedResultsPar function on the slected results.
