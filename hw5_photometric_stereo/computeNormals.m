function [normals, albedo_img] = computeNormals(light_dirs, img_cell, mask)
% Photometric stereo requires the object to be lit by at least 3 light sources.

numL = length(img_cell);
all_img = zeros(size(mask,1), size(mask,2), numL);

for ct = 1:numL
    all_img(:, :, ct) = img_cell{ct};
end

selected_Index = 1:numL;
albedo_img = mask*0;
normals = zeros(size(mask,1), size(mask,2),3);
[x, y] = find(mask > 0);

S = light_dirs;
for i=1:length(x)
    I = arrayfun(@(k) all_img(x(i), y(i), k),selected_Index)';
    N = inv(S' * S) * S' * I; 
    
    albedo_img(x(i), y(i)) = norm(N);
    normals(x(i), y(i), :) = N / norm(N);
    
end
% normalize
albedo_img = albedo_img / max(albedo_img(:));
