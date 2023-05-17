function [CC, strel_size] = imopen_iterative(mask, n_components_desired, max_strel_size)
% IMOPEN_ITERATIVE  performs 3D imopening until maximum structuring element
% (strel) size or desired number of components is reached.
%
% INPUTS:
%   mask                  : array-like binary mask
%   n_components_desired  : int representing final number of components
%   max_strel_size        : int representing maximum radius of structuring
%                           element sphere
%
% OUTPUTS:
%   CC                    : connected components after opening
%   strel_size            : final radius used to open components
%
% Created by              : Emily Xie 2021
% Revised by              : Kenneth Gao 2023

for strel_size = 1:max_strel_size
    se = strel3d(strel_size);
    mask_processed = imopen(mask, se);
    
    CC = bwconncomp(mask_processed);
    n_components = length(CC.PixelIdxList);
    if n_components == n_components_desired
        break
    end
end
end