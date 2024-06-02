function distance = cvpr_cosine_compare(vector_A,vector_B)
%follow the cosine distance formula
%Step 1: computation of dot product
dot_product = dot(vector_A, vector_B);

%step 2: computation of the magnitudes using norm function
mag_A = norm(vector_A);
mag_B = norm(vector_B);

%step 3: computation of similarity
cosine_similarity = dot_product ./ (mag_A .* mag_B);

%step 4: This is the final step. compute the distance
distance = 1 - cosine_similarity;
end