% Code to try and find the softness parameters for taylor dome ice core. 

% remember to comment out quit for local job

try
    % clean up the environment and set up parallel processing
    close all; clear all;
    matlabpool;
    
    DEBUG = 0;
    
    tic;
% use GUI to load in initial setting structure   
%     % make sure to load in the right settings structure
%     h = Thor.Build.structure;
%     waitfor(h);
%     pause(0.2);
%     
%     % load initial settings for a run
%     load +Thor/+Build/initial.mat

% manually load in initial setings structure
    load ./+Thor/+Build/Settings/Taylor_getSoft.mat
    in = default;
    clear default;

    DATE = now;
    display(['Run started ',datestr(DATE)]);
    
    % set up model
        % build the different runs
        runs = 16;
        timesteps = 22900; % step-size is definded in in.tsize
        IN(runs) = in; % initialize each runs settings 


        % vary the softness parameters for each run
        softmin = 0; 
        softmax = 2;
        soft = linspace(softmin,softmax,runs);
        parfor ii = 1:runs
            IN(ii) = in;
            IN(ii).soft = repmat([1, soft(ii)],in.nelem,1);
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
        DEAPTH = Taylor.getDeapth(to, SAVE, in.tsize, AGE); %#ok<NASGU> % m
        
        % Surface vertical velocity (RAYMOND 1983)
        yts = 60*60*24*365*1000; % s a^{-1}
        Vs = abs((AGE(2,2)-AGE(1,2))/((AGE(2,2)-AGE(1,2))*yts)); % m s^{-1}
        
        
        % initialize density of ice
        rho = 916.7; % kg m^{-3}
        % initialize gravitational acceleration
        g = 9.81; % m s^{-2}
%         % initialize ratio between transverse and longitudinal strain rates (REEH 1988)
%         %       circular domes:    alpha = 1
%         %       strait ice divide: alpha = 0
%         alpha = 1;
%         % difference between  sigma_x and sigma_z (REEH 1988)
%         %   assuming no accumulation, and reference temp is real temp.
%         ds = 1/10;
    
    TIME(1) = toc;
    display(['Elapsed time to intitialize Thor is ',num2str(TIME(1)),' seconds.']);
    
    % setup each run    
        parfor jj = 1:runs
            % set initial tempuratures
            IN(jj).T = IN(jj).T.*0+interp1q(Z',T',zo); 
            if DEBUG == 1; display(['ii: ',num2str(jj),', T: ',num2str(IN(jj).T(1))]); end
            % set initial stress (RAYMOND 1983)
            %  hydrostatic stress
            P = rho*g*(zo-37);
            %  Glen's Flow Law Parameter
            ALPHA = interp1(IN(jj).A(1,:), IN(jj).A(2,:),IN(jj).T);% s^{-1} Pa^{-n}
            %  deviatoric stress
            Dev = 2*(ALPHA).^(-1./IN(jj).glenexp).*(2*Vs./Z(2)).^(1./IN(jj).glenexp).*(1-zo./Z(2)).^(1./IN(jj).glenexp);
            Dev = reshape(Dev,1,1,[]);
            IN(jj).stress(3,3,:) = IN(jj).stress(3,3,:).*0-P-Dev;
            IN(jj).stress(1,1,:) = IN(jj).stress(1,1,:).*0-P+Dev;
            IN(jj).stress(2,2,:) = IN(jj).stress(2,2,:).*0-P+Dev;
%             % set initial stress (REEH 1988)
%             IN(jj).stress(3,3,:) = IN(jj).stress(3,3,:).*0-rho*g*(zo-37);
%             IN(jj).stress(1,1,:) = IN(jj).stress(3,3,:)+ds*rho*g*(zo-37);
%             IN(jj).stress(2,2,:) = IN(jj).stress(3,3,:)+((1+2*alpha) / (2+alpha))*ds*rho*g*(zo-37);
            if DEBUG == 1; display(['ii: ',num2str(jj),', Stress(3,3): ',num2str(IN(jj).stress(3,3,1))]); end
            if DEBUG == 1; display(['ii: ',num2str(jj),', Stress(2,2): ',num2str(IN(jj).stress(2,2,1))]); end
            if DEBUG == 1; display(['ii: ',num2str(jj),', Stress(1,1): ',num2str(IN(jj).stress(1,1,1))]); end
            % run setup
            [CONN{jj}, NAMES{jj},SET{jj} ] = Thor.setup(IN(jj), jj);  %#ok<SAGROW,AGROW>
        end
    TIME(2) = toc;
    display(['Total elapsed time to setup Thor is ',num2str(TIME(2)),' seconds.']);
    
    
    % step each run
    parfor kk = 1:runs 
        for ll = 1:timesteps
            deapth = Taylor.getDeapth(to, ll, SET{kk}.tsize, AGE);
            temp = interp1q(Z',T',deapth);
            if DEBUG == 1; 
               display(['Time,run: ',num2str(ll),' , ',num2str(kk),...
                        ' ; Temp ',num2str(temp),' ; Deapth ', num2str(deapth)]);
            end
            SET{kk}.T = SET{kk}.T.*0+temp; %#ok<SAGROW,AGROW>
            % calculate new stress (RAYMOND 1983)
            %  hydrostatic stress
            P = rho*g*(deapth-37);
            %  Glen's Flow Law Parameter
            
            ALPHA = interp1(SET{kk}.A(1,:), SET{kk}.A(2,:),SET{kk}.T);% s^{-1} Pa^{-n}
            %  deviatoric stress
            Dev = 2*(ALPHA).^(-1./SET{kk}.glenexp).*(2*Vs./Z(2)).^(1./SET{kk}.glenexp).*(1-deapth./Z(2)).^(1./SET{kk}.glenexp);
            Dev = reshape(Dev,1,1,[]);
            SET{kk}.stress(3,3,:) = SET{kk}.stress(3,3,:).*0-P-Dev; %#ok<SAGROW,AGROW>
            SET{kk}.stress(1,1,:) = SET{kk}.stress(1,1,:).*0-P+Dev; %#ok<SAGROW,AGROW>
            SET{kk}.stress(2,2,:) = SET{kk}.stress(2,2,:).*0-P+Dev; %#ok<SAGROW,AGROW>
%                % calculate new stress (REEH 1988)
%                SET{kk}.stress(3,3,:) = SET{kk}.stress(3,3,:).*0-rho*g*(deapth-37); %#ok<SAGROW,AGROW>
%                SET{kk}.stress(1,1,:) = SET{kk}.stress(3,3,:)+ds*rho*g*(deapthj-37); %#ok<SAGROW,AGROW>
%                SET{kk}.stress(2,2,:) = SET{kk}.stress(3,3,:)+((1+2*alpha) / (2+alpha))*ds*rho*g*(deapth-37); %#ok<SAGROW,AGROW>
            if DEBUG == 1; display(['ii: ',num2str(kk),', Stress(3,3): ',num2str(SET{kk}.stress(3,3,1))]); end
            if DEBUG == 1; display(['ii: ',num2str(kk),', Stress(2,2): ',num2str(SET{kk}.stress(2,2,1))]); end
            if DEBUG == 1; display(['ii: ',num2str(kk),', Stress(1,1): ',num2str(SET{kk}.stress(1,1,1))]); end
            Taylor.taylorStep(CONN{kk},NAMES{kk},SET{kk}, kk, ll, SAVE);
        end
    end
    TIME(3) = toc;
    display(['Total elapsed time to step Thor through ',num2str(timesteps),' time steps']);
    display(['for ',num2str(runs),'runs is ',num2str(TIME(3)),' seconds.']);
    
    %% calculate eigenvalues at each saved time step for each run
        EIG = zeros(3,size(SAVE,2),in.nelem,runs);
        for oo = 1:runs
            for mm = 1:in.nelem
                for nn = 1:size(SAVE,2)

                    tmp = load(['./+Thor/CrysDists/Run' num2str(oo) '/SavedSteps/Step'...
                                num2str(SAVE(nn)) '_' NAMES{oo}.files{mm}]);
                    EIG(:,nn,mm,oo) = Thor.Utilities.eigen(tmp.(NAMES{oo}.files{mm}), SET{oo});
                end
            end
        end
        
        % get average eignevalues for each run
        [E1 E2 E3] = Taylor.reshapeEIG(EIG); %#ok<NASGU>
        
        
        % clear unessacary variables
        clear in mm nn oo softmax softmin tmp
        % save all variables
        save ./+Taylor/getSoft.mat
    
    TIME(4) = toc;
    display('Total elapsed time to calculate eigenvaluse at each saved time step');
    display(['for each run is ',num2str(TIME(4)),' seconds.']);
    
    %%
    
    matlabpool close;


catch ME
    matlabpool close;
    TIME(5) = toc;
    display(['Total elapsed time before crash is ',num2str(TIME(5)),' seconds.']);
    
    save ./+Taylor/getSoftCrash.mat
    
    rethrow(ME);

	
end

quit;
