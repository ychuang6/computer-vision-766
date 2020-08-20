function trackingTester(data_params, tracking_params)
    total_n = size(data_params.frame_ids, 2);
    searchsize = tracking_params.search_half_window_size;
    
    out_dir = strcat(data_params.data_dir, '_results');
    if isempty(dir(out_dir))
        mkdir(out_dir);
    end
    % generate a color map from the object of interest, 
    % and compute all subsequent color histograms based on 
    % the SAME color map. 
    base_imgpath = fullfile(data_params.data_dir, data_params.genFname(data_params.frame_ids(1)));
    base_img = imread(base_imgpath);
    bin_num = tracking_params.bin_n;
    
    rect = tracking_params.rect;
    x_min = rect(1);
    y_min = rect(2);
    boxW = rect(3);
    boxH = rect(4);
    
    % divide the color range of an image into several bins
    box_img = base_img(y_min:(y_min + boxH)-1, x_min:(x_min + boxW)-1, :);
    [rgb_X, rgb_map ] = rgb2ind(box_img, bin_num);
    
    % compute the color histogram
    [base_hist, edges] = histcounts(rgb_X(:), bin_num);
    for i = 1:total_n
        img_path = fullfile(data_params.data_dir, data_params.genFname(data_params.frame_ids(i)));
        img_raw = imread(img_path);
        img_now = img_raw;
        
        [jj, ii, kk] = size(img_now);
        
        xS = max(1, x_min - searchsize);
        xE = min(ii, x_min + boxW + searchsize)-1;
        yS = max(1, y_min - searchsize);
        yE = min(jj, y_min + boxH + searchsize)-1;
        
        box_now = (img_now(yS:yE, xS:xE,:)); 
      
        sel_channel(:,:,1) = im2col(box_now(:,:,1), [boxH boxW]);
        sel_channel(:,:,2) = im2col(box_now(:,:,2), [boxH boxW]);
        sel_channel(:,:,3) = im2col(box_now(:,:,3), [boxH boxW]);

        for j = 1:size(sel_channel,2)
           [rgbX_now, rgb_map_now] = rgb2ind(sel_channel(:,j,:), rgb_map); %y_dim
           rest_histG(:,j) = histcounts(rgbX_now, bin_num);
        end
        
        corrMain = corr(base_hist', rest_histG);
        [~, max_ind] = find(corrMain == max(corrMain(:)));

        meanI = round(mean(max_ind));
        
        realH = size(box_now,1) - boxH + 1; %Height 
        rect(1) = round(meanI / realH) + xS;
        rect(2) = round(mod(meanI, realH)) + yS;
        x_min = rect(1);
        y_min = rect(2);
    
        target_img = drawBox(img_raw, rect, [255 0 0], 3);
        imshow(target_img)
        output_path = fullfile(out_dir, data_params.genFname(data_params.frame_ids(i)));
        imwrite(target_img, output_path);
        giffilename = fullfile(out_dir, strcat(data_params.data_dir,'.gif'));
        [gif_img, cm ] = rgb2ind(target_img, 256);
        if i == 1
            imwrite(gif_img, cm, giffilename, 'gif','Loopcount',inf); 
        else
            imwrite(gif_img, cm, giffilename, 'gif','WriteMode','append'); 
        end
    end
end