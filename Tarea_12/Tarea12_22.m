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
clear; close all; clc; 
N = 100; 
load("senal0010_0100.mat");
%Ventana
M.w = hamming(N,'periodic')';
%Definimos los dos NFFT a usar
NFFT1 = 100;
NFFT2 = 1000;
% procesado y reconstrucción
R1 = procesar_fft_y_reconstruccion(x,M.w,NFFT1);
R2 = procesar_fft_y_reconstruccion(x,M.w,NFFT2);
%Plots
figure('Name','Resultados NFFT = 100 y NFFT = 1000');
subplot(2,2,1);
semilogy(abs(R1.Xh),'Color','r'); hold on;
plot(R1.Kp1, R1.A, '.', 'MarkerSize', 15, 'Color', 'b');
xline(R1.Kp1,"--");
xlabel('k+1'); ylabel('|X(k)|');
title(sprintf("Espectro ventana Hamming (NFFT=%d), EMC=%.4f",NFFT1,R1.EMC));
hold off;
subplot(2,2,2);
n = 0:N-1;
plot(n,x,'k--'); hold on;
plot(n,R1.xe,'b');
title(sprintf("Reconstruccion (NFFT=%d), EMC=%.4f",NFFT1,R1.EMC));
legend('original','reconstruida');
hold off;
subplot(2,2,3);
semilogy(abs(R2.Xh),'Color','r'); hold on;
plot(R2.Kp1, R2.A, '.', 'MarkerSize', 15, 'Color', 'b');
xline(R2.Kp1,"--");
xlabel('k+1'); ylabel('|X(k)|');
title(sprintf("Espectro ventana Hamming (NFFT=%d), EMC=%.4f",NFFT2,R2.EMC));
hold off;
subplot(2,2,4);
plot(n,x,'k--'); hold on;
plot(n,R2.xe,'b');
title(sprintf("Reconstruccion (NFFT=%d), EMC=%.4f",NFFT2,R2.EMC));
legend('original','reconstruida');
hold off;

%% Funciones Auxiliares
function R = procesar_fft_y_reconstruccion(x,win,NFFT)
    Mx = x(:)' .* win;
    M_X = fft(Mx,NFFT) * 2 / sum(win);
    M_Xh = M_X(1:NFFT/2);
    Kp1 = encontrar_picos_fijos(NFFT);
    A = abs(M_X(Kp1));
    p = angle(M_X(Kp1));
    w = (Kp1-1) * 2*pi/NFFT;
    n = (0:length(win)-1)';
    xe = sum(A .* cos(w .* n + p),2);
    deltax = x(:) - xe(:);
    EMC = norm(deltax)/norm(x) * 100;
    R.Xh  = M_Xh;
    R.Kp1 = Kp1;
    R.A   = A;
    R.p   = p;
    R.w   = w;
    R.xe  = xe;
    R.EMC = EMC;
end

function Kp1 = encontrar_picos_fijos(NFFT)
    switch NFFT
        case 100
            Kp1 = [9 16 22 37]; 
      case 1000
            Kp1 = [82 154 207 359];
        otherwise
            error("No hay picos definidos para este NFFT");
    end
end
