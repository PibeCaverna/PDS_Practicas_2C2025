%% Función para retornar un filtro pasabandas
function [hT] = BlackmanPBd(wc1,wc2,N)
% Muestras de la ventana
  M = ceil(N/2);
  n = -M:M;
  %Ventana y respuesta ideal
  hd = wc2/pi*sinc(wc2*n/pi)-wc1/pi*sinc(wc1*n/pi);
  W = blackman(2*M+1)';

% Variable de retorno (rta impulsiva del filtro)
  hT = W.*hd;



