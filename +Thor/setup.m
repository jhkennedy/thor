function [ NAMES, SET] = setup( in, RUN )
% [ NAMES, SET ] = SETUP( in, RUN ) sets up the the model.
%   Initial settings set in 'in' are used to build the list of crystal
%   distrobution names, NAMES, and the model settings, SETTINGS. If no
%   crystal distrobution files are specified, setup will build crystal
%   distrobution based on the parameters set in 'in'.     
%
%   RUN is the run number to seperate different runs.
%
%   'in' is a structure holding the initial model parameters. The in structure
%   can be built from the template +Thor/+Build/inTEMPLATE.mat. This sturcture
%   will become the settings structure SET after SETUP is run. 
%
%       in.nelem is a scalar value, [NELEM], giving the number of elements or
%       crystal distrobutions. 
%
%       in.numbcrys is a scaler value holding the number of crystals in the
%       elements.  
%
%       in.distype is a character array specifying the type of crystal
%       distrobution to either make or load. To make a distrobution set 
%       in.distype to 'iso', 'same' or 'NNI'. 
%           'iso' results in a isotropic randomly generated crystal pattern.
%            'same' results in a distrobution that is the same for every
%            element. 'NNI' is the same as 'same' except that the crystals are
%            randomly ordered for each element.   
%
%       in.stress is a 3x3xNELEM array holding the stress tensor for each
%       element.
%
%       in.xcec is a NELEMx2 array holding the numeric softness parameters,
%       [xc1, ec1; ...; xc_NELEM, ec_NELEM] where the 'xc's are the
%       contributions of the center crystals and the 'ec's are the controbutions
%       of each neighbor crystal.  
%
%       in.T is a NELEMx1 array holding the temperature of each element in
%       degrees celcius. 
%
%       in.glenexp is a NELEMx1 array holding the exponent from glens flow law
%       for each element. 3 is the defalut value for all elements.  
%
%       in.width is a 1x3 array holding the length width and hight of the
%       crystal distrobutions
%
%       in.tstep is a NELEMx1 array that will hold the current length of
%       the time step in seconds for each element. 
%
%       in.ti is a NELEMx1 array that will hold the current model time in
%       seconds for each element.  
%
%       in.to is a NUMBCRYSxNELEM zeros array that will hold the time of last
%       recrystallization for each crystal. This is needed by the normal growth
%       law.
%
%       in.CONN is a character array holding the name of the
%       connectivity array .mat file. This is built with
%       Thor.Build.connectivity.
%       
%       in.A is a 2x12 array holding the tempurature dependance of Glen's flow
%       law parameter as taken from 'The Physics of Glaciers' by Patterson (3rd
%       Ed.). It has units of s^{-1} Pa^{-n}, where n is the glen exponent.   
%
%       in also has a number of optional parameters. If in.distype is set to
%       create crystal distrobutions, THOR will need these optional settings.
%
%           in.disangles is an NELEMx2 array holding [Ao1, A1; ...; Ao_NELEM,
%           A_NELEM] where the 'Ao's are the girdle angles of the crystal
%           distrobution and the 'A's are the cone angles of the distrobution. 
%
%           in.grain is a NELEMx2 array holding, [MIN, MAX], the minimum, MIN,
%           and maximum, MAX, crystal diameters for building a crystal
%           distrobution for each element. Grain sizes are picked randomly from
%           within this open interval.    
%
%       SETUP will also create the structure in.Do, NUMBCRYSxNELEM array, which
%       saves the initial grain size of each crystal. This is needed by the
%       normal growth law. 
%
% SETUP saves a set of variables in the form of  EL********.mat, where
% ********* is the element number, into directory +Thor/CrysDists. nelem files
% are created with each containing the fields of the crystal distrobution
% structure: theta, phi, size and dislDens.
%
%   theta is the co-latitude angles of the crystals in the distrobution.
%
%   phi is the azimuth angles of the crystals in the distrobution. 
%
%   size is the sizes of the crystals in the distrobution.
%
%   dislDens is the dislocation densities of the crystals in the
%   distrobution. 
%
% setup returns variables NAMES, and SETTINGS. 
%       
%   NAMES.files holes a column vector of all the EL********.mat files names
%   where the row number corrosponds to the crystal number. Therefor, a crystal
%   distrobution can be accessed as such:  
%       cdist = load(['./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii}])
%
%   SET is an equivelent structure to 'in' outlined above. SET will be used to
%   change the model settings over time while keeping the initial settings in
%   'in' intact throughout the model. 
%
%   see also Thor, Thor.Build, Thor.Build.connectivity, and Thor.Utilities.grow.

    %% make directory for run
    warning off MATLAB:MKDIR:DirectoryExists
    eval(['mkdir ./+Thor/CrysDists/Run' num2str(RUN) '/']);
    eval(['mkdir ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/']);
    

        
    %% initialize crystal distributions
    switch in.distype{1,:}
        case 'iso'
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}
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
                in.Do(:,ii) = cdist.size;

                % save crystal distrobutions
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                % Save a copy for step zero
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
            end

        case 'same'
            % create the same crystal distrobution for same number of crystals and
            % distrobution angles then save them to disk 
            
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}
            
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
                cdist.size = mean(in.grain).*ones(size(cdist.theta));
                in.Do(:,ii) = cdist.size;    
                
                % save crystal distrobutions
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                % Save a copy for step zero
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
            end

        case 'NNI'
            % create the same crystal distrobution for same number of crystals and
            % distrobution angles but randomize the packing then save them to disk 
            
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}

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
                cdist.size = mean(in.grain).*ones(size(cdist.theta));
                in.Do(:,ii) = cdist.size;
                
                % save crystal distrobutions
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                % Save a copy for step zero
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
            end
            
        otherwise
            % load saved crystal distrobution
            
            % set file names for each element
            fname = @(x) sprintf('EL%09.0f', x);
            NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);
            
            for ii = 1:in.nelem

                % check to see if file exists
                if logical(exist(in.distype{ii,1}, 'file'))

                    % load file
                    cdist = load(in.distype{ii,1});
                    if all(isfield(cdist,{'size','theta','phi','dislDens'}) )
                        if all(size(cdist.theta) == size(cdist.phi)) && all(size(cdist.theta) == size(cdist.size)) && all(size(cdist.theta) == size(cdist.dislDens))

                            % set the number of crystals in the settings
                            in.numbcrys = size(cdist.theta,1);
                            % set the initial grain size in the setting
                            in.Do(:,ii) = cdist.size;
                            
                            % save crystal distrobutions
                            eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                            % Save a copy for step zero
                            eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                            
                            
                        else
                            error('Thor:Setup:fieldSize','The loaded crystal distrobution''s theta, phi, size and dislDens fields were not all the same size; one or more crystals are missing information. ')
                        end
                    else
                        error('Thor:Setup:missingFields', 'The loaded crystal distrobution was missing a required field. %s needs to have the fields theta, phi, size and dislDens.', in.distype{ii,1});
                    end
                else

                    error('Thor:Setup:fileNotFound', ['The distobution type ',in.distype{ii,1},...
                                                      ' was not a known type or a file in matlabs path. Possible distrobution types are '...
                                                      'iso, same and NNI. Files must be ''.mat'' files and be in Matlabs path; '...
                                                      'the ''.mat'' extension must be included.'])
                end
            end
    end
    
    % set the model settings
    SET = in;
    
    
end