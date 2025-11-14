%%% Script para generar graficos superpuestos
%%% Primero hay que correr Filtros.m, ya que usa los filtros generados
%%% en el workspace
Filtros

%Nombres de los directorios
files = {{'TXT/mod_elimina_banda.TXT' 'TXT/fase_elimina_banda.TXT'}, ...
         {'TXT/mod_elimina_banda_zoom.TXT' 'TXT/fase_elimina_banda_zoom.TXT'}, ...
         {'TXT/mod_pasa_banda_.TXT' 'TXT/fase_pasa_banda_.TXT'}, ...
         {'TXT/mod_pasa_banda_zoom.TXT' 'TXT/fase_pasa_banda_zoom.TXT'}, ...
         {'TXT/mod_pasbanda_ultimo.TXT' 'TXT/fase_pasbanda_ultmio.TXT'}, ...
        };
%cargamos los datos de los archivos
fileam = size(files); fileam = fileam(2);
expdata = {};
for i = 1:fileam
    expdata{i} = {load(files{i}{1}) load(files{i}{2})};
end

%Retardo del dsp (en muestras)
ret = 48;

PasaBanda = [zeros(1,ret) PasaBanda];
EliminaBanda = [zeros(1,ret) EliminaBanda];

%Discretizado del filtro
PasaBanda = floor(PasaBanda*32767);
EliminaBanda = floor(EliminaBanda*32767);

%% Figuras del eliminabanda
[hbr,fbr] = freqz(EliminaBanda,1,100000,Fs);

figure('Name','Eliminabanda');
subplot(2,1,1);
title('Modulo');
grid on;
hold on;
plot(fbr,20*log10(abs(hbr))-90);
plot(expdata{1}{1}(:,1),expdata{1}{1}(:,2));
hold off;
ylabel('|h(f)| [db]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});
subplot(2,1,2)
title('Fase');
grid on;
hold on;
plot(fbr,angle(hbr));
plot(expdata{1}{2}(:,1),expdata{1}{2}(:,2));
hold off;
ylabel('\angle{h(f)} [°]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});


figure('Name','Eliminabanda (zoom)');
subplot(2,1,1);
title('Modulo');
grid on;
hold on;
plot(fbr,20*log10(abs(hbr))-90);
plot(expdata{2}{1}(:,1),expdata{2}{1}(:,2));
xlim([min(expdata{2}{1}(:,1)) max(expdata{2}{1}(:,1))]);
hold off;
ylabel('|h(f)| [db]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});
subplot(2,1,2)
title('Fase');
grid on;
hold on;
plot(fbr,angle(hbr));
plot(expdata{2}{2}(:,1),expdata{2}{2}(:,2));
xlim([min(expdata{2}{2}(:,1)) max(expdata{2}{2}(:,1))]);
hold off;
ylabel('\angle{h(f)} [°]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});

%% Figuras del pasabanda
[hbp,fbp] = freqz(PasaBanda,1,100000,Fs);

figure('Name','Pasabanda');
subplot(2,1,1);
title('Modulo');
grid on;
hold on;
plot(fbp,20*log10(abs(hbp)));
plot(expdata{3}{1}(:,1),expdata{3}{1}(:,2));
hold off;
ylabel('|h(f)| [db]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});
subplot(2,1,2)
title('Fase');
grid on;
hold on;
plot(fbp,unwrap(angle(hbp))*180/pi);
plot(expdata{3}{2}(:,1),expdata{3}{2}(:,2));
hold off;
ylabel('\angle{h(f)} [°]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});


figure('Name','Pasabanda (zoom)');
subplot(2,1,1);
title('Modulo');
grid on;
hold on;
plot(fbp,20*log10(abs(hbp)));
plot(expdata{4}{1}(:,1),expdata{4}{1}(:,2));
xlim([min(expdata{4}{1}(:,1)) max(expdata{4}{1}(:,1))]);
hold off;
ylabel('|h(f)| [db]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});
subplot(2,1,2)
title('Fase');
grid on;
hold on;
plot(fbp,unwrap(angle(hbp)));
plot(expdata{4}{2}(:,1),expdata{4}{2}(:,2));
xlim([min(expdata{4}{2}(:,1)) max(expdata{4}{2}(:,1))]);
hold off;
ylabel('\angle{h(f)} [°]')
xlabel('f [Hz]')
legend({'Teorico' 'Experimental'});

%% Analogico vs Digital
figure('Name','Analogico vs Digital');
subplot(2,1,1);
title('Modulo');
grid on;
hold on;
plot(expdata{3}{1}(:,1),expdata{3}{1}(:,2));
plot(expdata{5}{1}(:,1),expdata{5}{1}(:,2));
hold off;
ylabel('|h(f)| [db]')
xlabel('f [Hz]')
legend({'Digital' 'Analogico'});
subplot(2,1,2)
title('Fase');
grid on;
hold on;
plot(expdata{3}{2}(:,1),expdata{3}{2}(:,2));
plot(expdata{5}{2}(:,1),expdata{5}{2}(:,2));
hold off;
ylabel('\angle{h(f)} [°]')
xlabel('f [Hz]')
legend({'Digital' 'Analogico'});
