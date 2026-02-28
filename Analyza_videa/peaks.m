%% ANALYZA KULTIVOVANOSTI MOTORA - ZAMERANÉ NA PEAKY
clc; clear; close all;

%% 1. Načítanie súboru
videoFile = 'TAM_paliva.mp4';
[audio, Fs] = audioread(videoFile);
if size(audio,2) == 2, audio = mean(audio,2); end
t = (0:length(audio)-1)/Fs;

%% 2. Parametre detekcie špičiek
% Hľadáme lokálne maximá, ktoré sú od seba aspoň 10ms (typický zvuk motora)
minPeakDistance = round(0.01 * Fs); 

%% 3. Rozdelenie na sekcie (podľa tvojho zadania)
idx_101 = t >= 5 & t < 29;   
idx_95  = t >= 29;           

segments = {'101 oktan', '95 oktan'};
indices = {idx_101, idx_95};
colors = {'r', 'g'};

figure('Color','w','Name','Analýza impulzov motora');

for i = 1:2
    seg_audio = abs(audio(indices{i})); % Pracujeme s absolútnou hodnotou (amplitúdou)
    seg_t = t(indices{i});
    
    % Detekcia špičiek (len tie najvýraznejšie - horných 10% sily)
    threshold = max(seg_audio) * 0.3; 
    [peaks, locs] = findpeaks(seg_audio, 'MinPeakHeight', threshold, 'MinPeakDistance', minPeakDistance);
    
    % --- VÝPOČTY KULTIVOVANOSTI ---
    % 1. Priemerná sila špičiek (ako hlasno to "klepe")
    mean_peak = mean(peaks);
    
    % 2. Stabilita špičiek (Smerodajná odchýlka výšky špičiek)
    % Čím MENŠIE číslo, tým vyrovnanejší a kultivovanejší chod.
    std_peak = std(peaks);
    
    % 3. Crest Factor (Pomer Peak/RMS) - v dB
    % Vysoké číslo = ostrý, kovový zvuk. Nízke číslo = hladký, mäkký zvuk.
    current_rms = sqrt(mean(seg_audio.^2));
    crest_factor = 20*log10(max(peaks) / current_rms);

    % Výpis výsledkov
    fprintf('\n========== %s ==========\n', segments{i});
    fprintf('Počet zachytených impulzov: %d\n', length(peaks));
    fprintf('Priemerná sila špičiek: %.4f\n', mean_peak);
    fprintf('Index nekultivovanosti (STD špičiek): %.6f\n', std_peak);
    fprintf('Ostrosť zvuku (Crest Factor): %.2f dB\n', crest_factor);
    
    % Vykreslenie
    subplot(2,1,i);
    plot(seg_t, seg_audio, 'Color', [0.7 0.7 0.7]); hold on;
    plot(seg_t(locs), peaks, 'o', 'MarkerEdgeColor', colors{i}, 'MarkerSize', 4);
    title(['Detekcia špičiek - ', segments{i}]);
    xlabel('Čas (s)'); ylabel('Amplitúda');
    grid on;
end
