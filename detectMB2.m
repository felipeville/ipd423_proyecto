% Function to detect the missing blocks
% Arguments:
%   X = input image
%   level = scale of the image to detect the MB
% Returns:
%   MB = N*2 matrix with the pixel coordinates of the MB

function [MB, mask] = detectMB2(X, level)
    L2 = [1 2 3 4 5 8 9 12 13 14 15 16 6 7 10 11];
    L3 = [1:9 16 17 24 25 32 33 40 41 48 49 56:64 10:15 18 23 26 31 34 39 ...
          42 47 50:55 19:22 27 30 35 38 43:46 28 29 36 37];
    
    mask = X;
    mask(mask > 0) = 1;   % assume dead pixels are == 0
    mask = imresize(mask, 0.5^level,'nearest');
    % Nearest neighbour is used for integer down-scaling
    % to avoid artifacts from other algorithms
    
    step = size(mask,1);
    MB = [0 0];
    mask = 1 - mask;
    
    C = bwconncomp(mask);
    Clist = C.PixelIdxList;
    Cn = C.NumObjects;
    
    for i = 1:Cn
        ids = Clist{i};
        S = length(ids);
        for k = 1:S
           if level == 0
               idx = ids(L3(k)) - 1;
           elseif level == 1
               idx = ids(L2(k)) - 1;
           else
               idx = ids(k) - 1;
           end
           n = floor(idx/step);
           m = idx - n*step;
           m = m + 1; n = n + 1;    % correccion indices MATLAB
           MB = [MB; m n];
        end       
    end
    MB = MB(2:length(MB),:);
end