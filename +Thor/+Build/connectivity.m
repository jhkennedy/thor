function connectivity(numbcrys, type)
% [CONN] = connectivity(numbcrys, type) builds and saves connectivity structures.
%   type is a character array specifying the packing structure of the
%       crystals. NUMBCRYS crystals are used in each distrobution. Possible values
%       are 'cubic' or 'hex'. 
%           cubic results in a 20x20x20 cubic distrobution of crystals, each 
%           having 6 nearest neighbors. 
%       
%           hex results in a 20x20x20 hexagonal closed pack structure, with
%           each crystal having 12 nearest neighboors. 
% Connectivity saves a file in './+Thor/+Build/Settings/CONN/' with a file name refering
% to type and numbcrys which contains CONN. 
%   CONN is a NUMBCRYSx1 cell array holding the crystal number for each nearest neighbor
%   of the crystal specified by the row number. 
%%
    switch type
        case 'cube'
            width = round(numbcrys^(1/3));
            if width^3 ~= numbcrys
                clear CONN;
                error('Crystal distrobutions of type ''cube'' must have the number of crystals equal to the cube of some integer. For example, 8000 crystals is 20^3 crystals.');
            end
            % cube length width hight array
            cube = [width, width, width];
            % initialize connectivity structure
            CONN = nan(numbcrys,6);
            % get cubic connectivity, 6 nearest neighbors
                % get indices for crystals
                [I,J,K] = ind2sub(cube,1:numbcrys);
                % get the top, bottom, left, right, front, back indices 1xNUMBCRYS*6
                cons = [I-1, I+1,   I,   I,   I,   I;...
                          J,   J, J-1, J+1,   J,   J;...
                          K,   K,   K,   K, K-1, K+1 ];
                % mask any unvalid indexes
                mask = [I-1, I+1, J-1, J+1,  K-1, K+1 ];
                mask = mask<1 | mask>width;
                % get valid index numbers on the conecting crystals
                ind = sub2ind(cube, cons(1,~mask)', cons(2,~mask)', cons(3,~mask)');
            % set connectivity matrix
            CONN(~mask) = ind;
            
            for ii = 1:numbcrys
                CON2{ii,1} = CONN(ii,~isnan(CONN(ii,:)));
            end
            
            CONN = CON2;
            
            % save conectivity structure
            eval(['save ./+Thor/+Build/Settings/CONN/',type, num2str(numbcrys),'.mat CONN']);
            
            
        case 'hex'
          % hexagonal connectivity, 12 nearest neigbors  
          
        otherwise
            error('%s is not a known connectivity type. To see valid types, type ''help Thor.Build.connectivity''.',type);
    end
 %%   
end
          