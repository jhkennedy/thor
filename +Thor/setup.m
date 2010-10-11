function [ NAMES, SET] = setup( in, RUN )
% [ NAMES, SETTINGS ] = SETUP( in, RUN ) sets up the the model.
%   Initial settings set in 'in' are used to build the list of crystal
%   distrobution names, NAMES, and the model settings, SETTINGS. If no
%   crystal distrobution files are specified, setup will build crystal
%   distrobution based on the parameters set in 'in'.     
%
%   RUN is the run number to seperate different runs.
%
%   'in' is a structure holding the initial model parameters. The in structure can be
%   built by calling the function Thor.Build.structure.
%
%       in.nelem is a scalar value, [NELEM], giving the number of elements or crystal
%       distrobutions.
%
%       in.distype is a character array specifying the type of crystal
%       distrobution to make. Possible values are 'iso'.
%           'iso' results in a isotropic randomly generated crystal pattern.
%            'same' results in a distrobution that is the same for every element. 
%            'NNI' results in a distrobution that has the same eigen values but the
%               crystals are randomly placed into the distrobutin so that the nighboors
%               are random for each element.   
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
%       parameter as taken from 'The Physics of Glaciers' by Patterson.
%       (3rd Ed.) It should have units of s^{-1} Pa^{-n}, where n is the
%       glen exponent. 
%       
%       in.connName is a character array holding the name of the
%       connectivity array .mat file. This is built with
%       Thor.Build.connectivity.
%
% SETUP saves a set of variables in the form of  EL********, where  ********* is the
% element number, into directory called 'CrysDists'. nelem files are created with each
% containing a crystal distrobution. The distrobutions are aranged in an 8000x10 cell
% array.
%
%   NAMES.files holes a column vector of all the files names where the row number
%   corrosponds to the crystal number.
%       therefor, a crystal distrobution can be accessed as such:
%           eval(['load ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{*********}]);
%       and the contents of a loaded crystal distrobution as such:
%           EL*********{crystal_number, NAMES.field_name}
%   However, for parallel applications in matlab, this functionality is
%   resticted. The file can still be accesed the through the NAMES
%   structure when the proxy save function isave is used. (Matlab restricts
%   the use of eval in parallel for loops). 
%
% setup returns variables NAMES, and SETTINGS. 
%
%   NAMES is outlined above.
%
%   SETTINGS is an equivelent structure to 'in' outlined above. SETTINGS will be used to
%   change the model settings over time while keeping the initial settings in 'in' intact
%   throughout the model.
%
%   see also Thor, Thor.Build, Thor.Build.structure, and Thor.Build.connectivity.

    %% make directory for run
    warning off MATLAB:MKDIR:DirectoryExists
    eval(['mkdir ./+Thor/CrysDists/Run' num2str(RUN) '/']);
    eval(['mkdir ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/']);
    

        
    %% initialize crystal distributions
    switch in.distype
        case 'saved'
            % check that a saved distribution is of the right size and structure, if not,
            % build appropriate structure
            
            % load in file names
        
        otherwise

            %% Initial crystal prameters
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}

            
            switch in.distype
                case 'iso'
                   
                    % set file names for each element
                    fname = @(x) sprintf('EL%09.0f', x);
                    NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);
                    
                    for ii = 1:in.nelem
                        % creat isotropic distrobution of angles
                        cdist.theta = in.disangles(ii,1) + (in.disangles(ii,2)-in.disangles(ii,1))...
                                    *rand(in.numbcrys,1);
                        cdist.phi = 2*pi*rand(in.numbcrys,1);
                        

                        % creat isotropic distrobution of grain size
                        cdist.size = in.grain(ii,1) + (in.grain(ii,2)-in.grain(ii,1))*rand(in.numbcrys,1);

                        % save crystal distrobutions
                        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                        % Save a copy for step zero
                        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                    end
                     
                case 'same'
                    % create the same crystal distrobution for same number of crystals and
                    % distrobution angles then save them to disk 
                    
                    % set file names for each element
                    fname = @(x) sprintf('EL%09.0f', x);
                    NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);
                    
                    for ii = 1:in.nelem
                        % creat isotropic distrobution of angles
                        PHI = linspace(0,2*pi, in.width(1)*in.width(2));
                        THETA = linspace(in.disangles(ii,1),in.disangles(ii,2), in.width(3));
                        cdist.phi= repmat(PHI,1,in.width(3))';
                        THETA = repmat(THETA,in.width(1)*in.width(2),1);
                        cdist.theta = reshape(THETA,1,[])';

                        % creat isotropic distrobution of grain size
                        cdist.size = in.Do(ii,1)*ones(in.numbcrys, 1);

                        % save crystal distrobutions
                        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                        % Save a copy for step zero
                        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                    end
                    
                case 'NNI'
                    % create the same crystal distrobution for same number of crystals and
                    % distrobution angles but randomize the packing then save them to disk 
                    
                    % set file names for each element
                    fname = @(x) sprintf('EL%09.0f', x);
                    NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);
                    
                    for ii = 1:in.nelem
                        % creat isotropic distrobution of angles
                        PHI = linspace(0,2*pi, in.width(1)*in.width(2));
                        THETA = linspace(in.disangles(ii,1),in.disangles(ii,2), in.width(3));
                        PHI = repmat(PHI,1,in.width(3));
                        THETA = repmat(THETA,in.width(1)*in.width(2),1);
                        THETA = reshape(THETA,1,[]);

                        % randomize order of crystals
                        sort = [randperm(in.numbcrys)',THETA',PHI'];
                        sort = sortrows(sort,1);

                        cdist.theta = sort(:,2);
                        cdist.phi = sort(:,3);

                        % creat isotropic distrobution of grain size
                        cdist.size = in.Do(ii,1)*ones(in.numbcrys, 1);

                        % save crystal distrobutions
                        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                        % Save a copy for step zero
                        eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                    end
                    
            end
    end
    
    % set the model settings
    SET = in;
    
    
end