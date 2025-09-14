%Cargamos los datos
Data = load("SDS00001.CSV");
%Separamos los  vectores para laburar mas comodos
t = Data(:,1);
x = Data(:,2);
ts = mean(diff(t));
% se elige el tamaño de la TDF igual al largo del vector x
Nf = length(x);
% se calcula el espectro usando la señal decimada por D
D = 10;
[Xk,fk] = espectro(x(1:D:end),Nf,D*ts);
% se grafica el espectro en dB y se rotulan y escalan los ejes
plot(fk,20*log10(abs(Xk)));
axis([0 25000 -20 70]);
xlabel('f [Hz]'); ylabel('|X[k]| [dB]')
% busca los picos del espectro
[pk,id] = findpeaks(20*log10(abs(Xk)),...
'minpeakdistance',floor(700*ts*Nf*D));
hold on; plot(fk(id),pk,'ro')

% calcula el THD para Nh = 15 armónicos
Nh = 25;
pkh = pk(1:Nh);
num = sum(10.^(pkh(2:end)/10));
den = 10^(pkh(1)/10);
THD = sqrt(num/den)*100

% THD+N: f0 es la frecuencia del tono, y Df define el ancho de banda B1
f0 = 1000;
Df = 200;

% convierte las frecuencias esquina de la banda a índices
kL = floor((f0-Df)*ts*Nf*D);
kH = ceil((f0+Df)*ts*Nf*D);
kB = ceil(25000*ts*Nf*D);

% Calcula las potencias de cada banda
PB1 = sum(abs(x(kL:kH)).^2);
PB2 = sum(abs(x(1:kB)).^2);
THDN1 = sqrt((PB2-PB1)/PB1)*100
THDN2 = sqrt((PB2-PB1)/PB2)*100