function [Medot,TSTEP]=strainStep(P)
% figure out smallest time step for strain step P

    try
        matlabpool;

        % load in settings structure and saved steps for ExploreParam2011Jan7cor
        load +Param/Results/ExploreParam2011Jan7cor/exploreResults.mat SAVE SET runs

        SAVE = SAVE; %#ok<*ASGSL>
        SET = SET;
        runs = runs;
        
        Medot = zeros(SET(1).nelem,size(SAVE,2),runs);
        medot = zeros(SET(1).nelem,size(SAVE,2));
        NELEM = SET(1).nelem;

        parfor ii = 1:runs
            Medot(:,:,ii) = hidePar(medot,NELEM,ii,SAVE,SET); 
        end

        TSTEP = P./Medot./(60*60*24*365);
    catch ME
        matlabpool close;

        rethrow(ME);
    end
    
end
    
    function [Medot]=hidePar(Medot,NELEM,ii,SAVE,SET)
        for jj = 1:NELEM
            for kk = 1:size(SAVE,2)
                
                cdist = load(['+Param/Results/ExploreParam2011Jan7cor/Run',num2str(ii),'/Step',num2str(SAVE(kk),'%05.0f'),'_EL',num2str(jj,'%09.0f'),'.mat']); 
                
                [cdist]=Thor.Utilities.vec(cdist,SET(ii),jj);
                
                edot = Thor.Utilities.bedot(cdist);
                
                Medot(jj,kk) = sqrt(1/2*(edot(1,1)^2+edot(2,2)^2+edot(3,3)^2+2*(edot(1,2)^2+edot(2,3)^2+edot(3,2)^2)));
                
            end
        end
    end