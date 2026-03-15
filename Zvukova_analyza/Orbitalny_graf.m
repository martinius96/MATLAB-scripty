clear; clc; close all;

%% 1. NAČÍTANIE A PRÍPRAVA DÁT
[audio1, fs1] = audioread('TAM_Paliva_3x3.mp4'); 
[audio2, fs2] = audioread('LPG.mp4'); 
[audio3, fs3] = audioread('astra.mp3'); 

% Prevody na mono
audio1 = mean(audio1, 2); audio2 = mean(audio2, 2); audio3 = mean(audio3, 2);
if fs2 ~= fs1, audio2 = resample(audio2, fs1, fs2); end
if fs3 ~= fs1, audio3 = resample(audio3, fs1, fs3); end

% Segmentácia
segments101 = [0, 3.2; 3.3, 5.9; 6.0, 9.2];
segments95  = [9.3, 12.5; 12.6, 16.6; 16.7, 20.1];
segmentsLPG = [0, 5.0; 5.1, 11.4];

extract = @(au, fs, segs) cell2mat(arrayfun(@(i) au(round(segs(i,1)*fs)+1 : round(segs(i,2)*fs)), 1:size(segs,1), 'UniformOutput', false)');

sigs = {extract(audio1, fs1, segments101), ...
        extract(audio1, fs1, segments95), ...
        extract(audio2, fs1, segmentsLPG), ...
        audio3(1:30000)}; % MISFIRE
titles = {'101 Oct', '95 Oct', 'LPG', 'MISFIRE'};

%% 2. ORBITÁLNA ANALÝZA (Zrozumiteľná vizualizácia cyklov)
figure('Name','Orbitálna diagnostika motora','Color','w','Position',[50 50 1200 600]);
cycle_len = 500; % Počet vzoriek na jeden cyklus (treba prispôsobiť otáčkam)

for k = 1:4
    s = sigs{k};
    % Orezanie na počet celých cyklov
    num_cycles = floor(length(s)/cycle_len);
    s_mat = reshape(s(1:num_cycles*cycle_len), cycle_len, []);
    
    subplot(2,2,k);
    theta = linspace(0, 2*pi, cycle_len);
    
    % Vykreslenie všetkých cyklov v polárnom grafe (tenké, priesvitné čiary)
    polarplot(theta, s_mat', 'Color', [0.2 0.2 0.2 0.1]); 
    hold on;
    
    % Priemerná stopa (hrubá červená čiara)
    polarplot(theta, mean(s_mat, 2), 'r', 'LineWidth', 2);
    
    title(['Orbitálny graf: ' titles{k}]);
    rlim([-0.1 0.1]); % Fixné limity pre porovnanie
    set(gca, 'ThetaZeroLocation', 'top');
end
