function W = createWeight()
    W(66,3) = 0;
    c = 1;
    for i=0:10
        for j=0:(10-i)
            k = 10 - (i+j);
            W(c,:) = [i/10 ,j/10 ,k/10];
            c = c+1;
        end
    end
end