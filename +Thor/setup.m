function [ CONN, NAMES, SETTINGS] = setup( in  )
% [ CONN, NAMES, SETTINGS ] = SETUP( in ) sets up the the model. Initial settings set in
% 'in' are used to build the connectivity structure, CONN, the list of crystal
% distrobution names, NAMES, and the model settings, SETTINGS. If no crystal distrobution
% files are specified, setup will build crystal distrobution based on the parameters set
% in 'in'.
%
%   'in' is a structure holding the initial model parameters. The in structure can be
%   built by calling the function Thor.Build.structure.
%
%       in.nelem is a scalar value, [NELEM], giving the number of elements or crystal
%       distrobutions.
%       
%       in.contype is a character array specifying the packing structure of the
%       crystals. NUMBCRYS crystals are used in each distrobution. Possible values
%       are 'cubic' or 'hex'. 
%           cubic results in a 20x20x20 cubic distrobution of crystals, each 
%           having 6 nearest neighbors. 
%       
%           hex results in a 20x20x20 hexagonal closed pack structure, with
%           each crystal having 12 nearest neighboors. 
%
%
%       in.distype is a character array specifying the type of crystal
%       distrobution to make. Possible values are 'iso'.
%           iso results in a isotropic randomly generated crystal pattern.
%
%       in.disangles is an NELEMx2 array holding [Ao1, A1; ...; Ao_NELEM, A_NELEM]
%       where the 'Ao's are the girdle angle of the crystal distrobution and
%       the 'A's are the cone angles of the distrobution
%
%       in.ynsoft is a character array of either 'yes' or 'no' that turns on or off the
%       softness parameter due to nearest neighbor interaction
%
%       in.soft is a 1x2 array holding the numeric softness parameters, [xc, ec].
%           xc is the contribution of the center crystal and ec is the controbution of
%           each neighbor crystal
%
%       in.glenexp is a NELEMx1 array holding the exponent from glens flow law for each
%       element. 3 is the defalut value for all elements.
%
%       in.stress is a 3x3xNELEM array holding the stress tensor for each element.
%
%       in.grain is a NELEMx2 array holding, [MIN, MAX], the minimum, MIN, and maximum,
%       MAX, crystal diameters for building a crystal distrobution for each element. Grain
%       sizes are picked randomly from within this open interval. 
%
%       in.Do is a NELEMx1 array holding the initial average grain size for each element. 
%
%       in.numbcrys is a scaler value holding the number of crystals in the elements. 
%
%       in.tsize is the time interval between sucessive steps.
%
%       in.tunit is a character array that specifies the units of tsize. Possible units
%       are 'year','day', and 'seconds', where 'year' is the default.
%
%       in.T is a NELEMx1 array holding the temperature of each element.
%       
%       in.Tunit is a character array that specifies the units of T. Possible units are
%       'kelvin' and 'celsius' where 'kelvin' is the default. 
%
%       in.A is an 2x12 array holding the tempurature dependance of Glen's flow law
%       parameter as taken from 'The Physics of Glaciers' by Patterson. (3rd Ed.)
%
% SETUP saves a set of variables in the form of  EL********, where  ********* is the
% element number, into directory called 'CrysDists'. nelem files are created with each
% containing a crystal distrobution. The distrobutions are aranged in an 8000x10 cell
% array.
%   NAMES is a structure holding th cell locations of the information
%   specified by each field of NAMES. The information cells are:
%      1) theta holds the colatitudinal orientation angle for the crystal
%      2) phi holds the longitudinal orientation angle for the crystal
%      3) rss holds the resolved shear stress on the crystal
%      4) vel holds he velocity gradient tensor for the crystal
%      5) ecdot holds the single crystal strain rate
%      6) odf hold the crystals controbution to the orientation distrobution function, ODF
%      7) crysSize holds the crystal diameter for the crystal
%      8) disdens holds the dislocation density for the crystal
%      9) dislEn holds the dislocation energy for the crystal
%      10)shmidt holds the shmidt tensor for the three slip systems of the crystal
%   NAMES.files holes a column vector of all the files names where the row number
%   corrosponds to the crystal number.
%       therefor, a crystal distrobution can be accessed as such:
%           eval(['load ./CrysDists/' NAMES.files{*********}]);
%       and the contents of a loaded crystal distrobution as such:
%           EL*********{crystal_number, NAMES.field_name}
%   However, for parallel applications in matlab, this functionality is resticted. It is
%   therefore best to use NAMES as a reference to remember the cell locations and not use
%   it as a programing convention. The file can still be accesed the through the NAMES
%   structure when the proxy save function isave is used. (Matlab restricts the use of
%   eval in parallel for loops). 
%
% setup returns variables CONN, NAMES, and SETTINGS. 
%   CONN is a NUMBCRYSx12 array holding the crystal number for each nearest neighbor in
%   the columns (first 6 used for  cubic and all twelve used for hexognal or fcc type
%   packing) of the crystal specified by the row number. 
%
%   NAMES is outlined above.
%
%   SETTINGS is an equivelent structure to 'in' outlined above. SETTINGS will be used to
%   change the model settings over time while keeping the initial settings in 'in' intact
%   throughout the model.
%
%   see also Thor, Thor.Build, and Thor.Build.structure

    %% Initialize variables
    
    % initialize structure that holds crystal info. Outlined above.
    NAMES = struct('theta', 1, 'phi', 2, 'rss', 3, 'vel', 4, 'ecdot', 5, 'odf', 6,... 
        'crysSize', 7, 'disdens', 8, 'dislEn', 9, 'shmidt', 10);
    
    % initialize connectivity structure
    CONN = nan(in.numbcrys,12);
    switch in.contype
        case 'cube'
            % cube length width hight array
            cube = [in.width, in.width, in.width];
            % initialize connectivity structure
            CONN = nan(in.numbcrys,12);
            % get cubic connectivity, 6 nearest neighbors
                % get indices for crystals
                [I,J,K] = ind2sub(cube,1:in.numbcrys);
                % get the top, bottom, left, right, back, front indices 1xNUMBCRYS*6
                cons = [I-1, I+1,   I,   I,   I,   I;...
                          J,   J, J-1, J+1,   J,   J;...
                          K,   K,   K,   K, K-1, K+1 ];
                % mask any unvalid indexes
                mask = [I-1, I+1, J-1, J+1,  K-1, K+1 ];
                mask = mask<1 | mask>in.width;
                % get valid index numbers on the conecting crystals
                ind = sub2ind(cube, cons(1,~mask)', cons(2,~mask)', cons(3,~mask)');
            % set connectivity matrix
            CONN(~mask) = ind;
        
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
            crysStruct = {0, 0, zeros(1,3), zeros(3,3), zeros(3,3), 0, 0, 0, 0, zeros(3,3,3)};
            % CrysDist is a cell array containing all the individual crystal
            % structured for a crystal distrobution

            %% Initial crystal prameters
            %  dislocation density -- thor2002 -- value set [38]
            crysStruct{8} = 4*1e10; % m^{-2}

            % build a crystal distrobution
            crysDist = repmat(crysStruct, in.numbcrys,1);
            
            switch in.distype
                case 'iso'
                    % create and crystal distrobution for each element and save then to disk
                    for ii = 1:in.nelem
                        % set file name
                        NAMES.files{ii} = sprintf('EL%09.0f', ii);
                        % create isotropic distrobution of angles
                        THETA = in.disangles(ii,1) + (in.disangles(ii,2)-in.disangles(ii,1))...
                                *rand(in.numbcrys,1);
                        PHI = 2*pi*rand(in.numbcrys,1);
                        % creat isotropic distrobution of grain size
                        GRAINS = in.grain(ii,1) + (in.grain(ii,2)-in.grain(ii,1))*rand(in.numbcrys,1);
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
        tmp.(NAMES.files{ii}) = Thor.Utilities.vec( tmp.(NAMES.files{ii}), in, ii, CONN);        
        
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