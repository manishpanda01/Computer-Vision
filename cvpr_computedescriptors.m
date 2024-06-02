function cvpr_computedescriptors(method)
close all;

%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'C:\Users\manis\OneDrive\Documents\Post Graduation\Computer Vision & Pattern Recognition\Assignment\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
OUT_FOLDER = 'C:\Users\manis\OneDrive\Documents\Post Graduation\Computer Vision & Pattern Recognition\Assignment\MSRC_ObjCategImageDatabase_v2\descriptor';
%% and within that folder, create another folder to hold these descriptors
%% the idea is all your descriptors are in individual folders - within
%% the folder specified as 'OUT_FOLDER'.
OUT_SUBFOLDER='';
switch method
    case 0
        OUT_SUBFOLDER = 'GlobalColourHistogram';
    case 1
        OUT_SUBFOLDER = 'SpatialColour';
    case 2
        OUT_SUBFOLDER = 'SpatialTexture';
    case 3
        OUT_SUBFOLDER = 'SpatialColourTexture';
    otherwise
end


%% selction for which method is to called for extracting the features 

allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
if (method ~=4)
    for filenum=1:length(allfiles)
    file_name=allfiles(filenum).name;
    fprintf('Processing file %d/%d - %s\n',filenum,length(allfiles),file_name);
    tic;
    imgfile_name_full=([DATASET_FOLDER,'/Images/',file_name]);
    img=double(imread(imgfile_name_full))./256;
    fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',file_name(1:end-4),'.mat'];%replace .bmp with .mat
    switch method
    case 0
        F = global_colour_histogram(img);
    case 1
        F = spatial_colour_grid(img);  %Spatial colour grid
    case 2
        F = spatial_texture_grid(img); %Spatial texture grid
    case 3
        F = spatial_colour_texture_grid(img); %Spatial texture and colour grid        
    otherwise
        %handle
    end
    save(fout, 'F');    
    toc
    end
else
    %PCA to be implemented
    allfiles=dir (fullfile(['descriptors/gridGradientRGB','/*.mat']));
    disc = [];
    for filenum=1:length(allfiles)
        file_name=allfiles(filenum).name;
        
        c = getClass(file_name);
        featfile=['descriptors/gridGradientRGB/',file_name];
        
        load(featfile,'F');
        disc = [disc ; F];
    end

    disc = disc';
    E = Eigen_Build(disc);

    %take only 97% of the eigen
    index = 0;
    sumTemp = 0.0;
    EigenVal = E.val;
    EigenVal = EigenVal ./ sum(EigenVal);
    
    for i =1:length(E.val)
        if(sumTemp <= .97)
            
            sumTemp = sumTemp + EigenVal(i);
        else
            index = i;
            break;
        end
    end

    %Create an new eigen vector,
    matrix_change = E.vct(:,1:index);
    transformed_data_set = matrix_change' * disc;  %transform and create data set with desc with low dims
    transformed_data_set = transformed_data_set';

    %save this new dataset (low dims)
    for i=1:size(transformed_data_set, 1)
        file_name=allfiles(i).name;
        
        disp(file_name);
        
        fout=[OUT_FOLDER,'/',OUT_SUBFOLDER,'/',file_name(1:end-4),'.mat'];%replace .bmp with .mat
        
        F = transformed_data_set(i,:);
        save(fout,'F'); 
    end

end

clear all
end

%get class_type from the name
function class = getClass(file_name)
    
    indx = strfind(file_name,'_');
    
    class_name = file_name(1:indx(1)-1);
    
    class = str2double(class_name);
end