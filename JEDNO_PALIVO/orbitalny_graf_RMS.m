clear; clc; close all;

%% 1. NAČÍTANIE CELÉHO SÚBORU (0 - 30s)
file_name = '95_TAM_30.mp4'; 

try
    [audio, fs] = audioread(file_name);
catch
    error('Súbor %s nebol nájdený. Skontrolujte názov v priečinku.', file_name);
end

% Prevod na mono
if size(audio, 2) > 1
    audio = mean(audio, 2);
end

% Orezanie na 30 sekúnd
target_dur = 30;
max_samples = min(length(audio), round(target_dur * fs));
sig = audio(1:max_samples);

fprintf('Spracovávam %.2f sekúnd pri %d Hz.\n', length(sig)/fs, fs);

%% 2. ORBITÁLNA ANALÝZA (Oprava polarplot chyby)
figure('Name','Orbitálna diagnostika','Color','w','Position',[100 100 800 700]);

% Nastavenie dĺžky cyklu (prispôsobte podľa otáčok)
cycle_len = 1200; 
num_cycles = floor(length(sig) / cycle_len);
s_mat = reshape(sig(1:num_cycles * cycle_len), cycle_len, []);

% Uhlová os
theta = linspace(0, 2*pi, cycle_len);

% --- FIX: Explicitné vytvorenie polárnych osí ---
ax = polaraxes; 
hold(ax, 'on');

% Vykreslenie všetkých cyklov (priesvitné sivé)
p_all = polarplot(ax, theta, s_mat', 'Color', [0.1 0.1 0.1 0.02]); 

% Vykreslenie priemeru (hrubá modrá)
p_mean = polarplot(ax, theta, mean(s_mat, 2), 'b', 'LineWidth', 2);

% Nastavenia grafu cez objekt 'ax'
title(ax, {'Orbitálny graf: Celých 30 sekúnd', 'Palivo: 95 Oktán'}, 'FontSize', 12);
rlim(ax, [-0.15 0.15]); 
ax.ThetaZeroLocation = 'top';
ax.ThetaDir = 'clockwise';
grid(ax, 'on');

%% 3. DOPLNKOVÁ ANALÝZA: RMS STABILITA
figure('Name','Stabilita signálu','Color','w');
cycle_rms = rms(s_mat);
t_axis = linspace(0, 30, length(cycle_rms));

plot(t_axis, cycle_rms, 'Color', [0.85 0.33 0.1]);
hold on;
yline(mean(cycle_rms), 'k--', 'Priemerné RMS');

title('Stabilita energie počas 30 sekúnd');
xlabel('Čas [s]');
ylabel('RMS Amplitúda');
grid on;
