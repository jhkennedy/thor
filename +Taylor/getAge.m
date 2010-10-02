function [AGE] = getAge()
% [AGE] = getAge() loads in the depth age relations for Taylor Dome and returns a 3040x2
% array where each row has [depth, age] as its entries. 


fTage = fopen('./+Taylor/Data/age.dat');
CTage = textscan(fTage, '%n%n%n', 'Delimiter', ' ', 'CommentStyle','#');
Tage = cell2mat(CTage);
fclose(fTage);

AGE = [Tage(:,2), Tage(:,1)];