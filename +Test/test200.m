% close all, clear all, clc

N = [5,10,20:10:100,150,200,400,600,800,1000];

Krd = Thor.ODF.watsonK([.4,.3,.3])
Ksm = Thor.ODF.watsonK([.8,.1,.1])

for jj = 1:100
    for ii = 1:length(N);

        Wrd = Thor.ODF.watsonGenerate(N(ii),Krd);
        Erd(:,ii,jj) = svd(diag(1/sqrt(N(ii)),0)*Wrd).^2;

        Wsm = Thor.ODF.watsonGenerate(N(ii),Ksm);
        Esm(:,ii,jj) = svd(diag(1/sqrt(N(ii)),0)*Wsm).^2;

    end
end

%%
figure
subplot(3,2,1)
plot(repmat(N,[100, 1]), squeeze(Erd(1,:,:))', '.')
hold on
plot([0,1000],[.4,.4],'k','LineWidth',3)
hold off
set(gca,'YLim',[0,1])
ylabel('Eigenvalue e1')
xlabel('Number of crystals')

subplot(3,2,3)
plot(repmat(N,[100, 1]), squeeze(Erd(2,:,:))', '.')
hold on
plot([0,1000],[.3,.3],'k','LineWidth',3)
hold off
set(gca,'YLim',[0,1])
ylabel('Eigenvalue e2')
xlabel('Number of crystals')

subplot(3,2,5)
plot(repmat(N,[100, 1]), squeeze(Erd(3,:,:))', '.')
hold on
plot([0,1000],[.3,.3],'k','LineWidth',3)
hold off
set(gca,'YLim',[0,1])
ylabel('Eigenvalue e3')
xlabel('Number of crystals')

subplot(3,2,2)
plot(repmat(N,[100, 1]), squeeze(Esm(1,:,:))', '.')
hold on
plot([0,1000],[.8,.8],'k','LineWidth',3)
hold off
set(gca,'YLim',[0,1])
ylabel('Eigenvalue e1')
xlabel('Number of crystals')

subplot(3,2,4)
plot(repmat(N,[100, 1]), squeeze(Esm(2,:,:))', '.')
hold on
plot([0,1000],[.1,.1],'k','LineWidth',3)
hold off
set(gca,'YLim',[0,1])
ylabel('Eigenvalue e2')
xlabel('Number of crystals')

subplot(3,2,6)
plot(repmat(N,[100, 1]), squeeze(Esm(3,:,:))', '.')
hold on
plot([0,1000],[.1,.1],'k','LineWidth',3)
hold off
set(gca,'YLim',[0,1])
ylabel('Eigenvalue e3')
xlabel('Number of crystals')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FEvoR: Fabric Evolution with Recrystallization %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2009-2014  Joseph H Kennedy
%
% This file is part of FEvoR.
%
% FEvoR is free software: you can redistribute it and/or modify it under the 
% terms of the GNU General Public License as published by the Free Software 
% Foundation, either version 3 of the License, or (at your option) any later 
% version.
%
% FEvoR is distributed in the hope that it will be useful, but WITHOUT ANY 
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
% FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
% details.
%
% You should have received a copy of the GNU General Public License along 
% with FEvoR.  If not, see <http://www.gnu.org/licenses/>.
%
% Additional permission under GNU GPL version 3 section 7
%
% If you modify FEvoR, or any covered work, to interface with
% other modules (such as MATLAB code and MEX-files) available in a
% MATLAB(R) or comparable environment containing parts covered
% under other licensing terms, the licensors of FEvoR grant
% you additional permission to convey the resulting work.


