% Function to detect the missing blocks
% Arguments:
%   X = input image
%   level = scale of the image to detect the MB
% Returns:
%   MB = N*2 matrix with the pixel coordinates of the MB

function [MB, mask] = detectMB(X, level)
    mask = X;
    mask(mask > 0) = 1;   % assume dead pixels are == 0
    mask = imresize(mask, 0.5^level,'nearest');
    % Nearest neighbour is used for integer down-scaling
    % to avoid artifacts from other algorithms
    
    M = size(mask,1);  N = size(mask,2);
    MB = [];
    
    for m = 1:M
        for n = 1:N
            if mask(m,n) < 1
                MB = [MB; m n];
            end
        end
    end
    mask = 1 - mask;
end