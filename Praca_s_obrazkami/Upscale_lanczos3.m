% --- Upscale fotografie 2x algoritmom Lanczos3 (pre ostré hrany) ---
% Script k článku https://deadawp.blog.sector.sk/blogclanok/13558/zvacsenie-fotografie-strata-kvality.htm
% Martin Chlebovec

% Vstupny obrazok, nazov vo workspace, priecienku
input_filename = 'FOTO.jpg';
[folder, name, ext] = fileparts(input_filename);

% Nacitanie obrazka do premennej
img = imread(input_filename);

% Kolko krat zväčešujeme
scaleFactor = 2;

% Realizácia zväčšenia obrázka algoritmom lanczos3
upscaled_img = imresize(img, scaleFactor, 'lanczos3');

% Nazov suboru s doplnenim upscaledx2 do nazvu
output_filename = fullfile(folder, [name '_upscaledx2' ext]);

% Ulozenie obrazka do zlozky s .m scriptom
imwrite(upscaled_img, output_filename);

fprintf('Hotovo! Obrázok bol uložený ako: %s\n', output_filename);
