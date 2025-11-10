%%% Script para generar graficos superpuestos
%%% Primero hay que correr Filtros.m (carga PasaBanda, EliminaBanda, Fs)
Filtros

% Archivos de medición
files = {{'TXT/mod_elimina_banda.TXT' 'TXT/fase_elimina_banda.TXT'}, ...
         {'TXT/mod_elimina_banda_zoom.TXT' 'TXT/fase_elimina_banda_zoom.TXT'}, ...
         {'TXT/mod_pasa_banda_.TXT' 'TXT/fase_pasa_banda_.TXT'}, ...
         {'TXT/mod_pasa_banda_zoom.TXT' 'TXT/fase_pasa_banda_zoom.TXT'}, ...
         {'TXT/mod_pasbanda_ultimo.TXT' 'TXT/fase_pasbanda_ultmio.TXT'}};

% Carga datos experimentales
fileam = numel(files);
expdata = cell(1,fileam);
for i = 1:fileam
    expdata{i} = {load(files{i}{1}) load(files{i}{2})};
end

% Retardo del DSP (en muestras)
ret = 48;

% =============================
% Cuantización Q15 estilo fir2ti5515
% =============================
scale = 32767;
PB_q = floor(PasaBanda * scale);
EB_q = floor(EliminaBanda * scale);

% Volvemos a float para análisis de freqz
PasaBandaQ   = PB_q / scale;
EliminaBandaQ = EB_q / scale;


%% =============================
%   FILTRO ELIMINA-BANDA
% =============================
[hbr, fbr] = freqz(EliminaBandaQ, 1, 100000, Fs);

% Corrección del retardo → solo fase
wbr = 2*pi*fbr/Fs;
hbr = hbr .* exp(-1j * wbr * ret);

figure('Name','Eliminabanda');
subplot(2,1,1); grid on; hold on; title('Modulo');
plot(fbr,20*log10(abs(hbr)));
plot(expdata{1}{1}(:,1),expdata{1}{1}(:,2));
ylabel('|H(f)| [dB]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;

subplot(2,1,2); grid on; hold on; title('Fase');
plot(fbr, unwrap(angle(hbr))*180/pi);
plot(expdata{1}{2}(:,1),expdata{1}{2}(:,2));
ylabel('\angleH(f) [°]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;


figure('Name','Eliminabanda (zoom)');
subplot(2,1,1); grid on; hold on; title('Modulo');
plot(fbr,20*log10(abs(hbr)));
plot(expdata{2}{1}(:,1),expdata{2}{1}(:,2));
xlim([min(expdata{2}{1}(:,1)) max(expdata{2}{1}(:,1))]);
ylabel('|H(f)| [dB]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;

subplot(2,1,2); grid on; hold on; title('Fase');
plot(fbr, unwrap(angle(hbr))*180/pi);
plot(expdata{2}{2}(:,1),expdata{2}{2}(:,2));
xlim([min(expdata{2}{2}(:,1)) max(expdata{2}{2}(:,1))]);
ylabel('\angleH(f) [°]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;


%% =============================
%   FILTRO PASA-BANDA
% =============================
[hbp, fbp] = freqz(PasaBandaQ, 1, 100000, Fs);

% Corrección del retardo
wbp = 2*pi*fbp/Fs;
hbp = hbp .* exp(-1j * wbp * ret);

figure('Name','Pasabanda');
subplot(2,1,1); grid on; hold on; title('Modulo');
plot(fbp,20*log10(abs(hbp)));
plot(expdata{3}{1}(:,1),expdata{3}{1}(:,2));
ylabel('|H(f)| [dB]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;

subplot(2,1,2); grid on; hold on; title('Fase');
plot(fbp, unwrap(angle(hbp))*180/pi);
plot(expdata{3}{2}(:,1),expdata{3}{2}(:,2));
ylabel('\angleH(f) [°]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;


figure('Name','Pasabanda (zoom)');
subplot(2,1,1); grid on; hold on; title('Modulo');
plot(fbp,20*log10(abs(hbp)));
plot(expdata{4}{1}(:,1),expdata{4}{1}(:,2));
xlim([min(expdata{4}{1}(:,1)) max(expdata{4}{1}(:,1))]);
ylabel('|H(f)| [dB]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;

subplot(2,1,2); grid on; hold on; title('Fase');
plot(fbp, unwrap(angle(hbp))*180/pi);
plot(expdata{4}{2}(:,1),expdata{4}{2}(:,2));
xlim([min(expdata{4}{2}(:,1)) max(expdata{4}{2}(:,1))]);
ylabel('\angleH(f) [°]'); xlabel('f [Hz]');
legend('Teorico','Experimental'); hold off;


%% =============================
% ANALOGICO vs DIGITAL (medidos)
% =============================
figure('Name','Analogico vs Digital');
subplot(2,1,1); grid on; hold on; title('Modulo');
plot(expdata{3}{1}(:,1),expdata{3}{1}(:,2));
plot(expdata{5}{1}(:,1),expdata{5}{1}(:,2));
ylabel('|H(f)| [dB]'); xlabel('f [Hz]');
legend('Digital','Analogico'); hold off;

subplot(2,1,2); grid on; hold on; title('Fase');
plot(expdata{3}{2}(:,1),expdata{3}{2}(:,2));
plot(expdata{5}{2}(:,1),expdata{5}{2}(:,2));
ylabel('\angleH(f) [°]'); xlabel('f [Hz]');
legend('Digital','Analogico'); hold off;
