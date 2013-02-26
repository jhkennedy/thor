function [EZZ] = verticalStrainPar(Dir, SET, runs, SAVE, NAMES)

    %% calculate vertical strain  for each save point
    % EZZ is size (# of saves, # of elements, # number of runs)
    EZZ = zeros(size(SAVE,2),SET(1).nelem, runs);
    ezz = zeros(size(SAVE,2),SET(1).nelem);
    
    parfor oo = 1:runs
        EZZ(:,:,oo) = hidePar(ezz, Dir, SET(oo), SAVE, NAMES, oo);
    end

end

function [ezz] = hidePar (ezz, Dir, SET, SAVE, NAMES, oo)
    for mm = 1:SET.nelem
        for nn = 1:size(SAVE,2)

            % load in saved crystal distrobutions
            cdist = load([Dir, '/Run' num2str(oo) '/Step'...
                           num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

            % calculate crystal vertical strain rates
            cdist = Thor.Utilities.vec(cdist, SET, mm);
            
            % calculate bulk strain rate
            edot = Thor.Utilities.bedot(cdist);
            
            % get verical strain at time steps
            ezz(nn,mm) = edot(3,3)*SET.tstep;
        end
    end
end