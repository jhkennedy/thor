function connectivity(width, type)
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
            
            numbcrys = width(1)^3;
            if (width(1) ~= width(2)) || width(1) ~= width(3)
                clear CONN;
                error('Crystal distrobutions of type ''cube'' must have the same width on each side. ie, width = [20,20,20] for an 8000 crystal distrobution.');
            end
            % cube length width hight array
            cube = width;
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
                mask = mask<1 | mask>width(1);
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
            
            
        case 'rec'
            
            numbcrys = width(1)*width(2)*width(3);
            % cube length width hight array
            % initialize connectivity structure
            CONN = nan(numbcrys,6);
            % get cubic connectivity, 6 nearest neighbors
                % get indices for crystals
                [I,J,K] = ind2sub(width,1:numbcrys);
                % get the top, bottom, left, right, front, back indices 1xNUMBCRYS*6
                cons = [I-1, I+1,   I,   I,   I,   I;...
                          J,   J, J-1, J+1,   J,   J;...
                          K,   K,   K,   K, K-1, K+1 ];
                % mask any unvalid indexes
                m1 = (I-1)<1; m2 = (I+1)>width(1);
                m3 = (J-1)<1; m4 = (J+1)>width(2);
                m5 = (K-1)<1; m6 = (K+1)>width(3);
                mask = [m1, m2, m3, m4, m5, m6];
                % get valid index numbers on the conecting crystals
                ind = sub2ind(width, cons(1,~mask)', cons(2,~mask)', cons(3,~mask)');
            % set connectivity matrix
            CONN(~mask) = ind;
            
            for ii = 1:numbcrys
                CON2{ii,1} = CONN(ii,~isnan(CONN(ii,:)));
            end
            
            CONN = CON2;
            
            % save conectivity structure
            eval(['save ./+Thor/+Build/Settings/CONN/',type, num2str(width(1)),'x',num2str(width(2)),'x',num2str(width(3)),'.mat CONN']);
        
        case 'hex'
          % hexagonal connectivity, 12 nearest neigbors  
          
        otherwise
            error('%s is not a known connectivity type. To see valid types, type ''help Thor.Build.connectivity''.',type);
    end
 %%   
end
          