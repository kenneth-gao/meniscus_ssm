function FV = mask_to_mesh(mask, voxel_size)
% MASK_TO_MESH  converts a 3D mask to a triangulated surface mesh
%
% INPUTS:
%   mask        : array-like 3D binary mask
%   voxel_size  : list of size 3 with dimensions of voxel
%
% OUTPUTS:
%   FV          : struct with faces and vertices of surface mesh
%
% Created by    : Kenneth Gao 2023

FV = isosurface(mask, 0);
FV = smoothpatch(FV, 1, 5);

% Scale to dimensions of voxel
FV.vertices(:,1) = (FV.vertices(:,1)-mean(FV.vertices(:,1))) * voxel_size(1);
FV.vertices(:,2) = (FV.vertices(:,2)-mean(FV.vertices(:,2))) * voxel_size(2);
FV.vertices(:,3) = (FV.vertices(:,3)-mean(FV.vertices(:,3))) * voxel_size(3);
end