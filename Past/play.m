test

cdist = cp1;

    Od = 0; % s^{-1} bulk rotation rate boundry condition

    % modeled velocity gradient
    Lm = Thor.Utilities.bvel(cdist, SET); % s^{-1}

    % modeled rotation rate
    Om = (1/2)*(Lm - Lm'); % s^{-1}

    % bulk roation 
    Ob = Od + Om; % s^{-1}
    
    % single crystal plastic rotation rate
    Op = cdist.vel/2 - permute(cdist.vel,[2,1,3])/2; % s^{-1}

    % crystal latice rotation
    Os = repmat(Ob,[1,1,SET.numbcrys]) - Op;
    
    % C-axis orientations
    N   = [sin(cdist.theta).*cos(cdist.phi) sin(cdist.theta).*sin(cdist.phi) cos(cdist.theta)]; % -
    
tic
C = mat2cell(SET.tstep*OS,3,3,ones(1,125));
C = cellfun(@expm,C,'UniformOutput',false);
    % get new C-axis orientation
    N1 =squeeze(sum(cell2mat(C).*permute(reshape(repmat(N,[1,3])',3,3,[]),[2,1,3]),2)); % -
toc

tic
for ii = 1:125
    N2(ii,:) = expm(SET.tstep*Os(:,:,ii))*N(ii,:)';
end
toc

tic
 n1 = N'+squeeze(sum(SET.tsize.*Os.*permute(reshape(repmat(N,[1,3])',3,3,[]),[2,1,3]),2));
 n2 = 
toc