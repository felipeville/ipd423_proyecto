% Function to enhance the interpolated MBs
% Arguments:
%   X = image after the directional interpolation
%   E = skeleton of the image obtained with Canny
%   MB = matrix with the pixel coordinates of the MB
% Returns:
%   Y = image with enhanced borders

function Y = edgeInterp(X, E, MB)
    Y = X;
    l = length(MB);

    for i = 1:l
       m = MB(i,1); n = MB(i,2);
       if E(m,n)
           ROI = E(m-1:m+1,n-1:n+1);
           ROI(2,2) = 0;
           %Y(m,n) = sum(ROI.*Y(m-1:m+1,n-1:n+1),'all')/sum(ROI,'all');
           Y(m-1:m+1, n-1:n+1) = imgaussfilt(Y(m-1:m+1, n-1:n+1), 0.1);
       end
    end
end