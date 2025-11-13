%%% Tarea 12: Análisis espectral de señales discretas
clear;
close all;
clc;
%% Carga de datos, Defino constantes
%cantidad de muestras
N = 100;
%señal x, carga la variable de una
load("senal0010_0100.mat");
%% 1_ fft de  la señal
X = fft(x,N);
%_________________________________________
figure('Name','Espectro fft');          %|
plot(linspace(0,2*pi,length(X)),abs(X));%|
grid on;                                %|
xlim([0 pi]);                           %|
xlabel('\omega');                       %|
ylabel('|X(e^{j\omega})|');             %|
%-----------------------------------------
%% 2_ Módulo del espectro mediante ventanas
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
X100 = {};
for k = 1:length(ventanas)
  X100{k} = {fft(x.*ventanas{k}{1}'),ventanas{k}{2}};
end
%ploteamos las aproximaciones_________________________________________
figure('Name', 'espectros ventaneados N =100, NFFT = N');           %|
hold on;                                                            %|
title('espectros ventaneados N =100, NFFT = N');                    %|
for k = 1:length(X100)                                              %|
  plot(linspace(0,2*pi,N),abs(X100{k}{1}),'DisplayName',X100{k}{2});%|
end                                                                 %|
plot(linspace(0,2*pi,N),abs(X),'DisplayName','fft directo');        %|
hold off                                                            %|
grid on;                                                            %|
xlabel('\omega');                                                   %|
ylabel('|X(e^{j\omega})|');                                         %|
legend('show')                                                      %|
xlim([0 pi]);                                                       %|
%---------------------------------------------------------------------

%% 3_ Espectros escalados 
for k = 1:length(X100)
  X100{k}{1} = (X100{k}{1}*2/N);
end
%ploteamos las aproximaciones_____________________________________________
figure('Name', 'espectros ventaneados y escalados N = 100, NFFT = N');  %|
title('espectros ventaneados y escalados N = 100, NFFT = N');           %|
for k = 1:length(X100)                                                  %|
  subplot(2,2,k);                                                       %|
  hold on;                                                              %|
  semilogy(linspace(0,2*pi,N),abs(X100{k}{1}),'DisplayName',X100{k}{2});%|
  title(ventanas{k}{2});                                                %|
  hold off                                                              %|
  grid on;                                                              %|
  xlabel('\omega');                                                     %|
  ylabel('|X(e^{j\omega})|');                                           %|
  legend('show')                                                        %|
  xlim([0 pi]);                                                         %|
end                                                                     %|
%-------------------------------------------------------------------------

%% 4_ Inciso 2 con N = 1000
NFFT = 1000;
%Aproximamos el espectro ventaneado
X1000 = {};
for k = 1:length(ventanas)
  X1000{k} = {fft(x.*ventanas{k}{1}',NFFT),ventanas{k}{2}};
end
%ploteamos las aproximaciones______________________________________________
figure('Name', 'espectros ventaneados N = 100, NFFT = 1000');            %|
title('espectros ventaneados N = 100, NFFT = 1000');                     %|
hold on;                                                                 %|
for k = 1:length(X1000)                                                  %|
  plot(linspace(0,2,NFFT),abs(X1000{k}{1}),'DisplayName',X1000{k}{2});   %|
end                                                                      %|
hold off                                                                 %|
grid on;                                                                 %|
xlabel('\omega');                                                        %|
ylabel('|X(e^{j\omega})|');                                              %|
legend('show')                                                           %|
xlim([0 1]);                                                             %|
%--------------------------------------------------------------------------

for k = 1:length(X1000)
  X1000{k}{1} = (X1000{k}{1}*2/NFFT);
end
%ploteamos las aproximaciones_______________________________________________
figure('Name', 'espectros ventaneados y escalados N = 100, NFFT = 1000'); %|
title('espectros ventaneados y escalados N = 100, NFFT = 1000')           %|
for k = 1:length(X1000)                                                   %|
  subplot(2,2,k);                                                         %|
  hold on;                                                                %|
  semilogy(linspace(0,2,NFFT),abs(X1000{k}{1}),'DisplayName',X1000{k}{2});%|
  title(ventanas{k}{2});                                                  %|
  hold off                                                                %|
  grid on;                                                                %|
  xlabel('\omega');                                                       %|
  ylabel('|X(e^{j\omega})|');                                             %|
  legend('show')                                                          %|
  xlim([0 1]);                                                            %|
end                                                                       %|
%---------------------------------------------------------------------------
