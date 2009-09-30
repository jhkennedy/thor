function [ eldata ] = setup( nelem, contype, distype, disangles, stress, n, ynsoft  )
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
% SETUP returns ELDATA, an 1xnelem cell array with each cell containing a
% crystal distrobution. 
% The distrobution is aranged in an 8000x5 cell array
% which is best indexed using the global varaiable NAMES created. 
%   NAMES is a structure holding th cell locations of the information
%   specified by each field of NAMES. The information cells are:
%      1) THETA holds the colatitudinal orientation angle for the crystal
%      2) PHI holds the longitudinal orientation angle for the crystal
%      3) VEL holds he velocity gradient tensor for the crystal
%      4) ECDOT holds the single crystal strain rate
%      5) ODF hold the crystals controbution to the orientation distrobution function, ODF
%
% therefor, a single crystal is accessed as such:
% ELDATA{element_number}{crystal_number,NAMES.field_name}
%
%   ELDATA{1}{1,NAMES.THETA} returns the colatitudinal orientation angle of
%   the first crystal in the first element. 
%
% setup also sets up the global variable CONN, a 1x12 vector holding the crystal number
% for each nearest neighbor (first 6 used for  cubic and all twelve used for hexognal or
% fcc type packing) 

    %% Initialize variables
    
    % set up global cell axcess array, NAMES (more explination when
    % assigned) and the conectivity matrix, CONN
    global NAMES CONN
    
    % number of crystals
    numbcrys = 20*20*20;

    % initialize structure that holds crystal info
    % names is a structure holding cell location of the information for a
    % crystal specified by the cell crysStruct
        % THETA holds the colatitudinal orientation angle for the crystal
        % PHI holds the longitudinal orientation angle for the crystal
        % VEL holds he velocity gradient tensor for the crystal
        % ECDOT holds the single crystal strain rate
        % ODF hold the crystals controbution to the orientation distrobution function, ODF
        % RSS holds the resolved shear stress for the crystal
    NAMES = struct('theta', 1, 'phi', 2, ...
                   'vel', 3, 'ecdot', 4, 'odf', 5);
     % CONN is a 1x12 vector holding the crystal number for each nearest
     % neighbor (first 6 used for  cubic and all twelve used for hexognal
     % or fcc type packing)  
    CONN = NaN(1,12,numbcrys);
    crysStruct = {0, 0, zeros(3,3), zeros(3,3), 0, zeros(1,3)};
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
            for ii = 1:numbcrys
                % get index for current crystal
                [I J K] = ind2sub([20 20 20], ii);
                % get the top-bottom-left-right-back-front indexes
                cons = [I-1, J, K; I+1, J, K; I, J-1, K;...
                          I, J+1, K; I, J, K-1; I, J, K+1];
                % try to get linear indecies
                for jj = 1:6
                    try
                        CONN(1,jj,ii) = sub2ind([20 20 20],...
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
    
    %% calculate initial velocity gradiant and single crystal strain rate
    
    parfor ii = 1:nelem % loop through the elements
        eldata{ii} = Thor.Utilities.vec( eldata{ii}, stress{ii}, n{ii}, ynsoft);
    end
    
end

