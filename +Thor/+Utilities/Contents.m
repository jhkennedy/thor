% Subpackage Utilities contains all the functions necessary to perform a
% time step in the Thor model. 
%
%  =========
%  Functions
%  =========
%
%   bedot
%       [edot] = bedot(cdist)
%       This function calculates the modeled bulk strain rate for the
%       crystal distribution specified by cdist.
%
%   bound
%       [cdist] = bound(cdist, SET, elem) 
%       This function checks the crystal orientation bounds for crystals in
%       cdist and fixes orientations outside the bounds (upper hemisphere).
%
%   bvel
%       [vel] = bvel(cdist, SET) 
%       This function calculates the modeled bulk velocity gradient for
%       the crystal distribution specified by cdist.
%
%   disl
%       [ cdist, rhoDotStrain ] = disl( cdist, SET, elem, K )
%       This function calculates the new dislocation density for each
%       crystal in the distribution specified by cdist.
%
%   grow
%       [cdist] = grow(cdist, SET, elem, step)
%       This function calculates the new crystal sizes for each crystal in
%       the distribution specified by cdist. 
%
%   migre
%       [cdist, SET, nMigRe] = migre(cdist, SET, elem, eigMask )
%       This function migration recrystallizes crystals that are favorable
%       to do so. 
%
%   poly
%       [cdist, SET, npoly] = poly(cdist, SET, elem, eigMask)
%       This function polygonizes crystals that are favorable to do so.
%
%   rotate
%       [ cdist ] = rotate(cdist, SET, elem )
%       This function rotates each crystal in the distribution specified by
%       cdist. 
%
%   shmidt
%       [cdist, R1, R2, R3] = shmidt(cdist, nc, stress)
%       This function calculates the Shmidt tensor and magnitude of the
%       Resolved Shear Stress (RSS) on the three slip systems for each
%       crystal in the distribution specified by cdist.  
%
%   soft
%       [cdist, esoft] = soft(cdist, CONN, xc, ec)
%       This function calculates the softness parameter of a crystal from
%       the interaction between the crystal and its nearest neighbors. 
%
%   vec
%       [cdist] = vec(cdist, SET, elem) 
%       This function calculates the velocity gradient and strain rate for
%       each crystal in the distribution specified by cdist.







