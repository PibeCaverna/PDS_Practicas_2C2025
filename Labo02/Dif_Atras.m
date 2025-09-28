%% como comparar las respuestas en frecuencias 
%  "teóricas" con las medidas
%  se analiza el sistema "diferencias hacia atrás"

close all;                    % cierra todas las ventanas
clear all;                    % limpia todas las variables

%% la respuesta en frecuencia teórica

[H,w] = freqz([1 -1]);        % esto devuelve un par de vectores H, con la 
                              % respuesta en frecuencia en módulo y fase, 
                              % y w con las frecuencias correspondientes 
                              % entre 0 y pi;
                            
%% la respuesta en frecuencia medida                            
m = load('modulo.TXT');       % carga el archivo "modulo.txt". Devuelve una
                              % matriz donde la primera columna es la
                              % frecuencia, y la segunda el modulo de la
                              % respuesta en frecuencia
modulo = m(:,2);              % el modulo es la segunda columna
frec_m = m(:,1);              % las frecuencias a las que se midió el módulo

f = load('fase.TXT');         % carga el archivo "fase.txt". Devuelve una
                              % matriz donde la primera columna es la
                              % frecuencia, y la segunda la fase de la
                              % respuesta en frecuencia
fase   = f(:,2);              % la fase es la segunda columna
frec_f = f(:,1);              % las frecuencias a las que se midió el módulo
                              % (en general es el mismo vector que frec_m)
                              
%% los graficos
% usamos "subplot" para usar una sola pantalla

% el eje "w" va entre 0 y pi. Para convertirlo a Hz se debe multiplicar por 
% Fs (la frecuencia de muestreo) y dividirlo por 2*pi. Fs se debe recordar
% (o anotar) del código del DSP.

Fs = 8000;
w_hz = w*Fs/2/pi;

% el modulo
subplot(2,1,1);               % hace un grafico de 2 filas y una columna, 
                              % y grafica en la primera fila
plot(w_hz,abs(H),'r-',...     % grafica la respuesta "teorica" en rojo
    frec_m,modulo,'b-');      % y la respuesta medida en azul
legend('teorica','medida',... % para indicar que es cada curva
    'location','NorthWest')   % para ubicar el cartelito donde no moleste
xlabel('f [Hz]');             % los nombres de los ejes
ylabel('|H(f)|');

% la fase
% la fase teorica esta en radianes: la medida (en esta caso) esta en
% grados, asi que es necesario escalarla

fase_g = angle(H)*180/pi;

subplot(2,1,2);               % hace un grafico de 2 filas y una columna, 
                              % y grafica en la segunda fila
plot(w_hz,fase_g,'r-',...     % grafica la respuesta "teorica" en rojo
    frec_f,fase,'b-');        % y la respuesta medida en azul
legend('teorica','medida',... % para indicar que es cada curva
    'location','NorthEast')   % para ubicar el cartelito donde no moleste
xlabel('f [Hz]');             % los nombres de los ejes
ylabel('arg\{H(f)\} [°]');


%% otro grafico
% como las repuestas dan "tan bien" es dificil compararlas. Lo que vamos a
% hacer es graficar la respuesta teórica como "circulitos", pero mas
% separadas en frecuencias. Para ello en frezq se puese especificar el
% vector de frecuencias donde se desea calcular la respuesta

N = 15;                       % la cantidad de puntos eonde queremos calcular
                              % la respuesta en frecuencia teórica
we = (0:N)/N*pi;              % el vector de frecuencias "elegidas"

[He, We]=freqz([1 -1],1,we);  % calcula la rta en frecuencia
mod_e = abs(He);              % el modulo de la rta en frecuencia
fas_e = angle(He)*180/pi;     % la fase escalada de la rta en frecuencia
frq_e = we*Fs/2/pi;           % el vector de frecuencias escalado en Hz

figure;                       % para que abra otra figura
% el modulo
subplot(2,1,1);               % hace un grafico de 2 filas y una columna, 
                              % y grafica en la primera fila
plot(frq_e,mod_e,'ro',...     % grafica la respuesta "teorica" en rojo
    frec_m,modulo,'b-');      % y la respuesta medida en azul
legend('teorica','medida',... % para indicar que es cada curva
    'location','NorthWest')   % para ubicar el cartelito donde no moleste
xlabel('f [Hz]');             % los nombres de los ejes
ylabel('|H(f)|');

% la fase
subplot(2,1,2);               % hace un grafico de 2 filas y una columna, 
                              % y grafica en la segunda fila
plot(frq_e,fas_e,'ro',...     % grafica la respuesta "teorica" en rojo
    frec_f,fase,'b-');        % y la respuesta medida en azul
legend('teorica','medida',... % para indicar que es cada curva
    'location','NorthEast')   % para ubicar el cartelito donde no moleste
xlabel('f [Hz]');             % los nombres de los ejes
ylabel('arg\{H(f)\} [°]');


