% Function to directional interpolate the MB
% Arguments:
%   X = input image
%   MB = matrix with MB indexes
% Returns:
%   Y = image with the MB interpolated

function Y = direcInterp(X, MB, flag)

    if ~exist('flag','var')
        flag = 0;
    end
    M = size(X,1); N = size(X,2);
    %Y = zeros(M+2,N+2);
    Y = padarray(X, [1 1], 'replicate');
    Y(2:M+1, 2:N+1) = X;
    
    Fh = [-1 0 -1 0 -1; 0 0 0 0 0; 2 0 2 0 2; 0 0 0 0 0; -1 0 -1 0 -1];
    F45 = [-1 0 -1 0 2; 0 0 0 0 0; -1 0 2 0 -1; 0 0 0 0 0; 2 0 -1 0 -1];
    %Fh = [-1 -2 -1; 0 0 0; 1 2 1];
    %F45 = [0 1 2; -1 0 1; -2 -1 0];
    Fv = Fh';   F135 = fliplr(F45);
    
    z = zeros(3,3,5);
    z(:,:,1) = [0 0 0; 1 0 1; 0 0 0];
    z(:,:,2) = [0 1 0; 0 0 0; 0 1 0];
    z(:,:,3) = [0 0 1; 0 0 0; 1 0 0];
    z(:,:,4) = [1 0 0; 0 0 0; 0 0 1];
    %z(:,:,5) = [0 1 0; 1 0 1; 0 1 0];
    z(:,:,5) = [1 1 1; 1 0 1; 1 1 1];
    

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
       Rn = sort(Rn);
       %if sum(abs(Rn))/4 < 2.5*abs(minimum)
       if (abs(Rn(1) - R(4)) < 2*std(Rn) && ~flag)
           index = 5;
       end
       Y(m,n) = sum( z(:,:,index).*Y(m-1:m+1,n-1:n+1) ,'all')/sum(z(:,:,index),'all');
       
    end
    
    Y = Y(2:M+1, 2:N+1);
end