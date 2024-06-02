function  descriptor = spatial_texture_grid(img) 
grid = 5; 
THRESHOLD_MAG = 15; % max value 255
ANGULAR_QUANTIZATION = 20;

img = img .* 1.0;

IMG = rgb2gray(img);

[edge_mag, edge_dir] = imgradient(IMG,'sobel');

edge_mag = uint8((edge_mag  / max(max(edge_mag))) * 255);

edge_dir = edge_dir + ((edge_dir < 0) * 360);

edge_mag_mask = edge_mag>THRESHOLD_MAG;

edge_dir_mask = floor(edge_mag_mask .* edge_dir);

%divide equally
gridWidth = floor(size(img, 2)/ grid);

gridHeight = floor(size(img, 1)/ grid);

descriptor = [];

bins_value = (0:floor(360/ANGULAR_QUANTIZATION):360);

bins_value = bins_value + ANGULAR_QUANTIZATION;

for R = 1:grid
    for C = 1:grid
        
        edge_dirGridIm = edge_dir_mask((gridHeight*(R-1)+1):gridHeight*R,(gridWidth*(C-1)+1):gridWidth*(C));
  
        g_bin = discretize(edge_dirGridIm,bins_value);
        
        gradient_histogram = histcounts(g_bin,ANGULAR_QUANTIZATION);
        
        gradient_histogram = gradient_histogram ./ sum(gradient_histogram);
        
        descriptor = [descriptor gradient_histogram];
              
    end
end
end


