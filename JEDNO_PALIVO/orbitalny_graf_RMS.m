clear; clc; close all;

%% 1. NAČÍTANIE A OREZANIE (1 - 29s)
file_name = 'LPG_OMV.mp4'; 
start_time = 1; % Začiatok v sekundách
end_time = 29;  % Koniec v sekundách

try
    [audio, fs] = audioread(file_name);
catch
    error('Súbor %s nebol nájdený. Skontrolujte názov v priečinku.', file_name);
end

% Prevod na mono
if size(audio, 2) > 1
    audio = mean(audio, 2);
end

% --- ÚPRAVA: Výpočet indexov pre 1. až 29. sekundu ---
idx_start = round(start_time * fs) + 1;
idx_end = min(length(audio), round(end_time * fs));

% Extrakcia signálu
sig = audio(idx_start:idx_end);
dur_actual = length(sig) / fs;

fprintf('Spracovávam úsek: %d s až %d s (Trvanie: %.2f s) pri %d Hz.\n', ...
        start_time, end_time, dur_actual, fs);

%% 2. ORBITÁLNA ANALÝZA (Interval 1 - 29s)
figure('Name','Orbitálna diagnostika (1-29s)','Color','w','Position',[100 100 800 700]);

% Nastavenie dĺžky cyklu (prispôsobte podľa otáčok motora)
cycle_len = 1200; 
num_cycles = floor(length(sig) / cycle_len);

% Reshape len pre orezaný signál
s_mat = reshape(sig(1:num_cycles * cycle_len), cycle_len, []);

% Uhlová os (0 až 360 stupňov v radiánoch)
theta = linspace(0, 2*pi, cycle_len);

% FIX: Explicitné vytvorenie polárnych osí
ax = polaraxes; 
hold(ax, 'on');

% Vykreslenie všetkých cyklov (priesvitné sivé)
polarplot(ax, theta, s_mat', 'Color', [0.1 0.1 0.1 0.02]); 

% Vykreslenie priemeru (hrubá modrá)
polarplot(ax, theta, mean(s_mat, 2), 'b', 'LineWidth', 2);

% Nastavenia grafu (Dynamické popisy pre 1-29s)
title(ax, {sprintf('Orbitálny graf: %d - %d sekunda', start_time, end_time), ...
           'Palivo: LPG'}, 'FontSize', 12);
       
rlim(ax, [min(sig)*1.1 max(sig)*1.1]); % Automatické prispôsobenie limitov podľa signálu
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
grid(ax, 'on');

%% 3. DOPLNKOVÁ ANALÝZA: RMS STABILITA (Interval 1 - 29s)
figure('Name','Stabilita signálu (1-29s)','Color','w');

cycle_rms = rms(s_mat);
% Časová os začína od start_time a končí v end_time
t_axis = linspace(start_time, end_time, length(cycle_rms));

plot(t_axis, cycle_rms, 'Color', [0.85 0.33 0.1], 'LineWidth', 1.5);
hold on;
yline(mean(cycle_rms), 'k--', sprintf('Priemerné RMS: %.4f', mean(cycle_rms)));

title(sprintf('Stabilita energie (Interval %d - %d s)', start_time, end_time));
xlabel('Čas [s]');
ylabel('RMS Amplitúda');
xlim([start_time end_time]); % Zabezpečí, že os X začína na 1 a končí na 29
grid on;
