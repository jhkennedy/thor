function [ CONN, NAMES, SET ] = step(CONN, NAMES, SET )
% [CONN, NAMES, SET] = step(CONN, NAMES, SET) preforms a time step specified in SET on all
% the crystal distrobutions in NAMES with a conectivity structure specified by CONN. 
%   CONN is a (SET.numbcrys)x12 array holding the crystal number for each nearest neighbor
%   in the columns (first 6 used for  cubic and all twelve used for hexognal or fcc type
%   packing) of the crystal specified by the row number. 
%
%   NAMES holds all the files names for the crystal distrobutions. NAMES is outlined in
%   Thor.setup.
%
%   SET is a structure holding the model settings as outlined in Thor.setup.
%
% step load in a crystal distrobution for each element and rotates the crystals. Then step
% calulates new velocity gradients, crystal strain rates, dislocation densities,
% dislocation energies, grain sizes, as well as checking for polygonization and migration
% recrystallization. step then saves the stepped crystal distrobutions to disk.
%
%   See also Thor.setup, Thor.Utilities.rotate, Thor.Utilities.vec, Thor.Utilities.disl,
%            Thor.Utilities.dislEn, Thor.Utilities.grow, Thor.Utilities.poly, and
%            Thor.Utilities.migre


    parfor ii = 1:SET.nelem

        % load element ii
        tmp = load(['./+Thor/CrysDists/' NAMES.files{ii}]); %#ok<PFBNS>
        
        % rotate the crstals from last time steps calculations
        tmp.(NAMES.files{ii}) = Thor.Utilities.rotate(tmp.(NAMES.files{ii}), SET );
        
        % calculate new velocity gradients and crystal strain rates
        tmp.(NAMES.files{ii}) = Thor.Utilities.vec( tmp.(NAMES.files{ii}), SET, ii, CONN);        
        
        % calculate new dislocation density
        tmp.(NAMES.files{ii}) = Thor.Utilities.disl(tmp.(NAMES.files{ii}), SET, ii);
        
        % calculate new dislocation energy
        tmp.(NAMES.files{ii}) = Thor.Utilities.dislEn(tmp.(NAMES.files{ii}));
        
        % grow the crystals
        tmp.(NAMES.files{ii}) = Thor.Utilities.grow(tmp.(NAMES.files{ii}), SET, ii);
        
        % check for polyiginization
        tmp.(NAMES.files{ii}) = Thor.Utilities.poly(tmp.(NAMES.files{ii}), SET, ii);
        
        % check for migration recrystallization
        tmp.(NAMES.files{ii}) = Thor.Utilities.migre(tmp.(NAMES.files{ii}), SET, ii);
                
        % save element ii
        isave(['./+Thor/CrysDists/' NAMES.files{ii}], tmp.(NAMES.files{ii}), NAMES.files{ii});
    end
end

%% extra functions
function isave(file, fin, var) %#ok<INUSL>
    eval([var '=fin;']);
    save(file, var);
end