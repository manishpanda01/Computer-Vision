function descriptor = spatial_colour_texture_grid(img)
%Size of the grid
grid = 4; 

%Ranges from 0 - 255
THRESHOLD_MAG = 10; 

ANGULAR_QUANTIZATION = 10; %Change this and observe the changes

img = img .* 1.0;
IMG = rgb2gray(img);

%Use sobel filter
[edge_mag, edge_dir] = imgradient(IMG,'sobel');

edge_mag = uint8((edge_mag  / max(max(edge_mag))) * 255);

%update value from 0 - 360
edge_dir = edge_dir + ((edge_dir < 0) * 360);

%create mask only when values are above threshold value
edge_mag_mask = edge_mag>THRESHOLD_MAG;

%make the previous threshold values zero
edge_theta_clean = floor(edge_mag_mask .* edge_dir);

bins_value = 0:floor(360/ANGULAR_QUANTIZATION):360 + ANGULAR_QUANTIZATION;

grid_width = floor(size(img, 2)/ grid);
grid_height = floor(size(img, 1)/ grid);

%Take each channel from the image
r = img(:,:,1);

b = img(:,:,3);

g = img(:,:,2);

Gbin = [];
descriptor = [];

for R = 1:grid
    for C = 1:grid
        r_grid = r((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
        g_grid = g((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
        b_grid = b((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
        %mean of each chanenl of the grid
        r_mean = mean(r_grid, 'all');
        
        g_mean = mean(g_grid, 'all');
        
        b_mean = mean(b_grid, 'all');
       
        edge_dirGridIm = edge_theta_clean((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
        Gbin = discretize(edge_dirGridIm,bins_value);
       
        gradient_Histogram = histcounts(Gbin,ANGULAR_QUANTIZATION);
        
        gradient_Histogram = gradient_Histogram ./ sum(gradient_Histogram);
       
        descriptor = [descriptor gradient_Histogram r_mean g_mean b_mean];
    
    end
end


end