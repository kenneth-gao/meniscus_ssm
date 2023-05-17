function [mask_medial, mask_lateral] = meniscus_mask_preprocess(mask, laterality, meniscus_mask_value, n_menisci, max_strel_size, min_meniscus_voxels)
% MENISCUS_MASK_PREPROCESS  Converts a single multiclass knee tissue mask
% into two binary meniscus masks (lateral and medial).
%
% INPUTS:
%   mask                : a 3D array-like multiclass tissue mask
%   laterality          : 'LEFT' or 'RIGHT' string denoting knee side
%   meniscus_mask_value : int representing meniscus class value in mask
%   n_menisci           : int representing number of components to extract
%   max_strel_size      : int representing largest structuring element size
%                         used for binary opening/closing operations
%   min_meniscus_voxels : int representing minimum number of elements in
%                         meniscus mask before throwing error
%
% OUTPUTS:
%   mask_medial         : a 3D array-like binary mask of medial meniscus
%   mask_lateral        : a 3D array-like binary mask of lateral meniscus
%
% Created by            : Kenneth Gao 2023

% Flip all right knees to match left
if strcmp(laterality, 'RIGHT')
    mask = flip(mask, 3);
end

% Convert multiclass mask to binary mask of meniscus
mask = mask == meniscus_mask_value;

% Perform initial connected component analysis to separate menisci
CC = bwconncomp(mask);
n_components = CC.NumObjects;
n_meniscus_voxels = sum(cellfun('length', CC.PixelIdxList));
disp(strcat('Number of connected components in meniscus mask: ', num2str(n_components)));
disp(strcat('Total voxels in meniscus mask: ', num2str(n_meniscus_voxels)));

% Binary opening/closing, if necessary
if n_components < n_menisci
    disp('Performing binary opening to increase spatial separation.')
    [CC, strel_size] = imopen_iterative(mask, n_menisci, max_strel_size);
    disp(strcat('Structuring element size:', num2str(strel_size)));
elseif n_components > n_menisci
    disp('Performing binary closing to decrease spatial separation.')
    [CC, strel_size] = imclose_iterative(mask, n_menisci, max_strel_size);
    disp(strcat('Structuring element size:', num2str(strel_size)));
end
disp(strcat('Number of components after binary processing:', num2str(CC.NumObjects)));

if CC.NumObjects < 2
    error('Medial/lateral menisci could not be extracted.')
end

% Choose 2 largest components
[component_vols, idx] = largest_n_components(CC, n_menisci);
if any(component_vols < min_meniscus_voxels)
    error('Poor segmentation or mask selection. Number of voxels too small.');
end

% Separate menisci
[mask_lateral, mask_medial] = split_menisci(CC, idx);

% Create bounding cube around menisci to reduce mask size
mask_lateral = bounding_cube(mask_lateral, 2);
mask_medial = bounding_cube(mask_medial, 2);
end