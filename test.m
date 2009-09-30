%% Test Thor model setup
matlabpool

global NAMES  %#ok<NUSED>
nelem = 1000;
contype = 'cube';
distype = 'iso';
disangles = repmat([0 pi/2], nelem, 1);
stress = [0, 0, 0; 0, 0, 0; 0, 0, 1];
stress = repmat(stress, [1 1 nelem]);
n = ones(nelem,1)*3;
    
try
    tic; eldata = Thor.setup(nelem, contype, distype, disangles, stress, n, 'no'); toc
    matlabpool close

catch ME
    matlabpool close
    rethrow(ME);

end

%% Test Thor 2001 results