function [Xk,fk] = espectro(x,Nf,Ts)
% Xk,fk] = espectro(x,Nf,Ts);
% esta función calcula el espectro de la señal discreta x suponiendo que
% las muestras están separadas cada Ts, usando una FFT de largo Nf.
% solo devuelve la primera mitad del vector de la FFT.
% Si no se especifica Nf hace Nf = length(x).
% Si no se especifica Ts supone Ts = 1.

% revisa la cantidad de argumentos pasados a la función y completa los que
% falten
if nargin<2
Nf = length(x);
end;
if nargin < 3
Ts = 1;
end

if Nf < length(x);
disp('espectro: error: el largo de la TDF debe ser mayor que el de x');
return
end
w = hanning(length(x)); % ventana de truncación (es un vector columna)
[m,n]= size(x);         % se fija si el vector x es fila o columna
if m > n                % es un vector columna
xv = x.*w;
else                    % es un vector fila
xv = x.*w';             % transpone el vector de la ventana
end
X = fft(xv,Nf);    % la transformada discreta de Fourier
f = (0:Nf-1)/Nf/Ts;% el eje de frecuencias

Xk = X(1:floor(Nf/2));% devuelve la primera mitad del espectro
fk = f(1:floor(Nf/2));% y del vector de frecuencias