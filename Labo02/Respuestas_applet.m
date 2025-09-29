close all; clear all;

Fs = 8000;

% Valores iniciales
a_val = 0; nd_val = 0;

%% Figura y paneles
fig = figure('Name','Selector de filtro');

% Panel de gráficas
panelGraficas = uipanel('Parent',fig,'Position',[0.01 0.3 0.98 0.69]);
ax1 = subplot(2,1,1,'Parent',panelGraficas); hMag = plot(NaN,NaN,'LineWidth',1.5);
grid on; xlabel('f [Hz]'); ylabel('|H(f)|'); title('Magnitud');
ax2 = subplot(2,1,2,'Parent',panelGraficas); hPhase = plot(NaN,NaN,'LineWidth',1.5);
grid on; xlabel('f [Hz]'); ylabel('arg\{H(f)\} [°]'); title('Fase');

% Panel de controles
panelControles = uipanel('Parent',fig,'Position',[0.01 0.01 0.98 0.28]);

% Popup para seleccionar filtro
filtros = {'Diferencia hacia atrás','Filtro recursivo 1er orden','Retardador n_d','Eco no recursivo','Eco recursivo'};
hPopup = uicontrol('Parent',panelControles,'Style','popupmenu','Units','normalized',...
                   'Position',[0.01 0.7 0.3 0.25],'String',filtros,'FontSize',10);

%% Edit y Slider para 'a'
hTextA = uicontrol('Parent',panelControles,'Style','text','Units','normalized',...
                   'Position',[0.35 0.7 0.05 0.25],'String','a:','HorizontalAlignment','right');
hEditA = uicontrol('Parent',panelControles,'Style','edit','Units','normalized',...
                   'Position',[0.41 0.7 0.1 0.25],'String',num2str(a_val),'Visible','off');
hSliderA = uicontrol('Parent',panelControles,'Style','slider','Units','normalized',...
                   'Position',[0.52 0.7 0.45 0.25],'Min',-1,'Max',1,'Value',a_val,'Visible','off');

%% Edit y Slider para 'nd'
hTextND = uicontrol('Parent',panelControles,'Style','text','Units','normalized',...
                   'Position',[0.35 0.4 0.05 0.25],'String','n_d:','HorizontalAlignment','right');
hEditND = uicontrol('Parent',panelControles,'Style','edit','Units','normalized',...
                   'Position',[0.41 0.4 0.1 0.25],'String',num2str(nd_val),'Visible','off');
hSliderND = uicontrol('Parent',panelControles,'Style','slider','Units','normalized',...
                   'Position',[0.52 0.4 0.45 0.25],'Min',0,'Max',100,'Value',nd_val,'Visible','off');

%% Callbacks
hPopup.Callback  = @(src,~) updateFilter(src,hMag,hPhase,hEditA,hSliderA,hTextA,hEditND,hSliderND,hTextND);
hEditA.Callback  = @(src,~) paramChange(hPopup,hEditA,hSliderA,hEditND,hSliderND,hMag,hPhase);
hSliderA.Callback = @(src,~) sliderChange(hPopup,hEditA,hSliderA,hEditND,hSliderND,hMag,hPhase);
hEditND.Callback = @(src,~) paramChange(hPopup,hEditA,hSliderA,hEditND,hSliderND,hMag,hPhase);
hSliderND.Callback = @(src,~) sliderChange(hPopup,hEditA,hSliderA,hEditND,hSliderND,hMag,hPhase);

% Inicializar
updateFilter(hPopup,hMag,hPhase,hEditA,hSliderA,hTextA,hEditND,hSliderND,hTextND);

%% Funciones
function updateFilter(src,hMag,hPhase,hEditA,hSliderA,hTextA,hEditND,hSliderND,hTextND)
    val = src.Value;

    % Ocultar todo por defecto
    set([hEditA hSliderA hTextA hEditND hSliderND hTextND],'Visible','off');

    persistent a_val nd_val
    if isempty(a_val), a_val=0; end
    if isempty(nd_val), nd_val=0; end

    switch val
        case 1 % Diferencia hacia atrás
            [H, w] = freqz([1 -1],1,1024,8000);
        case 2 % Filtro recursivo
            set([hEditA hSliderA hTextA],'Visible','on');
            hEditA.String = num2str(a_val); hSliderA.Value = a_val;
            [H, w] = freqz(1,[1 -a_val],1024,8000);
        case 3 % Retardador
            set([hEditND hSliderND hTextND],'Visible','on');
            hEditND.String = num2str(nd_val); hSliderND.Value = nd_val;
            [H, w] = freqz([zeros(1,nd_val) 1],1,1024,8000);
        case 4 % Eco no recursivo
            set([hEditA hSliderA hTextA hEditND hSliderND hTextND],'Visible','on');
            hEditA.String = num2str(a_val); hSliderA.Value = a_val;
            hEditND.String = num2str(nd_val); hSliderND.Value = nd_val;
            [H, w] = freqz([1 zeros(1,nd_val) a_val],1,1024,8000);
        case 5 % Eco recursivo
            set([hEditA hSliderA hTextA hEditND hSliderND hTextND],'Visible','on');
            hEditA.String = num2str(a_val); hSliderA.Value = a_val;
            hEditND.String = num2str(nd_val); hSliderND.Value = nd_val;
            [H, w] = freqz(1,[1 zeros(1,nd_val) -a_val],1024,8000);
    end

    set(hMag,'XData',w,'YData',abs(H));
    set(hPhase,'XData',w,'YData',angle(H)*180/pi);
end

function paramChange(hPopup,hEditA,hSliderA,hEditND,hSliderND,hMag,hPhase)
    val = hPopup.Value;
    a_val = str2double(hEditA.String);
    nd_val = round(str2double(hEditND.String));
    hSliderA.Value = a_val; hSliderND.Value = nd_val;
    actualizarGrafico(val,a_val,nd_val,hMag,hPhase);
end

function sliderChange(hPopup,hEditA,hSliderA,hEditND,hSliderND,hMag,hPhase)
    val = hPopup.Value;
    a_val = hSliderA.Value;
    nd_val = round(hSliderND.Value);
    hEditA.String = num2str(a_val); hEditND.String = num2str(nd_val);
    actualizarGrafico(val,a_val,nd_val,hMag,hPhase);
end

function actualizarGrafico(val,a_val,nd_val,hMag,hPhase)
    switch val
        case 2 % Filtro recursivo
            [H, w] = freqz(1,[1 -a_val],1024,8000);
        case 3 % Retardador
            [H, w] = freqz([zeros(1,nd_val) 1],1,1024,8000);
        case 4 % Eco no recursivo
            [H, w] = freqz([1 zeros(1,nd_val) a_val],1,1024,8000);
        case 5 % Eco recursivo
            [H, w] = freqz(1,[1 zeros(1,nd_val) -a_val],1024,8000);
        otherwise
            return
    end
    set(hMag,'XData',w,'YData',abs(H));
    set(hPhase,'XData',w,'YData',angle(H)*180/pi);
end
