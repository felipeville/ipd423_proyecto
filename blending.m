function Y = blending(X, mask)
    Y = X;
    comp = bwconncomp(mask);
    L = comp.NumObjects;
    comp = comp.PixelIdxList;
    
    step = size(X,1);
    level = log2(step/64);
    k = 2^level;
    
    for i = 1:L
       idx = comp{i}(1) - 1;
       n = floor(idx/step);
       m = idx - n*step;
       m = m + 1; n = n + 1;    % correccion indices MATLAB
       
       ROI = Y(m-k/2:m+k-1+k/2, n-k/2:n+k-1+k/2);
       %mv = min(ROI,[],'all');
       %Mv = max(ROI,[],'all');
       D = dct2(ROI);
       D_ = zeros(size(D));
       D_(1:k,1:k) = D(1:k,1:k);
       D = idct2(D_);
       %D = rescale(D,mv,Mv);
       Y(m:m+k-1, n:n+k-1) = D(k/2+1:k/2+k,k/2+1:k/2+k);
    end
end