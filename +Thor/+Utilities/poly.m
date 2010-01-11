function [ cdist ] = poly( cdist, SET, elem )
% [cdist]=poly(cdist, SET, elem) polygonizes crystals favorable do so.
%   cdist is a crystal distrobution is aranged in an (SET.numbcrys)x10 cell array. The crystal
%   distrubution structure is outlined in Thor.setup.
%   
%   SET is a structure holding the model setting as outlined in Thor.setup.
%
%   elem is the element number of the crystal distrobution, cdist.
%
% poly retruns a crystal distrobution, cdist, withpolygonized crystals that were favorable
% to do so. 
%
%   See also Thor.setup


    del = 0.065; % ratio threshold -- Thor 2002 [26]
    rhop = 5.4e10; % m^{-2} dislocation density needed to form a wall -- Thor 2002 [26]
    
    for ii = 1:SET.numbcrys
        % get crystal angles and applied stress
        THETA = cdist{ii,1}; % -
        PHI = cdist{ii,2}; % -
        S = SET.stress(:,:,elem); % Pa
        
        
        % basal plane vectors for the crystal
        B(1,:)  =  1/3*[cos(THETA).*cos(PHI) cos(THETA).*sin(PHI) -sin(THETA)];  % -
        B(2,:)  = -1/6*[(cos(THETA).*cos(PHI) + 3^(.5)*sin(PHI))...
         (cos(THETA).*sin(PHI) - 3^(.5)*cos(PHI)) -sin(THETA)]; % -
        B(3,:)  = -1/6*[(cos(THETA).*cos(PHI) - 3^(.5)*sin(PHI))...
         (cos(THETA).*sin(PHI) + 3^(.5)*cos(PHI)) -sin(THETA)]; % -
        
        % calculate the magnitude of the RSS
        Mtau = norm(B(1,:)*cdist{ii,3}(1,1)+B(2,:)*cdist{ii,3}(1,2)+B(3,:)*cdist{ii,3}(1,3)); % Pa
        Mstress = ( S(1,1)*S(2,2)+S(2,2)*S(3,3)+S(3,3)*S(1,1)...
                   -(S(1,2)^2+S(2,3)^2+S(3,1)^2) )^(1/2); % Pa
       
       % compare  magnitude of the RSS to magnitude of the applied stress and polyconize
       % if favorable
       if ((Mtau/Mstress)<del) && (cdist{ii,8}>rhop)
           % reduce dislocation density
           cdist{ii,8} = cdist{ii,8}-rhop; % m^{-2}
           % half crystal size
           cdist{ii,7} = cdist{ii,7}/2; % m
           % rotate crystal
           if (THETA<(pi/6))
               % if withing 30 degrees of vertical move crystal away by 5 degrees
               cdist{ii,1} = THETA + pi/36; % -
           % else choose sign at random and then move crystal +/- 5 degrees
           elseif (rand(1)<0.5)
               cdist{ii,1} = THETA + pi/36; % -
           else
               cdist{ii,1} = THETA - pi/36; % -
           end
       end
    end
end

