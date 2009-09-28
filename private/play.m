% a = NaN(1,6);
% [I J K]=ind2sub([20 20 20], 400);
% cons = [I-1, J, K; I+1, J, K; I, J-1, K;...
%                           I, J+1, K; I, J, K-1; I, J, K+1];
% for jj = 1:6
% try
% a(jj) = sub2ind([20 20 20], cons(jj,1), cons(jj,2), cons(jj,3))
% end
% end

crysStruct.connect = NaN(1,6);
ii = 400;

[I J K] = ind2sub([20 20 20], ii);
                % get the top-bottom-left-right-back-front indexes
                cons = [I-1, J, K; I+1, J, K; I, J-1, K;...
                          I, J+1, K; I, J, K-1; I, J, K+1];
                % try to get linear indecies
                for jj = 1:6
                    try
                        crysStruct.connect(jj) = sub2ind([20 20 20],...
                                                 cons(jj,1),cons(jj,2),cons(jj,3));
                    catch ME %#ok<NASGU>
                        % subscrypt was outside of array. This will hapen at all
                        % corners and walls. Will leave value as NaN.
                        clear ME;
                    end
                end