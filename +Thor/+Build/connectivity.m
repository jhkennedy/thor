function[saveName] = connectivity(width, type)
% [saveName] = connectivity(numbcrys, type) builds and saves connectivity
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
% name referring to type and numbcrys which contains CONN. [saveName] is
% then returned by the function where:
%
%   saveName is the name of the the saved file.
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
            
            % conectivity stucture name:
            saveName = [type, num2str(numbcrys)];            
            
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
            saveName = [type, num2str(width(1)),'x',num2str(width(2)),'x',num2str(width(3))];
            eval(['save ./+Thor/+Build/Settings/CONN/',saveName ,'.mat CONN']);
        
        otherwise
            error('%s is not a known connectivity type. To see valid types, type ''help Thor.Build.connectivity''.',type);
    end
    
    % save connectivity structure
    eval(['save ./+Thor/+Build/Settings/CONN/',saveName,'.mat CONN']);

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


