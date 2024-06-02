function F = global_colour_histogram(img)
%img = double(img) .*1;
% Quantization factor
q = 9; 

%extr_chact all the channels 
r=img(:,:,1);
g=img(:,:,2);
b=img(:,:,3);

%bins 
g_bin = floor(g .* q);

b_bin = floor(b .* q);

r_bin = floor(r .* q);


b_chin = r_bin .*(q^2) + g_bin .*(q^1) + b_bin;

Val  = histcounts(b_chin,q^3);

F = Val ./ sum(Val);
end

