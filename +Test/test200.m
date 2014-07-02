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