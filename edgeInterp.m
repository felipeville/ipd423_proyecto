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
        ROI = E(m-1:m+1,n-1:n+1);
        ROI(2,2) = 0;
        if sum(ROI,'all') > 0
           if E(m,n)
               Y(m,n) = sum(ROI.*Y(m-1:m+1,n-1:n+1),'all')/sum(ROI,'all');
           else 
               ROI = ones(3,3) - ROI;
               Y(m,n) = sum(ROI.*Y(m-1:m+1,n-1:n+1),'all')/sum(ROI,'all');
           end
        end
    end
end