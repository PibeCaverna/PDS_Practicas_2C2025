%% Función para retornar un filtro pasabandas
function [hT] = BlackmanPBd(wr1,wc1,wc2,wr2,Ar1,Ap,Ar2,N)
  %Bandas de corte ideal
  wc1 = (wr1+wc1)/2;
  wc2 = (wr2+wc2)/2;

