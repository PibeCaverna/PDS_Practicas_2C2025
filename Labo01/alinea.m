function [xa,ya] = alinea(x,y)
%[xa,ya] = alinea(x,y)
% esta función "alinea" los vectores x e y. Calcula la correlación
% cruzada entre ambos, se fija donde está el maximo: Si el máximo está
% ubicado por encima de la mitad del vector de correlación cruzada
% desplaza la señal x; en caso contrario desplaza la señal y. Si el pico
% de la correlación cruzada es negativo, invierte la señal y.    
xc = xcorr(x,y);
[m,idx] = max(abs(xc)); des = idx-length(x);
if xc(idx)< 0; y = -y; end
if des > 0
    ya = y(1:end-des); xa = x(des:end-1);
else
    des = -des;
    xa = x(1:end-des); ya = y(des:end-1);
end
