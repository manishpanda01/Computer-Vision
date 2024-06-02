function cvpr_visualsearch(method) % main fucntion to call for running the image search
% method used for distance calculation to be set below
distance_method=2; %value ranges from 0-2
close all;
%queryIndexes = {100 , 381 , 419, 225};
%% Edit the following line to the folder you unzipped the MSRCv2 dataset to
DATASET_FOLDER = 'C:\Users\manis\OneDrive\Documents\Post Graduation\Computer Vision & Pattern Recognition\Assignment\MSRC_ObjCategImageDatabase_v2';

%% Create a folder to hold the results...
DESCRIPTOR_FOLDER = 'C:\Users\manis\OneDrive\Documents\Post Graduation\Computer Vision & Pattern Recognition\Assignment\MSRC_ObjCategImageDatabase_v2\descriptor';
%% and within that folder, another folder to hold the descriptors
%% we are interested in working with
DESCRIPTOR_SUBFOLDER='';
switch method
    case 0
        fprintf("Global Colour Histogram \n");
        DESCRIPTOR_SUBFOLDER = 'GlobalColourHistogram';
    case 1
        fprintf("Spatial colour grid \n");
        DESCRIPTOR_SUBFOLDER = 'SpatialColour';
    case 2
        fprintf("Spatial texture grid \n");
        DESCRIPTOR_SUBFOLDER = 'SpatialTexture';
    case 3
        fprintf("Spatial colour and texture grid \n");
        DESCRIPTOR_SUBFOLDER = 'SpatialColourTexture';
    otherwise
       
end

switch distance_method
    case 0
        disp("l2 Norm");
    case 1
        disp("Cosine Distance");
    case 2
        disp("Mahalanobis Distance");
    otherwise
       
end

%% 1) Load all the descriptors into "ALLFEAT"
%% each row of ALLFEAT is a descriptor (is an image)

ALLFEAT=[];
ALLFILES=cell(1,0);
ctr=1;
allfiles=dir (fullfile([DATASET_FOLDER,'/Images/*.bmp']));
for filenum=1:length(allfiles)
    fname=allfiles(filenum).name;
    imgfname_full=([DATASET_FOLDER,'/Images/',fname]);
    img=double(imread(imgfname_full))./256;
    thesefeat=[];
    featfile=[DESCRIPTOR_FOLDER,'/',DESCRIPTOR_SUBFOLDER,'/',fname(1:end-4),'.mat'];%replace .bmp with .mat
    load(featfile,'F');
    ALLFILES{ctr}=imgfname_full;
    ALLFEAT=[ALLFEAT ; F];
    ctr=ctr+1;
end

%% 2) Pick an image at random to be the query
NIMG=size(ALLFEAT,1);           
%queryimg=floor(rand()*NIMG);
queryimg = 100; %books
%queryimg = 381; %Tree
%queryimg = 419; %Plane
%queryimg = 225; %Road
%queryimg = 187; %Dog
%queryimg = 132;
fprintf("Name of image %s \n", allfiles(queryimg).name);
fprintf("QueryImage : %d \n", queryimg);

%Generate Eigen Model if mahalanobis distance is selected 
E = 0.0;
if(distance_method == 2)
    dataset = ALLFEAT';
    E = Eigen_Build(dataset);
    E = Eigen_Deflate(E, 'keepf', 0.99);
end

%% 3) Compute the distance of image to the query
dst=[];
getdst = 0;
NIMG = size(ALLFEAT, 1);

tic
for i=1:NIMG
    candidate=ALLFEAT(i,:);
    query=ALLFEAT(queryimg,:);    
    switch distance_method
    case 0
        getdst = cvpr_L2_norm(query, candidate);
    case 1
        getdst = cvpr_cosine_compare(query, candidate);
    case 2
        getdst = cvpr_mahalanobis_compare(query, candidate, E);
    otherwise
        % Handle
    end

    dst=[dst ; [getdst i]];
end
toc
% sorting the distances
dst=sortrows(dst,1); 
dst_all = dst;
%% 4) Visualise the results

SHOW=11;
dst=dst(1:SHOW,:);
outdisplay=[];

%To remove cropped image, we are going to find the max width and height of
%the top 10 res and the querry image
maximum_Width = 0; maximum_Height = 0;
for i=1:size(dst,1)
    img=imread(ALLFILES{dst(i,2)});
    img=img(1:2:end,1:2:end,:); % make image a quarter size
    if(maximum_Width < size(img,2))
         maximum_Width = size(img,2);
    end
    if(maximum_Height < size(img,1))
         maximum_Height = size(img,1);
    end
end   
for i=1:size(dst,1)
   img=imread(ALLFILES{dst(i,2)});
   img=img(1:2:end,1:2:end,:); % make image a quarter size
   
   %if the width is less than max, append zeores
   if(size(img, 2) < maximum_Width)
       dif = maximum_Width - size(img, 2);
       img = [img zeros(size(img, 1), dif, 3)];
   end
   
    %if the height is less than max, append zeores
   if(size(img, 1) < maximum_Height)
       dif = maximum_Height - size(img, 1);
       img = [img;zeros(dif,size(img, 2), 3)];
   end
   %img=img(1:100,:,:); % crop image to uniform size vertically (some MSVC images are different heights)
   outdisplay=[outdisplay img];
end
figure()
imshow(outdisplay);

[precision1, recall1] = compute_PR(dst, ALLFILES);

[fullPrecision, fullRecall] = compute_PRCurve(dst_all, ALLFILES);

 AveragePrecision = compute_AP(dst_all, fullPrecision, ALLFILES);
 
% MAP = compute_MAP(ALLFEAT, ALLFILES, distance_method, E); 
%uncomment the above line when MAP needs to be estimated 
 fprintf("Precision: %f \n", precision1);
 fprintf("Recall: %f \n", recall1);
 fprintf("Average Precision: %f \n", AveragePrecision);
% fprintf("Mean Average Precision: %f \n", MAP) %Uncomment this when needed

figure()
axis on;

plot(fullRecall, fullPrecision)
xlabel("Recall");
ylabel("Precision");
title("Precision-Recall curve");
clear all;
end


%Precision and Recall output
function [precision, recall]=compute_PR(dst, ALLFILES)
    instance_per_class = [30,30,30,30,30,30,30,30,30,32,30,34,30,30,24,30,30,30,30,21];
    
    class = zeros(size(dst,1), 0);
    for i = 1:size(dst,1)
     
        path_name = ALLFILES{dst(i,2)};
        class(i) = getClass(path_name);
    end
    
    Q_Class = class(1);
    label_temp_array = class;
    
    label_temp_array(label_temp_array ~= Q_Class) = 0;
    label_temp_array(label_temp_array == Q_Class) = 1;
    
    precision = (sum(label_temp_array)) / length(label_temp_array);
    recall = (sum(label_temp_array)) / instance_per_class(Q_Class);    
end


%PR curve
function [precision_values, recall_values] = compute_PRCurve(dst_all, ALLFILES)
    precision_values = zeros(size(dst_all,1), 0);
    recall_values = zeros(size(dst_all,1), 0);
    
    %iterate over all the ranks
    for i = 1:length(dst_all)
        current_Distance = dst_all(1:i,:);
        [precision_values(i),recall_values(i)] = compute_PR(current_Distance, ALLFILES);
    end

end

%AP  
function AP = compute_AP(dst_all, fullPrecision, ALLFILES)
    instance_per_class = [30,30,30,30,30,30,30,30,30,32,30,34,30,30,24,30,30,30,30,21];
    
    class = zeros(size(dst_all,1), 0);
    for i = 1:size(dst_all,1)
      
        %Get the full image path
        path_name = ALLFILES{dst_all(i,2)};
        class(i) = getClass(path_name);
    end
    
    Q_Class = class(1);
    label_temp_array = class;
    label_temp_array(label_temp_array ~= Q_Class) = 0;
    label_temp_array(label_temp_array == Q_Class) = 1;
    
    %numerator of AP
    num_sum =  sum(fullPrecision .* label_temp_array);
    
    AP = num_sum/instance_per_class(Q_Class);  
end

%% Extract class form the name
function class = getClass(path)
    indx = strfind(path,'/');
    index = indx(length(indx));
    name = path(index+1:end);
    
    %take the class only
    indx = strfind(name,'_');
    class_name = name(1:indx(1)-1);
    class = str2double(class_name);
end

%measure distance
function dst = getDst(queryimg, ALLFEAT, distance_method, E)
    dst=[];
    getdst = 0;
    for i=1:size(ALLFEAT,1)
        candidate=ALLFEAT(i,:);
        query=ALLFEAT(queryimg,:);
        
    switch distance_method
    case 0
        getdst = cvpr_L2_norm(query, candidate);
    case 1
        getdst = cvpr_cosine_compare(query, candidate);
    case 2
        getdst = cvpr_mahalanobis_compare(query, candidate, E);
    otherwise
        %handle
    end
        dst=[dst ; [getdst i]];
    end
    dst=sortrows(dst,1);  % sort the results
    
end

%MAP(Time consuming)
function map = compute_MAP(ALLFEAT, ALLFILES, distance_method, EM)
    %consider a random small data set for faster process
    small_data_set = [5,31,68,105,129,155,182,207,232,256,310,345,370,393,420,456,489,515,545,575];
    AP_array = [];
    for i = 1:length(small_data_set)
        
        dst_all = getDst(small_data_set(i), ALLFEAT, distance_method, EM);
        
        precision_values = compute_PRCurve(dst_all, ALLFILES);
        
        averageprecision = compute_AP(dst_all, precision_values, ALLFILES);
        AP_array = [AP_array averageprecision];
    end
    fprintf("\n");
    map =  mean(AP_array);
    
end