function [one, two, three] = reshapeClimateEIG(EIG)
%%
    % calculate the size of the EIG matrix
    sE = size(EIG);

    % sort the eigenvalues
    EIG = sort(EIG,1,'descend'); % will not be nescessary soon
    
    % average eigenvalues for each element
    EIG = squeeze(mean(EIG,4));
    
    % seperate the three eigenvalues
    one   = squeeze(EIG(1,:,:,:));
    two   = squeeze(EIG(2,:,:,:));
    three = squeeze(EIG(3,:,:,:));
end