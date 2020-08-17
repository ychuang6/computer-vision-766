function [rgb_stack, gray_stack] = loadFocalStack(focal_stack_dir)
dirlist = dir(focal_stack_dir);
name_L = arrayfun(@(x) contains(dirlist(x).name,'.jpg'), 1:length(dirlist));
startI = find(name_L > 0, 1);
diffI = startI - 1;
totaln = (length(dirlist) - startI) + 1; 

img1 = imread(fullfile(dirlist(startI).folder, dirlist(startI).name));
[imgH, imgW, dim] = size(img1);
rgb_stack = zeros(imgH, imgW, totaln*3);
gray_stack = zeros(imgH, imgW, totaln);

ct = 1;
for i = startI:length(dirlist)
    curImg = imread(fullfile(dirlist(i).folder, dirlist(i).name));
    rgb_stack(:,:,ct:(ct+2)) = curImg;
    ct = ct + 3;
    grayImg = rgb2gray(curImg);
    gray_stack(:,:,i-diffI) = grayImg;
end

