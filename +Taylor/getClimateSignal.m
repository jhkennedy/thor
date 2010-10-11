% Code to try and find the softness parameters for taylor dome ice core. 
%   Grootes et all, 1994
%   Waddington et all, 1993
%   Kavanaugh et all, 2009 1-3
% remember to comment out quit for local job

try
    % clean up the environment and set up parallel processing
    close all; clear all;
    matlabpool;
    
    DEBUG = 0;
    
    tic;

    % manually load in initial setings structure
    load ./+Thor/+Build/Settings/Taylor_getClimateSignal.mat

    DATE = now;
    display(['Run started ',datestr(DATE)]);
    
    % set up model
        % build the different runs
        runs = 8;
        timesteps = 200; % step-size is definded in in.tstep 
        IN(runs) = in; % initialize each runs settings 


        % vary the softness parameters for each run
        softmin = 0; 
        softmax = 2;
        soft = linspace(softmin,softmax,runs);
        parfor ii = 1:runs
            IN(ii) = in;
            IN(ii).xcec = repmat([1, soft(ii)],in.nelem,1);
        end

    % set up Taylor Dome
        % Mi-max deapth vector
        Z = [0, 600]; % m
        % initial starting deapth
        zo = 100; % m
        
        % temperature
        T = [-43, -24]; % C
       
        % get depth age relation
        AGE = Taylor.getAge();
        % initial starting time
        to = 1.525; % kyr 
        % Save at these time steps
        SAVE = [0,1, 50:50:timesteps];
        % Deapths at saved time steps
        DEAPTH = Taylor.getDeapth(to, SAVE, in.tstep, AGE); %#ok<NASGU> % m
        
        % Surface vertical velocity (RAYMOND 1983)
        kyts = 60*60*24*365*1000; % s ka^{-1}
        Vs = abs((AGE(2,2)-AGE(1,2))/((AGE(2,2)-AGE(1,2))*kyts)); % m s^{-1}
        
        
        % initialize density of ice
        rho = 916.7; % kg m^{-3}
        % initialize gravitational acceleration
        g = 9.81; % m s^{-2}

    
    TIME(1) = toc;
    display(['Elapsed time to intitialize Thor is ',num2str(TIME(1)),' seconds.']);
    
    % setup each run    
        parfor jj = 1:runs
            % set initial tempuratures
            IN(jj).T = IN(jj).T.*0+interp1q(Z',T',zo); 
            if DEBUG == 1; display(['ii: ',num2str(jj),', T: ',num2str(IN(jj).T(1))]); end
            % set initial stress (RAYMOND 1983)
            %  hydrostatic stress
            P = -rho*g*(zo-37);
            %  Glen's Flow Law Parameter
            ALPHA = interp1(IN(jj).A(1,:), IN(jj).A(2,:),IN(jj).T);% s^{-1} Pa^{-n}
            %  deviatoric stress
            Dev = 2*(ALPHA).^(-1./IN(jj).glenexp).*(2*Vs./Z(2)).^(1./IN(jj).glenexp).*(1-zo./Z(2)).^(1./IN(jj).glenexp);
            Dev = reshape(Dev,1,1,[]);
            IN(jj).stress(3,3,:) = IN(jj).stress(3,3,:).*0+P-Dev;
            IN(jj).stress(1,1,:) = IN(jj).stress(1,1,:).*0+P+Dev;
            IN(jj).stress(2,2,:) = IN(jj).stress(2,2,:).*0+P+Dev;

                if DEBUG == 1; display(['ii: ',num2str(jj),', Stress(3,3): ',num2str(IN(jj).stress(3,3,1))]); end
                if DEBUG == 1; display(['ii: ',num2str(jj),', Stress(2,2): ',num2str(IN(jj).stress(2,2,1))]); end
                if DEBUG == 1; display(['ii: ',num2str(jj),', Stress(1,1): ',num2str(IN(jj).stress(1,1,1))]); end
            
            % run setup
            [NAMES(jj),SET(jj) ] = Thor.setup(IN(jj), jj);  %#ok<SAGROW,AGROW>
        end
    TIME(2) = toc;
    display(['Total elapsed time to setup Thor is ',num2str(TIME(2)),' seconds.']);
    
    % set climate layers
    for qq = 1:runs
        for rr = 1:SET(qq).nelem
            cdist = load(['./+Thor/CrysDists/Run' num2str(qq) '/' NAMES(qq).files{rr}]);
            cdist.theta(eigenMask(:,2)) = cdist.theta(eigenMask(:,2))*0.9;
            cdist.size(eigenMask(:,2)) = cdist.size(eigenMask(:,2))*2;
            eval(['save ./+Thor/CrysDists/Run' num2str(qq) '/' NAMES(qq).files{rr} ' -struct cdist theta phi size dislDens']);
            eval(['save ./+Thor/CrysDists/Run' num2str(qq) '/SavedSteps/Step00000_' NAMES(qq).files{rr} ' -struct cdist theta phi size dislDens']);
        end
    end
%     % save crystal distrobutions
%                         eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
%                     end
%                     
%             end
%     end
% 
%     % Save a copy for step zero
%     eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
    
    
    % step each run
    parfor kk = 1:runs 
        for ll = 1:timesteps
            % get current deapth
            deapth = Taylor.getDeapth(to, ll, SET(kk).tstep, AGE);
            % get current temperature
            temp = interp1q(Z',T',deapth);
            SET(kk).T = SET(kk).T.*0+temp; %#ok<SAGROW,AGROW>
            
                if DEBUG == 1; 
                   display(['Time,run: ',num2str(ll),' , ',num2str(kk),...
                            ' ; Temp ',num2str(temp),' ; Deapth ', num2str(deapth)]);
                end

            
            % calculate new stress (RAYMOND 1983)
                %  hydrostatic stress
                P = rho*g*(deapth-37);
                %  Glen's Flow Law Parameter
                ALPHA = interp1(SET(kk).A(1,:), SET(kk).A(2,:),SET(kk).T);% s^{-1} Pa^{-n}
                %  deviatoric stress
                Dev = 2*(ALPHA).^(-1./SET(kk).glenexp).*(2*Vs./Z(2)).^(1./SET(kk).glenexp).*(1-deapth./Z(2)).^(1./SET(kk).glenexp);
                Dev = reshape(Dev,1,1,[]);
                SET(kk).stress(3,3,:) = SET(kk).stress(3,3,:).*0-P-Dev; %#ok<SAGROW,AGROW>
                SET(kk).stress(1,1,:) = SET(kk).stress(1,1,:).*0-P+Dev; %#ok<SAGROW,AGROW>
                SET(kk).stress(2,2,:) = SET(kk).stress(2,2,:).*0-P+Dev; %#ok<SAGROW,AGROW>

                    if DEBUG == 1; display(['ii: ',num2str(kk),', Stress(3,3): ',num2str(SET(kk).stress(3,3,1))]); end
                    if DEBUG == 1; display(['ii: ',num2str(kk),', Stress(2,2): ',num2str(SET(kk).stress(2,2,1))]); end
                    if DEBUG == 1; display(['ii: ',num2str(kk),', Stress(1,1): ',num2str(SET(kk).stress(1,1,1))]); end

            % perform time step
            Thor.step(NAMES(kk),SET(kk), kk, ll, SAVE);
        end
    end
    TIME(3) = toc;
    display(['Total elapsed time to step Thor through ',num2str(timesteps),' time steps']);
    display(['for ',num2str(runs),'runs is ',num2str(TIME(3)),' seconds.']);
    
    %% calculate eigenvalues at each saved time step for each run
        EIG = zeros(3,size(eigenMask,2),size(SAVE,2),in.nelem,runs);
        for oo = 1:runs
            for mm = 1:in.nelem
                for nn = 1:size(SAVE,2)
                    
                    % load in saved crystal distrobutions
                    cdist = load(['./+Thor/CrysDists/Run' num2str(oo) '/SavedSteps/Step'...
                                   num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);
                    
                    % calculate eigenvalue
                    EIG(:,:,nn,mm,oo) = Thor.Utilities.eigenClimate( cdist, eigenMask );
                end
            end
        end
        
        % get average eignevalues for each run
%         [E1 E2 E3] = Taylor.reshapeClimateEIG(EIG); %#ok<NASGU>
        
        
        % clear unessacary variables
        clear in mm nn oo softmax softmin cdist
        % save all variables
        save ./+Taylor/getClimateSignal.mat
    
    TIME(4) = toc;
    display('Total elapsed time to calculate eigenvalues at each saved time step');
    display(['for each run is ',num2str(TIME(4)),' seconds.']);
    
    %%
    
    matlabpool close;


catch ME
    matlabpool close;
    TIME(5) = toc;
    display(['Total elapsed time before crash is ',num2str(TIME(5)),' seconds.']);
    
    save ./+Taylor/getClimateSignalCrash.mat
    
    rethrow(ME);

	
end

quit;
