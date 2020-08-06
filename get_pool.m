
function  [P_result, dst_result]= get_pool(im)
    P_result = [];
    dst_result = [];
    [im_cols,im_rows,~] = size(im);
    s = 64 / sqrt(im_cols * im_rows);
    cols = fix(s * im_cols + 0.5);
    rows = fix(s * im_rows + 0.5);
    pos0 = zeros((cols - 1) * (rows - 1), 2);
    c = 0;
    %downsampling
    % n = im_cols / cols
    % 1.5 * n ...2.5 * n ,3.5 * n.....(cols - 1) * n
    for i = 1:cols - 1
        for j = 1:rows - 1
            x = fix((i + 0.5) * im_cols / cols);
            y = fix((j + 0.5) * im_rows / rows);
            c = c + 1;
            pos0(c,:) = [x y];
        end
    end
    % randomized point to create random pair
    pos1 = pos0(randperm(size(pos0, 1)),:);
    [P,dst,isadd]= get_color_contrast_pool(im, pos0, pos1);
    if(isadd)
        P_result = [P_result;P];
        dst_result = [dst_result;dst];
    end
    cols = cols / 2;
    rows = rows / 2;
    
    pos0 = zeros(cols - 2 * rows - 1, 2);
    pos1 = zeros(cols - 2 * rows - 1, 2);
    c = 0;
    % shift x direction get pair
    for i = 1:cols - 2
        for j = 1:rows - 1
            x0 = fix((i + 0.5) * im_cols / cols);
            x1 = fix((i + 1.5) * im_cols / cols);
            y  = fix((j + 0.5) * im_rows / rows);
            c = c + 1;
            pos0(c,:) = [x0, y];
            pos1(c,:) = [x1, y];
        end
    end
    [P,dst,isadd]= get_color_contrast_pool(im, pos0, pos1);
    if(isadd)
        P_result = [P_result;P];
        dst_result = [dst_result,dst];
    end
    pos0 = zeros(cols - 1 * rows - 2, 2);
    pos1 = zeros(cols - 1 * rows - 2, 2);
    c = 0;
    % shift y direction get pair
    for i = 1:cols - 1
        for j = 1:rows - 2
            x  = fix((i + 0.5) * im_cols / cols);
            y0 = fix((j + 0.5) * im_rows / rows);
            y1 = fix((j + 1.5) * im_rows / rows);
            c = c + 1;
            pos0(c,:) = [x, y0];
            pos1(c,:) = [x, y1];
        end
    end
    [P,dst,isadd]= get_color_contrast_pool(im, pos0, pos1);
    if(isadd)
        P_result = [P_result;P];
        dst_result = [dst_result,dst];
    end
end
function  [P,dst,isadd]= get_color_contrast_pool(im, pos0, pos1)
    P(1,3) = 0;
    dst = 0;
    c = 0;
    for i=1:size(pos0,1)
        c0 = double(im(pos0(i,1), pos0(i,2),:));
        c1 = double(im(pos1(i,1), pos1(i,2),:));
        Rx = c0(1) / 255 - c1(1) / 255;
        Gx = c0(2) / 255 - c1(2) / 255;
        Bx = c0(3) / 255 - c1(3) / 255;
        d = sqrt(Rx * Rx + Gx * Gx + Bx * Bx) / 1.41;
        if(d>=0.05)
            c = c + 1;
            P(c,:) =[Rx Gx Bx];
            dst(c) = d;
        end
    end
    if(c~=0)
        isadd = 1;
    else
        isadd = 0;
    end
end
