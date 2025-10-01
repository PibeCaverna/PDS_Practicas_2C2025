%% Clase 9 PDS 251001

%% Blackman
% Especificaciones del Filtro
A_paso = 1;         %Amplitud de la banda de paso (db)
A_rechazo = -50;    %Amplitud de la banda de rechazo (db)
ADJ = -15;          %Ajuste de muestras para optimizar el filtro

wr1 = 0.1*pi;       %freq rechazo inferior
wr2 = 0.5*pi;       %freq rechazo superior
wp1 = 0.2*pi;       %freq paso inferior
wp2 = 0.4*pi;       %freq paso superior
wc1 = (wr1+wp1)/2;  %freq de corte ideal inferior
wc2 = (wr2+wp2)/2;  %freq de corte ideal superior

ALP = 12*pi;        %Ventana de Blackman

% Implementacion del filtro
delta1 = wp1-wr1;
delta2 = wr2-wp2;
deltaw = min(abs(delta1),abs(delta2));
N = ceil(ALP/deltaw);
M = ceil(N/2)+ADJ;
n = -M:M;
hd = wc2/pi*sinc(wc2*n/pi)-wc1/pi*sinc(wc1*n/pi);
W = blackman(2*M+1)';
hT = W.*hd;
figure('Name','Blackman')
freqz(hT);

%% Kaiser

% Especificaciones del Filtro
A_paso = 1;         %Amplitud de la banda de paso (db)
A_rechazo = -6N
0;    %Amplitud de la banda de rechazo (db)
ADJ = -15;          %Ajuste de muestras para optimizar el filtro

wr1 = 0.1*pi;       %freq rechazo inferior
wr2 = 0.5*pi;       %freq rechazo superior
wp1 = 0.2*pi;       %freq paso inferior
wp2 = 0.4*pi;       %freq paso superior
wc1 = (wr1+wp1)/2;  %freq de corte ideal inferior
wc2 = (wr2+wp2)/2;  %freq de corte ideal superior
D1 = 10^(A_rechazo/20);
D2 = (10^(A_paso/20)-1)/(10^(A_paso/20)+1);
D3 = 10^(A_rechazo/20);

[N,Ww,beta] = kaiserord([wr1 wp1 wp2 wr2]/pi,[0 1 0],[D1 D2 D3]);

M = ceil(N/2);
n = -M:M;
hd = wc2/pi*sinc(wc2*n/pi)-wc1/pi*sinc(wc1*n/pi);
hT = kaiser(2*M+1,beta)'.*hd;
figure('Name','Kaiser')
freqz(hT);