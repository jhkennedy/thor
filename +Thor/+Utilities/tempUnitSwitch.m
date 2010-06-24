function [T, Tunits] = tempUnitSwitch(T, Tunits)
% function to switch the time T from the units specified by Tunits to seconds.

    switch Tunits
        case 'Seconds'
            return;
        case 'Days'
            T = T*24*60*60;
            Tunits = 'Seconds';
        case 'Weeks'
            T = T*7*24*60*60;
            Tunits = 'Seconds';
        case 'Years'
            T = T*365*24*60*60;
            Tunits = 'Seconds';
        otherwise
            error('Thor:tempUnitSwitch', 'Unknown Temperature Unit. Known units are: Seconds, Days, Weeks, Years.')
    end

end