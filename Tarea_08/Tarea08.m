%% Tarea 08 Decodificador: Aplicación de filtros 
%% pasabanda y desplazamiento en frecuencia

%Archivo de entrada
global IN;
%Muestras por defecto
N = 601;
%Frecuencias de corte para las distintas regiones
CutA = [9*pi/20 23*pi/40];  CutB = [33*pi/40 pi];
CutC = [23*pi/40 33*pi/40]; CutD = [0 9*pi/20];
freq = {CutD CutA CutC CutB};
%Filtros selectores de regiones
global FiltA; FiltA = BlackmanPBd(freq{2}(1),freq{2}(2),N);
global FiltB; FiltB = BlackmanPBd(freq{4}(1),freq{4}(2),N);
global FiltC; FiltC = BlackmanPBd(freq{3}(1),freq{3}(2),N);
global FiltD; FiltD = BlackmanPBd(freq{1}(1),freq{1}(2),N);
%Frecuencias de desplazamiento
global w;
w = {pi*11/20, -pi*9/20, pi*3/10, -pi*(1/8+1)};
%Filtros H_n
global H_n;
H_n = {BlackmanPBd(pi*11/20,pi,2*N), ...
       BlackmanPBd(0,pi/8,2*N), ...
       BlackmanPBd(3*pi/10,11*pi/20,2*N), ...
       BlackmanPBd(pi/8,3*pi/10,2*N)};
%Salida
global OUT;

%Opciones
opts = { ...
'2. Respuestas en frecuencia filtros', ...
'3. Espectros de frecuencia (sin desplazar)', ...
'5. Espectros de frecuencia (desplazados, superpuestos)', ...
'6. Respuesta en frecuencia filtros superposición', ...
'7. Espectros de frecuencia desplazados y filtrados', ...
'9. Espectros de frecuencia desplazados, fitrados y ajustados en ganancia'};

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
PLAY = uicontrol(Opciones, ...
                 Style = 'pushbutton', ...
                 String = 'Reproducir Decodificado', ...
                 Units='normalized', ...
                 Position=[.1 .70 .8 .05]);
%Asignación de Callbacks
set(Selector,Callback=@(src,~) ... 
    cambiar_plot(src,Ejes,freq,str2double(Ncambia.String)));
set(Ncambia,Callback=@(src,~) ...
    cambiar_plot(Selector,Ejes,freq,str2double(src.String)));
set(IN_Select,Callback=@(src,~) ...
    cambiar_entrada(src));
set(PLAY, 'Callback', @(src,evt) play_callback(src,evt,IN_Select));

function play_callback(~,~,IN_Select)
    cambiar_entrada(IN_Select);
    global IN;
    global FiltA; global FiltB;
    global FiltC; global FiltD;
    global w; global H_n;
    soundsc(decrypter({FiltD FiltA FiltC FiltB}, w, H_n, IN.xe), IN.Fs);
end
%Inicia la APP  
cambiar_plot(Selector,Ejes,freq,str2double(Ncambia.String));
cambiar_entrada(IN_Select);
%Callbacks
function cambiar_plot(src,ax,freq, N)
  global IN;
  global H_n;
  global w;
  global FiltA;
  global FiltB;   
  global FiltC;  
  global FiltD;   

  FiltA = BlackmanPBd(freq{2}(1),freq{2}(2),N);
  FiltB = BlackmanPBd(freq{4}(1),freq{4}(2),N);
  FiltC = BlackmanPBd(freq{3}(1),freq{3}(2),N);
  FiltD = BlackmanPBd(freq{1}(1),freq{1}(2),N);  

  if isnan(N) || N <= 0
    N = 1;
  end
  cla(ax);
  switch src.Value
    case 1
      frsponse({FiltD FiltA FiltC FiltB}, ...
               {'Filtro D' 'Filtro A' 'Filtro C' 'Filtro B'}, ax);
    case 2
      plotbanda(freqsep({FiltD FiltA FiltC FiltB}, IN.xe), ...
                {'Banda D' 'Banda A' 'Banda C' 'Banda B'}, ax);
    case 3
      bandas = freqsep({FiltD FiltA FiltC FiltB}, IN.xe);
      for k = 1:numel(bandas)
        n = 0:numel(bandas{k})-1;
        bandas{k} = bandas{k}*2.*(cos(w{k}*n'));
      end
      plotbanda(bandas, {'Banda D' 'Banda A' 'Banda C' 'Banda B'}, ax);
    case 4
      frsponse(H_n,{'Filtro 1' 'Filtro 2' 'Filtro 3' 'Filtro 4'},ax);
    case 5
      bandas = freqsep({FiltD FiltA FiltC FiltB}, IN.xe);
      for k = 1:numel(bandas)
        n = 0:numel(bandas{k})-1;
        bandas{k} = bandas{k}*2.*(cos(w{k}*n'));
        bandas{k} = filter(H_n{k},1,bandas{k});
      end
      plotbanda(bandas, {'Banda D' 'Banda A' 'Banda C' 'Banda B'}, ax);
    case 6
      global OUT;
      OUT = decrypter({FiltD FiltA FiltC FiltB},w,H_n,IN.xe);
      plotbanda({OUT},{'Espectro desencriptado'},ax);
  end
end
function cambiar_entrada(src)
  global IN;
  IN = open(fullfile('AudioIN',src.String{src.Value}));
  IN.xe = flip(IN.xe);
  IN.xe = inversor_freq(IN.xe);
end
%Funciones del programa
function frsponse(H,Nombre,ax)
  M = numel(H);
  hold(ax,'on');
  for k = 1:M
    [Hf, w] = freqz(H{k});
    plot(ax,w/pi,abs(Hf)); 
  end
  grid(ax,'on');
  legend(ax,Nombre,'Location','best');
  xlabel(ax,"Frecuencia \times \pi [rad/muestra]");
  ylabel(ax,"H(e^{j\omega})");
  hold(ax,'off');
end

function invfreq = inversor_freq(senal)
  N = length(senal);
  n = 0:N-1;

  invfreq = senal.*((-1).^n');
end

function bandas = freqsep(filtros,x)
  M = numel(filtros);
  bandas = {};
  for k = 1:M
    bandas{k} = filter(filtros{k},1,x);
  end
end

function plotbanda(x,Nombres,ax)
  M = numel(x);
  hold(ax,'on');
  for k = 1:M
    [h, w] = freqz(x{k});
    plot(ax,w/pi,abs(h),LineWidth=1.2);
  end
  xlabel(ax,'Frecuencia \times \pi [rad/muestra]');
  ylabel(ax,'Amplitud');
  legend(ax,Nombres,'Location','best');
  hold(ax,'off')
end

function signalis = decrypter(Selectores, Desplazadores, Filtros, x)
  %La señal se invierte en tiempo y frecuencia al seleccionarla,
  %por eso se obvian los pasos correspondientes.
  bandas = freqsep(Selectores, x);
  for k = 1:numel(bandas)
    n = 0:numel(bandas{k})-1;
    bandas{k} = bandas{k}*2.*(cos(Desplazadores{k}*n'));
    bandas{k} = filter(Filtros{k},1,bandas{k});
  end
  bandas{1} = bandas{1}/2; bandas{3} = bandas{3}/2;    
  signalis = bandas{1}+bandas{2}+bandas{3}+bandas{4};
end
