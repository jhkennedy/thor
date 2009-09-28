function [ eldata ] = setup( nelem, contype, distype, disangles  )
% [ELDATA] = SETUP(NELEM, CONTYPE, DISTYPE, DISANGLES) sets up the cell
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
% SETUP returns ELDATA, an 1xnelem cell array with each cell containing a
% crystal distrobution. 
% The distrobution is aranged in an 8000x7 cell array
% which is best indexed using the global varaiable NAMES created. 
%   NAMES is a structure holding th cell locations of the information
%   specified by each field of NAMES. The information cells are:
%       THETA holds the colatitudinal orientation angle for the crystal
%       PHI holds the longitudinal orientation angle for the crystal
%       SHMIDT holds the Shmidt tensors on each slip system for the crystal
%       RSS holds the rrss on each slip system for the crystal
%       VEL holds he velocity gradient tensor for the crystal
%       ECDOT holds the single crystal strain rate
%       CONNECT is a 1x12 vector holding the crystal number for each
%           nearest neighbor (first 6 used for  cubic and all twelve used
%           for hexognal or fcc type packing)
%
% therefor, a single crystal is accessed as such:
% ELDATA{element_number}{crystal_number,NAMES.field_name}
%
%   ELDATA{1}{1,NAMES.THETA} returns the colatitudinal orientation angle of
%   the first crystal in the first element. 

    %% Initialize variables
    
    % set up global cell axcess array (more explination when assigned)
    global NAMES
    
    % number of crystals
    numbcrys = 20*20*20;

    % initialize structure that holds crystal info
    % names is a structure holding cell location of the information for a
    % crystal specified by the cell crysStruct
        % THETA holds the colatitudinal orientation angle for the crystal
        % PHI holds the longitudinal orientation angle for the crystal
        % SHMIDT holds the Shmidt tensors on each slip system for the crystal
        % RSS holds the rrss on each slip system for the crystal
        % VEL holds he velocity gradient tensor for the crystal
        % ECDOT holds the single crystal strain rate
        % CONNECT is a 1x12 vector holding the crystal number for each
            % nearest neighbor (first 6 used for  cubic and all twelve used
            % for hexognal or fcc type packing)
    NAMES = struct('theta', 1, 'phi', 2, 'shmidt', 3, 'rss', 4, ...
                   'vel', 5, 'ecdot', 6, 'connect', 7);
    crysStruct = {0, 0, zeros(3,3,3), ones(1,3), ...
                      zeros(3,3), zeros(3,3), NaN(1,12)};
    % CrysDist is a cell array containing all the individual crystal
    % structured for a crystal distrobution
    crysDist = repmat(crysStruct, numbcrys,1);
    % eldata is a cell array containing all the crystal distrobutions for
    % each element
    eldata = cell(1, nelem);
    
    %% initialize each crystal and its connectivity structure
    switch contype
        case 'cube'
            % cubic connectivity, 6 nearest neigbors
            parfor ii = 1:numbcrys
                % get index for current crystal
                [I J K] = ind2sub([20 20 20], ii);
                % get the top-bottom-left-right-back-front indexes
                cons = [I-1, J, K; I+1, J, K; I, J-1, K;...
                          I, J+1, K; I, J, K-1; I, J, K+1];
                % try to get linear indecies
                for jj = 1:6
                    try
                        crysDist{ii,7}(jj) = sub2ind([20 20 20],...
                                                 cons(jj,1),cons(jj,2),cons(jj,3));
                    catch ME %#ok<NASGU>
                        % subscrypt was outside of array. This will hapen at all
                        % corners and walls. Will leave value as NaN.
                    end
                end
             end
        case 'hex'
            
    end
    
    % initialize each element
    parfor ii = 1:nelem
        eldata{ii} = crysDist;
    end

    
    %% initialize crystal distrobutions
    switch distype
        case 'iso'
            % generate angles and place then in crystal distrobutions
            for ii = 1:nelem
                THETA = disangles(ii,1) + (disangles(ii,2)-disangles(ii,1))...
                        *rand(20*20*20,1);
                THETA = num2cell(THETA);
                PHI = 2*pi*rand(20*20*20,1);
                PHI = num2cell(PHI);
                eldata{ii}(:,1) = THETA;
                eldata{ii}(:,2) = PHI;
            end
    end
    
    %% calculate initial shmidt tensor for each crystal
    
    parfor ii = 1:nelem
        for jj = 1:8000
            eldata{ii}{jj,3} = Thor.Utilities.shmidt(eldata{ii}{jj,1}, eldata{ii}{jj,2});
        end
    end
    
end

