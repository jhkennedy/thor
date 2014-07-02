function connectivity(width, type)
% connectivity(numbcrys, type) builds and saves connectivity
% structures. 
%
%   width is a 3x1 array specifying the length (L), width (W) and height
%   (H) of the crystal structure.
%
%   type is a character array specifying the packing structure of the
%   crystals. Possible values are 'cube' or 'rec'. 
%           cubic results in a LxLxL distribution of crystals, each having
%           6 nearest neighbors.  
%           
%           rec results in a LxWxH distribution of crystals, each having 6
%           nearest neighbors.
%
% Connectivity saves a file in './+Thor/+Build/Settings/CONN/' with a file
% name referring to type and numbcrys which contains CONN.
%
%   CONN is a NUMBCRYSx1 cell array holding the crystal number for each
%   nearest neighbor of the crystal specified by the row number. 

    switch type
        case 'cube'
               
            if (width(1) ~= width(2)) || width(1) ~= width(3)
                clear CONN;
                error('Crystal distributions of type ''cube'' must have the same width on each side. ie, width = [20,20,20] for an 8000 crystal distribution.');
            end
            
            % number of crystals
            numbcrys = width(1)^3;

            % initialize connectivity structure
            CONN = nan(numbcrys,6);
            CON2 = cell(numbcrys,1);
            
            % get cubic connectivity, 6 nearest neighbors
                % get indexes for crystals
                [I,J,K] = ind2sub(width,1:numbcrys);
                % get the top, bottom, left, right, front, back indexes 1xNUMBCRYS*6
                cons = [I-1, I+1,   I,   I,   I,   I;...
                          J,   J, J-1, J+1,   J,   J;...
                          K,   K,   K,   K, K-1, K+1 ];
                % mask any unvalid indexes
                mask = [I-1, I+1, J-1, J+1,  K-1, K+1 ];
                mask = mask<1 | mask>width(1);
                % get valid index numbers on the connecting crystals
                ind = sub2ind(width, cons(1,~mask)', cons(2,~mask)', cons(3,~mask)');
            % set connectivity matrix
            CONN(~mask) = ind;
            
            for ii = 1:numbcrys
                CON2{ii,1} = CONN(ii,~isnan(CONN(ii,:)));
            end
            
            CONN = CON2; %#ok<NASGU>
            
            % save connectivity structure
            eval(['save ./+Thor/+Build/Settings/CONN/',type, num2str(numbcrys),'.mat CONN']);
            
            
        case 'rec'
            
            % get number of crystals
            numbcrys = width(1)*width(2)*width(3);

            % initialize connectivity structure
            CONN = nan(numbcrys,6);
            CON2 = cell(numbcrys,1);
            
            % get cubic connectivity, 6 nearest neighbors
                % get indexes for crystals
                [I,J,K] = ind2sub(width,1:numbcrys);
                % get the top, bottom, left, right, front, back indexes 1xNUMBCRYS*6
                cons = [I-1, I+1,   I,   I,   I,   I;...
                          J,   J, J-1, J+1,   J,   J;...
                          K,   K,   K,   K, K-1, K+1 ];
                % mask any unvalid indexes
                m1 = (I-1)<1; m2 = (I+1)>width(1);
                m3 = (J-1)<1; m4 = (J+1)>width(2);
                m5 = (K-1)<1; m6 = (K+1)>width(3);
                mask = [m1, m2, m3, m4, m5, m6];
                % get valid index numbers on the connecting crystals
                ind = sub2ind(width, cons(1,~mask)', cons(2,~mask)', cons(3,~mask)');
            % set connectivity matrix
            CONN(~mask) = ind;
            
            for ii = 1:numbcrys
                CON2{ii,1} = CONN(ii,~isnan(CONN(ii,:)));
            end
            
            CONN = CON2; %#ok<NASGU>
            
            % save connectivity structure
            eval(['save ./+Thor/+Build/Settings/CONN/',type, num2str(width(1)),'x',num2str(width(2)),'x',num2str(width(3)),'.mat CONN']);
        
        otherwise
            error('%s is not a known connectivity type. To see valid types, type ''help Thor.Build.connectivity''.',type);
    end

end
          
