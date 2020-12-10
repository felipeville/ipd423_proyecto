% Function to detect the missing blocks
% Arguments:
%   cA = aproximation image
%   x = upscaled image from the previous level
% Returns:
%   MB = N*2 matrix with the pixel coordinates of the MB

function y = mergeMB(cA, x, mask)
    y = cA.*(1-mask) + x.*mask;
end