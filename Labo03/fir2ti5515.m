function bq = fir2ti5515(b,flg,NomArch)
% BQ = FIR2TIDSP(B,FLG,NombreArchivo) 
%  Esta función convierte el vector de coeficientes B de un filtro FIR en 
%  un archivo *.h con el formato adecuado para agregarlo como un #include
%  en el programa principal. Está pensado para ser usado con la funcion FIR
%  de la librería DSPLIB.
%
%  Devuelve el vector de coeficientes cuantizados.
%
%  Si la variable FLG es no nula, grafica la respuesta en frecuencia y el 
%  mapa de polos y ceros del filtro original y el filtro con los 
%  coeficientes cuantizados.
%
%  Si no se especifica el nombre de archivo, genera un "FIRcoefs.h"

if nargin<2
    flg = 0;
    FilePathName = 'FIRcoefs.h';
    DialogWin = 1;
elseif nargin<3
    FilePathName = 'FIRcoefs.h';
    DialogWin = 1;
else
    FilePathName = NomArch;
    DialogWin = 0;
end

if DialogWin == 1
        [file,path] = uiputfile('FIRcoefs.h','fir2ti5515:Salvar coeficientes');
        FilePathName = strcat(path,file);
end

%cuantiza el vector de coeficientes
bq = floor(b*32767);
N = length(b);

% arma la fecha
fecha = datestr(now);
lblk  = round((53-length(fecha))/2);
StrDate = ['/* ' blanks(lblk) fecha ];
StrDate = [StrDate blanks(54-length(StrDate)) '*/\r\n'];

% abre el archivo y formatea los datos
fid=fopen(FilePathName,'w+');
fprintf(fid,'/******************************************************/\r\n');
fprintf(fid,'/* Coeficientes de un filtro FIR para usarlo con la   */\r\n');
fprintf(fid,'/* funcion FIR de la librería DSPLIB                  */\r\n');
fprintf(fid,StrDate);
fprintf(fid,'/******************************************************/\r\n');
fprintf(fid,'#define FIRlength %2i \r\n',N);  % largo del FIR
fprintf(fid,'                     \r\n');
fprintf(fid,'DATA FIRcoefs[%i] = {\r\n',N);
for I = 1:N-1,
    if I < 10
        fprintf(fid,'     %+6i,     /*  b[%1i]   = %+3.6f */\r\n',bq(I),I,b(I));
    elseif I<100
        fprintf(fid,'     %+6i,     /*  b[%1i]  = %+3.6f */\r\n',bq(I),I,b(I));            
    else
        fprintf(fid,'     %+6i,     /*  b[%1i] = %+3.6f */\r\n',bq(I),I,b(I));
    end
end
if N<10
    fprintf(fid,'     %+6i      /*  b[%1i]   = %+3.6f */\r\n',bq(N),N,b(N));    
elseif I<100
    fprintf(fid,'     %+6i      /*  b[%1i]  = %+3.6f */\r\n',bq(N),N,b(N));            
else
    fprintf(fid,'     %+6i      /*  b[%1i] = %+3.6f */\r\n',bq(N),N,b(N));
end
fprintf(fid,'};\r\n');
fprintf(fid,'/******************************************************/\r\n');
fclose(fid);

disp('===================================================')
disp('Los coeficientes del filtro FIR')
disp('están en el archivo:')
disp(' ')
disp(FilePathName)
disp('===================================================')

if flg ~= 0
    fvtool(b,1,bq,32767)
%     [ho,wo]=freqz(b,1,4096);
%     [hq,wq]=freqz(bq,32767,4096);
%     ro = roots(b);
%     rq = roots(bq);
%     figure;
%     plot(wo/pi,20*log10(abs(ho)),'r-',...
%         wq/pi,20*log10(abs(hq)),'b-');
%     axis([0 1 -100 5]);
%     legend('original','cuantizado');
%     
%     figure;
%     p=plot(real(ro),imag(ro),'ro',...
%         real(rq),imag(rq),'bd',...
%         0,0,'bx',...
%         [-10 10],[0,0],'k:',...
%         [0,0],[-10 10],'k:');
%     text(0,0,sprintf('(%i)',N),'VerticalAlignment','bottom');
%     set(p,'MarkerSize',5)
%     axis('equal');
%     axis([-1.2 1.2 -1.2 1.2]);
%     legend('original','cuantizado');
end
