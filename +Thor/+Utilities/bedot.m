function [ edot ] = bedot( cdist )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    edot = zeros(3,3);

    ODF = sum([cdist{1:8000,5}]);

    for ii = 1:8000
        edot = edot + cdist{ii,4};
    end

    edot = edot/ODF;

end

