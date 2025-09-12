Data = load("SDS00001.CSV");
%Separamos los  vectores para laburar mas comodos
t = Data(:,1);
ch1 = Data(:,2);
ch2 = Data(:,3);
% la frecuencia de la señal
f0 = 1000;
% estima la frecuencia de muestreo
ts = mean(diff(t));
% pone en fase las dos señales (en muestras)
[x,y] = alinea(ch1,ch2);
% Busca nuevamente un numero entero de períodos
Nc = floor(1/(ts*f0));
Nx = length(x);
Np = floor(Nx/Nc);
Nm = Np*Nc;
% se queda con un numero entero de períodos de la señal
t = t(1:Nm);
x = x(1:Nm);
y = y(1:Nm);
t = (0:Nm-1)*ts;
% grafica las señales alineadas
figure; plot(t,x,t,y); legend('x','y')
% Calcula los valores eficaces
d_rms = sqrt(trapz(t,(x-y).^2)/max(t));
x_rms = sqrt(trapz(t,x.^2)/max(t))
y_rms = sqrt(trapz(t,y.^2)/max(t))
thd = d_rms/y_rms*100