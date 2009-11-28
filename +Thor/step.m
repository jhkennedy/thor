function [ CONN, NAMES, SET ] = step(CONN, NAMES, SET )
%
% stuff!

    parfor ii = 1:SET.nelem
        % load element ii
        tmp = load(['./+Thor/CrysDists/' NAMES.files{ii}]); %#ok<PFBNS>
        
        % rotate the crstals from last time steps calculations
        tmp.(NAMES.files{ii}) = Thor.Utilities.rotate(tmp.(NAMES.files{ii}), SET );
        % calculate new velocity gradients and crystal strain raits
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

% migration recrystallization

%% extra functions
function isave(file, fin, var) %#ok<INUSL>
    eval([var '=fin;']);
    save(file, var);
end