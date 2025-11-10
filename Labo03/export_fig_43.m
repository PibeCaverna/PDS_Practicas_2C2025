function export_fig_43(figHandle, fileName)
% EXPORT_FIG_43 Exporta una figura con relación de aspecto 4:3 en alta resolución.
%
% Uso:
%   export_fig_43(fig, 'nombre_salida')
%
% Parámetros:
%   figHandle  -> handle de la figura que se desea exportar (gcf si es la figura actual)
%   fileName   -> nombre del archivo de salida sin extensión

    if nargin < 1
        figHandle = gcf;
    end
    if nargin < 2
        fileName = 'figure_export';
    end

    % Relación de aspecto 4:3
    set(figHandle, 'PaperUnits', 'inches');
    set(figHandle, 'PaperPosition', [0 0 8 6]);  % 8:6 -> 4:3
    set(figHandle, 'PaperSize', [8 6]);

    % Exporta en PNG a 300 dpi
    print(figHandle, fileName, '-dpng', '-r300');

    fprintf('Figura exportada: %s.png con resolución 300 dpi y formato 4:3\n', fileName);
end
