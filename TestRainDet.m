%% Test the rain detection function
clear all
close all

fileNameCells{1}='TestFile1.flac' ; %Lets assume this file starts at 9am on 13th august 2014
fileNameCells{2}='TestFile2.flac'; %This files follows on immeadiately from the the first one
%   fileNameCells{1}='C:\Mersey Gateway Recordings\Recordings Second Time repetition\Point 4 hill\SD A\MERSEY-GATE__0__20140812_230451.wav'
%   fileNameCells{2}='C:\Mersey Gateway Recordings\Recordings Second Time repetition\Point 4 hill\SD A\MERSEY-GATE__0__20140813_082423.wav'
%   fileNameCells{3}='C:\Mersey Gateway Recordings\Recordings Second Time repetition\Point 4 hill\SD A\MERSEY-GATE__0__20140813_125614.wav'
%   fileNameCells{4}='C:\Mersey Gateway Recordings\Recordings Second Time repetition\Point 4 hill\SD A\MERSEY-GATE__0__20140813_221546.wav'
% startDate=datenum(2014,08,13,09,00,00);  % this is the date number

startDate=datenum(2014,08,12,23,04,51);  % this is the date number

% 
plotYN=1;  %plot updates as data is computed

 nCores=feature('numCores'); % how many processing cores do you have?

[RainDet, RainDetRaw, Time]=acousticRainDetection(fileNameCells,startDate,plotYN,nCores);


       plot((Time),RainDet)
        ax = gca;
        ax.XTick = Time;        
        datetick('x',15,'keepticks')
        xlabel('Time')
        ylabel('Detection Output (1=rain, 0 = rain free)')
        drawnow
