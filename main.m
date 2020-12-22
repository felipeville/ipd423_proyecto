%% Load Image
% To set the default DWT mode
% dwtmode('sym','nodisplay')

clear, close all

% Load and pre-process the test image
load noise25.mat
%W = rand10MB();
image = 'lena.tif';
map = gray;

X_og = imread("test_images/"+image); X_og = double(X_og);
X_og = X_og(:,:,1);
X_og(X_og == 0) = 1;
X = X_og.*W;

imshow(X,map)
%% DWT
close all
psi = 'haar';

L = 3;  % levels
Ao = zeros(64,64);

for k = 1:L+1
    A = X;
    for i = k:L
        [A, cH, cV, cD] = dwt2(A, psi);
    end
    
    if k > 1
        A = Ao;
    end
    
    [MB, mask] = detectMB2(X, 4-k);
    Ad = direcInterp(A, MB);
    E = edge(Ad,'canny', [0.05 0.2], 4*sqrt(2));
    G = 2^(k-1);
    E = imdilate(E, ones(G,G));
    Ae = edgeInterp2(Ad, E, MB);
    
    if k < 4
        %cH = detailInterp(Ae,psi,cH,mask,E,'cH');
        %cV = detailInterp(Ae,psi,cV,mask,E,'cV');
        %cD = detailInterp(Ae,psi,cD,mask,E,'cD');
        
        cH = direcInterp(cH, MB);
        cV = direcInterp(cV, MB);
        cD = direcInterp(cD, MB);
        
        Ao = idwt2(Ae,cH,cV,cD,psi);
    end
    %figure, imagesc(E), colormap(map), axis image
end

% Load the original image for comparison
peak_value = max(max(X_og));
min_value = min(min(X_og));

Ae = floor( rescale(Ae,min_value,peak_value) );

PSNR = psnr(Ae, X_og, 255);
disp("PSNR = " + PSNR + " [dB]");

figure, imshow(X_og, map)
figure, imshow(X,map)
figure, imshow(Ae, map)
%%
imwrite(X_og,map,'result_images/man.png');
imwrite(X,map,'result_images/man_MB_25.png');
imwrite(Ae,map,'result_images/man_result_25.png');
%figure, imshow(Ad, map)
%% DCT
close all

L = 3;  % levels
Ao = zeros(64,64);

for k = 1:L+1
    A = X;
    for i = k:L
        s = size(A); M = s(1); N = s(2);
        A = idct2(dct2(A), M/2, N/2);
    end
    
    [MB, mask] = detectMB2(X, 4-k);
    
    if k > 1
        A = mergeMB(A, Ao, mask);
    end
    
    Ad = direcInterp(A, MB);
    E = edge(Ad,'canny', [0.05 0.3], 2*sqrt(2));
    G = 2^(k-1);
    E = imdilate(E, ones(G,G));
    Ae = edgeInterp2(Ad, E, MB);
    
    if k < 4
        Ao = idct2(dct2(Ae), M, N);
    end
    
    %figure, imagesc(E), colormap(map), axis image
end


% Load the original image for comparison
peak_value = max(max(X_og));
min_value = min(min(X_og));

Ae = floor( rescale(Ae,min_value,peak_value) );

PSNR = psnr(Ae, X_og, 255);
disp("PSNR = " + PSNR + " [dB]");

figure, imshow(X_og, map)
figure, imshow(Ae, map)
%%
%imwrite(X,map,'result_images/peppers_MB_10.png');
imwrite(Ae,map,'result_images/peppers_result_10r_dct.png');
%% DWT Testing
close all
psi = 'db2';

L = 3;  % levels
Ao = zeros(64,64);

for k = 1:L+1-2
    A = X;
    for i = k:L
        [A, cH, cV, cD] = dwt2(A, psi);
    end
    
    if k > 1
        A = Ao;
    end
    
    %[MB, mask] = detectMB(X, 4-k);
    [MB, mask] = detectMB3(W, 4-k, psi);
    Ad = direcInterp(A, MB);
    E = edge(Ad,'canny', [0.05 0.3], 2*sqrt(2));
    E = imdilate(E, ones(k,k));
    Ae = edgeInterp2(Ad, E, MB);
    
    if k < 4
        cH = direcInterp(cH, MB);
        cV = direcInterp(cV, MB);
        cD = direcInterp(cD, MB);

        Ao = idwt2(Ae,cH,cV,cD,psi);
    end
    
end

figure, imagesc(A), colormap(map), axis image
figure, imagesc(E), colormap(map), axis image
figure, imagesc(Ad), colormap(map), axis image
figure, imagesc(Ae), colormap(map), axis image