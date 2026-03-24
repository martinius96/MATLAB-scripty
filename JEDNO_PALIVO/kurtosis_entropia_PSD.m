clear; clc; close all;

%% 1. NAČÍTANIE A DEFINÍCIA INTERVALU
filename = 'LPG_OMV.mp4';
start_time = 1; % Začiatok analýzy (sekunda)
end_time = 29;  % Koniec analýzy (sekunda)

try
    [audio, fs] = audioread(filename);
catch
    error('Súbor %s nebol nájdený!', filename);
end

% Prevod na mono
if size(audio, 2) > 1
    audio = mean(audio, 2);
end

%% 2. OREZANIE SIGNÁLU (1. až 29. sekunda)
% Výpočet indexov: (čas * frekvencia)
% Pridávame 1, pretože Matlab indexuje od 1, nie od 0
idx_start = round(start_time * fs) + 1;
idx_end = round(end_time * fs);

% Kontrola, či nahrávka nie je kratšia ako požadovaný koniec
if idx_end > length(audio)
    idx_end = length(audio);
    actual_end_time = length(audio) / fs;
    warning('Nahrávka je kratšia. Končím na čase %.2f s', actual_end_time);
else
    actual_end_time = end_time;
end

% Samotné orezanie
sig = audio(idx_start:idx_end);

% Odstránenie DC zložky (vycentrovanie okolo nuly)
sig = sig - mean(sig);

fprintf('--- Analýza úseku: %d s až %.2f s ---\n', start_time, actual_end_time);
fprintf('Súbor: %s | Vzorkovacia frekvencia: %d Hz\n\n', filename, fs);

%% 3. VÝPOČET METRÍK
res.rms = rms(sig);
res.kurt = kurtosis(sig);

try
    res.ent = pentropy(sig, fs);
catch
    psd = abs(fft(sig)).^2;
    psd = psd / sum(psd);
    res.ent = -sum(psd .* log2(psd + eps));
end

res.crest = max(abs(sig)) / res.rms;

%% 4. VÝPIS DO KONZOLY
fprintf('=====================================================\n');
fprintf('VÝSLEDNÉ METRIKY (INTERVAL: %d - %d s)\n', start_time, end_time);
fprintf('=====================================================\n');
fprintf('%-25s | %12.4f\n', 'Kurtosis (Kultivovanosť)', res.kurt);
fprintf('%-25s | %12.4f\n', 'Entropia (Chaos)',      res.ent);
fprintf('%-25s | %12.4f\n', 'RMS (Hlučnosť/Energia)', res.rms);
fprintf('%-25s | %12.4f\n', 'Crest Factor (Rázy)',    res.crest);
fprintf('-----------------------------------------------------\n');

%% 5. VIZUALIZÁCIA
figure('Name', sprintf('Analýza úseku %d-%ds', start_time, end_time), 'Color', 'w');

% Časový priebeh
subplot(2,1,1);
% Vytvorenie časovej osi, ktorá začína na start_time a končí na actual_end_time
t = linspace(start_time, actual_end_time, length(sig));

plot(t, sig, 'Color', [0 0.45 0.74]);
title(['Časový priebeh signálu: ', num2str(start_time), 's až ', num2str(end_time), 's']);
xlabel('Čas [s]'); 
ylabel('Amplitúda');
xlim([start_time end_time]); % Zabezpečí, že graf ukáže len daný rozsah
grid on;

% Výkonové spektrum (PSD)
subplot(2,1,2);
periodogram(sig, rectwin(length(sig)), length(sig), fs);
title('Výkonové spektrálne hustoty (PSD) orezaného úseku');
grid on;
