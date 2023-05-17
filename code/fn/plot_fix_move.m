function [] = plot_fix_move(fix, move)
% PLOT_FIX_MOVE  plots two 3D point clouds: fix (blue) and move (red)
% 
% INPUTS:
%   fix        : point cloud 1
%   move       : point cloud 2
% 
% Created by   : Kenneth Gao 2023

figure();
plot3(fix(1, :), fix(3, :), fix(2, :), '.b');
axis 'off'
hold on;
grid on;
plot3(move(1, :), move(3, :), move(2, :), '.r');
view(0, 120);

end