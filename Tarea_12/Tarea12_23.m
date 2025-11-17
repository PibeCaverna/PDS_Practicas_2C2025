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
Fs = 1/mean(diff(S.t));
%% 1_ Canal distorsionado en funcion del tiempo
figure('Name','Señal Distorsionada');
plot(S.t,S.c1);xlim([min(S.t)/4 max(S.t)/4]);
title('Señal distorsionada');
%% 2_ FFT mediante ventana de Blackman Harris
N = 200;
NFFT = length(DAT.f);
M.w = blackmanharris(N);
M.x = S.c1(1:N) .* M.w';
M.X = fft(M.x,NFFT);
M.X = M.X(1:NFFT)*2/sum(M.w);
M.Xdbrms = 20*log10(2*M.X/sqrt(2));
M.f = linspace(0,Fs/2,NFFT);
%Gráfica para comparar la fft de matlab con la del analizador
figure('Name','Comparación fft Matlab vs analizador')
hold on;
semilogy(DAT.f,DAT.A,'DisplayName','Analizador de señales');
semilogy(M.f,abs(M.Xdbrms),'DisplayName','FFT BHM osciloscopio');
xlabel('f [Hz]'); ylabel('|H(e^{j\omega}| [dbrms])'); legend on;
title('Comparación de FFT Calculada via Analizador vs Matlab');