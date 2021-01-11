function Y = edgeInterp3(X, E, MB)

    M = size(X,1); N = size(X,2);
    Y = padarray(X, [1 1], 'replicate');
    Y(2:M+1, 2:N+1) = X;
    
    Fh = [-1 0 -1 0 -1; 0 0 0 0 0; 2 0 2 0 2; 0 0 0 0 0; -1 0 -1 0 -1];
    F45 = [-1 0 -1 0 2; 0 0 0 0 0; -1 0 2 0 -1; 0 0 0 0 0; 2 0 -1 0 -1];
    Fv = Fh';   F135 = fliplr(F45);
    
    z = zeros(3,3,5);
    z(:,:,1) = [0 0 0; 1 0 1; 0 0 0];
    z(:,:,2) = [0 1 0; 0 0 0; 0 1 0];
    z(:,:,3) = [0 0 1; 0 0 0; 1 0 0];
    z(:,:,4) = [1 0 0; 0 0 0; 0 0 1];

    R = zeros(M+2, N+2, 4);
    R(:,:,1) = conv2(Y, Fh, 'same');
    R(:,:,2) = conv2(Y, Fv, 'same');
    R(:,:,3) = conv2(Y, F45, 'same');
    R(:,:,4) = conv2(Y, F135, 'same');
    
    L = size(MB,1);
    for i = 1:L
       s = MB(i,:);
       m = s(1)+1; n = s(2)+1;
       Rn = [R(m,n,1) R(m,n,2) R(m,n,3) R(m,n,4)];
       [~, index] = max(Rn);
       ROI = E(m-1:m+1, n-1:n+1);
       if sum(ROI,'all') > 0  
           if E(m,n)
               Y(m,n) = sum( z(:,:,index).*Y(m-1:m+1,n-1:n+1) ,'all')/sum(z(:,:,index),'all');
           else
               H = 1 - E(m-1:m+1, n-1:n+1);
               w = [sqrt(2) 1 sqrt(2); 1 0 1; sqrt(2) 1 sqrt(2)];
               Y(m,n) = sum( w.*H.*Y(m-1:m+1,  n-1:n+1) ,'all')/sum(w.*H,'all');
               %C = bwconncomp(H);
               %Clist = C.PixelIdxList;
               %w = ones(3,3);   w(2,2) = 0;
               %Ci = C.NumObjects;
           end 
       end
           
    end
    
    Y = Y(2:M+1, 2:N+1);
end