% Package Thor contains all the functions necessary to run the Thor model.
%
%  =========
%  Functions
%  =========
%
%   analyzeDistro
%       [ EIG, DISLINFO, SIZEINFO ]=analyzeDistro( cdist, eigenMask ) 
%       This function calculates the orientation eigenvalues, mean
%       dislocation density, and mean grain size of a crystal
%       distrobution. 
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
