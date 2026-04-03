clear; clc; close all;

%% 1. DEFINÍCIA SÚBOROV A INTERVALU
% Zoradené súbory presne v poradí: 95, 100, LPG
files = {'95_TAM.mp4', '100_OMV.mp4', 'LPG_OMV.mp4'};
labels = {'95 oktan', '100 oktan', 'LPG'};

% Úprava času na 6. až 20. sekundu
start_time = 6; 
end_time = 20;  
cycle_len = 500; 

% Zväčšená výška okna pre text pod grafmi
figure('Name', 'Orbitálna diagnostika motora s metrikami', 'Color', 'w', 'Position', [50, 100, 1400, 650]);

for k = 1:length(files)
    try
        %% 2. NAČÍTANIE A PRÍPRAVA DÁT
        [audio, fs] = audioread(files{k});
        
        if size(audio, 2) > 1
            audio = mean(audio, 2); 
        end
        
        idx_start = round(start_time * fs) + 1;
        idx_end = round(end_time * fs);
        
        if idx_end > length(audio)
            idx_end = length(audio);
        end
        
        s = audio(idx_start:idx_end);
        s = s - mean(s); 
        
        % Nafúknutie amplitúdy pre lepšiu viditeľnosť detailov
        s = 0.35 * (s / max(abs(s)));
        
        %% 3. ORBITÁLNA ANALÝZA
        num_cycles = floor(length(s) / cycle_len);
        s_mat = reshape(s(1:num_cycles * cycle_len), cycle_len, []);
        
        r_mat = s_mat + 0.5;
        
        % Vlastné umiestnenie subplotu (posunuté vyššie)
        pos = [0.05 + (k-1)*0.32, 0.35, 0.26, 0.55]; 
        subplot('Position', pos);
        
        theta = linspace(0, 2*pi, cycle_len);
        
        %% 4. VYKRESLENIE
        % Jemné dymové čiary
        polarplot(theta, r_mat', 'Color', [0.2 0.2 0.2, 0.04]); 
        hold on;
        
        % Priemerná stopa
        mean_r = mean(r_mat, 2);
        polarplot(theta, mean_r, 'r', 'LineWidth', 1.5);
        
        title(['Orbitálny graf: ' labels{k}], 'FontSize', 12, 'FontWeight', 'bold');
        
        % Nastavenie limitov, aby grafy maximálne vyplnili priestor
        rlim([0 0.85]); 
        set(gca, 'ThetaZeroLocation', 'top');
        
        %% 5. VÝPOČET METRÍK
        avg_radius = mean(mean_r);                % Priemerný polomer
        r_std = std(mean_r);                       % Odchýlka polomeru
        
        diffs = r_mat - mean_r;
        jitter = mean(std(diffs));                 % Rozptyl cyklov
        
        % Index kruhovitosti (Circularity)
        x = mean_r .* cos(theta)';
        y = mean_r .* sin(theta)';
        poly_area = polyarea(x, y);
        poly_perimeter = sum(sqrt(diff(x).^2 + diff(y).^2)) + sqrt((x(end)-x(1))^2 + (y(end)-y(1))^2);
        circularity = (4 * pi * poly_area) / (poly_perimeter^2);
        
        %% 6. VLOŽENIE TEXTU POD GRAF
        str = {
            sprintf('Priem. polomer: %.4f', avg_radius), ...
            sprintf('Odch. polomeru: %.5f', r_std), ...
            sprintf('Rozptyl cyklov: %.4f', jitter), ...
            sprintf('Index kruhu: %.4f', circularity)
        };
        
        % Pomocné kartézske osi umiestnené pod polárny graf
        text_pos = [pos(1), 0.05, pos(3), 0.2]; 
        ax2 = axes('Position', text_pos, 'Visible', 'off');
        
        % Vykreslenie textu vycentrovaného pod grafom
        text(ax2, 0.5, 0.5, str, 'FontSize', 10, 'FontName', 'FixedWidth', ...
            'VerticalAlignment', 'middle', 'HorizontalAlignment', 'center', ...
            'BackgroundColor', 'w', 'EdgeColor', [0.7 0.7 0.7], 'Margin', 8);
        
        fprintf('Spracované: %s\n', labels{k});
        
    catch ME
        fprintf('Chyba pri spracovaní súboru %s: %s\n', files{k}, ME.message);
    end
end
