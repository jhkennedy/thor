function [AGE] = getAge()
fTage = fopen('./+Taylor/age.dat');
CTage = textscan(fTage, '%n%n%n', 'Delimiter', ' ', 'CommentStyle','#');
Tage = cell2mat(CTage);
fclose(fTage);

AGE = [Tage(:,2), Tage(:,1)];