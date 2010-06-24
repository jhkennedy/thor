function [z] = getDeapth(to, step, stepsize, AGE)




% convert from seconds to kyr
stepsize = stepsize/(365*24*60*60*1000); % kyr

% get current time
t = to+step*stepsize; %  kyr

% get depth at current time
z = interp1(AGE(:,1), AGE(:,2), t);