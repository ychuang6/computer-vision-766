function mask = computeMask(img_cell)
mask = zeros(size(img_cell{1}));

for i=1:length(img_cell)
    imgnow = img_cell{i};
    mask(imgnow > 0) = 1;
end