%% Tarea 6, Ejercicio 2, chequeo de los distintos sistemas
close all;                    % cierra todas las ventanas
clear all;                    % limpia todas las variables

%% Sistema 1
Muestras1 = 20;
n1 = -Muestras1:Muestras1;

sis1x = [1 -sqrt(2) 1];
sis1y = [1 -1/2];
x1 = cos(n1*pi/4+pi/8)+sin(n1*pi/4+pi/6)+1;
y1 = filter(sis1x,sis1y,x1);
[H1,w1] = freqz(sis1x,sis1y,1024,'whole');

figure('Name','Sistema 1')
    subplot(2,2,1);
        stem(n1,x1,'filled');
        title('Señal de entrada');
        xlabel('n'); ylabel('x[n]');
    subplot(2,2,2);
        stem(n1,y1,'filled');
        title('Señal Filtrada');
        xlabel('n'); ylabel('y[n]');
    subplot(2,2,3)
        plot(w1/pi,abs(H1));
        title('Modulo respuesta en frecuencia');
        xlabel('Frecuencia \times \pi');
        ylabel('|H(e^{j\omega})|')
    subplot(2,2,4)
        plot(w1/pi,angle(H1));
        title('Fase respuesta en frecuencia');
        xlabel('Frecuencia \times \pi');
        ylabel('\angle{H(e^{j\omega})}')

%% Sistema 2
Muestras2 = 15;
n2 = 0:Muestras2-1;

sis2 = [1 1];
x2 = 1+2*cos(n2*pi/2);
y2 = filter(sis2,1,x2);
[H2,w2] = freqz(sis2,1,1024,'whole');

figure('Name','Sistema 2')
    subplot(2,2,1);
        stem(n2,x2,'filled');
        title('Señal de entrada');
        xlabel('n'); ylabel('x[n]');
    subplot(2,2,2);
        stem(n2,y2,'filled');
        title('Señal Filtrada');
        xlabel('n'); ylabel('y[n]');
    subplot(2,2,3)
        plot(w2/pi,abs(H2));
        title('Modulo respuesta en frecuencia');
        xlabel('Frecuencia \times \pi');
        ylabel('|H(e^{j\omega})|')
    subplot(2,2,4)
        plot(w2/pi,angle(H2));
        title('Fase respuesta en frecuencia');
        xlabel('Frecuencia \times \pi');
        ylabel('\angle{H(e^{j\omega})}')

%% Sistema 3
Muestras3 = 20;
n3 = 0:Muestras3-1;

sis3 = [-1/8 1/2 -1/8];
x3 = 3+2*cos(n3*pi/2)+sin(n3*7*pi/10);
y3 = filter(sis3,1,x3);
[H3,w3] = freqz(sis3,1,1024,'whole');

figure('Name','Sistema 3')
    subplot(2,2,1);
        stem(n3,x3,'filled');
        title('Señal de entrada');
        xlabel('n'); ylabel('x[n]');
    subplot(2,2,2);
        stem(n3,y3,'filled');
        title('Señal Filtrada');
        xlabel('n'); ylabel('y[n]');
    subplot(2,2,3)
        plot(w3/pi,abs(H3));
        title('Modulo respuesta en frecuencia');
        xlabel('Frecuencia \times \pi');
        ylabel('|H(e^{j\omega})|')
    subplot(2,2,4)
        plot(w3/pi,angle(H3));
        title('Fase respuesta en frecuencia');
        xlabel('Frecuencia \times \pi');
        ylabel('\angle{H(e^{j\omega})}')
