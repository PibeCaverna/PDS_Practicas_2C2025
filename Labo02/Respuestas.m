%%Obtiene todas las respuestas teóricas
close all;                    % cierra todas las ventanas
clear all;                    % limpia todas las variables
%Frecuencia de muestreo
Fs = 8000;

% diferencia hacia atrás
[H_difftras, w_difftras] = freqz([1 -1], 1);
w_difftras_hz = w_difftras/2/pi;

figure('Name','Diferencia hacia atrás');
subplot(2,1,1);
plot(w_difftras_hz, abs(H_difftras), 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('|H(f)|');
title('Magnitud');

subplot(2,1,2);
plot(w_difftras_hz, angle(H_difftras), 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('arg\{H(f)\} [°]');
title('Fase');

% Filtro recursivo de primer orden: y[n] = a y[n-1] + x[n]

% Parámetros
a_init = 0; 
[H_rec, w_rec] = freqz(1, [1 -a_init], 1024, Fs);
figure('Name','Filtro recursivo de primer orden');

subplot(2,1,1);
hMag = plot(w_rec, abs(H_rec), 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('|H(f)|');
title('Magnitud');

subplot(2,1,2);
hPhase = plot(w_rec, angle(H_rec)*180/pi, 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('arg\{H(f)\} [°]');
title('Fase');

hSlider = uicontrol('Style','slider',...
    'Min',-1,'Max',1,'Value',a_init,...
    'SliderStep',[0.05/2 0.05/2],...
    'Units','normalized','Position',[0.25 0.01 0.5 0.05]);
hText = uicontrol('Style','text',...
    'Units','normalized','Position',[0.78 0.01 0.15 0.05],...
    'String',sprintf('a = %.2f',a_init));
hSlider.Callback = @(src,~) updatePlot(src,hMag,hPhase,hText,Fs);
function updatePlot(src,hMag,hPhase,hText,Fs)
    a = src.Value;
    [H_rec, w_rec] = freqz(1,[1 -a],1024,Fs);
    set(hMag,'XData',w_rec,'YData',abs(H_rec));
    set(hPhase,'XData',w_rec,'YData',angle(H_rec)*180/pi);
    set(hText,'String',sprintf('a = %.2f',a));
end

% Retardador de nd muestras: y[n] = x[n-nd]

nd_init = 0;
[H_delay, w_delay] = freqz([zeros(1,nd_init) 1], 1, 1024, Fs);

% Crear figura
figure('Name','Retardador de n_d muestras');
subplot(2,1,1);
hMag = plot(w_delay, abs(H_delay), 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('|H(f)|');
title('Magnitud');

subplot(2,1,2);
hPhase = plot(w_delay, angle(H_delay)*180/pi, 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('arg\{H(f)\} [°]');
title('Fase');

% Slider para variar nd
hSlider = uicontrol('Style','slider',...
    'Min',0,'Max',100,'Value',nd_init,...
    'SliderStep',[1/100 1/100],... 
    'Units','normalized','Position',[0.25 0.01 0.5 0.05]);
hText = uicontrol('Style','text',...
    'Units','normalized','Position',[0.78 0.01 0.2 0.05],...
    'String',sprintf('n_d = %d',nd_init));
hSlider.Callback = @(src,~) updateDelay(src,hMag,hPhase,hText,Fs);
function updateDelay(src,hMag,hPhase,hText,Fs)
    nd = round(src.Value); 
    [H_delay, w_delay] = freqz([zeros(1,nd) 1], 1, 1024, Fs);
    set(hMag,'XData',w_delay,'YData',abs(H_delay));
    set(hPhase,'XData',w_delay,'YData',angle(H_delay)*180/pi);
    set(hText,'String',sprintf('n_d = %d',nd));
end

% Generador de eco no recursivo: y[n] = x[n] + a x[n-nd]

a_init = 0;
nd_init = 0;

b = [1 zeros(1,nd_init) a_init];
[H_echo, w_echo] = freqz(b, 1, 1024, Fs);

figure('Name','Generador de eco no recursivo');

subplot(2,1,1);
hMag = plot(w_echo, abs(H_echo), 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('|H(f)|');
title('Magnitud');

subplot(2,1,2);
hPhase = plot(w_echo, angle(H_echo)*180/pi, 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('arg\{H(f)\} [°]');
title('Fase');

% --- Slider para 'a' ---
hSliderA = uicontrol('Style','slider',...
    'Min',-1,'Max',1,'Value',a_init,...
    'SliderStep',[0.05/2 0.05/2],...
    'Units','normalized','Position',[0.25 0.07 0.5 0.05]);

hTextA = uicontrol('Style','text',...
    'Units','normalized','Position',[0.78 0.07 0.2 0.05],...
    'String',sprintf('a = %.2f',a_init));

% --- Slider para 'nd' ---
hSliderND = uicontrol('Style','slider',...
    'Min',0,'Max',10,'Value',nd_init,...
    'SliderStep',[1/10 1/10],...
    'Units','normalized','Position',[0.25 0.01 0.5 0.05]);

hTextND = uicontrol('Style','text',...
    'Units','normalized','Position',[0.78 0.01 0.2 0.05],...
    'String',sprintf('n_d = %d',nd_init));
hSliderA.Callback  = @(src,~) updateEcho(src,hSliderND,hMag,hPhase,hTextA,hTextND,Fs);
hSliderND.Callback = @(src,~) updateEcho(hSliderA,src,hMag,hPhase,hTextA,hTextND,Fs);
function updateEcho(sliderA,sliderND,hMag,hPhase,hTextA,hTextND,Fs)
    a  = sliderA.Value;
    nd = round(sliderND.Value);
    b = [1 zeros(1,nd) a];
    [H_echo, w_echo] = freqz(b,1,1024,Fs);
    set(hMag,'XData',w_echo,'YData',abs(H_echo));
    set(hPhase,'XData',w_echo,'YData',angle(H_echo)*180/pi);
    set(hTextA,'String',sprintf('a = %.2f',a));
    set(hTextND,'String',sprintf('n_d = %d',nd));
end

% Generador de eco recursivo: y[n] = x[n] + a y[n-nd]
a_init = 0;
nd_init = 0;
b = 1;
a_den = [1 zeros(1,nd_init) -a_init];
[H_echo, w_echo] = freqz(b, a_den, 1024, Fs);

figure('Name','Generador de eco recursivo');
subplot(2,1,1);
hMag = plot(w_echo, abs(H_echo), 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('|H(f)|');
title('Magnitud');
subplot(2,1,2);
hPhase = plot(w_echo, angle(H_echo)*180/pi, 'LineWidth',1.5);
grid on;
xlabel('f [Hz]');
ylabel('arg\{H(f)\} [°]');
title('Fase');

% Slider para 'a'
hSliderA = uicontrol('Style','slider',...
    'Min',-0.99,'Max',0.99,'Value',a_init,... % evitar inestabilidad
    'SliderStep',[0.05/1.98 0.05/1.98],...
    'Units','normalized','Position',[0.25 0.07 0.5 0.05]);

hTextA = uicontrol('Style','text',...
    'Units','normalized','Position',[0.78 0.07 0.2 0.05],...
    'String',sprintf('a = %.2f',a_init));
% Slider para 'nd'
hSliderND = uicontrol('Style','slider',...
    'Min',0,'Max',10,'Value',nd_init,...
    'SliderStep',[1/10 1/10],...
    'Units','normalized','Position',[0.25 0.01 0.5 0.05]);

hTextND = uicontrol('Style','text',...
    'Units','normalized','Position',[0.78 0.01 0.2 0.05],...
    'String',sprintf('n_d = %d',nd_init));
hSliderA.Callback  = @(src,~) updateEchoRec(src,hSliderND,hMag,hPhase,hTextA,hTextND,Fs);
hSliderND.Callback = @(src,~) updateEchoRec(hSliderA,src,hMag,hPhase,hTextA,hTextND,Fs);
function updateEchoRec(sliderA,sliderND,hMag,hPhase,hTextA,hTextND,Fs)
    a  = sliderA.Value;
    nd = round(sliderND.Value);
    b = 1;
    a_den = [1 zeros(1,nd) -a];
    [H_echo, w_echo] = freqz(b, a_den, 1024, Fs);
    set(hMag,'XData',w_echo,'YData',abs(H_echo));
    set(hPhase,'XData',w_echo,'YData',angle(H_echo)*180/pi);
    set(hTextA,'String',sprintf('a = %.2f',a));
    set(hTextND,'String',sprintf('n_d = %d',nd));
end
