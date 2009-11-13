%% Test Thor model setup
% matlabpool
% 
% nelem = 1000;
% contype = 'cube';
% distype = 'iso';
% disangles = repmat([0 pi/2], nelem, 1);
% stress = [0, 0, 0; 0, 0, 0; 0, 0, 1];
% stress = repmat(stress, [1 1 nelem]);
% n = ones(nelem,1)*3;
%     
% try
%     tic; [eldata, CONN, NAMES] = Thor.setup(nelem, contype, distype, disangles, stress, n, 'no'); toc
%     matlabpool close
% 
% catch ME
%     matlabpool close
%     rethrow(ME);
% 
% end

%% Test Thor 2001 results

% figure 3
matlabpool

nelem = 100;
contype = 'cube';
distype = 'iso';
A = linspace(pi/200, pi/2);
Ao = zeros(1,100);
disangles = [Ao', A'];
stress = [0, 0, 0; 0, 0, 0; 0, 0, 1];
stress = repmat(stress, [1 1 nelem]);
n = ones(nelem,1)*3;
    
try
    tic; [CONN, NAMES] = Thor.setup(nelem, contype, distype, disangles, stress, n, 'no'); toc
    
    
    edot = zeros(3,3,nelem);
    for ii = 1:nelem
        tmp = load(['./+Thor/CrysDists/' NAMES.files{ii}]);
        edot(:,:,ii) = Thor.Utilities.bedot(tmp.(NAMES.files{ii}));
    end
    
    edot = edot./(edot(3,3,nelem));
    edot(isnan(edot)) = 0;
%     edot(abs(edot)<=.000025) = 0;
    
    plot(A*180/pi,edot(9:9:end))
    title('Bulk strain rate enhancement for uniaxial compression');
    xlabel('Cone Angle (degrees)')
    ylabel('Enhancement Factor')

    matlabpool close

catch ME
    matlabpool close
    rethrow(ME);

end

% figure 8
% matlabpool
% 
% nelem = 100;
% contype = 'cube';
% distype = 'iso';
% A = linspace(pi/200, pi/2);
% Ao = zeros(1,100);
% disangles = [Ao', A'];
% stress = [0, 0, 1; 0, 0, 0; 1, 0, 2];
% stress = repmat(stress, [1 1 nelem]);
% n = ones(nelem,1)*3;
%     
% try
%     tic; [eldata, CONN, NAMES] = Thor.setup(nelem, contype, distype, disangles, stress, n, 'no'); toc
%     
%     
%     edot = zeros(3,3,nelem);
%     for ii = 1:nelem
%         edot(:,:,ii) = Thor.Utilities.bedot(eldata{ii});
%     end
%     
%     edot = edot./(edot(3,3,nelem));
%     edot(isnan(edot)) = 0;
% %     edot(abs(edot)<=.000025) = 0;
%     
%     plot(A*180/pi,edot(9:9:end))
%     title('Bulk strain rate enhancement for combined compression and shear');
%     xlabel('Cone Angle (degrees)')
%     ylabel('Enhancement Factor')
%     
%     matlabpool close
% 
% catch ME
%     matlabpool close
%     rethrow(ME);
% 
% end

% figure 7
% matlabpool
% 
% nelem = 100;
% contype = 'cube';
% distype = 'iso';
% A = linspace(pi/200, pi/2);
% Ao = zeros(1,100);
% disangles = [Ao', A'];
% stress = [0, 0, 1; 0, 0, 0; 1, 0, 0];
% stress = repmat(stress, [1 1 nelem]);
% n = ones(nelem,1)*3;
%     
% try
%     tic; [eldata, CONN, NAMES] = Thor.setup(nelem, contype, distype, disangles, stress, n, 'no'); toc
%     
%     
%     edot = zeros(3,3,nelem);
%     for ii = 1:nelem
%         edot(:,:,ii) = Thor.Utilities.bedot(eldata{ii});
%     end
%     
% %     edot(abs(edot)<=.000000025) = 0;
%     edot = edot./(edot(1,3,nelem));
%     edot(isnan(edot)) = 0;
% %     edot(abs(edot)<=.000025) = 0;
%     
%     plot(A*180/pi,edot(7:9:end-2))
%     title('Bulk strain rate enhancement for simple shear');
%     xlabel('Cone Angle (degrees)')
%     ylabel('Enhancement Factor')
%     
%     matlabpool close
% 
% catch ME
%     matlabpool close
%     rethrow(ME);
% 
% end

%% Test Thor 2002 results

