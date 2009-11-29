function [ TAU ] = rss( S123, stress )
% [TAU]=RSS(S123, stress) returns the RSS, resolved shear stress, on a crystal that has the
% shmidt tensors S123 experiencing a stress.
%    S123 is a 3x3x3 array holding the shmidt tensors for each slip system where the
%    tensor for slip system 's' is obtained by S123(:,:,s)
%
%    stress is a 3x3 array holding the stress tensor that the crystal experiences
%
% RSS returns TAU, a 1x3 array holding the RSS on each of the slip systems where the RSS
% on a slip system 's' is obtained by TAU(1,s)


    %% calculate the RSS on each slip system
    TAU(1,1) = sum(sum(S123(:,:,1).*stress));
    TAU(1,2) = sum(sum(S123(:,:,2).*stress));
    TAU(1,3) = sum(sum(S123(:,:,3).*stress));
    
end

