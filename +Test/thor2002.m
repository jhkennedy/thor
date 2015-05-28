%% recreate throstur plots
% close all, clear all, clc

temperature = -10; % Celsius
dt = 1000; % years
cc = 1; 
cn = 0;

% stress = [ 10000,     0, 10000;...
%                0,     0,     0;...
%            10000,     0,-10000];
% stress = [     0,     0, 10000;...
%                0,     0,     0;...
%            10000,     0,     0];
stress = [ 10000,     0,     0;...
               0,     0,     0;...
               0,     0,-10000];
% stress = [  5000,     0,     0;...
%                0,  5000,     0;...
%                0,     0,-10000];
crystals = 8000;
% expand the stress for RSS
stress = repmat(stress,[1,1,crystals]);
       


e1 = 1/3:.01:1;
e2 = (1 - e1)/2;
e3 = 1 - e1 - e2;

wd = zeros(crystals,3,length(e1));

for ii = 1:length(e1)
    wk(ii) = Thor.ODF.watsonK( [e1(ii),e2(ii),e3(ii)] );
    wd(:,:,ii) = Thor.ODF.watsonGenerate(crystals, wk(ii));
end

%%

n = 3;
R = 0.008314472; % units: kJ K^{-1} mol^{-1}
beta = 630.0;    % from Thors 2001 paper (pg 510, above eqn 16)

if (temperature > -10)
    Q = 115;
else
    Q = 60;
end
A = 3.5e-25*beta*exp(-(Q/R)*(1.0/(273.15+temperature)-1.0/263.15)); % units: s^{-1} Pa^{-n}


edot = zeros(3,3,length(e1));
for ii = 1:length(e1)
    % get all theta and phis
    N = wd(:,:,ii)'./repmat(sqrt( wd(:,1,ii)'.^2+ wd(:,2,ii)'.^2+ wd(:,3,ii)'.^2),[3,1]); % -
    
    % get new angles
    HXY = sqrt(N(1,:).^2+N(2,:).^2);
    theta = atan2(HXY,N(3,:))';
    phi   = atan2(N(2,:),N(1,:))';
    
    % sines and cosines so calculation only has to be preformed once
    st = sin(theta); ct = cos(theta);
    sp = sin(phi);   cp = cos(phi); sq3 = sqrt(3);

    % Basal plane vectors
    B1 = [ct.*cp/3, ct.*sp/3, -st/3]; % -
    B2 = [(-ct.*cp - sq3.*sp)/6, (-ct.*sp+sq3.*cp)/6, st/6]; % -
    B3 = [(-ct.*cp + sq3.*sp)/6, (-ct.*sp-sq3.*cp)/6, st/6]; % -

    % C-axis orientation
    N = [st.*cp, st.*sp, ct]; % -
    
    j=1:3;
    S1 = reshape(repmat(B1',3,1).* N(:,j(ones(3,1),:)).',[3,3,crystals]);
    S2 = reshape(repmat(B2',3,1).* N(:,j(ones(3,1),:)).',[3,3,crystals]);
    S3 = reshape(repmat(B3',3,1).* N(:,j(ones(3,1),:)).',[3,3,crystals]);

    R1 = reshape(sum(sum(S1.*stress)),1,[])'; % Pa
    R2 = reshape(sum(sum(S2.*stress)),1,[])'; % Pa
    R3 = reshape(sum(sum(S3.*stress)),1,[])'; % Pa
    
    cdist.MRSS = sqrt( sum( ( B1.*repmat(R1,[1,3])...
                             +B2.*repmat(R2,[1,3])...
                             +B3.*repmat(R3,[1,3]) ).^2,2) );  % Pa
    
    
    [ ~, esoft ] = Thor.Utilities.soft( cdist, 'cube8000.mat', cc, cn );
    G1 = A*esoft.*R1.*abs(esoft.*R1).^(n-1); % s^{-1}
    G2 = A*esoft.*R2.*abs(esoft.*R2).^(n-1); % s^{-1}
    G3 = A*esoft.*R3.*abs(esoft.*R3).^(n-1); % s^{-1}

    % calculate the velocity gradient (size 3x3xN)
    vel = S1.*reshape(repmat(G1',[9,1]),3,3,[])...
         +S2.*reshape(repmat(G2',[9,1]),3,3,[])... 
         +S3.*reshape(repmat(G3',[9,1]),3,3,[]); % s^{-1}

    % calculate the strain rate (size 3x3xN)
    ecdot = vel/2 + permute(vel,[2,1,3])/2; % s^{-1}
    
    edot(:,:,ii) = (1/crystals)*sum(ecdot,3);

end

E33 = squeeze( edot(3,3,:)/edot(3,3,1) );
E13 = squeeze( edot(1,3,:)/edot(1,3,1) );

figure, 
plot(wk,E33, '-b')
figure,
plot(wk,E13, '-g')