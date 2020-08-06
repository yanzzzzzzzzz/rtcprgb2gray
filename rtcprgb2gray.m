% im : input rgb image
% W : the candicate weight follow by section 2.2 
% sigma :gaussian distribution sigma
% n : Return n better contrast preserving weights index
function top_n = rtcprgb2gray(im, W, sigma, n)
    %get pool P
    [P, delta_xy]= get_pool(im);
    % convert grayscale value by weight wi and calculate E(g) in pool P
    record_Eg=zeros(size(W,1),1);

    for wi=1:size(W,1)
        L = P(:,1) * W(wi,1) + P(:,2) * W(wi,2) + P(:,3) * W(wi,3);
        a = (L + delta_xy') / sigma;
        b = (L - delta_xy') / sigma;
        Eg = sum(log(exp(-a .* a) + exp(-b .* b)));
        
        record_Eg(wi) = Eg / size(P,1);
    end
    [~,top_n] = maxk(record_Eg,n);
end