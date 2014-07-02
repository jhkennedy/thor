% Package Thor contains all the functions necessary to run the Thor model.
%
%  =========
%  Functions
%  =========
%
%   setup
%       [ NAMES, SET ] = SETUP( in, RUN ) 
%       This function sets up the model and readies matlab for a model run.
%
%   stepStrain
%       [SET, NPOLY, NMIGRE] = 
%           stepStrain(NAMES, SET, StrainStep, RUN, STEP, SAVE, eigenMask) 
%       This function performs a time step long enough to reach a strain
%       specified by StrainStep. 
%
%   stepTime
%       [SET, NPOLY, NMIGRE, StrainStep] = 
%           step(NAMES, SET, RUN, STEP, SAVE, eigenMask) 
%       This function performs a time step.
%
%  ===========
%  Subpackages
%  ===========
%
%   Utilities
%       A subpackage that contains all the functions necessary to perform a
%       timestep for the Thor model.
%
%   ODF
%       A subpackage that contains function useful for building
%       orientation distribution functions (0DFs). 
%
%   Build
%       A subpackage that contains helper functions for setting up the
%       model and some saved settings files. 
%
%  =======
%  Folders
%  =======
%
%   CrysDists
%       A folder that contains the working files when Thor is being run.
%       See setup for more information.
