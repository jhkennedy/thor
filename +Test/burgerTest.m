N = 5;
n = 3;

stress = [1,0,0;0,0,0;0,0,-1];

ww.N = Thor.ODF.watsonGenerate(N, 3);
W.N = ww.N';

HXY = sqrt(W.N(1,:).^2+W.N(2,:).^2);
W.theta = atan2(HXY,W.N(3,:))';
W.phi   = atan2(W.N(2,:),W.N(1,:))'; 

W.N = W.N';

% sines and cosines so calculation only has to be preformed once
st = sin(W.theta); ct = cos(W.theta);
sp = sin(W.phi);   cp = cos(W.phi); sq3 = sqrt(3);

% Basal plane vectors
W.B1 = [ct.*cp/3, ct.*sp/3, -st/3]; % -
W.B2 = [(-ct.*cp - sq3.*sp)/6, (-ct.*sp+sq3.*cp)/6, st/6]; % -
W.B3 = [(-ct.*cp + sq3.*sp)/6, (-ct.*sp-sq3.*cp)/6, st/6]; % -

% W.B1 = W.B1./repmat(sqrt(sum(W.B1.^2,2)),1,3);
% W.B2 = W.B2./repmat(sqrt(sum(W.B2.^2,2)),1,3);
% W.B3 = W.B3./repmat(sqrt(sum(W.B3.^2,2)),1,3);

% Shmidt tensor (outer product -- A'*N for each crystal)
j=1:3;
W.S1 = reshape(repmat(W.B1',3,1).* W.N(:,j(ones(3,1),:)).',[3,3,N]); % -
W.S2 = reshape(repmat(W.B2',3,1).* W.N(:,j(ones(3,1),:)).',[3,3,N]); % -
W.S3 = reshape(repmat(W.B3',3,1).* W.N(:,j(ones(3,1),:)).',[3,3,N]); % -

% expand the stress for RSS
W.stress = repmat(stress,[1,1,N]); 
    
% calculate the RSS on each slip system (Nx1 vector)
W.R1 = reshape(sum(sum(W.S1.*W.stress)),1,[])'; % Pa
W.R2 = reshape(sum(sum(W.S2.*W.stress)),1,[])'; % Pa
W.R3 = reshape(sum(sum(W.S3.*W.stress)),1,[])'; % Pa

% calculate the rate of shearing on each slip system (size Nx1)
W.G1 = W.R1.*abs(W.R1).^(n-1); % s^{-1}
W.G2 = W.R2.*abs(W.R2).^(n-1); % s^{-1}
W.G3 = W.R3.*abs(W.R3).^(n-1); % s^{-1}
    
% calculate the velocity gradient (size 3x3xN)
W.vel = W.S1.*reshape(repmat(W.G1',[9,1]),3,3,[])...
       +W.S2.*reshape(repmat(W.G2',[9,1]),3,3,[])... 
       +W.S3.*reshape(repmat(W.G3',[9,1]),3,3,[]); % s^{-1}
   
%%%% New Method
   
% if ((cAxis[2] != 0) && (-cAxis[0] != cAxis[1]))
%         std::vector<double> burger1 = {cAxis[2],cAxis[2],-cAxis[0]-cAxis[1]};
%     else
%         std::vector<double> burger1 = {-cAxis[1]-cAxis[2],cAxis[0],cAxis[0]};

for ii = 1:N
    if ((ww.N(ii,3) ~= 0) && (-ww.N(ii,1) ~= ww.N(ii,2)))
        ww.A1(ii,:) = [ww.N(ii,3),ww.N(ii,3),-ww.N(ii,1)-ww.N(ii,2)];
    else
        ww.A1(ii,:) = [-ww.N(ii,2)-ww.N(ii,3),ww.N(ii,1),ww.N(ii,1)];
    end
    
end

ww.A1 = (ww.A1./repmat(sqrt(sum(ww.A1.^2,2)),1,3))/2;

for ii = 1:N
   ww.A2(ii,:) = cross(ww.N(ii,:),ww.A1(ii,:)); 
end

ww.A2 = (ww.A2./repmat(sqrt(sum(ww.A2.^2,2)),1,3))/2;

% Shmidt tensor (outer product -- A'*N for each crystal)
j=1:3;
ww.S1 = reshape(repmat(ww.A1',3,1).* ww.N(:,j(ones(3,1),:)).',[3,3,N]); % -
ww.S2 = reshape(repmat(ww.A2',3,1).* ww.N(:,j(ones(3,1),:)).',[3,3,N]); % -

% expand the stress for RSS
ww.stress = repmat(stress,[1,1,N]); 
    
% calculate the RSS on each slip system (Nx1 vector)
ww.R1 = reshape(sum(sum(ww.S1.*ww.stress)),1,[])'; % Pa
ww.R2 = reshape(sum(sum(ww.S2.*ww.stress)),1,[])'; % Pa

% calculate the rate of shearing on each slip system (size Nx1)
ww.G1 = ww.R1.*abs(ww.R1).^(n-1); % s^{-1}
ww.G2 = ww.R2.*abs(ww.R2).^(n-1); % s^{-1}
    
% calculate the velocity gradient (size 3x3xN)
ww.vel = ww.S1.*reshape(repmat(ww.G1',[9,1]),3,3,[])...
        +ww.S2.*reshape(repmat(ww.G2',[9,1]),3,3,[]); % s^{-1}
    
    
%%% play


for ii = 1:N
    W.A2(ii,:) = cross(W.N(ii,:),W.B1(ii,:));
end