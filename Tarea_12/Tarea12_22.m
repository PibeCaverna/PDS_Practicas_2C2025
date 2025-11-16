%%% Tarea 12: Análisis espectral de señales discretas
clear; close all; clc;
%% Carga de datos, Defino constantes
%cantidad de muestras
N = 100;
%señal x, carga la variable de una
load("senal0010_0100.mat");
%eje de frecuencia
w = linspace(0,pi,N/2);
tickw = {[0 pi/4 pi/2 3*pi/4 pi],...
        {"0", "\pi/4", "\pi/2", "3\pi/4", "\pi"}};
%% 1_ fft de  la señal
X = fft(x,N);
%_________________________________________
figure('Name','Espectro fft');          %|
plot(w,abs(X(1:N/2)));                  %|
grid on;  xlim([0 pi]);                 %|
xlabel('\omega');                       %|
xticks(tickw{1});                       %|
xticklabels(tickw{2});                  %|
ylabel('|X(e^{j\omega})|');             %|
%-----------------------------------------
%% 2_ Módulo del espectro mediante ventanas
%Numero de la FFT
NFFT = N;
%Definimos las ventanas
ventanas = {};
ventanas{1} = {rectwin(N),             'Rectangular'};
ventanas{2} = {hamming(N,'periodic'),  'Hamming'    };
ventanas{3} = {hanning(N,'periodic'),  'Von Hann'   };
ventanas{4} = {blackman(N,'periodic'), 'Blackman'   };
%Las ploteamos________________________________________
figure('Name', 'Ventanas');                         %|
for k = 1:length(ventanas)                          %|
  subplot(2,2,k);                                   %|
  plot(ventanas{k}{1});                             %|
  grid on;                                          %|
  xlabel('n');                                      %|
  ylabel('w[n]');                                   %|
  title(ventanas{k}{2});                            %|
  ylim([0 1.05]);                                   %|
end                                                 %|
%-----------------------------------------------------

%Aproximamos el espectro ventaneado
x100 = {};
X100 = {};
for k = 1:length(ventanas)
  x100{k} = x.*ventanas{k}{1}'; 
  X100{k} = fft(x100{k},NFFT);
end
%ploteamos las aproximaciones_________________________________________
figure('Name', 'espectros ventaneados N =100, NFFT = N');           %|
hold on;                                                            %|
title('espectros ventaneados N =100, NFFT = N');                    %|
for k = 1:length(X100)                                              %|
  plot(w,abs(X100{k}(1:NFFT/2)),'DisplayName',ventanas{k}{2});      %|
end                                                                 %|
hold off; grid on; xticks(tickw{1}); xticklabels(tickw{2});         %|
xlabel('\omega'); ylabel('|X(e^{j\omega})|');                       %|
legend('show')                                                      %|
%---------------------------------------------------------------------

%% 3_ Espectros escalados 
% Tengo que multiplicar por 2 y dividir por el area de la ventana (H(2w=0))
X100scl = {};
for k = 1:length(X100)
  X100scl{k} = abs(X100{k})*2/sum(ventanas{k}{1});
end
%ploteamos las aproximaciones_____________________________________________
figure('Name', 'espectros ventaneados y escalados N = 100, NFFT = N');  %|
title('espectros ventaneados y escalados N = 100, NFFT = N');           %|
for k = 1:length(X100scl)                                               %|
  subplot(2,2,k);                                                       %|
  semilogy(w,X100scl{k}(1:N/2)); title(ventanas{k}{2});                 %|
  xlabel('\omega');  ylabel('|X(e^{j\omega})|');                        %|
  xticks(tickw{1}); xticklabels(tickw{2});                              %|
end                                                                     %|
%-------------------------------------------------------------------------

%% 4_ Inciso 2 con NFFT = 1000
NFFT = 1000;
%Aproximamos el espectro ventaneado
w1k = linspace(0,pi,NFFT/2);
x1000 = {};
X1000 = {};
for k = 1:length(ventanas)
  x1000{k} = x.*ventanas{k}{1}'; 
  X1000{k} = fft(x100{k},NFFT);
end
%ploteamos las aproximaciones_________________________________________
figure('Name', 'espectros ventaneados N =100, NFFT = 1000');        %|
hold on;                                                            %|
title('espectros ventaneados N =100, NFFT = 1000');                 %|
for k = 1:length(X1000)                                             %|
  plot(w1k,abs(X1000{k}(1:NFFT/2)),'DisplayName',ventanas{k}{2});   %|
end                                                                 %|
hold off; grid on; xticks(tickw{1}); xticklabels(tickw{2});         %|
xlabel('\omega'); ylabel('|X(e^{j\omega})|');                       %|
legend('show')                                                      %|
%---------------------------------------------------------------------
%Escalamos
X1000scl = {};
for k = 1:length(X1000)
  X1000scl{k} = abs(X1000{k})*2/sum(ventanas{k}{1});
end
%ploteamos las aproximaciones______________________________________________
figure('Name', 'espectros ventaneados y escalados N = 100, NFFT = 1000');%|
title('espectros ventaneados y escalados N = 100, NFFT = 1000');         %|
for k = 1:length(X1000scl)                                               %|
  subplot(2,2,k);                                                        %|
  semilogy(w1k,X1000scl{k}(1:NFFT/2)); title(ventanas{k}{2});            %|
  xlabel('\omega');  ylabel('|X(e^{j\omega})|');                         %|
  xticks(tickw{1}); xticklabels(tickw{2});                               %|
end                                                                      %|
%--------------------------------------------------------------------------

%% 5_ Tabla con frecuencias normalizadas
% Elijo todos los picos locales, pero hay algunos que son muy tenues
% Los agarre a mano, puede que esten un toq mal
rctabla = {'Rectangular',...
           [0.202693 2.04429  1.08036 0.132646],...
           [0.202693 0.963254 1.29693 2.26018]};
hatabla = {'Hamming',...
           [0.1123 2.0037 1.0092 0.0872],...
           [0.5100 0.9633 1.2967 2.2539]};
vhtabla = {'Von Hann',...
           [0.0993 1.9967 0.9969 0.0108 0.0799],...
           [0.5225 0.9633 1.2969 1.7125 2.2476]};
bltabla = {'Blackman',...
           [0.0997 1.9980 0.9987 0.0103 0.0800],...
           [0.5163 0.9633 1.2969 1.7125 2.2476]};
% Construcción de tablas individuales
T_rect = table(rctabla{2}(:), rctabla{3}(:)/pi, ...
    'VariableNames', {'Amplitud', 'f_norm_(×π)'});
T_ham = table(hatabla{2}(:), hatabla{3}(:)/pi, ...
    'VariableNames', {'Amplitud', 'f_norm_(×π)'});
T_hann = table(vhtabla{2}(:), vhtabla{3}(:)/pi, ...
    'VariableNames', {'Amplitud', 'f_norm_(×π)'});
T_blk = table(bltabla{2}(:), bltabla{3}(:)/pi, ...
    'VariableNames', {'Amplitud', 'f_norm_(×π)'});
% Mostrar tablas en consola
disp('==== Ventana Rectangular ===='), disp(T_rect)
disp('==== Ventana Hamming ===='),    disp(T_ham)
disp('==== Ventana Von Hann ===='),   disp(T_hann)
disp('==== Ventana Blackman ===='),   disp(T_blk)

%% 7_ Reconstruccion y sintesis mediante ventana de hamming
%Limpiamos todo y nos quedamos solo con la ventana de hamming
clear; close all; clc; N = 100; NFFT = 1000;
load("senal0010_0100.mat");
w = linspace(0,pi,NFFT/2);
tickw = {[0 pi/4 pi/2 3*pi/4 pi],...
        {"0", "\pi/4", "\pi/2", "3\pi/4", "\pi"}};
%Struct con la data relevante de los incisos anteriores
M.w = hamming(N,'periodic');
M.x = x.*M.w';
M.X = fft(M.x,NFFT)*2/sum(M.w);
%plot para buscar el "k" de cada pico
figure('Name','Espectro mediante ventana de Hamming N = 100, NFFT = 1000');
semilogy(abs(M.X(1:NFFT/2)),'Color','r'); xlabel('k+1'); ylabel('|X(k)|');
%establezco los valores de k+1 de los picos y su amplitud
M.peak.Kp1 = [082 154 207 359]; M.peak.A = abs(M.X(M.peak.Kp1));
M.peak.w = M.peak.Kp1*2*pi/NFFT; M.peak.p = angle(M.X(M.peak.Kp1));
%Agrego picos al plot
hold on; plot(M.peak.Kp1,M.peak.A,'.','MarkerSize',15,"Color","b");
xline(M.peak.Kp1,"--"); hold off;
title('Espectro mediante ventana de Hamming N = 100, NFFT = 1000');
%Reconstrucción
n = (0:N-1); xe = sum(M.peak.A .* cos(M.peak.w .* n.' + M.peak.p),2);
figure('Name','Comparación señal de entrada vs reconstruida');
subplot(2,1,1); hold on; plot(n,x,'--');plot(n,xe);
legend('original','reconstruida');
title('Señal original vs reconstruida, N = 100, NFFT = 1000');hold off;
%Calculos de error
deltaxmax = max(x-xe); EMC = norm(x(:) - xe(:)) / norm(x(:)) * 100;
subplot(2,1,2); plot(n,deltaxmax,'Color','r');
title(sprintf("x[n]-xe[n] (N = 100, NFFT = 1000), EMC = %.4f",EMC));