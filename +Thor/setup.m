function [ NAMES, SET] = setup( in, RUN )
% [ NAMES, SET ] = SETUP( in, RUN ) sets up the the model.
%   Initial settings set in 'in' are used to build the list of crystal
%   distribution names, NAMES, and the model settings, SET. If no
%   crystal distribution files are specified, setup will build crystal
%   distribution based on the parameters set in 'in'.     
%
%   RUN is the run number to separate different runs.
%
%   'in' is a structure holding the initial model parameters. The in
%   structure can be built from the template +Thor/+Build/inTEMPLATE.mat.
%   This structure will become the settings structure SET after SETUP is
%   run.  
%
%       in.nelem is a scalar value, [NELEM], giving the number of elements
%       or crystal distributions.
%
%       in.numbcrys is a scaler value holding the number of crystals in the
%       elements.  
%
%       in.distype is a character array specifying the type of crystal
%       distribution to either make or load. To make a distribution set 
%       in.distype to 'iso', 'same' or 'NNI'. 
%           'iso' results in a isotropic randomly generated crystal pattern
%
%            'same' results in a single isotropic distribution that is used
%            for every element. 
%
%            'NNI' is the same as 'same' except that the crystals are
%            randomly ordered for each element.    
%
%       in.stress is a 3x3xNELEM array holding the stress tensor for each
%       element.
%
%       in.xcec is a NELEMx2 array holding the numeric softness parameters,
%       [xc1, ec1; ...; xc_NELEM, ec_NELEM] where the 'xc's are the
%       contributions of the center crystals and the 'ec's are the
%       contributions of each neighbor crystal.  
%
%       in.T is a NELEMx1 array holding the temperature of each element in
%       degrees Celsius. 
%
%       in.glenexp is a NELEMx1 array holding the exponent from glens flow
%       law for each element. 3 is the default value for all elements.
%
%       in.width is a 1x3 array holding the length width and hight of the
%       crystal distributions
%
%       in.tstep is a NELEMx1 array that will hold the current length of
%       the time step in seconds for each element. 
%
%       in.ti is a NELEMx1 array that will hold the current model time in
%       seconds for each element.  
%
%       in.to is a NUMBCRYSxNELEM zeros array that will hold the time of
%       last recrystallization for each crystal. This is needed by the
%       normal growth law.
%
%       in.CONN is a character array holding the name of the connectivity
%       array .mat file. This is built with Thor.Build.connectivity. 
%       
%       in.A is a 2x12 array holding the temperature dependence of Glen's
%       flow law parameter as taken from 'The Physics of Glaciers' by
%       Cuffey and Patterson (4th Ed.). It has units of s^{-1} Pa^{-n},
%       where n is the glen exponent. 
%
%       in.poly is a 1x1 logical that turn on and off polygonization (on
%       when true).
%
%       in.migre is a 1x1 logical that turn on and off migration
%       recrystallization (on when true). 
%
%       'in' also has a number of optional parameters. If in.distype is set
%       to create crystal distributions, THOR will need these optional
%       settings. 
%
%           in.disangles is an NELEMx2 array holding 
%           [Ao1, A1; ...; Ao_NELEM, A_NELEM] where the 'Ao's are the
%           girdle angles of the crystal distribution and the 'A's are the
%           cone angles of the distribution.
%
%           in.grain is a NELEMx2 array holding, [MIN, MAX], the minimum,
%           MIN, and maximum, MAX, crystal diameters for building a crystal
%           distribution for each element. Grain sizes are picked randomly
%           from within this open interval.    
%
%       SETUP will also create the structure in.Do, NUMBCRYSxNELEM array,
%       which saves the initial grain size of each crystal. This is needed
%       by the normal growth law. 
%
% SETUP saves a set of variables in the form of  EL********.mat, where
% ********* is the element number, into directory +Thor/CrysDists. nelem
% files are created with each containing the fields of the crystal
% distrobution structure: theta, phi, size and dislDens.
%
%   theta is the co-latitude angles of the crystals in the distribution.
%
%   phi is the azimuth angles of the crystals in the distribution. 
%
%   size is the sizes of the crystals in the distribution.
%
%   dislDens is the dislocation densities of the crystals in the
%   distribution. 
%
% setup returns variables NAMES, and SET. 
%       
%   NAMES structure which has the field 'files'. NAMES.files holds a cell
%   vector of all the EL********.mat files names where the index
%   corresponds to the crystal number. Therefor, a crystal distribution can
%   be accessed as such:
%       cdist = load(['./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii}])
%
%   SET is an equivelent structure to 'in' outlined above. SET will be used
%   to change the model settings over time while keeping the initial
%   settings in 'in' intact throughout the model. 
%
%   see also Thor, Thor.Build and Thor.Build.connectivity.

    %% make directory for run
    warning off MATLAB:MKDIR:DirectoryExists
    eval(['mkdir ./+Thor/CrysDists/Run' num2str(RUN) '/']);
    eval(['mkdir ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/']);
    

        
    %% initialize crystal distributions
    switch in.distype{1,:}
        % FIXME: Use code from ODF to build isotropic crystal distributions
        case 'iso'
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}
            % set file names for each element
            fname = @(x) sprintf('EL%09.0f', x);
            NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);

            for ii = 1:in.nelem
                % create isotropic distribution of angles
                cdist.theta = in.disangles(ii,1) + (in.disangles(ii,2)-in.disangles(ii,1))...
                            *rand(in.numbcrys,1);
                cdist.phi = 2*pi*rand(in.numbcrys,1);


                % create isotropic distribution of grain size
                cdist.size = in.grain(ii,1) + (in.grain(ii,2)-in.grain(ii,1))*rand(in.numbcrys,1);
                in.Do(:,ii) = cdist.size;

                % save crystal distributions
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                % Save a copy for step zero
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
            end

        case 'same'
            % create the same crystal distribution for same number of crystals and
            % distribution angles then save them to disk 
            
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}
            
            % set file names for each element
            fname = @(x) sprintf('EL%09.0f', x);
            NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);

            for ii = 1:in.nelem
                % create isotropic distribution of angles
                PHI = linspace(0,2*pi, in.width(1)*in.width(2));
                THETA = linspace(in.disangles(ii,1),in.disangles(ii,2), in.width(3));
                cdist.phi= repmat(PHI,1,in.width(3))';
                THETA = repmat(THETA,in.width(1)*in.width(2),1);
                cdist.theta = reshape(THETA,1,[])';

                % create isotropic distribution of grain size
                cdist.size = mean(in.grain).*ones(size(cdist.theta));
                in.Do(:,ii) = cdist.size;    
                
                % save crystal distributions
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                % Save a copy for step zero
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
            end

        case 'NNI'
            % create the same crystal distribution for same number of crystals and
            % distribution angles but randomize the packing then save them to disk 
            
            %  dislocation density -- thor2002 -- value set [38]
            cdist.dislDens = ones(in.numbcrys,1)*4*1e10; % m^{-2}

            % set file names for each element
            fname = @(x) sprintf('EL%09.0f', x);
            NAMES.files = cellfun(fname,num2cell(1:in.nelem),'UniformOutput',false);

            for ii = 1:in.nelem
                % create isotropic distribution of angles
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

                % create isotropic distribution of grain size
                cdist.size = mean(in.grain).*ones(size(cdist.theta));
                in.Do(:,ii) = cdist.size;
                
                % save crystal distributions
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
                % Save a copy for step zero
                eval(['save ./+Thor/CrysDists/Run' num2str(RUN) '/SavedSteps/Step00000_' NAMES.files{ii} ' -struct cdist theta phi size dislDens']);
            end
            
        otherwise
            % load saved crystal distribution
            
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



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEvoR: Fabric Evolution with Recrystallization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2009-2014  Joseph H Kennedy
%
% This file is part of FEvoR.
%
% FEvoR is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later 
% version.
%
% FEvoR is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
% details.
%
% You should have received a copy of the GNU General Public License along 
% with FEvoR.  If not, see <http://www.gnu.org/licenses/>.
%
% Additional permission under GNU GPL version 3 section 7
%
% If you modify FEvoR, or any covered work, to interface with
% other modules (such as MATLAB code and MEX-files) available in a
% MATLAB(R) or comparable environment containing parts covered
% under other licensing terms, the licensors of FEvoR grant
% you additional permission to convey the resulting work.


