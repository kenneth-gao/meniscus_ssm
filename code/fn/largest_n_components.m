function [CC_n_voxels, idx] = largest_n_components(CC, n_components)
% LARGEST_N_COMPONENTS  extracts the largest n connected components
%
% INPUTS:
%   CC            : connected components; see BWCONNCOMP
%   n_components  : int representing number of components to extract
%
% OUPUTS:
%   CC_n_voxels   : list of size n with number of voxels in largest n
%                   components
%
%   idx           : list of indices of size n of largest n components in CC
%
% Created by      : Emily Xie 2021
% Revised by      : Kenneth Gao 2023

n_voxels = cellfun(@numel, CC.PixelIdxList);
[sorted_n_voxels, idx] = sort(n_voxels, 'descend');
CC_n_voxels = sorted_n_voxels(1:n_components);
idx = idx(1:n_components);
end