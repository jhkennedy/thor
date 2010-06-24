function [ds] = getDeltaSigma(T, alpha, betaz, H, z, accum, n)

    if accum == 0
        ds = 0;
    else

        ec = (1+alpha+alpha^2)^(1/2) / (1+alpha/2);
        phi = (35/2)*(z^3)*( 1 - (3/2)*z^2 - (1/8)*z^3 );
        
        Ar = 
        
        ds = ( ( (a/H)*(ec/2)^(1-n)*phi*(2+alpha) )/( Ar*betaz*(1+alpha) ) )^(1/n) 
    end

end

    % deapth variation of the flow law parameter (REEH 1988)
    % for isothermal, non-enhanced ice: betaz = 1
    betaz = 1;