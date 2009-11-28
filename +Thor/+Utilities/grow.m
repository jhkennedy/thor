function [ cdist ] = grow( cdist, SET, elem )
%GROW Summary of this function goes here
%   Detailed explanation goes here

% crystal grain growth and such

    Ko = 9.2e-9; % m^2 s^{-1}
    Q = 40; % kJ mol^{-1}
    R = 0.008314472; % kJ K^{-1} mol^{-1}
    
    % calculate grain growth factor
    K = Ko*exp(-Q/(R*SET.T(elem)));
    
    % find the average dislocaton energy
    for ii = 1:(20*20*20)
        dislEnAv = dislEnAv + cdist{ii,9}/(SET.numbcrys);
    end
    
    % grow grain
    for ii = 1:(SET.numbcrys)
        % modify grain growth by dilocation energy
        Ki = (dislEnAv - cdist{ii,9})*K;
        % calculate new crystal diameter
        cdist{ii, 7} = (Ki*SET.tsize + SET.Do^2)^(1/2);
    end
    
    
end