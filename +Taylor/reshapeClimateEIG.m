function [one, two, three] = reshapeClimateEIG(EIG)
% 
%     sE = size(EIG);
% 
%     one   = cell(1,sE(4));
%     two   = one;
%     three = one;
%     
%     
%     for ii = 1:sE(4)
%         one{ii}   = reshape(EIG(1,:,:,ii),sE(2),[]);
%         two{ii}   = reshape(EIG(2,:,:,ii),sE(2),[]);
%         three{ii} = reshape(EIG(3,:,:,ii),sE(2),[]);
%         
%         one{ii}   = sum(one{ii},2)'/sE(3);
%         two{ii}   = sum(two{ii},2)'/sE(3);
%         three{ii} = sum(three{ii},2)'/sE(3);
%         
%     end
%     
%         one   = cell2mat(one');
%         two   = cell2mat(two'); 
%         three = cell2mat(three');
%         
end