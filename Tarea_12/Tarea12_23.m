%%% Tarea 12: Medición de la distorsión en los amplificadores
clear; close all; clc;
%% Carga de datos, definición de constantes
% Datos del osciloscopio
data = load("SDS00002.CSV");
S.t = data(:,1); S.c1 = data(:,2); S.c2 = data(:,3);
% Datos del analizador DAT solo
data = load("SCRN0004.TXT");
DAT.f = data(:,1); DAT.A = data(:,2);
% Datos del analizador DAT + Ruido
data = load("SCRN0007.TXT");
DATpR.f = data(:,1); DATpR.A = data(:,2);
clear data;
%Constantes
Fs = 1/mean(diff(S.t)); Fs2 = 50000;
N = length(S.c1); NFFT = length(S.c1);
%% 1_ Canal distorsionado en funcion del tiempo
figure('Name','Señal Distorsionada');
plot(S.t,S.c1);xlim([min(S.t)/4 max(S.t)/4]);
title('Señal distorsionada');
%% 2_ FFT mediante ventana de Blackman Harris
M.w = blackmanharris(N);
M.x = S.c1 .* M.w;
M.X = fft(M.x,NFFT);
M.X = abs(M.X)*2/sum(M.w);
M.Xdb = 20*log10(M.X);
M.f = (0:NFFT-1)*Fs/NFFT;
%Gráfica para comparar la fft de matlab con la del analizador
figure('Name','Comparación fft Matlab vs analizador')
hold on;
semilogy(DAT.f,DAT.A,'DisplayName','Analizador de espectro');
semilogy(M.f,M.Xdb,'DisplayName','FFT BHM osciloscopio');
xlabel('f [Hz]'); ylabel('|H(e^{j\omega}| [dbrms])');
xlim([0 max(DAT.f)]); legend show; 
title('Comparación de FFT Calculada via Analizador vs Matlab');
%% 4_ Decimado de muestras
%Factor de decimado
D.FD = round(Fs/Fs2);
%Decimado por truncado manual
D.m.x = S.c1(1:D.FD:end);
%Decimado por funcion Decimate
D.d.x = decimate(S.c1,D.FD);
%Tomo N de la longitud de las señales 
%¿Puedo asumir que siempre son iguales?
D.N = length(D.m.x);
%Asumiendo misma longitud, la ventana es la misma
D.w = blackmanharris(D.N);
D.f = (0:(NFFT/D.FD)-1)*Fs2/(NFFT/D.FD);
%Calculamos la FFT, los dbrms y el vector de frecuencia
D.m.X = fft(D.m.x,NFFT/D.FD);   D.d.X = fft(D.d.x,NFFT/D.FD);
D.m.X = abs(D.m.X)*2/sum(D.w);  D.d.X = abs(D.d.X)*2/sum(D.w);
D.m.Xdb = 20*log10(D.m.X);      D.d.Xdb = 20*log10(D.d.X);
% Ploteamos en la misma figura que 2_
hold on;
semilogy(D.f,D.m.Xdb,'DisplayName','Decimado a mano');
semilogy(D.f,D.d.Xdb,'DisplayName','Decimado x funcion');
xlim([0 max(DAT.f)]); l2 = legend('show');
l2.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

%% 5_ Calculo de DAT
% Se preserva el espectro decimado con la función decimate
% Presto que es más pequeño que el del osciloscopio y es menos
% susceptible al aliasing, respecto del decimado a mano
Sp = D.d; Sp.Xdb = Sp.Xdb(1:(NFFT/D.FD)/2); Sp.f = D.f(1:(NFFT/D.FD)/2);
% Seleccionamos los picos con una prominencia de al menos 10db y mayores a -50 db
% Los criterios fuero seleccionados tal que se evaluen los picos prominente
% (a nuestra discrecion), sin perder los picos del gif del analizador de espectro
[Sp.pk.y Sp.pk.x] = findpeaks(Sp.Xdb,Sp.f,...
  'MinPeakHeight',-50,'MinPeakProminence',10);
[DAT.pk.y DAT.pk.x] = findpeaks(DAT.A,DAT.f,...
  'MinPeakHeight',-50,'MinPeakProminence',10);
figure('Name','picos');
hold on;
semilogy(DAT.f,DAT.A,'DisplayName','Analizador de espectro','Color','b');
semilogy(DAT.pk.x,DAT.pk.y,'v','Color','b','DisplayName','Picos Analizador');
semilogy(Sp.f,Sp.Xdb,'DisplayName','Espectro Calculado y decimado','Color','r');
semilogy(Sp.pk.x,Sp.pk.y,'v','Color','r','DisplayName','Picos Calculados');
hold off; xlabel('f [hz]'), ylabel('A [db Vpk]'); l5 = legend('show');
l5.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));
title('Espectros y sus picos')
% Calculo DAT
Sp.DAT = calc_DAT(Sp);
DAT.DAT = calc_DAT(DAT);
disp(sprintf('DAT (Espectro Calculado): %.3f%%',Sp.DAT));
disp(sprintf('DAT (Analizador): %.3f%%',DAT.DAT));
%% 6_ DAT+Ruido
%Sacamos los picos de DATpR, usamos el mismo criterio que en 4_
[DATpR.pk.y DATpR.pk.x] = findpeaks(DATpR.A,DATpR.f,...
  'MinPeakHeight',-50,'MinPeakProminence',10);
%Definimos el rango respecto de la fundamental (pm125Hz)
rango = 125;
%Calculamos DATpR
Sp.DATpR = calc_DATpR(Sp,rango);
DATpR.DATpR = calc_DATpR(DATpR,rango);
disp(sprintf('DAT + Ruido (Espectro Calculado): %.3f%%',Sp.DATpR));
disp(sprintf('DAT + Ruido (Analizador): %.3f%%',DATpR.DATpR));
%% Funciones auxiliares
function out = iff(cond, a, b)
    if cond, out = a; else, out = b; end
end

function DAT_val = calc_DAT(S)
% calc_DAT  Calcula la Distorsión Armónica Total (DAT%)
% Entrada:
%   S.pk.x  -> frecuencias de los picos
%   S.pk.y  -> amplitudes en dBpk
%
% Salida:
%   DAT_val -> DAT% (valor escalar)
    % Convertimos picos dBpk → Vpk
    v = 10.^(S.pk.y/20);
    % Fundamental = primer pico
    v1 = v(1);
    % Armónicos = a partir de k = 2
    vH = v(2:end);
    % Fórmula DAT
    DAT_val = 100*sqrt(sum(vH.^2)/(v1^2));
end


function DATpr_val = calc_DATpR(S, rango)
% calc_DATpR  Calcula la métrica DAT + Ruido (%)
% Entrada:
%   S.pk.x  -> frecuencias de los picos
%   S.pk.y  -> amplitudes en dBpk
%   rango   -> exclusión alrededor de la fundamental (en Hz), ej: 125
%
% Salida:
%   DATpr_val -> porcentaje DAT+Ruido
    % Convertimos picos dBpk → Vpk
    v = 10.^(S.pk.y/20);
    % Fundamental = primer pico
    f1 = S.pk.x(1);
    % Banda a excluir
    fs = f1 - rango;
    fe = f1 + rango;
    % Índices dentro y fuera de la banda
    idx_in  = find(S.pk.x >= fs & S.pk.x <= fe);
    idx_out = setdiff(1:numel(v), idx_in);
    % Energías
    Etot = sum(v.^2);
    Eout = sum(v(idx_out).^2);
    % Fórmula DAT + Ruido
    DATpr_val = 100*sqrt(Eout/Etot);
end
