clear; clc; close all;

%% 1. NAČÍTANIE A PRÍPRAVA DÁT (0 - 30s)
filename = '95_TAM_30.mp4'; 

try
    [audio, fs] = audioread(filename);
catch
    error('Súbor %s nebol nájdený!', filename);
end

% Prevod na mono
if size(audio,2) > 1, audio = mean(audio,2); end

% Orezanie na 30 sekúnd
target_dur = 30;
max_samples = min(length(audio), round(target_dur * fs));
sig = audio(1:max_samples);

% Normalizácia pre lepšiu viditeľnosť v grafe
sig = sig / max(abs(sig)) * 0.1; 

%% 2. FÁZOVÝ PORTRÉT (Analýza stability v čase)
% Rozdelíme 30s na 4 rovnomerné bloky pre porovnanie
chunk_size = floor(length(sig) / 4);
titles = {'0-7.5s (Štart)', '7.5-15s (Priebeh)', '15-22.5s (Priebeh)', '22.5-30s (Koniec)'};
col = [0 0.4470 0.7410]; % Jednotná modrá pre 95 oktán

figure('Name','Fázový portrét: Vývoj stability (30s)','Color','w','Position',[100 100 1100 800]);

for k = 1:4
    subplot(2,2,k);
    
    % Výber konkrétneho časového bloku
    start_idx = (k-1) * chunk_size + 1;
    end_idx = k * chunk_size;
    s_chunk = sig(start_idx:end_idx);
    
    % Vykreslenie fázového portrétu (x(t) vs x(t+1))
    % Používame každú 2. vzorku pre lepšiu prehľadnosť pri 30s dĺžke
    plot(s_chunk(1:2:end-1), s_chunk(2:2:end), '.', 'Color', [col 0.2], 'MarkerSize', 0.1);
    
    title(titles{k}); 
    grid on; 
    axis square;
    xlim([-0.12 0.12]); 
    ylim([-0.12 0.12]);
    xlabel('x(t)'); ylabel('x(t+1)');
    
    % Pridanie popisu s RMS pre daný blok
    text(-0.1, 0.1, sprintf('RMS: %.4f', rms(s_chunk)), 'FontWeight', 'bold');
end

sgtitle('Fázová analýza 95-oktánového paliva (0-30s)', 'FontSize', 16);

%% 3. CELKOVÝ KOMBINOVANÝ PORTRÉT (Prekrytie)
figure('Name','Celkový fázový portrét','Color','w');
plot(sig(1:5:end-1), sig(2:5:end), '.', 'Color', [col 0.05], 'MarkerSize', 0.1);
title('Súhrnný fázový portrét (Všetky cykly dohromady)');
xlabel('x(t)'); ylabel('x(t+1)');
axis square; grid on;
xlim([-0.12 0.12]); ylim([-0.12 0.12]);
