function result = computeFlow(img1, img2, win_radius, template_radius, grid_MN)
%produces the optical flow vector field as a needle map” of a given resolution, overlaid on the first of the two images.

flowMat = [];
img11 = padarray(img1, [template_radius, template_radius]);
img22 = padarray(img2, [win_radius, win_radius]);

imgH = size(img1, 1);
imgW = size(img1, 2);
ingrid_MN = size(img1)./grid_MN;
gridH = round(ingrid_MN(1)); %Y
gridW = round(ingrid_MN(2)); %X


for i = 1 :gridW: imgW 
    for j = 1 :gridH: imgH  
        template_j = j: (j + 2*template_radius); 
        template_i = i : (i + 2*template_radius); 
        template = img11(  template_j , template_i); 
        
        win_j = j : (j + 2*win_radius);
        win_i = i : (i + 2*win_radius); 
        window = img22(win_j , win_i);
        corrMain = normxcorr2(template, window);
        
        corrMat = corrMain( ...
            template_radius+1 : (size(corrMain,1) - template_radius), ...
            template_radius+1 : (size(corrMain,2) - template_radius) );
        
        [j_max, i_max] = find(corrMat == max(corrMat(:)));
        if length(i_max) > 1
            i_max = round( mean(i_max));
            j_max = round( mean(j_max));
        end
        
        uu = i_max - (win_radius + 1);
        vv = j_max - (win_radius + 1);
        flowMat = [flowMat; i, j, uu, vv];
    end
end
fh = figure;
imshow(img1);
hold on
quiver(flowMat(:,1), flowMat(:,2), flowMat(:,3), flowMat(:,4), 0, 'Color','c')
hold off
result = saveAnnotatedImg(fh);
end

function annotated_img = saveAnnotatedImg(fh)
figure(fh); % Shift the focus back to the figure fh

% The figure needs to be undocked
%set(fh, 'WindowStyle', 'normal');

% The following two lines just to make the figure true size to the
% displayed image. The reason will become clear later.
img = getimage(fh);
truesize(fh, [size(img, 1), size(img, 2)]);
set(gcf,'color','w')
% getframe does a screen capture of the figure window, as a result, the
% displayed figure has to be in true size. 
frame = getframe(fh);
pause(0.5); 
% Because getframe tries to perform a screen capture. it somehow 
% has some platform depend issues. we should calling
% getframe twice in a row and adding a pause afterwards make getframe work
% as expected. This is just a walkaround. 
annotated_img = frame.cdata;


end        