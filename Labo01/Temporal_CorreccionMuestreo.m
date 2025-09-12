Data = load("SDS00001.CSV");
%Separamos los  vectores para laburar mas comodos
t = Data(:,1);
ch1 = Data(:,2);
ch2 = Data(:,3);
% la frecuencia de la señal
f0 = 1000;
% estima la frecuencia de muestreo
ts = mean(diff(t));
% el numero de puntos de un período
Nc = floor(1/(ts*f0));
Nx = length(ch1);
Np = floor(Nx/Nc);
Nm = Np*Nc;
% se queda con un numero entero de periodos de la señal
t = t(1:Nm);
x = ch1(1:Nm);
y = ch2(1:Nm);
% grafica la señal
figure; plot(t,x,t,y); legend('x','y')
% calcula el valor eficaz y la THD
x_rms = sqrt(trapz(t,x.^2)/(max(t)-min(t)))
y_rms = sqrt(trapz(t,y.^2)/(max(t)-min(t)))
thd_e = 100*sqrt(x_rms^2-y_rms^2)/y_rms
