tic

def = 10; % 
Aodeg = 0; % girdle angle in degrees
Ao = Aodeg *pi/180; % girdle angle in radians
Adeg = 90; % cone angle in degrees
A = Adeg *pi/180; % cone angle in radians

% even distribution of crystals (one at each theta,phi point)
THETA = linspace(Ao,A,def); 
PHI = linspace(0,2*pi,def);


toc