function [] = plot_mesh(F, V, C, az, el)
% VISUALIZE_MESH  render 3D mesh with color data
%
% INPUTS:
%   F         : Faces of triangulated mesh
%   V         : Vertices of triangulated mesh
%   C         : Color data
%   az        : camera azimuth
%   el        : camera elevation
%
% Created by  : Emily Xie 2021
% Revised by  : Kenneth Gao 2023

patch('Faces', F, 'Vertices', V, 'FaceVertexCData', C, 'EdgeAlpha', 0, 'FaceColor', 'flat');
colormap turbo;
xlim([-40 40]); ylim([-40 40]); zlim([-40 40]);
view(az, el);

camlight('headlight');
material dull;

axis equal;
axis off;
end
