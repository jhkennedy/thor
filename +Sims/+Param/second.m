% code to explore the parameter space of my model:
    % Stress -> compression, shear, combined, real (Ray. 1983 in Taylor)
        % stress range from 0.1 to 0.4 bar [10000 - 40000 Pa](Pettit 2003)
    % Fabric -> isotropic, 80 deg. cone, 60 deg. cone, 30 deg. cone
    % NNI    -> none, mild, full
    % other? -> grain size, types of layering, # of crystals / layer
    % 
    % average antarctic ice temp. -30 deg C ... Tim

try
    % clean up the enironment and set up parallel processing
    close all; clear all;
    matlabpool open
    
    % start timing
    tic;     DATE = now;
    display(sprintf('\n Run started %s \n', datestr(DATE)))
    
    % manually load in initial setting structure
    in = struct([]);
    load ./+Sims/+Param/Settings/2014_02_05_Second.mat
    
    runs = length(in);
       
        
    %% set up the model
    
    MaxStrain  = 0.5;
    StrainStep = 0.00025;
    StrainSwitch = 0.2; 
    
    if exist('SetStress','var')
        display(['Stress will switch at ',num2str(StrainSwitch), ' bulk strain!'])
    else
        display('Stress will not switch; no SetStress array!')
        SetStress = [];
    end
    
    TimeSteps = ceil(MaxStrain/StrainStep);
    SAVE = [0,1:4:TimeSteps];
    StrainStepArray = (1:TimeSteps)*StrainStep;
    [~,StepSwitch] = max(StrainStepArray >= StrainSwitch);
    
    
    ModelTime = cell(1,runs);
    PolyEvents = cell(1,runs);
    MigreEvents= cell(1,runs);
    
    parfor ii = 1:runs
       [NAMES(ii), SET(ii)] = Thor.setup(in(ii), ii); 
    end
    
    TIME(1) = toc;
    display(sprintf('\n Time to set up Thor is %g seconds. \n', TIME(1)))
    
    %% step the model
    parfor jj = 1:runs
        
        ModelTime{jj} = zeros(SET(jj).nelem, size(SAVE,2) );
        PolyEvents{jj} = zeros(SET(jj).nelem, size(eigenMask,2), TimeSteps);
        MigreEvents{jj} = zeros(SET(jj).nelem, size(eigenMask,2), TimeSteps);
        i = 1;
        
        for kk = 1:TimeSteps
            
            % Switch stress from intial regime to shear regime
            if (kk == StepSwitch && ~isempty(SetStress))
                SET(jj).stress = SetStress(jj).stress;
            end
            
            [SET(jj), PolyEvents{jj}(:,:,kk), MigreEvents{jj}(:,:,kk)] = Thor.stepStrain(NAMES(jj), SET(jj), StrainStep, jj, kk, SAVE, eigenMask); % % s^{-1}
            
            
            % save model time for steps specified in SAVE
            if any(SAVE == kk)
                ModelTime{jj}(:,i+1) = SET(jj).ti;
                i = i+1;
            end
        end
    end
   
    TIME(2) = toc;
    display(sprintf('\n Time to step Thor through %d time steps for %d runs is \n     %g seconds. \n', TimeSteps, runs, TIME(2)-TIME(1) ) )
    

    %% save results
    
    save ./+Sims/+Param/secondResults.mat
    
    %% close the matlab pool
    matlabpool close;
    TIME(8) = toc;
    display(sprintf('\n Total time to run PARAM is \n     %g seconds. \n', TIME(8) ) )
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    % email me to tell me the run is done
    !mail -s SECOND:DONE jhkennedy@alaska.edu < ./+Sims/+Param/second.log
    
catch ME
    matlabpool close;
    TIME(9) = toc;
    display(sprintf('Total elapsed time before crash is %f seconds.', TIME(9)))
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    display(ME.message);
    
    % email me to tell me run has crashed
    !mail -s SECOND:CRASH jhkennedy@alaska.edu < ./+Sims/+Param/second.log
    
    save ./+Sims/+Param/secondCRASH.mat
        
    rethrow(ME);
    
end

quit;
    
