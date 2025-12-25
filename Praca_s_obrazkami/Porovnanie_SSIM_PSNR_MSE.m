%% ============================
%%  Script pre porovnanie originálneho obrázka vs. 2x a 4x zväčšeného akýmkoľvek algoritmom
%%  Martin Chlebovec (martinius96@gmail.com)
%% ============================

clc;
clear;

%% ====== URL OBRÁZKOV ======
url_original = "https://.jpg";   % 870x489
url_2x       = "https://.jpg"; % 1740x978
url_4x       = "https://.jpg"; % 3480x1956

%% ====== NAČÍTANIE ======
orig = imread(url_original);
img2x = imread(url_2x);
img4x = imread(url_4x);

%% ====== PREVOD NA GRAYSCALE ======
if size(orig,3) == 3
    orig = rgb2gray(orig);
end
if size(img2x,3) == 3
    img2x = rgb2gray(img2x);
end
if size(img4x,3) == 3
    img4x = rgb2gray(img4x);
end

%% ====== NORMALIZÁCIA ======
orig = im2double(orig);
img2x = im2double(img2x);
img4x = im2double(img4x);

%% ====== RESIZE NA VEĽKOSŤ ORIGINÁLU ======
img2x_resized = imresize(img2x, size(orig), 'bicubic');
img4x_resized = imresize(img4x, size(orig), 'bicubic');

%% ====== POROVNANIE ======
% --- 2x ---
mse_2x  = immse(img2x_resized, orig);
psnr_2x = psnr(img2x_resized, orig);
ssim_2x = ssim(img2x_resized, orig);

% --- 4x ---
mse_4x  = immse(img4x_resized, orig);
psnr_4x = psnr(img4x_resized, orig);
ssim_4x = ssim(img4x_resized, orig);

%% ====== VÝSLEDKY ======
fprintf('\n==============================\n');
fprintf(' UPSCALING QUALITY RESULTS\n');
fprintf('==============================\n');

fprintf('\n--- 2x UPSCALE ---\n');
fprintf('SSIM: %.4f  (%.2f %%)\n', ssim_2x, ssim_2x * 100);
fprintf('PSNR: %.2f dB\n', psnr_2x);
fprintf('MSE : %.6f\n', mse_2x);

fprintf('\n--- 4x UPSCALE ---\n');
fprintf('SSIM: %.4f  (%.2f %%)\n', ssim_4x, ssim_4x * 100);
fprintf('PSNR: %.2f dB\n', psnr_4x);
fprintf('MSE : %.6f\n', mse_4x);

%% ====== VOLITEĽNÉ: ZOBRAZENIE ROZDIELOV ======
figure('Name','Rozdiely oproti originálu');

subplot(1,3,1);
imshow(orig);
title('Originál');

subplot(1,3,2);
imshow(abs(orig - img2x_resized), []);
title('Rozdiel 2x');

subplot(1,3,3);
imshow(abs(orig - img4x_resized), []);
title('Rozdiel 4x');
