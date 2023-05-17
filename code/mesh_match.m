function [] = mesh_match(atlas_path, df_path, dst)
% MESH_MATCH  transforms tissue segmentation masks of knee MRI to 3D 
% surfaces of the menisci
%
% INPUTS:
%   atlas_path        : path of atlas mask in .mat format
%   df_path           : path of text file with paths of all other masks
%   dst               : directory to which surfaces will be saved
% 
% Created by          : Kenneth Gao 2023

addpath(genpath(fullfile(cd, 'fn')));

%% Hyperparameters

meniscus_mask_value = 7;
n_menisci = 2;
max_strel_size = 8;
min_meniscus_voxels = 1500;
voxel_size = [0.36458333, 0.36458333, 0.69999999];

%% Generate atlas surface mesh

tStart = tic;
disp('GENERATING ATLAS:')

% Parse atlas information
[~, atlas_filename, ~] = fileparts(atlas_path);
atlas_attributes = strsplit(atlas_filename, '_');
atlas_laterality = atlas_attributes{2};

% Load atlas mask
atlas_mask = load(atlas_path).x;

% Mask preprocessing extracts lateral and medial menisci
[atlas_medial, atlas_lateral] = meniscus_mask_preprocess(atlas_mask, atlas_laterality, meniscus_mask_value, n_menisci, max_strel_size, min_meniscus_voxels);
atlas_dims_m = size(atlas_medial);
atlas_dims_l = size(atlas_lateral);

% Convert mask to mesh
FV_m = mask_to_mesh(atlas_medial, voxel_size);
FV_l = mask_to_mesh(atlas_lateral, voxel_size);

% Save atlas
if ~exist(dst, 'dir')
    mkdir(dst)
end
savename_m = fullfile(dst, 'atlas_mesh_m.mat');
savename_l = fullfile(dst, 'atlas_mesh_l.mat');
f.FV = FV_m;
save(savename_m, '-struct', 'f');
f.FV = FV_l;
save(savename_l, '-struct', 'f');

tEnd = toc(tStart);
disp(strcat('Time to convert mask to mesh:', num2str(tEnd)));
disp('ATLAS GENERATED.')

% Visualize surface, if desired
% plot_mesh(FV_m.faces, FV_m.vertices, 0, 0)
% plot_mesh(FV_l.faces, FV_m.vertices 0, 0)

%% Mesh match

disp('PERFORMING MESH MATCH')
df = readtable(df_path, 'Delimiter', ',', 'ReadVariableNames', 0);

if ~exist(fullfile(dst, 'medial'), 'dir')
    mkdir(fullfile(dst, 'medial'))
end
if ~exist(fullfile(dst, 'lateral'), 'dir')
    mkdir(fullfile(dst, 'lateral'))
end

for i = 1:height(df)
    % Parse file information
    row = df{i, 1};
    filepath = row{1};
    disp(strcat('Current file:', filepath))
    [~, filename, ~] = fileparts(filepath);
    file_attributes = strsplit(filename, '_');
    file_laterality = file_attributes{2};
    
    % Load mask
    mask = load(filepath).x;
    
    % Mask preprocessing extracts lateral and medial menisci
    [mask_medial, mask_lateral] = meniscus_mask_preprocess(mask, file_laterality, meniscus_mask_value, n_menisci, max_strel_size, min_meniscus_voxels);
    dims_m = size(mask_medial);
    dims_l = size(mask_lateral);
    
    % Convert mask to mesh
    FV2_m = mask_to_mesh(mask_medial, voxel_size);
    FV2_l = mask_to_mesh(mask_lateral, voxel_size);
    
    % Rough scaling
    xfactor_m = atlas_dims_m(2) / dims_m(2);
    yfactor_m = atlas_dims_m(1) / dims_m(1);
    zfactor_m = atlas_dims_m(3) / dims_m(3);
    xfactor_l = atlas_dims_l(2) / dims_l(2);
    yfactor_l = atlas_dims_l(1) / dims_l(1);
    zfactor_l = atlas_dims_l(3) / dims_l(3);
    
    FV2_m.vertices(:, 1) = FV2_m.vertices(:, 1) * xfactor_m;
    FV2_m.vertices(:, 2) = FV2_m.vertices(:, 2) * yfactor_m;
    FV2_m.vertices(:, 3) = FV2_m.vertices(:, 3) * zfactor_m;
    FV2_l.vertices(:, 1) = FV2_l.vertices(:, 1) * xfactor_l;
    FV2_l.vertices(:, 2) = FV2_l.vertices(:, 2) * yfactor_l;
    FV2_l.vertices(:, 3) = FV2_l.vertices(:, 3) * zfactor_l;
    
    % Meniscus matching
    disp('Performing ICP for medial meniscus.')
    [fix_m, move_m, ~] = rigid_match(FV_m.vertices, FV2_m.vertices);
    disp('Performing ICP for lateral meniscus.')
    [fix_l, move_l, ~] = rigid_match(FV_l.vertices, FV2_l.vertices);
    
    % Rescale to original size
    move_m(1, :) = move_m(1, :) / xfactor_m;
    move_m(2, :) = move_m(2, :) / yfactor_m;
    move_m(3, :) = move_m(3, :) / zfactor_m;
    move_l(1, :) = move_l(1, :) / xfactor_l;
    move_l(2, :) = move_l(2, :) / yfactor_l;
    move_l(3, :) = move_l(3, :) / zfactor_l;
    
    % Plot, if desired
    % plot_fix_move(fix_m, move_m)
    % plot_fix_move(fix_l, move_l)
    
    % Save
    savename_m = fullfile(dst, 'medial', strcat(filename, '_m.mat'));
    savename_l = fullfile(dst, 'lateral', strcat(filename, '_l.mat'));
    f.move = move_m;
    save(savename_m, '-struct', 'f');
    f.move = move_l;
    save(savename_l, '-struct', 'f');
    
    close all;
    disp(strcat('Completed:', filename));
end
disp('COMPLETED!!');
end