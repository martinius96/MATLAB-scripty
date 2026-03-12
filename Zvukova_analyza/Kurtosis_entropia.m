clear;
clc;
close all;

% 1. Načítanie súboru
filename = 'TAM_Paliva_3x3.mp4';

try
    [audio, fs] = audioread(filename);
catch
    error('Súbor %s nebol nájdený!', filename);
end

% Ak je stereo, prevedieme na mono
if size(audio, 2) > 1
    audio = mean(audio, 2);
end

% 2. Definícia segmentov (3 videá na palivo)
segments101 = [
    0,   3.2;
    3.3, 5.9;
    6.0, 9.2
];

segments95 = [
    9.3, 12.5;
    12.6, 16.6;
    16.7, 20.1
];

% 3. Výpočet metrík
res101 = analyze_fuel(audio, fs, segments101, '101 Oktán');
res95  = analyze_fuel(audio, fs, segments95,  '95 Oktán');

% 4. Zobrazenie výsledkov
display_results(res101, res95);


% =====================================================
% FUNKCIA NA ANALÝZU PALIVA
% =====================================================
function s = analyze_fuel(audio, fs, segs, label)

fprintf('--- Analýza: %s ---\n', label);

for i = 1:size(segs,1)

    startIdx = round(segs(i,1) * fs) + 1;
    endIdx   = min(round(segs(i,2) * fs), length(audio));

    sig = audio(startIdx:endIdx);

    % Odstránenie DC zložky
    sig = sig - mean(sig);

    % Výpočet metrík
    s.rms(i)  = rms(sig);
    s.kurt(i) = kurtosis(sig);

    % Entropia
    try
        s.ent(i) = pentropy(sig, fs);
    catch
        % Náhradná spektrálna entropia
        psd = abs(fft(sig)).^2;
        psd = psd / sum(psd);
        s.ent(i) = -sum(psd .* log2(psd + eps));
    end

    fprintf('Video %d: RMS=%.4f | Kurtosis=%.3f | Entropia=%.3f\n', ...
        i, s.rms(i), s.kurt(i), s.ent(i));

end

% Priemery
s.avg_rms  = mean(s.rms);
s.avg_kurt = mean(s.kurt);
s.avg_ent  = mean(s.ent);

fprintf(' >> PRIEMER: RMS=%.4f | Kurtosis=%.3f | Entropia=%.3f\n\n', ...
    s.avg_rms, s.avg_kurt, s.avg_ent);

end


% =====================================================
% FUNKCIA NA ZOBRAZENIE VÝSLEDKOV
% =====================================================
function display_results(r101, r95)

fprintf('\n=====================================================\n');
fprintf('ZÁVEREČNÉ POROVNANIE (Priemerné hodnoty)\n');
fprintf('=====================================================\n');

fprintf('%-20s | %-12s | %-12s\n', 'Metrika', '101 Oct', '95 Oct');
fprintf('-----------------------------------------------------\n');

fprintf('%-20s | %12.4f | %12.4f\n', ...
    'Kurtosis (Kultiv.)', r101.avg_kurt, r95.avg_kurt);

fprintf('%-20s | %12.4f | %12.4f\n', ...
    'Entropia (Chaos)', r101.avg_ent, r95.avg_ent);

fprintf('%-20s | %12.4f | %12.4f\n', ...
    'RMS (Hlučnosť)', r101.avg_rms, r95.avg_rms);

fprintf('-----------------------------------------------------\n');

% Logika určenia víťaza
if r101.avg_kurt < r95.avg_kurt && r101.avg_ent < r95.avg_ent

    fprintf('ZÁVER: Motor beží kultivovanejšie na 101 OKTÁNOVÉ palivo.\n');

elseif r95.avg_kurt < r101.avg_kurt && r95.avg_ent < r101.avg_ent

    fprintf('ZÁVER: Motor beží kultivovanejšie na 95 OKTÁNOVÉ palivo.\n');

else

    fprintf('ZÁVER: Výsledky sú zmiešané, pozrite sa na jednotlivé videá.\n');

end

end
