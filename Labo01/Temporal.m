Data = load("SDS00001.CSV");
%Separamos los  vectores para laburar mas comodos
t = Data(:,1);
ch1 = Data(:,2);
ch2 = Data(:,3);
%Figurita
figure; plot(t,ch1,t,ch2); legend("canal 1","canal 2");
%Valores Eficaces
x_rms = sqrt(trapz(t,ch1.^2)/(max(t)-min(t)))
y_rms = sqrt(trapz(t,ch2.^2)/(max(t)-min(t)))
%THD de valores eficaces
thd_e = 100*sqrt(x_rms^2-y_rms^2)/y_rms