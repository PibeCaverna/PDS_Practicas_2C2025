%% Variables Globales
a = 0.8;
nd = 20;
Fs = 8000;
IIRM = load("SCRN0008.TXT");
IIRF = load("SCRN0009.TXT");
FIRM = load("SCRN0011.TXT");
FIRF = load("SCRN0012.TXT");

%% Eco FIR (No recursivo)
b = [1 zeros(1,nd) a];
[H_Fir, W_fir] = freqz(b,a,1000,Fs);

figure('Name','ECO FIR');
subplot(2,1,1);
xlabel('f [Hz]');
ylabel('|H(f)|');
hold on;
plot(W_fir,abs(H_Fir),LineWidth=1.2);
plot(W_fir,FIRM(:,2),LineWidth=1.2);
hold off;
legend({'Teorico' 'Experimental'});
title('Modulo');

subplot(2,1,2);
xlabel('f [Hz]');
ylabel('\angle{H(f)}°');
hold on;
plot(W_fir,angle(H_Fir)*180/pi,LineWidth=1.2);
plot(W_fir,FIRF(:,2),LineWidth=1.2);
hold off;
legend({'Teorico' 'Experimental'});
title('Fase');

%% ECO IIR (Recursivo)
num = 1;
den = [1 zeros(1,nd) -a];
[H_iir, W_iir] = freqz(num,den,1000,Fs);

figure('Name','ECO IIR');
subplot(2,1,1);
xlabel('f [Hz]');
ylabel('|H(f)|');
hold on;
plot(W_iir,abs(H_iir),LineWidth=1.2);
plot(W_iir,IIRM(:,2),LineWidth=1.2);
hold off;
legend({'Teorico' 'Experimental'});
title('Modulo');

subplot(2,1,2);
xlabel('f [Hz]');
ylabel('\angle{H(f)}°');
hold on;
plot(W_iir,angle(H_iir)*180/pi,LineWidth=1.2);
plot(W_iir,IIRF(:,2),LineWidth=1.2);
hold off;
legend({'Teorico' 'Experimental'});
title('Fase');