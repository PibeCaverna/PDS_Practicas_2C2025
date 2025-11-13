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
%Aca escalamos los espectros. Según Nacho y GPT con 2/N alcanza pa
%Todo, en 5.B del apunte habla de lobulos pero no lo entendí
X100scl = {};
for k = 1:length(X100)
  X100scl{k} = abs(X100{k})*2/N;
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
  X1000scl{k} = abs(X1000{k})*2/N;
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
           [0.503662 2.04429  1.08036 0.132646],...
           [0.202693 0.963254 1.29693 2.26018]};
hatabla = {'Hamming',...
           [0.0606319 1.08201  0.544943 0.0470894],...
           [0.509958  0.963254 1.29693  2.25389]};
vhtabla = {'Von Hann',...
           [0.0496613 0.998329 0.498469 0.0399608],...
           [0.522549  0.963254 1.29693  2.24759],};
bltabla = {'Blackman',...
           [0.0419 0.8391 0.4195 0.0043 0.0336],...
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