function [fix, move, ID] = rigid_match(X1, X2)
% RIGID_MATCH  performs rigid alignment and matching of two point clouds
% using ICP to determine transformation matrix (alignment) and knn for
% matching
%
% INPUTS:
%   X1        : point cloud 1 (fix)
%   X2        : point cloud 2 (move)
%
% OUTPUTS:
%   fix       : X1 transpose
%   move      : X2 transpose after registration
%   ID        : correspondence between fix and move
%
% Created by  : Emily Xie 2021
% Revised by  : Kenneth Gao 2023

fix = transpose(X1);
move = transpose(X2);

% Alignment
[Ricp, p, ER, t] = icp(fix, move, 30, 'Matching', 'Delaunay');
move = Ricp * move + repmat(p, 1, size(move,2));

% Matching
[ID, d] = knnsearch(transpose(move), transpose(fix));

move = move(:, ID);
end

