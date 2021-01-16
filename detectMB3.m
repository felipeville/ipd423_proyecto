% Function to detect the missing blocks
% Arguments:
%   X = input image
%   level = scale of the image to detect the MB
% Returns:
%   MB = N*2 matrix with the pixel coordinates of the MB

function [MB, mask] = detectMB3(X, level)
    mask = X;
    mask(mask > 0) = 1;   % assume dead pixels are == 0
    mask = imresize(mask, 0.5^level,'nearest');
    % Nearest neighbour is used for integer down-scaling
    % to avoid artifacts from other algorithms
    
    M = size(mask,1);  N = size(mask,2);
    MB = [0 0];
    
    for m = 1:M
        for n = 1:N
            check = ismember([m n], MB, 'rows');
            j = 8/(2^level) - 1;
            if (mask(m,n) < 1 && ~check)
                if level == 0
                    for k = 0:j
                        MB = [MB; m+k n];
                        MB = [MB; m+k n+j];
                    end
                    for k = 1:j-1
                        MB = [MB; m n+k];
                        MB = [MB; m+j n+k];
                    end
                    for k = 1:j-1
                        MB = [MB; m+k n+1];
                        MB = [MB; m+k n+j-1];
                    end
                    for k = 2:j-2
                        MB = [MB; m+1 n+k];
                        MB = [MB; m+j-1 n+k];
                    end
                    % 4
                    for k = 2:j-2
                        MB = [MB; m+k n+2];
                        MB = [MB; m+k n+j-2];
                    end
                    for k = 3:j-3
                        MB = [MB; m+2 n+k];
                        MB = [MB; m+j-2 n+k];
                    end
                    for k = 3:j-3
                        MB = [MB; m+k n+3];
                        MB = [MB; m+k n+j-3];
                    end
                elseif level == 1
                    for k = 0:j
                        MB = [MB; m+k n];
                        MB = [MB; m+k n+j];
                    end
                    for k = 1:j-1
                        MB = [MB; m n+k];
                        MB = [MB; m+j n+k];
                    end
                    for k = 1:j-1
                        MB = [MB; m+k n+1];
                        MB = [MB; m+k n+j-1];
                    end
                else
                    MB = [MB; m n];
                end             
            end
        end
    end
    mask = 1 - mask;
    MB = MB(2:length(MB),:);
end