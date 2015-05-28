%% test RSS
close all, clear all, clc;

ii=10;

temperature = -10; % Celsius
dt = 1000; % years

rho = 917; g = -9.81; h = 100:100:1000; P = rho*g*h;
devStress = [ 10000,     0, 10000;...
                  0,     0,     0;...
              10000,     0,-10000];


stress = eye(3)*P(ii) + devStress;
          
Mstress= sqrt(2/3* sum( sum(stress.^2) ) );

theta = pi/3;
phi   = pi/3;

n = 3;
R = 0.008314472; % units: kJ K^{-1} mol^{-1}
beta = 630.0;    % from Thors 2001 paper (pg 510, above eqn 16)

if (temperature > -10)
    Q = 115;
else
    Q = 60;
end
A = 3.5e-25*beta*exp(-(Q/R)*(1.0/(273.15+temperature)-1.0/263.15)); % units: s^{-1} Pa^{-n}

% sines and cosines so calculation only has to be preformed once
st = sin(theta); ct = cos(theta);
sp = sin(phi);   cp = cos(phi); sq3 = sqrt(3);

% Basal plane vectors
B1 = [ct.*cp/3, ct.*sp/3, -st/3]; % -
B2 = [(-ct.*cp - sq3.*sp)/6, (-ct.*sp+sq3.*cp)/6, st/6]; % -
B3 = [(-ct.*cp + sq3.*sp)/6, (-ct.*sp-sq3.*cp)/6, st/6]; % -

% C-axis orientation
cAxis = [st.*cp, st.*sp, ct]; % -

shmidt1 = B1'*cAxis;
shmidt2 = B2'*cAxis;
shmidt3 = B3'*cAxis;

rss1 = sum(sum(shmidt1.*stress));
rss2 = sum(sum(shmidt2.*stress));
rss3 = sum(sum(shmidt3.*stress));
display(rss1)
display(rss2)
display(rss3)

G1 = A*rss1.*abs(rss1).^(n-1); % s^{-1}
G2 = A*rss2.*abs(rss2).^(n-1); % s^{-1}
G3 = A*rss3.*abs(rss3).^(n-1); % s^{-1}
display(G1)
display(G2)
display(G3)

Gvel = shmidt1*G1+shmidt2*G2+shmidt3*G3;
display(Gvel)