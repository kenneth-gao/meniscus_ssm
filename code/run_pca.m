function [] = run_pca(df_path, n_pc, dst)
% RUN_PCA  loads vertex data from surface meshes and performs probabilistic
% PCA to determine shape modes
%
% INPUTS:
%   df_path        : path of text file with paths of all meshes
%   n_pc           : desired number of principal components
%   dst            : path to which PCA variables will be saved
%
% Created by       : Kenneth Gao 2023

addpath(genpath(fullfile(cd, 'fn')));

%% Load all data

df = readtable(df_path, 'Delimiter', ',', 'ReadVariableNames', 0);
ids = {};
data = [];

for i = 1:height(df)
    row = df{i, 1};
    filepath = row{1};
    [~, filename, ~] = fileparts(filepath);
    
    load(filepath);
    ids{end + 1} = filename;
    % Flatten and concatenate
    data = [data, move(:)];
end

%% PCA

% Probabilistic PCA
[pc, W, data_mean, xr, evals, percent_var] = ppca(data, n_pc);

% Zero-mean data
A = repmat(mean(data, 2), 1, size(data, 2));
data_zero_mean = data - A;
pc = W * data_zero_mean;

pc_mean = mean(pc')';
A1 = mean(A')';

% Reconstruct observations
data_mean_recon = pinv(W) * pc_mean;
data_mean_recon = data_mean_recon + A1;

mean_recon = reshape(data_mean_recon, size(move));

% Plot mean surface, if desired
% plot3(mean_recon(1, :), mean_recon(2, :), mean_recon(3, :), '.b')

save(dst, 'ids', 'pc', 'W', 'data_mean', 'xr', 'evals', 'percent_var', 'mean_recon', 'A1', 'df_path', 'n_pc');
disp(strcat('Saved PCA vars:',  dst));
end