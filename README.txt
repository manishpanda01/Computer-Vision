Start by extracting all of the MATLAB files into a new directory from the supplied zip file. Next, adjust the paths in the DESCRIPTOR_FOLDER and DATASET_FOLDER to include MSRC_ObjCategImageDatabase_v2. You must first set up four sub-folders for descriptors: GlobalColourHistogram, SpatialColour, SpatialTexture, and SpatialColourTexture, before executing the cvpr_computedescriptors function. Call cvpr_computedescriptors(0) to start the descriptor computation after these directories are prepared. To process all descriptors, proceed by entering values 1, 2, and 3 in the ensuing calls.
When it comes time to analyze the visual search, you should choose a distance method. Change the value of the distance_method variable from 0 to 2 for a more thorough analysis in Line 3 of the cvpr_visualsearch.m file to accomplish this. The function names and associated numbers will be noted at the end of the file for convenience of reference. Run cvpr_visualsearch(0) to begin with the global color histogram, modifying the method parameters as necessary for exhaustive testing.
Refer to lines 64 to 69 in cvpr_visualsearch.m, where a number of query picture class numbers (e.g., 100 for books) are predefined, to improve the precision of your tests. To evaluate and examine the results for every class, uncomment these lines one at a time.


Reference:
1. Descriptor sub folder names : GlobalColourHistogram, SpatialColour, SpatialTexture, SpatialColourTexture

2. cvpr_computedescriptors(method) and cvpr_visualsearch(method)
   method = 0 for global colour histogram
   method = 1 for spatial colour grid
   method = 2 for spatial texture grid
   method = 3 for spatial colour and texture grid

3. In visual search line 3 (distance_method = value)
   value = 0 for L2 norm
   value = 1 for Cosine distance
   value = 2 for mahalanobis distance


