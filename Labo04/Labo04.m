%%Laboratorio 04: Respuesta en frecuencia usando TDF
clear; close all; clc;

%% Definiciones
% Datos del analizador de espectro
Spect.S.Mod  = load("Datos_Analizador/Modulo_Metodo1.TXT");
Spect.S.PH   = load("Datos_Analizador/Fase_Metodo1.TXT");
Spect.S.Nom  = 'Barrido en Frecuencia';

Spect.C.Mod  = load("Datos_Analizador/Modulo_Metodo2.TXT");
Spect.C.PH   = load("Datos_Analizador/Fase_Metodo2.TXT");
Spect.C.Nom  = 'Chirp';

Spect.B.Mod  = load("Datos_Analizador/Modulo_Metodo3_RuidoBlanco.TXT");
Spect.B.PH   = load("Datos_Analizador/Fase_Metodo3_RuidoBlanco.TXT");
Spect.B.Nom  = 'Ruido Blanco';

Spect.BL.Mod = load("Datos_Analizador/Modulo_Metodo3_RuidoBL.TXT");
Spect.BL.PH  = load("Datos_Analizador/Fase_Metodo3_RuidoBL.TXT");
Spect.BL.Nom = 'Ruido Blanco (BL)';

Spect.R.Mod  = load("Datos_Analizador/Modulo_Metodo3_RuidoRosa.TXT");
Spect.R.PH   = load("Datos_Analizador/Fase_Metodo3_RuidoRosa.TXT");
Spect.R.Nom  = 'Ruido Rosa';

% Datos del osciloscopio
Scope.m20.C1 = load("Datos_Osciloscopio/C1_20micro.txt");
Scope.m20.C2 = load("Datos_Osciloscopio/C2_20micro.txt");
Scope.m20.id = "Ancho de pulso = 20{\mu}s";

Scope.m40.C1 = load("Datos_Osciloscopio/C1_40micro.txt");
Scope.m40.C2 = load("Datos_Osciloscopio/C2_40micro.txt");
Scope.m40.id = "Ancho de pulso = 40{\mu}s";

%% Figuras de control (Para chequear)
% Analizador de espectro
figure('Name','Analizador de espectro');

subplot(2,1,1); title("Modulo"); grid on; hold on;
pltsgnl(Spect.S.Mod,Spect.S.Nom);
pltsgnl(Spect.C.Mod,Spect.C.Nom);
pltsgnl(Spect.B.Mod,Spect.B.Nom);
pltsgnl(Spect.BL.Mod,Spect.BL.Nom);
pltsgnl(Spect.R.Mod,Spect.R.Nom);
hold off; lsam = legend('show');
lsam.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

subplot(2,1,2); title("Fase"); grid on; hold on;
pltsgnl(Spect.S.PH,Spect.S.Nom);
pltsgnl(Spect.C.PH,Spect.C.Nom);
pltsgnl(Spect.B.PH,Spect.B.Nom);
pltsgnl(Spect.BL.PH,Spect.BL.Nom);
pltsgnl(Spect.R.PH,Spect.R.Nom);
hold off; lsaf = legend('show');
lsaf.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

%% Osciloscopio
figure('Name','Osciloscopio');

subplot(2,1,1); title('Ancho de pulso = 20us'); grid on; hold on;
pltsgnl(Scope.m20.C1,'Canal 1');
pltsgnl(Scope.m20.C2,'Canal 2');
hold off; lscp20 = legend('show');
lscp20.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

subplot(2,1,2); title('Ancho de pulso = 40us'); grid on; hold on;
pltsgnl(Scope.m40.C1,'Canal 1');
pltsgnl(Scope.m40.C2,'Canal 2');
hold off; lscp40 = legend('show');
lscp40.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

%% Construcción de la respuesta en frecuencia
% Obtengo la tasa de muestreo, es la misma para todos
Scope.Ts = mean(diff(Scope.m20.C1(:,1)));
Scope.Fs = 1/Scope.Ts;
% Establezco una tasa de muestreo más adecuada
Fsd = 200000;
% Decimo los datos del osciloscopio
%D = Scope.Fs/Fsd;
%Scope.m20.C1 = decimarcanal(Scope.m20.C1,D);
%Scope.m20.C2 = decimarcanal(Scope.m20.C2,D);
%Scope.m40.C1 = decimarcanal(Scope.m40.C1,D);
%Scope.m40.C2 = decimarcanal(Scope.m40.C2,D);
%% Ploteo otra vez, para chequear
figure('Name','Osciloscopio decimado');

subplot(2,1,1); title('Ancho de pulso = 20us'); grid on; hold on;
pltsgnl(Scope.m20.C1,'Canal 1');
pltsgnl(Scope.m20.C2,'Canal 2');
hold off; lscpd20 = legend('show');
lscpd20.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

subplot(2,1,2); title('Ancho de pulso = 40us'); grid on; hold on;
pltsgnl(Scope.m40.C1,'Canal 1');
pltsgnl(Scope.m40.C2,'Canal 2');
hold off; lscpd40 = legend('show');
lscpd40.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));
%% Calculo las respuestas impulsivas
[M P F] = fresponse(Scope.m20.C1,Scope.m20.C2);
Scope.m20.H = [M P F];
[M P F] = fresponse(Scope.m40.C1,Scope.m40.C2);
Scope.m40.H = [M P F];
clear M; clear P; clear F;
%% Las ploteamos
figure('Name', 'Espectros Calculados')
subplot(2,1,1); title("Modulo"); grid on; hold on;
pltscope_mod(Scope.m20.H,Scope.m20.id);
pltscope_mod(Scope.m40.H,Scope.m40.id);
hold off; lsosm = legend('show');
lsosm.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

subplot(2,1,2); title("Fase"); grid on; hold on;
pltscope_phase(Scope.m20.H,Scope.m20.id);
pltscope_phase(Scope.m40.H,Scope.m40.id);
hold off; lsosf = legend('show');
lsosf.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));
%% Plot final
figure('Name','Espectros superpuestos');

subplot(2,1,1); title("Modulo"); grid on; hold on;
pltsgnl(Spect.S.Mod,Spect.S.Nom);
pltsgnl(Spect.C.Mod,Spect.C.Nom);
pltsgnl(Spect.B.Mod,Spect.B.Nom);
pltsgnl(Spect.BL.Mod,Spect.BL.Nom);
pltsgnl(Spect.R.Mod,Spect.R.Nom);
pltscope_mod(Scope.m20.H,Scope.m20.id);
pltscope_mod(Scope.m40.H,Scope.m40.id);
hold off; lsesm = legend('show');
lsesm.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

subplot(2,1,2); title("Fase"); grid on; hold on;
pltsgnl(Spect.S.PH,Spect.S.Nom);
pltsgnl(Spect.C.PH,Spect.C.Nom);
pltsgnl(Spect.B.PH,Spect.B.Nom);
pltsgnl(Spect.BL.PH,Spect.BL.Nom);
pltsgnl(Spect.R.PH,Spect.R.Nom);
pltscope_phase(Scope.m20.H,Scope.m20.id);
pltscope_phase(Scope.m40.H,Scope.m40.id);
hold off; lsesf = legend('show');
lsesf.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

%% Funciones Auxiliares
function pltsgnl(signl,id)
    %dada una señal de la forma [y x], lo plotea
    plot(signl(:,1),signl(:,2),'DisplayName',id);
end

function out = iff(cond, a, b)
    if cond, out = a; else, out = b; end
end

function sgnlo = zerostrt(sgnl)
    %Transforma el vector para que la muestra inicial de la señal
    %temporal sea t = 0
    delta = sgnl(1,1);
    r = sgnl(:,2);
    t = sgnl(:,1)-delta;
    sgnlo = [t r];
end

function [Hkm Hkf fk] = fresponse(sigi,sigo)
    % Calcula la respuesta en frecuencia dada por un par señales discretas, 
    % muestreadas por un mismo vector de tiempos
    x = sigi(:,2)-sigi(1,2); y = sigo(:,2)-sigo(1,2);
    t = sigi(:,1);
    %TDF
    Ts = mean(diff(t)); Fs = 1/Ts; N = length(x);
    fk = ((0:N-1)/N*Fs)'; Xk = fft(x); Yk = fft(y);
    Hkm = abs(Yk./Xk); Hkf = angle(Yk./Xk);
end

function c_dec = decimarcanal(Canal,D)
  % Decima un canal de osciloscopio con el formato del LeCroy
  t = decimate(Canal(:,1),D);
  c = decimate(Canal(:,2),D);
  c_dec = [t c];
end

function pltscope_mod(H, id)
    % Grafica el módulo de una estructura H usando pltsgnl
    N = length(H(:,3));
    M = [H(1:floor(N/2),3), H(1:floor(N/2),1)];   % Armo vector [f, |H|]
    pltsgnl(M, id);
end

function pltscope_phase(H, id)
    % Grafica la fase de una estructura H usando pltsgnl
    N = length(H(:,3));
    P = [H(1:N/2,3), unwrap(H(1:N/2,2))];   % Armo vector [f, ∠H]
    pltsgnl(P, id);
end
