% code to explore the parameter space of my model:
    % Stress -> compression, shear, combined, real (Ray. 1983 in Taylor)
        % stress range from 0.1 to 0.4 bar [10000 - 40000 Pa](Pettit 2003)
    % Fabric -> isotropic, 80 deg. cone, 60 deg. cone, 30 deg. cone
    % NNI    -> none, mild, full
    % other? -> grain size, types of layering, # of crystals / layer
    % 
    % average antarctic ice temp. -30 deg C ... Tim

try
    % clean up the enironment and set up parallel processing
    close all; clear all;
    matlabpool 4;
    
    % start timing
    tic;     DATE = now;
    display(sprintf('\n Run started %s \n', datestr(DATE)))
    
    in = struct([]);
    
    % manually load in initial setting structure
    load ./+Param/Settings/exploreParam2011Jan7.mat
    
    runs = 32;        
    
    %% Runs 1-24
      % R1  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R2  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R3  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R4  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R5  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R6  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R7  - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
      
      % R8  - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R9  - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R10 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R11 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R12 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R13 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R14 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
    

      % R15 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R16 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R17 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R18 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R19 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R20 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R21 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R22 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R23 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R24 - c80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
       
    %% Runs 25-56
      % R25 - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R26 - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R27 - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R28 - c80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      
      % R29 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R30 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R31 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R32 - c80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R33 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R34 - c80_rec20x20x30_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R35 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R36 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R37 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R38 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R39 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R40 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R41 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R42 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R43 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R44 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R45 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R46 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R47 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R48 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R49 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R50 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R51 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R52 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R53 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R54 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R55 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R56 - c80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
    
    %% Runs 57-78
      % R57 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R58 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R59 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R60 - c80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R61 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R62 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R63 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R64 - c80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R65 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R66 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R67 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R68 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R69 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R70 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R71 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R72 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R73 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R74 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R75 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R76 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R77 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R78 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)

    %% Runs 79-103
      % R79 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R80 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R81 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R82 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R83 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R84 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R85 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R86 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R87 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R88 -tb80_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
       
      % R89 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R90 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R91 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R92 -tb80_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R93 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R94 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R95 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R96 -tb80_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R97 -tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R98 -tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R99 -tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R100-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R101-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R102-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R103-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
    
    %% Runs 104-128
      % R104-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R105-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R106-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R107-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R108-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R109-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R110-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R111-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R112-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R113-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R114-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R115-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R116-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R117-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R118-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R119-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R120-tb80_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
       
      % R121-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R122-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R123-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R124-tb80_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R125-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R126-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R127-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R128-tb80_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
    %% Runs 129-160
      % R129-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R130-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R131-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R132-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R133-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R134-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R135-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R136-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R137-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R138-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R139-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R140-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R141-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R142-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R143-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R144-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R145-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R146-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R147-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R148-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R149-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R150-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R151-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R152-868D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
       
      % R153-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R154-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R155-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R156-868D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R157-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R158-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R159-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R160-868D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      
    %% Runs 161-188
      % R161-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R162-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R163-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R164-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R165-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R166-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R167-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R168-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R169-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R170-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R171-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R172-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R173-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R174-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R175-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R176-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R177-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R178-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R179-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R180-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R181-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R182-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R183-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R184-868D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
       
      % R185-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R186-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R187-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R188-868D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      
    %% Runs 189-216
      % R189-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R190-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R191-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R192-868D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R193- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R194- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R195- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R196- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R197- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R198- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R199- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R200- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R201- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R202- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R203- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R204- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R205- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R206- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R207- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R208- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R209- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R210- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R211- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R212- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R213- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R214- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R215- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R216- c60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
      
    %% Runs 217-248
      % R217- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R218- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R219- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R220- c60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R221- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R222- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R223- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R224- c60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R225- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R226- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R227- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R228- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R229- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R230- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R231- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R232- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R233- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R234- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R235- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R236- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R237- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R238- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R239- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R240- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R241- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R242- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R243- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R244- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R245- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R246- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R247- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R248- c60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
      
    %% Runs 249-280
      % R249- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R250- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R251- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R252- c60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R253- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R254- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R255- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R256- c60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R257-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R258-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R259-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R260-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R261-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R262-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R263-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R264-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R265-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R266-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R267-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R268-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R269-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R270-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R271-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R272-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R273-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R274-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R275-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R276-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R277-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R278-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R279-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R280-tb60_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
      
    %% Runs 281-312
      % R281-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R282-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R283-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R284-tb60_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R285-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R286-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R287-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R288-tb60_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R289-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R290-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R291-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R292-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R293-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R294-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R295-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R296-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R297-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R298-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R299-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R300-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R301-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R302-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R303-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R304-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R305-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R306-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R307-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R308-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R309-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R310-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R311-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R312-tb60_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
      
    %% Runs 313-344
      % R313-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R314-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R315-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R316-tb60_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R317-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R318-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R319-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R320-tb60_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R321-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R322-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R323-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R324-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R325-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R326-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R327-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R328-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R329-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R330-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R331-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R332-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R333-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R334-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R335-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R336-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R337-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R338-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R339-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R340-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R341-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R342-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R343-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R344-686D_rec20x20x60_1 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
      
    %% Runs 345-384
      % R345-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R346-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R347-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R348-686D_rec20x20x60_1 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R349-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R350-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R351-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R352-686D_rec20x20x60_1 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
      % R353-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Dome    )
      % R354-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R355-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 12,21)
      % R356-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R357-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 12,21)
      % R358-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
      % R359-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 12,21)
       
      % R360-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Dome    )
      % R361-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R362-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 12,21)
      % R363-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R364-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 12,21)
      % R365-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
      % R366-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 12,21)
       
      % R367-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 13,31)
      % R368-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .05 bar (SS 12,21)
      % R369-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 13,31)
      % R370-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .1  bar (SS 12,21)
      % R371-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 13,31)
      % R372-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .2  bar (SS 12,21)
      % R373-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 13,31)
      % R374-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .4  bar (SS 12,21)
      % R375-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 13,31)
      % R376-686D_rec20x20x60_2 > Sigma @ .0 bar > Tau @ .8  bar (SS 12,21)
       
      % R377-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .0  bar (Ridge   )
      % R378-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .05 bar (CB 13,31)
      % R379-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .1  bar (CB 13,31)
      % R380-686D_rec20x20x60_2 > Sigma @ .1 bar > Tau @ .2  bar (CB 13,31)
       
      % R381-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .0  bar (Ridge   )
      % R382-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .2  bar (CB 13,31)
      % R383-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .4  bar (CB 13,31)
      % R384-686D_rec20x20x60_2 > Sigma @ .4 bar > Tau @ .8  bar (CB 13,31)
       
       
     %% Elements for each run
        % E1 - no NNI > Grains same (****_rec20x20x60_*)  > Poly on > T -30
        % E2 - no NNI > Grains half (****_rec20x20x60_*h) > Poly on > T -30
        
        % E3 - no NNI > Grains same (****_rec20x20x60_*)  > Poly on > T -15
        % E4 - no NNI > Grains half (****_rec20x20x60_*h) > Poly on > T -15
       
        % E5 - no NNI > Grains same (****_rec20x20x60_*)  > Poly on > T -10
        % E6 - no NNI > Grains half (****_rec20x20x60_*h) > Poly on > T -10
        
        % E7 - no NNI > Grains same (****_rec20x20x60_*)  > Poly on > T -05
        % E8 - no NNI > Grains half (****_rec20x20x60_*h) > Poly on > T -05
        
    %% set up the model
    
    timesteps = 1000;
    SAVE = [0,1, 25:25:timesteps];
    
    parfor ii = 1:runs
       [NAMES(ii), SET(ii)] = Thor.setup(in(ii), ii); %#ok<SAGROW,AGROW>
    end
    
    TIME(1) = toc;
    display(sprintf('\n Time to set up Thor is %g seconds. \n', TIME(1)))
    
    %% step the model
    parfor jj = 1:runs
        for kk = 1:timesteps
            Thor.step(NAMES(jj), SET(jj), jj, kk, SAVE);
        end
    end
   
    TIME(2) = toc;
    display(sprintf('\n Time to step Thor through %d time steps for %d runs is \n     %g seconds. \n', timesteps, runs, TIME(2)-TIME(1) ) )
    
    %% calculate eigenvalues at each saved time step for each run
    EIG = zeros(3,size(eigenMask,2),size(SAVE,2),in(1).nelem,runs);
    % EIG is ([e1;e2;e3],# of masks, # of saves, # of elements, # number of runs )
    for oo = 1:runs
        for mm = 1:in(1).nelem
            for nn = 1:size(SAVE,2)

                % load in saved crystal distrobutions
                cdist = load(['./+Thor/CrysDists/Run' num2str(oo) '/SavedSteps/Step'...
                               num2str(SAVE(nn), '%05.0f') '_' NAMES(oo).files{mm}]);

                % calculate eigenvalue
                EIG(:,:,nn,mm,oo) = Thor.Utilities.eigenClimate( cdist, eigenMask );
            end
        end
    end
        
    TIME(3) = toc;
    display(sprintf('\n Time to calculate the eigenvalues is: \n     %g seconds. \n', TIME(3)-TIME(2) ) )
    
    %% analyize results
    
    
    %% save results
    
    save ./+Param/exploreResults.mat
    
    %% close the matlab pool
    matlabpool close;
    TIME(8) = toc;
    display(sprintf('\n Total time to run PARAM is \n     %g seconds. \n', TIME(8) ) )
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    % email me to tell me the run is done
    !mail -s THOR:DONE jhkennedy@alaska.edu < done.txt 
    
catch ME
    matlabpool close;
    TIME(9) = toc;
    display(sprintf('Total elapsed time before crash is %f seconds.', TIME(9)))
    display(sprintf('\n Goodbye! \n'))
    display(sprintf('\n Run ended %s \n', datestr(now)))
    
    save ./+Param/exploreCRASH.mat
    
    % email me to tell me run has crashed
    !mail -s THOR:CRASH jhkennedy@alaska.edu < crash.txt
    
    rethrow(ME);
    
end

quit;
    