clear; clc; close all;

%% 1. NAČÍTANIE SÚBORU
filename = '95_TAM_30.mp4';

try
    [audio, fs] = audioread(filename);
catch
    error('Súbor %s nebol nájdený!', filename);
end

% Prevod na mono
if size(audio, 2) > 1
    audio = mean(audio, 2);
end

% Orezanie na presných 30 sekúnd (ak je nahrávka dlhšia)
target_dur = 30;
max_samples = min(length(audio), round(target_dur * fs));
sig = audio(1:max_samples);

% Odstránenie DC zložky (vycentrovanie signálu)
sig = sig - mean(sig);

fprintf('--- Analýza nahrávky (0 - 30s) ---\n');
fprintf('Súbor: %s\n', filename);
fprintf('Vzorkovacia frekvencia: %d Hz\n\n', fs);

%% 2. VÝPOČET METRÍK
% RMS - Hlučnosť / Energia
res.rms = rms(sig);

% Kurtosis - Kultivovanosť / Špičatosť (čím bližšie k 3, tým viac sa podobá šumu/stabilitie)
res.kurt = kurtosis(sig);

% Entropia - Miera chaosu v spaľovaní
try
    res.ent = pentropy(sig, fs);
catch
    % Náhradný výpočet spektrálnej entropie, ak nie je dostupný Toolbox
    psd = abs(fft(sig)).^2;
    psd = psd / sum(psd);
    res.ent = -sum(psd .* log2(psd + eps));
end

% Crest Factor - Pomer špičky k efektívnej hodnote (detekcia nárazov)
res.crest = max(abs(sig)) / res.rms;

%% 3. ZOBRAZENIE VÝSLEDKOV
fprintf('=====================================================\n');
fprintf('VÝSLEDNÉ METRIKY PRE 95 OKTÁNOVÉ PALIVO\n');
fprintf('=====================================================\n');
fprintf('%-25s | %-12s\n', 'Metrika', 'Hodnota');
fprintf('-----------------------------------------------------\n');
fprintf('%-25s | %12.4f\n', 'Kurtosis (Kultivovanosť)', res.kurt);
fprintf('%-25s | %12.4f\n', 'Entropia (Chaos)',      res.ent);
fprintf('%-25s | %12.4f\n', 'RMS (Hlučnosť/Energia)', res.rms);
fprintf('%-25s | %12.4f\n', 'Crest Factor (Rázy)',    res.crest);
fprintf('-----------------------------------------------------\n');

%% 4. VIZUALIZÁCIA (Voliteľné)
figure('Name','Analýza signálu','Color','w');

% Časový priebeh
subplot(2,1,1);
t = (0:length(sig)-1)/fs;
plot(t, sig, 'Color', [0 0.45 0.74]);
title('Časový priebeh signálu (30s)');
xlabel('Čas [s]'); ylabel('Amplitúda');
grid on;

% Výkonové spektrum
subplot(2,1,2);
periodogram(sig, rectwin(length(sig)), length(sig), fs);
title('Výkonové spektrálne hustoty (PSD)');
grid on;
