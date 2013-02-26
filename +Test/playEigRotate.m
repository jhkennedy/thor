% script to test eigenvalue and strain enhancement

trials = 1000;

% number of crystals
N = 8000; 

k = -1; 

E = 10;

edotz = zeros(1,trials);
eig = zeros(1,trials);

parfor ii = 1:trials;
    
[edotz(ii), eig(ii)] = Test.eigRotate(N,k,E);

end; clear ii;


fprintf('Results of %d tials with %d crystals.\n\n',trials,N)
fprintf(' Eigenvalue enhancement:\n  Max:  %f\n  Min:  %f\n  Mean: %f\n\n',max(eig), min(eig),mean(eig))
fprintf(' strain rate enhancement:\n  Max:  %f\n  Min:  %f\n  Mean: %f\n\n',max(edotz), min(edotz),mean(edotz))
