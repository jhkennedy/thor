try
   
    close all; clear all; clc;

%     h = waitbar(0, 'Initializing . . .');
    tic;
    matlabpool;
    
    load ./taylorEigen.mat
    load +Thor/+Build/initial.mat
    
    pltcrys = 1;
    toyr = 1000; 
    in.tsize =toyr*31556926;
    timesteps = 30;%290;

    
    in.T = in.T - 15;
    
    tp = zeros(8000,2,timesteps,3);
    
    for jj = [1,1, 6]
        kk = [0,ones(1,100)];

        in.soft = [jj, kk(jj)];

        [CONN, NAMES, SET] = Thor.setup(in); toc


        for ii=1:timesteps
            [ CONN, NAMES, SET ] = Thor.step(CONN, NAMES, SET ); toc
            tmp = load(['./+Thor/CrysDists/' NAMES.files{pltcrys}]);
            tmp = tmp.(NAMES.files{pltcrys});
            tp(:,:,ii,jj) = [cell2mat(tmp(:,1)), cell2mat(tmp(:,2))];
        end

    end
    
    %% af 
    eigens = zeros(3,timesteps,3);
    for ll = 1:3
        for kk = 1:timesteps
           eigens(:,kk,ll) = posterEigen(tp(:,2,kk,ll), tp(:,1,kk,ll));
        end
    end
    %% fa
    depth = (0:timesteps);
    DEAPTH = daf.a*TAYLOR(:,1).^daf.b+daf.c;
    plot(depth(2:end), eigens(3,:,1),depth(2:end), eigens(1,:,1),depth(2:end), eigens(2,:,1), 'LineWidth', 2)
        xlabel('Age (kyr)')
        axis([0 30 0 1])
        title('Model Results for Taylor Dome');
            xlabel('Age  (kyr)');
            ylabel('Eigenvalue');
            legend('\lambda_1','\lambda_2','\lambda_3',...
                    'Location', 'SouthOutside', 'Orientation', 'Horizontal');
%     figure, plot(depth(2:end), eigens(1,:,2),depth(2:end), eigens(2,:,2),depth(2:end), eigens(3,:,2))
%     figure, plot(depth(2:end), eigens(1,:,3),depth(2:end), eigens(2,:,3),depth(2:end), eigens(3,:,3))

    figure, plot(DEAPTH/1000, TAYLOR(:,3), '.',...
             DEAPTH/1000, TAYLOR(:,4), '.',...
             DEAPTH/1000, TAYLOR(:,5), '.','MarkerSize',25);
            title('Taylor Dome Ice Core');
            xlabel('Age  (kyr)');
            ylabel('Eigenvalue');
            legend('\lambda_1','\lambda_2','\lambda_3',...
                    'Location', 'SouthOutside', 'Orientation', 'Horizontal');

    
    %% adf
    matlabpool close;
    
    
catch ME
    matlabpool close;
    toc;
    rethrow(ME);
    
end