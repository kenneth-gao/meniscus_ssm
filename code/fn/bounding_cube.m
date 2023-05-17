function bound_mask = bounding_cube(mask, pad)
% BOUNDING_CUBE localizes and bounds a binary mask
%
% INPUTS:
%   mask        : array-like binary mask
%   pad         : int of zero padding; default 0
%
% OUTPUTS:
%   bound_mask  : bounding cube around localized region-of-interest
%
% Created by    : Kenneth Gao 2023

if nargin == 1
    pad = 0;
end

mask_size = size(mask);
stats = regionprops(mask, 'PixelIdxList');
[x, y, z] = ind2sub(mask_size, stats.PixelIdxList);

x_min = min(x) - pad;
x_max = max(x) + pad;
y_min = min(y) - pad;
y_max = max(y) + pad;
z_min = min(z) - pad;
z_max = max(z) + pad;

if x_min < 1
    x_min = 1;
end
if x_max > mask_size(1)
    x_max = mask_size(1);
end
if y_min < 1
    y_min = 1;
end
if y_max > mask_size(2)
    y_max = mask_size(2);
end
if z_min < 1
    z_min = 1;
end
if z_max > mask_size(3)
    z_max = mask_size(3);
end

bound_mask = mask(x_min:x_max, y_min:y_max, z_min:z_max);
end