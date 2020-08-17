function [center, radius, area] = findSphere(img)
bin_img = im2bw(img);
CC = regionprops(bin_img, 'Area', 'Centroid', 'EquivDiameter');

center = CC.Centroid;
area = CC.Area;
%radiusfromArea = sqrt( area / pi );
radius = CC.EquivDiameter / 2;
