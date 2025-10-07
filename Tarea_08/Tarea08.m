%% Tarea 08 Decodificador: Aplicación de filtros 
%% pasabanda y desplazamiento en frecuencia

%Frecuencias de corte para las distintas regiones
CutA = [9*pi/20 23*pi/40];  CutB = [33*pi/40 pi];
CutC = [23*pi/40 33*pi/40]; CutD = [0 9*pi/20];
freq = {CutA CutB CutC CutD};
%Muestras por defecto
N = 300;
%Archivo de entrada
global IN;

%Opciones
opts = {'Respuestas en frecuencia', ...
        'Bandas respuesta frecuencia', ...
        'Temporal filtrado (sin desplazar)', ...
        'Bandas de frecuencia (sin desplazar)'};

%GUI para ver todo
Origen = figure(Name='Tarea_08', ...
                Units='normalized', ...
                Windowstyle='docked');
Opciones = uipanel(Origen, ...
                   Title='Opciones', ...
                   Units='normalized', ...
                   Position=[0 0 .2 1]);
Plots = uipanel(Origen, ...
                Units='normalized', ...
                Position=[.2 0 .8 1]);
Ejes = axes(Plots, ...
            Units='normalized', ...
            Position=[.1 .1 .85 .85]);
Selector = uicontrol(Opciones, ...
                     Style='popupmenu', ...
                     String=opts, ...
                     Units='normalized', ...
                     Position=[.1 .9 .8 .05]);
Ntxt = uicontrol(Opciones, ...
                 Style='text', ...
                 String='N = ', ...
                 Units='normalized', ...
                 Position=[.1 .84 .3 .05]);
Ncambia = uicontrol(Opciones, ...
                    Style='edit', ...
                    String=num2str(N), ...
                    Units='normalized', ...
                    Position=[.35 .85 .45 .05]);
IN_Select = uicontrol(Opciones, ...
                      Style='popupmenu', ...
                      String={dir(fullfile('AudioIN','*.mat')).name}, ...
                      Units='normalized', ...
                      Position=[.1 .79 .8 .05]);
%Asignación de Callbacks
set(Selector,Callback=@(src,~) ... 
    cambiar_plot(src,Ejes,freq,str2double(Ncambia.String)));
set(Ncambia,Callback=@(src,~) ...
    cambiar_plot(Selector,Ejes,freq,str2double(src.String)));
set(IN_Select,Callback=@(src,~) ...
    cambiar_entrada(src));
%Inicia la APP  
cambiar_plot(Selector,Ejes,freq,str2double(Ncambia.String));
cambiar_entrada(IN_Select);
%Callbacks
function cambiar_plot(src,ax,freq, N)
  global IN;
  if isnan(N) || N <= 0
    N = 1;
  end

  FiltA = BlackmanPBd(freq{1}(1),freq{1}(2),N); 
  FiltB = BlackmanPBd(freq{2}(1),freq{2}(2),N);
  FiltC = BlackmanPBd(freq{3}(1),freq{3}(2),N); 
  FiltD = BlackmanPBd(freq{4}(1),freq{4}(2),N);
  cla(ax);
  switch src.Value
    case 1
      frsponse({FiltA FiltB FiltC FiltD}, ...
               {'Filtro A' 'Filtro B' 'Filtro C' 'Filtro D'}, ax);
    case 2
      frsimple({FiltA FiltB FiltC FiltD}, ...
               {'Filtro A' 'Filtro B' 'Filtro C' 'Filtro D'}, ax);
    case 3
      bandpass({FiltA FiltB FiltC FiltD}, IN.xe, IN.Fs, ...
               {'Banda A' 'Banda B' 'Banda C' 'Banda D'}, ax);
    case 4
      freqband({FiltA FiltB FiltC FiltD}, IN.xe, IN.Fs, ...
               {'Banda A' 'Banda B' 'Banda C' 'Banda D'}, ax);
  end
end
function cambiar_entrada(src)
  global IN;
  IN = open(fullfile('AudioIN',src.String{src.Value}));
  IN.xe = inversor_freq(IN.xe);
  IN.xe = fliplr(IN.xe);
end
%Funciones del programa
function frsponse(H,Nombre,ax)
  M = numel(H);
  hold(ax,'on');
  for k = 1:M
    [Hf, w] = freqz(H{k});
    mag = 20*log10(abs(Hf)+eps);

    plot(ax,w/pi,mag,DisplayName=Nombre{k}); grid(ax,'on');
    xlabel(ax,"Frecuencia \times \pi [rad/muestra]");
    ylabel(ax,"Ganancia [dB]");
  end
  hold(ax,'off');
end

function frsimple(H,Nombre,ax)
  M = numel(H);
  hold(ax,'on');
  xlabel(ax,'Frecuencia × \pi [rad/muestra]');
  ylabel(ax,'|H(e^{j\omega})|');
  for k = 1:M
    [Hf, w] = freqz(H{k}, 1, 1024);
    plot(ax,w/pi, abs(Hf), 'LineWidth', 1.2);
  end
  legend(ax,Nombre, 'Location', 'best');
  hold(ax,'off');
end

function bandpass(filtros,senal,fs,leyenda,ax)
  M = numel(filtros);
  t = 0:length(senal)-1;
  t = t/fs;
  hold(ax,'on');
  xlabel(ax,'Tiempo [s]');
  ylabel(ax,'Amplitud');
  for k = 1:M
    S = filter(filtros{k},1,senal);
    plot(ax,t,S,'LineWidth',1.2)
  end
  legend(ax,leyenda,'Location','best');
  hold(ax,'off');
end
function freqband(filtros,senal,fs,leyenda,ax)
  M = numel(filtros);
  t = 0:length(senal)-1;
  t = t/fs;
  hold(ax,'on');
  xlabel(ax,'Frecuencia \times \pi [rad/muestra]');
  ylabel(ax,'Amplitud');
  for k = 1:M
    [h,w] = freqz(filter(filtros{k},1,senal));
    plot(ax,w/pi,abs(h),'LineWidth',1.2)
  end
  legend(ax,leyenda,'Location','best');
  hold(ax,'off');
end

function invfreq = inversor_freq(senal)
  N = length(senal);
  n = 0:N-1;

  invfreq = senal.*((-1).^n)';
end

