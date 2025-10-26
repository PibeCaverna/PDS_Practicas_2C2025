%%% Laboratorio 3: Filtros FIR

%% Parametros
%freq de muestreo
Fs = 48000;
%ancho de banda de paso
bwp = 1000;
%ancho banda de rechazo
bwr = 2000;
%Tamaño banda Transición
Trnbw = 500;

%% Specs
% Pasabanda     Eliminabanda
fp1 = 500;      fr1 = 500;      
fp2 = fp1+bwp;  fr2 = fr1+bwr;
%Amplitudes máximas (db)
Ap = 1;        Ar = -70;

%% Filtro Pasabanda (bp)
%Parámetros D de kaiser
D = [10^(Ar/20) ...
     (10^(Ap/20)-1)/(10^(Ap/20)+1) ...
     10^(Ar/20)];
%Frecuencias de rechazo
frbp = [fp1-Trnbw, fp2+Trnbw];
wrbp = 2*pi*frbp/Fs;
%Frecuencias de corte
fcbp = [(frbp(1)+fp1)/2, (frbp(2)+fp2)/2];
wcbp = 2*pi*fcbp/Fs;
%Vector de bandas
fbbp = [frbp(1) fp1 fp2 frbp(2)];
wbbp = 2*pi*fbbp/Fs;
%Parámetros ventana de kaiser, preguntar por dev = [0,1,0]
[Nbp,Wnbp, betabp] = kaiserord(fbbp,[0,1,0],D,Fs);
Mbp = ceil(Nbp/2);
n = -Mbp:Mbp;
%Filtro ideal ¿Me conviene laburar en Hz?
hbpi = wcbp(2)/pi*sinc(wcbp(2)*n/pi)-wcbp(1)/pi*sinc(wcbp(1)/pi*n);
%Ventana de kaiser
Wbp = kaiser(2*Mbp+1,betabp);
%filtro real
[hbp, fbp] = freqz(Wbp'.*hbpi,1,1024,Fs);

%% Plot filtro pasabanda
figure('name','Pasabanda (Ventana Kaiser)');
subplot(2,1,1);
plot(fbp,abs(hbp));
grid on;
xlabel('f [Hz]');
ylabel('|H(f)|');
title('Magnitud');
subplot(2,1,2);
plot(fbp,angle(hbp)*180/pi);
grid on;
xlabel('f [Hz]');
ylabel('\angle{H(f)} [°]');
title('Fase');

%% Filtro Eliminabanda (br)
