clc;clear;close all;

file_dir = dir('testdata/*.png');    
save_folder = "save";
save_folder = create_folder(save_folder);
W = createWeight();
sigma = 0.05;
top_n_select = 3;
for num = 1:size(file_dir,1)
    tic
    % load image
    img_name = file_dir(num).name(1:end-4);
    disp("img name:" + img_name);
    im = imread(file_dir(num).folder + "/" + file_dir(num).name);
    % rtcprgb2gray
    top_n = rtcprgb2gray(im, W, sigma, top_n_select);
    toc
    for max_i=1:top_n_select
        wi = top_n(max_i);
        img = imlincomb(W(wi, 1), im(:,:,1), W(wi, 2), im(:,:,2),  W(wi, 3), im(:,:,3));
        % figure,imshow(img)
        imwrite(img,save_folder + img_name  + "_rank" + max_i +".png");
    end
end

