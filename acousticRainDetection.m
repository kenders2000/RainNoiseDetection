function [RainDet RainDetRaw Time]=acousticRainDetection(fileNameCells,startDate,plotYN,nCores)
% This function detects the presence of rain fall in recordings from the
% acoustic signature.  The function assumes mono audio, and a sampling
% freqeuency of 44.1 kHz.Although it will accept any sampling freqeuency,
% and resample to 44.1 kHz. Stereo files are summed over the channels to
% mono.
% fileNameCells is a cell array where each cell contains a string where the
%   string is the patha and filename of a wav file, the order of the files
%   important, this enables processing of recordings consisting of multiple
%   files,  
% startdate is a number in matlab datenum format represet the
%   extact start time of the first recording, the files must be contiguous.
    
% The function description: 
% 1) Audio is analysed in 10 sec, non overlapping chunks
% 2) In each 10s chunk a selection of audio features are extracted
% 3) from these features  Random forest has been trained to detect the
% presence of rain fall, the random forest was trained using the statistics
% toolbox, but a function has been provided to evaluate the forest without
% the toolbox (randForest)
% 4) the function will output the calss of each 10 s chucnk (0= rain free,
% 1= contains rain), which has been smoothed using a 5minute moving average
% window (30 10s chunks)
% 5) the function utilises the parallel computing tool box if available and
% will automatically process Nc process simultaneously where Nc is the
% number of cores on the computer, the function extrects a numner of wav
% files at each iteration so that the data is seperately available for each
% core in the parfor loop.

Fs=44100;
NN=0;
%
 load  randForest data 
 data1=data;
close all
  for i=1:length(fileNameCells)
str=fileNameCells{i};
%   [siz Fs1]=audioread(str,'SIZ');
  INFO = audioinfo(str);
  Fs1=INFO.SampleRate;
  siz=INFO.TotalSamples;
        N=floor(siz(1)/(10*Fs1));

%         clear rainYN
        for n=1:nCores:N
            %%#
            n1=0; i=n;
            for n1=0:nCores-1
                i=n+n1;
                if (i)>(N-1) break; end
                N1=(i-1)*10*Fs1+1;
                [y Fs1]=audioread(str,[N1 N1+10*Fs1]);
                y=sum(y,2);
                y=resample(y,Fs,Fs1);
                wavwrite(y,Fs,16,[num2str(n1+1) '.wav']);
            end
            rainYN_=zeros(nCores,1);
            parfor i= 1:n1
               [y Fs ]=wavread([num2str(i) '.wav']);
               y=y/sqrt(mean(y.^2));
                [rainYN_(i)]=featuresFinal(y,Fs,data1);
%                 [genAcIn HistimpZ WPD_E oFeats BioInd Towsey L10 L50 L90]=features(y,Fs,cutoff,lvs);
%                 genAcIn=rmfield(genAcIn,'Leq')        ;
%                 feats1=[cell2mat(struct2cell(BioInd)); cell2mat(struct2cell(genAcIn)); WPD_E' ; oFeats.moment(:,2:end)'; cell2mat(struct2cell(Towsey)); HistimpZ' ];% feats
%                 rainYN_(i)=str2num(cell2mat(predict(b,feats1(Ifeats)')))
            end
            for n2=0:(n1)
                i=n+n2+NN;
                rainYN(i)=rainYN_(n2+1);
                delete([num2str(n2+1) '.wav'])
            end
%                         sum(rainYN)
%                         20140812_230451
%                         dd = datenum(2014,08,10,00,14,46)+(1:length(rainYN))*10/60/60/24 ;
% 20140809_211546
% GATE__0__20140812_230451   063518
dd = startDate+(1:length(rainYN))*10/60/60/24 ;
if plotYN==1
        plot((dd),smooth(rainYN,30))
        ax = gca;
        ax.XTick = dd;        
        datetick('x',15,'keepticks')
        xlabel('Time')
        ylabel('Detection Output (1=rain, 0 = rain free)')
        drawnow
end
        end
                NN=NN+N;
  end
  RainDet=smooth(rainYN,30);
      RainDetRaw=rainYN;
      Time=dd;

