function img_Disc = spatial_colour_grid(img)
grid = 5;
img = img .* 1.0;

grid_width = floor(size(img, 2)/ grid);
grid_height = floor(size(img, 1)/ grid);
r = img(:,:,1);
g = img(:,:,2);
b = img(:,:,3);

count = 0;
img_Disc = zeros(grid.*grid.*3, 0);

for R = 1:grid
    for C = 1:grid
        r_grid = r((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
        g_grid  = g((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
        b_grid  = b((grid_height*(R-1)+1):grid_height*R,(grid_width*(C-1)+1):grid_width*(C));
        
         r_mean = mean(r_grid, 'all');
        
        g_mean = mean(g_grid, 'all');
        
        b_mean = mean( b_grid, 'all');
        
        count = count+1; 
        img_Disc(count) = r_mean;
        
        count = count+1;
        img_Disc(count) = g_mean;
        
        count = count+1;
        img_Disc(count) =  b_mean;
        
    end
end

end
