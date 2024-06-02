function distance = cvpr_mahalanobis_compare(distance1,distance2, EM)
%Compute mean 
distance1 = distance1 - EM.org';

distance2 = distance2 - EM.org';

%project to space
distance1_ei = EM.vct' * distance1';

distance2_ei = EM.vct' * distance2';

temperature = distance1_ei - distance2_ei;

square = temperature .* temperature;

Distance = square ./ EM.val; 

distance = sqrt(sum(Distance));
end

