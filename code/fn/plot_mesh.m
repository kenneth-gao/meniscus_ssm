function [] = plot_mesh(F, V, az, el)
% VISUALIZE_MESH  render 3D mesh
%
% INPUTS:
%   F         : Faces of triangulated mesh
%   V         : Vertices of triangulated mesh
%   az        : camera azimuth
%   el        : camera elevation
%
% Created by  : Emily Xie 2021
% Revised by  : Kenneth Gao 2023

patch('Faces', F, 'Vertices', V, 'FaceColor', [0.8, 0.7, 0.6], 'EdgeAlpha', 0);
xlim([-40 40]); ylim([-40 40]); zlim([-40 40]);
view(az, el);

camlight('headlight');
material dull;

axis equal;
axis off;
end
