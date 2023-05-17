% Interactive script to generate and visualize shape variations after PCA

clear all;
close all;
clc;

%% Inputs

atlas_path = '/PATH/TO/ATLAS_MESH.mat';
pca_vars_path = '/PATH/TO/PCA_VARIABLES.mat';
dst = '/DIRECTORY/TO/SAVE/FIGS.fig';
atlas_path = '/data/VirtualAging/users/kgao/meniscus_SSM/test/atlas_mesh_m.mat';
pca_vars_path = '/data/VirtualAging/users/kgao/meniscus_SSM/medial_PCAvars.mat';
dst = '/data/VirtualAging/users/kgao/meniscus_SSM/';

load(atlas_path);
load(pca_vars_path);

%% Generate synthetic images

mode_num = 3;       % PC number to visualize
std = 2;            % standard deviation
az = 0;             % viewing parameter azmuth
el = 0;             % viewing parameter

deviation = std * sqrt(evals(mode_num)) * W(mode_num, :);

% Euclidean distance color map
dev_reshape = reshape(deviation, size(mean_recon));
dev_magnitude = zeros([size(dev_reshape, 2) 1]);
for i = 1:size(dev_reshape, 2)
    dev_magnitude(i) = norm(dev_reshape(:, i));
end
dist_map = figure();
plot_mesh_cdata(FV.faces, mean_recon', dev_magnitude, az, el);

% Max mode
max_coordinates = reshape(A1' + deviation, size(mean_recon));
max_mode = figure();
plot_mesh(FV.faces, max_coordinates', az, el);

% Min mode
min_coordinates = reshape(A1' - deviation, size(mean_recon));
min_mode = figure();
plot_mesh(FV.faces, min_coordinates', az, el);

%% Save

savename = fullfile(dst, strcat('mode_', num2str(mode_num)));

savefig(dist_map, strcat(savename, '_distmap.fig'));
saveas(dist_map, strcat(savename, '_distmap.png'));

savefig(max_mode, strcat(savename, '_max.fig'));
saveas(max_mode, strcat(savename, '_max.png'));

savefig(min_mode, strcat(savename, '_min.fig'));
saveas(min_mode, strcat(savename, '_min.png'));
