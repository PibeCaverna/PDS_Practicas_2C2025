%%% Laboratorio 3: Filtros FIR

%% Parametros
%freq de muestreo
Fs = 48000;
%ancho de banda de paso
bwp = 1000;
%ancho banda de rechazo
bwr = 3000;
%Tamaño banda Transición
Trnbw = 500;

%% Specs
% Pasabanda     Eliminabanda
fp1 = 1000;     fr1 = 1000;      
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

%% Filtro Eliminabanda (br)
%Frecuencias de paso
fpbr = [fr1+Trnbw, fr2-Trnbw];
wpbr = 2*pi*fpbr/Fs;
%Frecuencias de corte
fcbr = [(fr1+fpbr(1))/2, (fr2+fpbr(2))/2];
wcbr = 2*pi*fcbr/Fs;
%Vector de bandas (rari el fbbr)
fbbr = [fr1 fpbr(1) fpbr(2) fr2];
wbbr = 2*pi*fbbr/Fs;
%Parámetros ventana de Kaiser (usa mismo D y Fs q bp)
[Nbr,Wnbr,betabr] = kaiserord(fbbr,[1,0,1],D,Fs);
Mbr = ceil(Nbr/2);
n = -Mbr:Mbr;
%Filtro ideal
hbri = wcbr(1)/pi*sinc(wcbr(1)/pi*n)-wcbr(2)/pi*sinc(wcbr(2)*n/pi);
hbri(ceil(length(hbri)/2)) = 1+hbri(ceil(length(hbri)/2));
%Ventana de Kaiser
Wbr = kaiser(2*Mbr+1,betabr);
%Filtro real
EliminaBanda = Wbr'.*hbri;
