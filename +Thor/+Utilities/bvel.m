function [ vel ] = bvel( cdist )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

    vel = zeros(3,3);

    for ii = 1:8000
        vel = vel + cdist{ii,3};
    end
    
    vel = vel/8000;
end

