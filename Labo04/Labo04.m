%%Laboratorio 04: Respuesta en frecuencia usando TDF
clear; close all; clc;

%% Definiciones
% Datos del analizador de espectro
Spect.S.Mod  = load("Datos_Analizador\Modulo_Metodo1.TXT");
Spect.S.PH   = load("Datos_Analizador\Fase_Metodo1.TXT");
Spect.S.Nom  = 'Barrido en Frecuencia';

Spect.C.Mod  = load("Datos_Analizador\Modulo_Metodo2.TXT");
Spect.C.PH   = load("Datos_Analizador\Fase_Metodo2.TXT");
Spect.C.Nom  = 'Chirp';

Spect.B.Mod  = load("Datos_Analizador\Modulo_Metodo3_RuidoBlanco.TXT");
Spect.B.PH   = load("Datos_Analizador\Fase_Metodo3_RuidoBlanco.TXT");
Spect.B.Nom  = 'Ruido Blanco';

Spect.BL.Mod = load("Datos_Analizador\Modulo_Metodo3_RuidoBL.TXT");
Spect.BL.PH  = load("Datos_Analizador\Fase_Metodo3_RuidoBL.TXT");
Spect.BL.Nom = 'Ruido Blanco (BL)';

Spect.R.Mod  = load("Datos_Analizador\Modulo_Metodo3_RuidoRosa.TXT");
Spect.R.PH   = load("Datos_Analizador\Fase_Metodo3_RuidoRosa.TXT");
Spect.R.Nom  = 'Ruido Rosa';

% Datos del osciloscopio
Scope.m20.C1 = load("Datos_Osciloscopio\C1_20micro.txt");
Scope.m20.C2 = load("Datos_Osciloscopio\C2_20micro.txt");
Scope.m20.id = "t = 20ms";

Scope.m40.C1 = load("Datos_Osciloscopio\C1_40micro.txt");
Scope.m40.C2 = load("Datos_Osciloscopio\C2_40micro.txt");
Scope.m40.id = "t = 40ms";

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

% Osciloscopio
figure('Name','Osciloscopio');

subplot(2,1,1); title('Base de tiempo = 20ms'); grid on; hold on;
pltsgnl(Scope.m20.C1,'Canal 1');
pltsgnl(Scope.m20.C2,'Canal 2');
hold off; lscp20 = legend('show');
lscp20.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

subplot(2,1,2); title('Base de tiempo = 40ms'); grid on; hold on;
pltsgnl(Scope.m40.C1,'Canal 1');
pltsgnl(Scope.m40.C2,'Canal 2');
hold off; lscp40 = legend('show');
lscp40.ItemHitFcn = @(~,ev) set(ev.Peer, 'Visible', ...
    iff(strcmp(ev.Peer.Visible,'on'),'off','on'));

%% Construcción de la respuesta en frecuencia 
[A B] = fresponse(Scope.m20.C1,Scope.m20.C2); 
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

function [Hkm Hkf] = fresponse(sigi,sigo)
    % Calcula la respuesta en frecuencia dada por un par señales discretas, 
    % muestreadas por un mismo vector de tiempos
    x = sigi(:,2)-sigi(1,2); y = sigi(:,2)-sigi(1,2);
    t = sigi(:,1);
    %TDF
    Ts = mean(diff(t)); Fs = 1/Ts; N = length(x);
    fk = (0:N-1)/N*Fs; Xk = fft(x); Yk = fft(y);
    Hkm = Yk./Xk; Hkf = angle(Yk./Xk);
end