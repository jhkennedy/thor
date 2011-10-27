N = 1000;
E = .33:.01:1;


E(2,:) = (1-E(1,:))/2;
E(3,:) = E(2,:);

K = zeros(1,size(E,2)-1);
for ii = 1:size(E,2)-1
    
    K(1,ii) = Thor.ODF.watsonK(E(:,ii));
    
end; clear ii;

cdist = zeros(N,3,size(E,2)-1);
for ii = 1:size(E,2)-1
    
    cdist(:,:,ii) = Thor.ODF.watsonGenerate(N, K(ii));
    
end; clear ii;

%% 

angs = zeros(N,2,size(E,2)-1);
for ii = 1:size(E,2)-1
    
       % calculate polar angles
            HXY = sqrt(cdist(:,1,ii).^2+cdist(:,2,ii).^2);
            THETA = atan2(HXY,cdist(:,3,ii));
            PHI   = atan2(cdist(:,2,ii),cdist(:,1,ii));
            
            % check angles are within allowed bounds 
            % (0 <= THETA <= pi/2, 0 <= PHI <= 2*pi)
                % THETA < 0 -- flip to positive theta and rotate PHI by pi
                PHI(THETA < 0) = PHI(THETA < 0) + pi;
                THETA(THETA < 0) = abs(THETA(THETA < 0));
            
                % THETA > pi/2 -- use `other end' of c-axis (symetric: can't
                % tell which side is which) 
                PHI(THETA > pi/2) = PHI(THETA > pi/2) + pi;
                THETA(THETA > pi/2) = pi - THETA(THETA > pi/2);

                % make sure PHI is within bounds
                PHI = rem(PHI +2*pi, 2*pi);  
    
    angs(:,1,ii) = THETA;
    angs(:,2,ii) = PHI;
    
end; clear ii HXY PHI THETA;

%%
cd /home/joseph/Documents/MATLAB/
ca = zeros(1,size(E,2)-1);
for ii = 1:size(E,2)-1
    ca(ii) = coneAngle(angs(:,1,ii));
end; clear ii;
ca_deg = deg(ca);

% %%
% 
% cd ~/Documents/MATLAB/
% 
% for ii = 1:size(E,2)-1
%     
%     equalAreaPoint(cdist(:,:,ii));
%     
%     pause(.25);
%     clf('reset');
%     
% end; clear ii;

cd /home/joseph/Documents/Programs/Thor/trunk/