% QUANTUM ENGINE STABILITY ANALYZER v10.0
% Nelineárna analýza fázových trajektórií

clear; clc;
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'Benzín TAM 95', 'Benzín OMV 100', 'LPG OMV'};
res = struct();

fprintf('--- SPUŠŤAM ANALÝZU FÁZOVÝCH TRAJEKTÓRIÍ ---\n\n');

for i = 1:length(files)
    try
        [y, fs] = audioread(files{i});
        if size(y, 2) > 1, y = mean(y, 2); end
        y = y(fs : 3*fs); % Stačia 2 sekundy pre hĺbkovú analýzu
        y = (y - mean(y)) / std(y);
        N = length(y);

        % --- 1. RECURRENCE RATE (RR) ---
        % Použijeme zjednodušenú metódu najbližších susedov
        delay = 15; % Fázový posun
        y_orig = y(1:end-delay);
        y_shifted = y(delay+1:end);
        
        % Vzdialenosť v 2D fázovom priestore
        dist = sqrt((y_orig(1:end-1) - y_orig(2:end)).^2 + ...
                    (y_shifted(1:end-1) - y_shifted(2:end)).^2);
        
        % Miera stability (nižšia variabilita vzdialenosti = vyššia RR)
        res(i).stability = 1 / (std(dist) + eps);

        % --- 2. DETERMINISMUS (DET) ---
        % Pomer usporiadaných zmien voči náhodným
        diffs = diff(y);
        res(i).det = sum(abs(diffs) < median(abs(diffs))) / length(diffs);

        % --- 3. DIVERGENCIA (Lyapunov odhad) ---
        % Ako rýchlo sa rozbiehajú blízke stavy
        d0 = abs(y(1:100) - y(2:101));
        d1 = abs(y(101:200) - y(102:201));
        res(i).divergence = mean(log(d1 ./ (d0 + eps)));

        fprintf('Spracované: %s\n', labels{i});
    catch ME
        fprintf('Chyba: %s\n', ME.message);
    end
end

% --- TABUĽKA VÝSLEDKOV ---
fprintf('\n%-15s | %-12s | %-12s | %-12s\n', 'Palivo', 'Stabilita RR', 'Determinizm', 'Divergencia');
fprintf('----------------------------------------------------------------------\n');
for i = 1:length(res)
    fprintf('%-15s | %-12.4f | %-12.4f | %-12.4f\n', ...
        labels{i}, res(i).stability, res(i).det, res(i).divergence);
end

fprintf('\nKedy je motor "V TOPU"?\n');
fprintf('1. Stabilita RR: Vyššie číslo = motor sa v cykloch vracia do rovnakého bodu.\n');
fprintf('2. Determinizm: Vyššie číslo (blízko 1) = motor je stroj, nie náhodný generátor hluku.\n');
fprintf('3. Divergencia: NIŽŠIE číslo = motor je predvídateľný a mechanicky "tuhý".\n');
