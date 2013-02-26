function [ inv ] = inv2( A )
% function [ inv ] = inv2( A ) calculates the second invariant of the
% rank 2 tensor A in cartesian space (3x3).
%   A should be a rant 2 tensor (3x3).
%   
%   inv will be the second invariant of tensor A.
%
% see also trace

inv = (1/2)*(trace(A)^2 - trace(A*A));