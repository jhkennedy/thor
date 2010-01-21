Tasdf = zeros(100,3);

for asdf =1:100
tic
play
Tasdf(asdf,1)=toc;
end

save ./Time.mat Tasdf

% close all, clear all
% 
% load ./Time.mat
% 
% for asdf =1:100
% tic
% play2
% Tasdf(asdf,2)=toc;
% end
% 
% save ./Time.mat Tasdf

close all, clear all

load ./Time.mat

for asdf =1:100
tic
play3
Tasdf(asdf,3)=toc;
end

