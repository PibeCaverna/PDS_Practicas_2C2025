# Tarea 8
Falconieri - Kromberger

## Diseño de filtros
Para diseñar los filtros, se decidió emplear la ventana de blackman sobre un filtro pasabandas ideal, cuya implementación se puede ver en el siguiente snippet:\\

```
function [hT] = BlackmanPBd(wc1,wc2,N)
% Muestras de la ventana
  M = ceil(N/2);
  n = -M:M;
  %Ventana y respuesta ideal
  hd = wc2/pi*sinc(wc2*n/pi)-wc1/pi*sinc(wc1*n/pi);
  W = blackman(2*M+1)';

% Variable de retorno (rta impulsiva del filtro)
  hT = W.*hd;
```
Debido a que la cantidad de muestras de la ventana debe mantenerse constante a lo largo de todos los filtros (en pos de mantener el retardo de la señal para todas las frecuencias), se desistió de definir la banda de paso, para en su lugar trabajar de forma directa con las frecuencias de corte. Con $601$ muestras en la ventana y partiendo de las frecuencias de corte indicadas, las respuestas impulsivas de los filtros se pueden apreciar en la siguiente figura:\\
---
La siguiente figura muestra la respuesta en freciencia de los cuatro filtros H_n usados para limpiar cada banda de frecuencia despúes de haber sido desplazada a su posición correspondiente

![Punto 2](imagenes/2.png)

## Inversión de tiempo y frecuencia de la señal encriptada
Para invertir en tiempo y frecuencia la señal de entrada se aplicaron los sistemas:\\
```
y[n] = x[-n]
y[n] = x[n](-1)^n
```
Cuya implementación en matlab termina siendo:\\
```
IN = open(fullfile('AudioIN',src.String{src.Value}));
IN.xe = flip(IN.xe);
IN.xe = inversor_freq(IN.xe);
function invfreq = inversor_freq(senal)
  N = length(senal);
  n = 0:N-1;

  invfreq = senal.*((-1).^n');
end
```
Luego se implementaron los filtros sobre la señal, lo cual resultó en el siguiente espectro en frecuencia:

![Punto 3](imagenes/3.png)

La siguiente figura muestra el espectro de la señal de audio encriptada desplazado y superpuesto.

![Punto 5](imagenes/5.png)

En la siguiente imagen se puede ver la respuesta en frecuencia de los filtros una vez se aplica el desplazamiento.

![Punto 6](imagenes/6.png)

La siguiente figura grafica el espectro de la señal desplazada y filtrada.

![Punto 7](imagenes/7.png)

La siguiente figura muestra el espectro de la señal desplazada, filtrada y ajustada en ganancia.

![Punto 9](imagenes/9.png)
