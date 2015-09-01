function [rainYN]=featuresFinal(y,Fs)
% Ffrom=1400;
% Fto=15000;
% yold=y;
% [a,g] = lpc(y,20);
% y=filter(a,1,y);
% soundsc(y,Fs)
% pwelch(yi);ylim([-60 30])
%% general acoustic parameters
y=y/sqrt(mean(y.^2));
% Impulsive integration  35 ms.
windowsize = round(0.035*Fs);
trailingsamples = mod(length(y), windowsize);
sampleframes = reshape( y(1:end-trailingsamples), windowsize, []);
ImpZ=20*log10(mean(sampleframes.^2));
LZmax_imp=max(ImpZ);

% Impulsive integration  5ms ;%35 ms.
windowsize = round(0.035*Fs);
[b a]=butter(5,(10000/(Fs/2)),'high');
yhp=filter(b,a,y);
yhp=yhp/sqrt(mean(yhp.^2));
trailingsamples = mod(length(y), windowsize);
sampleframes = reshape( yhp(1:end-trailingsamples), windowsize, []);
ImphfZ=20*log10(mean(sampleframes.^2));
L=-100:0.05:100;

HistimpZ=hist(ImphfZ,L)/length(ImphfZ);
[null I]=min(abs(cumsum(HistimpZ)-0.1));genAcIn.LhpF90=L(I);
[null I]=min(abs(cumsum(HistimpZ)-0.5));genAcIn.LhpF50=L(I);
[null I]=min(abs(cumsum(HistimpZ)-0.9));genAcIn.LhpF10=L(I);

LevelsZ=10*log10(y.^2);
L=-20:0.05:120;
HistZ=hist(LevelsZ,L)/length(LevelsZ);
[null I]=min(abs(cumsum(HistZ)-0.1));genAcIn.L90=L(I);
[null I]=min(abs(cumsum(HistZ)-0.9));genAcIn.L10=L(I);

L=-60:0.5:60;

HistimpZ=hist(ImphfZ,L)/length(ImphfZ);
% plot(L,HistimpZ)
%%  Wavelet packet decomp
 [WPD_E featL feat3 L10 L50 L90 ]  = getmswpfeat(y,round(0.035*Fs),round(0.035*Fs/2),9,'wmtsa');
% % % % % % % % % % % %    'Hist109'
% % % % % % % % % % % %     'WPD 288'
% % % % % % % % % % % %     'WPD 779'
% % % % % % % % % % % %     'WPD 993'
% % % % % % % % % % % %     'M'
% % % % % % % % % % % %     'Hist 83'
% % % % % % % % % % % %     'WPD 650'
% % % % % % % % % % % %     'Hist127'
% % % % % % % % % % % %     'WPD 390'
% % % % % % % % % % % %     'WPD 282'
% % % % % % % % % % % %     'Hist 23'
% % % % % % % % % % % %     'WPD 823'
% % % % % % % % % % % %     'WPD 352'
% % % % % % % % % % % %     'Hist217'
% % % % % % % % % % % %     'moments9'
% % % % % % % % % % % %     'Hist235'
% % % % % % % % % % % %     'Hist128'


%   'Hist115'
%     'Hist 88'
%     'WPD 707'
%     'WPD 515'
%     'L90'
%     'WPD 274'
%     'WPD 289'
%     'Hist130'
%     'Hist 85'
%     'Hist129'
%     'WPD 576'
%     'Hist218'
%     'Hist  2'
%     'Hist232'
%     'Hist134'
yf=yhp;

Env=sqrt(abs(hilbert(yf).^2));
M=median(Env);%*2^(1-1);  This is only if the wave is in integer values,
for ii=1:10
    oFeats.moment(ii)=moment((y),ii);
end

%%
features=[HistimpZ(115) HistimpZ(88) WPD_E(707) WPD_E(515) genAcIn.L90 ...
    WPD_E(274) WPD_E(289) HistimpZ(130) HistimpZ(85) HistimpZ(129) WPD_E(576)...
    HistimpZ(218) HistimpZ(2) HistimpZ(232) HistimpZ(134)];





% features=[HistimpZ(117) WPD_E(912) WPD_E(795) HistimpZ(54)  LZmax_imp ...
%     WPD_E(648)   WPD_E(798) HistimpZ(63) WPD_E(49) HistimpZ(192) HistimpZ(51) HistimpZ(165) ...
%     HistimpZ(47 ) HistimpZ(175) HistimpZ(52)];
load trainedalgo4 b;
rainYN=str2num(cell2mat(predict(b,features)));
