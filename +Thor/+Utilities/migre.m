function [ cdist ] = migre( cdist, SET, elem )
% [cdist]=migre(cdist,SET,elem) recrystalizes crystals that are favorable to do so. 
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% migre returns a crystal distrobution, cdist, with recrystalized crystals that were
% favorable to do so. 
%
%   See also Thor.setup

    % only active above 12 degrees celsius
    if SET.T(elem)>(-12)

        % new crystal dislocation density
        rhoo = 1e10; % m^{-2} 
        % effectice stress
        s = SET.stress(:,:,elem); % Pa
        es = ( s(1,1)^2 + s(2,2)^2 + s(1,1)*s(2,2) ...
              + s(1,2)^2 + s(2,3)^2 +s(3,1)^2 )^(1/2); % Pa
        % new crystal size
        pc = 1; % Pa^{4/3} m
        D = pc*es^(-4/3); % m

        for ii = 1:SET.numbcrys

            % get grain boundry energy
            Egb = Thor.Utilities.gbEn(cdist{ii,7}); % J  m^{-3}
            % check to see if it energetically favorable to recrystalize
            if cdist{ii,9}>Egb
                % set new crystals dislocation density
                cdist{ii,8} = rhoo; % m^{-2}
                % set new crystal size
                cdist{ii,7} = D; % m
                % find a soft orientation
                    RSS = sum(cell2mat(cdist(:,3)).^2,2).^(1/2);
                    RSS = RSS == max(RSS);
                    % pick an new theta ~ +- 10 degrees different than softest crystal
                    cdist{ii,1} = cdist{RSS,1} +(-1+2*rand(1))*0.02;
                    % pick an new phi ~ +- 10 degrees different than softest crystal
                    cdist{ii,2} = cdist{RSS,2} +(-1+2*rand(1))*0.02;
            end
        end
    end
end

