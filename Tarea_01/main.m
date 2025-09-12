%Parametros iniciales
T = 1;
N = 4;
smpl = 1000*N;
DC = 50;
t = linspace(-T,T,smpl).';
k = -N:1:N;
%La onda cuadrada
x = square(2*pi*t/T+pi*DC/100,DC);
x = (x+1)/2;
%Calculo de los coeficientes
dt = T/(smpl-1);
C_k = x.'*exp(-j*2*pi/T*(t*k));
C_k = dt/T * C_k.';
% Reconstrucción usando la serie truncada
x_rec = real(exp(-j*2*pi/T*(t*k))*C_k);
%Valores de funcion sync
k_sync = linspace(-N,N,1000*N);
sync = zeros(size(k_sync));
sync(k_sync==0) = DC/100;
sync(k_sync~=0) = sin(pi*k_sync(k_sync~=0)*DC/100)...
    ./(pi*k_sync(k_sync~=0)).* exp(-1j*pi*k_sync(k_sync~=0)*DC/100);
%Señal Temporal
subplot(3,2,1)
plot(t,x,'linewidth',1.5)
grid on, ylim([-0.2 1.2])
xlabel('t'), ylabel('x(t)')
title('Onda cuadrada unipolar')
%Modulo Coeficientes de Fourier
subplot(3,2,2)
stem(k, abs(C_k),'filled')
hold on
plot(k_sync, abs(sync),'r--','LineWidth',1.5,'DisplayName','|sync|')
grid on
hold off
xlabel('k'), ylabel('|C_k|')
title('Módulo de los coeficientes de Fourier')
%Fase Coeficientes de Fourier
subplot(3,2,4)
stem(k,angle(C_k),'filled','LineWidth',1.5)
hold on
plot(linspace(-N,N,1000*N),angle(sync),'r--')
grid on
hold off
xlabel('k'), ylabel('Fase(C_k) [rad]')
title('Fase de los Coeficientes de Fourier')
%Señal Recuperada y Superposicion con Original
subplot(3,2,3)
plot(t,x_rec,'-',t,x,'--','LineWidth',1.5)
grid on
xlabel('t'), ylabel('x(t)')
title(sprintf('Reconstrucción con N = %d armónicos', N))
%Diferencia entre original y reconstruida
subplot(3,2,[5,6])
dif = x_rec-x;
plot(t,dif,'-','LineWidth',1.5)
grid on
xlabel('t'), ylabel('Diferencia')
title('Diferencia entre Original y Reconstruida')
