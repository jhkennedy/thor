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
% matlabpool
% 
% nelem = 100;
% contype = 'cube';
% distype = 'iso';
% A = linspace(pi/200, pi/2);
% Ao = zeros(1,100);
% disangles = [Ao', A'];
% stress = [0, 0, 0; 0, 0, 0; 0, 0, 1];
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
%     plot(A,edot(9:9:end))
%     
%     matlabpool close
% 
% catch ME
%     matlabpool close
%     rethrow(ME);
% 
% end

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
%     plot(A,edot(9:9:end))
%     
%     matlabpool close
% 
% catch ME
%     matlabpool close
%     rethrow(ME);
% 
% end

%% Test Thor 2002 results
