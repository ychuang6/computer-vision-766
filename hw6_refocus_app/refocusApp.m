function refocusApp(rgb_stack, depth_map)

[imgH, imgW, dim] = size(rgb_stack);
% start with random img in the stack
totaln = dim / 3;
index = randi(totaln);
figure
while(true)
    imgnow = rgb_stack( :, :, (index*3)-2 : (index*3) );
    
    imshow(uint8(imgnow))
    % choose a focus point on image
    [j, i] = ginput(1);
    i = round(i);
    j = round(j);
    % terminate app when point is outside of image
    if i < 1 || i > imgH || j < 1 || j > imgW
        break
    end

    % refocus
    index = depth_map(i, j);

end