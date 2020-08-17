function index_map = generateIndexMap(gray_stack, w_size)

H = [-1 2 -1];
dx2 = imfilter(gray_stack, H);
dy2 = imfilter(gray_stack, H');
lap_filtered = abs(dx2 + dy2);

% sum of the square of mod_lap responses within the window defined by half
% window size
lap_filtered = imfilter(lap_filtered, ones( (2*w_size) + 1 ) );
ave_filtered = imfilter(lap_filtered, fspecial('average', 25) );

[~, index_map] = max(ave_filtered, [], 3);