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
%Filtro real
PasaBanda = Wbp'.*hbpi;
[hbp, fbp] = freqz(PasaBanda,1,1024,Fs);

%% Plot filtro pasabanda
figure('name','Pasabanda (Ventana Kaiser)');
subplot(2,1,1);
plot(fbp,20*log10(abs(hbp)));
grid on;
xlabel('f [Hz]');
ylabel('|H(f)| [db]');
title('Magnitud');
subplot(2,1,2);
plot(fbp,angle(hbp)*180/pi);
grid on;
xlabel('f [Hz]');
ylabel('\angle{H(f)} [°]');
title('Fase');

%% Filtro Eliminabanda (br)
%Frecuencias de paso
fpbr = [fr1+Trnbw, fr2-Trnbw];
wpbr = 2*pi*fpbr/Fs;
%Frecuencias de corte
fcbr = [(fr1+fpbr(1))/2, (fr2+fpbr(2))/2];
wcbr = 2*pi*fcbr/Fs;
%Vector de bandas (rari el fbbr)
fbbr = [1 fpbr(1) fpbr(2) Fs/2-1];
wbbr = 2*pi*fbbr/Fs;
%Parámetros ventana de Kaiser (usa mismo D y Fs q bp)
[Nbr,Wnbr,betabr] = kaiserord(fbbr,[0,1,0],D,Fs);
Mbr = ceil(Nbr/2);
n = -Mbr:Mbr;
%Filtro ideal
hbri = wcbr(2)/pi*sinc(wcbr(2)*n/pi)+wcbr(1)/pi*sinc(wcbr(1)/pi*n);
%Ventana de Kaiser
Wbr = kaiser(2*Mbr+1,betabr);
%Filtro real
EliminaBanda = Wbr'.*hbri;
[hbr, fbr] = freqz(EliminaBanda,1,1024,Fs);

%% Plot filtro eliminabanda
figure('name','Eliminabanda (Ventana Kaiser)')
subplot(2,1,1);
plot(fbr,20*log10(abs(hbr)));
grid on;
xlabel('f [Hz]');
ylabel('|H(f)| [db]');
title('Magnitud');
subplot(2,1,2);
plot(fbr,angle(hbr)*180/pi);
grid on;
xlabel('f [Hz]');
ylabel('\angle{H(f)} [°]');
title('Fase');
