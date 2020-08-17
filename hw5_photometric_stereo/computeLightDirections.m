function light_dirs_5x3 = computeLightDirections(center, radius, img_cell)
% assume an orthographic projection
% find the normal to the brightest surface spot on the sphere

light_dirs_5x3 = zeros(length(img_cell), 3);

for i = 1:length(img_cell)
    imgnow = img_cell{i};
    maxVal = max(imgnow(:));
    [y, x] = find(imgnow == maxVal);
    l_center = [mean(x), mean(y)];
    
    xdiff = l_center(1) - center(1);
    ydiff = l_center(2) - center(2);
    z = sqrt(radius^2 - xdiff^2 - ydiff^2);
    
    n = [xdiff, ydiff, z];
    unit_surf_norm = n / norm(n);
    light_dirs_5x3(i,:) = unit_surf_norm * double(maxVal);
    
    
end