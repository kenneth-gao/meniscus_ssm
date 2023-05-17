function [medial, lateral] = split_menisci(CC, idx)
% SPLIT_MENISCI  extracts medial and lateral menisci from mask.
% This assumes that medial comes first in the third axis.
%
% INPUTS:
%   CC        : connected components; see BWCONNCOMP
%   idx       : list of indices of two menisci in CC
%
% OUTPUTS:
%   medial    : array-like medial meniscus mask
%   lateral   : array-like lateral meniscus mask
%
% Created by  : Emily Xie 2021
% Revised by   : Kenneth Gao 2023

centroids = regionprops(CC, 'Centroid');
centroid1z = centroids(idx(1)).Centroid(3);
centroid2z = centroids(idx(2)).Centroid(3);

medial = zeros(CC.ImageSize, 'logical');
lateral = zeros(CC.ImageSize, 'logical');

if (centroid1z < centroid2z)
    medial(CC.PixelIdxList{idx(1)}) = 1;
    lateral(CC.PixelIdxList{idx(2)}) = 1;
elseif (centroid1z > centroid2z)
    lateral(CC.PixelIdxList{idx(1)}) = 1;
    medial(CC.PixelIdxList{idx(2)}) = 1;
end
end