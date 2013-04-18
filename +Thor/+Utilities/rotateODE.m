function [RDOT] = rotateODE(ROTR, N)

RDOT = ROTR*N;

end