function [ CONN, NAMES, SETTINGS] = setup( in  )
% [ELDATA] = SETUP(NELEM, CONTYPE, DISTYPE, DISANGLES, stress, n) sets up the cell
% array that holds crystal distrobution variables for each element
% specified by NELEM using the packing structure specified by CONTYPE. Each
% crystal distrobution is made acording to DISTYPE and DISANGLES.
%
%   NELEM is a scalar value specifying how many elements to build a crystal
%   distrobution for. 
%
%   CONTYPE is a character array specifying the packing structure of the
%   crystals. 8000 crystals are used in each distrobution. Possible values
%   are 'cubic' or 'hex'. 
%       cubic results in a 20x20x20 cubic distrobution of crystals, each 
%       having 6 nearest neighbors. 
%       
%       hex results in a 20x20x20 hexagonal closed pack structure, with
%       each crystal having 12 nearest neighboors. 
%
%   DISTYPE is a character array specifying the type of crystal
%   distrobution to make. Possible values are 'iso'.
%       iso results in a isotropic randomly generated crystal pattern.
%
%   DISANGLES is an 2xNELEM array holding [Ao1, A1; ...; Ao_NELEM, A_NELEM]
%   where the 'Ao's are the girdle angle of the crystal distrobution and
%   the 'A's are the cone angles of the distrobution
%
%   STRESS is a 3x3xNELEM array holding the stress tensor for each element
%
%   N is a NELEMx1 array holding the flow law power for each element, 3 is generally used
%   (glens flow)
%
%   YNSOFT is a character array of either 'yes' or 'no' that turns on or off the softness
%   parameter due to nearest neighbor interaction
%
% SETUP saves a set of variables in the form of  EL********, where  ********* is the
% element number, into directory called 'CrysDists'. nelem files are created with each containing a crystal distrobution. 
% The distrobution is aranged in an 8000x5 cell array
%   NAMES is a structure holding th cell locations of the information
%   specified by each field of NAMES. The information cells are:
%      1) THETA holds the colatitudinal orientation angle for the crystal
%      2) PHI holds the longitudinal orientation angle for the crystal
%      3) VEL holds he velocity gradient tensor for the crystal
%      4) ECDOT holds the single crystal strain rate
%      5) ODF hold the crystals controbution to the orientation distrobution function, ODF
%      6) FILES holes a column vector of all the files names where the row corrosponds to
%      the crystal number
%
% therefor, a crystal distrobution can be accessed as such:
%    eval(['load ./CrysDists/' NAMES.files{*********}]);
% and the contents of a loaded crystal distrobution as such:
%    EL*********{crystal_number, NAMES.field_name}
% However, for parallel applications, this will not work. It is therefore best to use
% NAMES as a reference to remember the cell locations and not use it as a programing
% convention. 
%
%
% setup also sets up the global variable CONN, a 1x12 vector holding the crystal number
% for each nearest neighbor (first 6 used for  cubic and all twelve used for hexognal or
% fcc type packing) 

    %% Initialize variables
    
    % number of crystals
    numbcrys = 20*20*20;
    
    % initialize structure that holds crystal info
    NAMES = struct('theta', 1, 'phi', 2, 'rss', 3, 'vel', 4, 'ecdot', 5, 'odf', 6,... 
        'crysize', 7, 'disdens', 8, 'dislEn', 9, 'shmidt', 10);
    % names is a structure holding cell location of the information for a
    % crystal specified by the cell crysStruct
        % THETA holds the colatitudinal orientation angle for the crystal
        % PHI holds the longitudinal orientation angle for the crystal
        % VEL holds he velocity gradient tensor for the crystal
        % ECDOT holds the single crystal strain rate
        % ODF hold the crystals controbution to the orientation distrobution function, ODF
    
    % initialize connectivity structure
    CONN = nan(numbcrys,12);
    switch in.contype
        case 'cube'
            % cubic connectivity, 6 nearest neigbors
            for ii = 1:numbcrys
                % get index for current crystal
                [I J K] = ind2sub([20 20 20], ii);
                % get the top-bottom-left-right-back-front indexes
                cons = [I-1, J, K; I+1, J, K; I, J-1, K;...
                          I, J+1, K; I, J, K-1; I, J, K+1];
                % try to get linear indecies
                for jj = 1:6
                    try
                        CONN(ii,jj) = sub2ind([20 20 20],...
                                        cons(jj,1),cons(jj,2),cons(jj,3));
                    catch ME %#ok<NASGU>
                        % subscrypt was outside of array. This will hapen at all
                        % corners and walls. Will leave value as NaN.
                    end
                end
             end
        case 'hex'
          % hexagonal connectivity, 12 nearest neigbors  
    end
        
    %% initialize crystal distributions
    switch in.distype
        case 'saved'
            % check that a saved distribution is of the right size and structure, if not,
            % build appropriate structure
            
            % load in file names
        
        otherwise
            CONN = NaN(numbcrys,12);
             % CONN is a NUMBCRYSx12 vector holding the crystal number for each nearest
             % neighbor (first 6 used for  cubic and all twelve used for hexognal
             % or fcc type packing)  
            crysStruct = {0, 0, zeros(1,3), zeros(3,3), zeros(3,3), 0, 0, 0, 0, zeros(3,3,3)};
            % CrysDist is a cell array containing all the individual crystal
            % structured for a crystal distrobution

            %% Initial crystal prameters
            %  dislocation density -- thor2002 -- value set [38]
            crysStruct{8} = 4*1e10; % m^{-2}

            % build a crystal distrobution
            crysDist = repmat(crysStruct, numbcrys,1);
            
            switch in.distype
                case 'iso'
                    % create and crystal distrobution for each element and save then to disk
                    for ii = 1:in.nelem
                        % set file name
                        NAMES.files{ii} = sprintf('EL%09.0f', ii);
                        % create isotropic distrobution of angles
                        THETA = in.disangles(ii,1) + (in.disangles(ii,2)-in.disangles(ii,1))...
                                *rand(numbcrys,1);
                        PHI = 2*pi*rand(numbcrys,1);
                        % creat isotropic distrobution of grain size
                        GRAINS = in.grain(1) + (in.grain(2)-in.grain(1))*rand(numbcrys,1);
                        % place crystal params into crystal distrobutions
                        crysDist(:,1) = num2cell(THETA);
                        crysDist(:,2) = num2cell(PHI);
                        crysDist(:,7) = num2cell(GRAINS);
                        % save crystal distrobutions
                        eval([NAMES.files{ii} '= crysDist;']);
                        eval(['save ./+Thor/CrysDists/' NAMES.files{ii} ' ' NAMES.files{ii}]);
                        eval(['clear ' NAMES.files{ii}])
                    end
            end
    end
    
    
    %% calculate initials 
    
    parfor ii = 1:in.nelem % loop through the elements
        % load element ii
        tmp = load(['./+Thor/CrysDists/' NAMES.files{ii}]); %#ok<PFBNS>
        % initialize velocity gradiant and single crystal strain rate
        tmp.(NAMES.files{ii}) = Thor.Utilities.vec( tmp.(NAMES.files{ii}), CONN, ii, in);        
        % initial dislocation energy
        tmp.(NAMES.files{ii}) = Thor.Utilities.dislEn(tmp.(NAMES.files{ii}));
        % save element ii
        isave(['./+Thor/CrysDists/' NAMES.files{ii}], tmp.(NAMES.files{ii}), NAMES.files{ii});
    end
    
    % set the model settings
    SETTINGS = in;
    
end

%% extra functions
function isave(file, fin, var) %#ok<INUSL>
    eval([var '=fin;']);
    save(file, var);
end