function [rhoDot] = dislODE(t, rho, Medot, b, K, Dtime, D)

DT = interp1(Dtime, D, t); % s

rhoDot = Medot/(b*DT) - rho*K/DT^2; % m^{-2} s^{-1}

end